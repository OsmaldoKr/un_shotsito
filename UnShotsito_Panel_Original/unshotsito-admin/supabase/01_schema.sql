-- Ejecutar una vez en un proyecto Supabase nuevo.
begin;
create schema shots;
revoke all on schema shots from public, anon, authenticated;
create table shots.admins (user_id uuid primary key references auth.users on delete cascade);
create table shots.estado (id boolean primary key check(id), revision bigint not null default 0);
insert into shots.estado(id) values(true);
create table shots.categorias (
 id uuid primary key default gen_random_uuid(),
 nombre text not null check (length(trim(nombre)) between 1 and 60),
 activo boolean not null default true, orden integer not null
);
create unique index categorias_nombre on shots.categorias(lower(trim(nombre)));
create table shots.consignas (
 id uuid primary key default gen_random_uuid(),
 categoria uuid not null references shots.categorias on delete cascade,
 tipo text not null check(tipo in ('reto','castigo')),
 texto text not null check(length(trim(texto)) between 1 and 600),
 activo boolean not null default true, creado timestamptz not null default now()
);
create index consignas_categoria on shots.consignas(categoria);
alter table shots.categorias enable row level security;
alter table shots.consignas enable row level security;
alter table shots.admins enable row level security;
alter table shots.estado enable row level security;
revoke all on all tables in schema shots from public, anon, authenticated;

create function public.catalogo_juego() returns jsonb
language sql stable security definer set search_path='' as $$
 select coalesce(jsonb_agg(jsonb_build_object(
 'id',c.id,'nombre',c.nombre,'retos',d.retos,'castigos',d.castigos
 ) order by c.orden,c.id),'[]') from shots.categorias c
 cross join lateral (
 select coalesce(jsonb_agg(jsonb_build_object('id',i.id,'texto',i.texto) order by i.creado,i.id)
 filter(where i.tipo='reto'),'[]') retos,
 coalesce(jsonb_agg(jsonb_build_object('id',i.id,'texto',i.texto) order by i.creado,i.id)
 filter(where i.tipo='castigo'),'[]') castigos
 from shots.consignas i where i.categoria=c.id and i.activo
 ) d where c.activo;
$$;
create function shots.exigir_admin() returns void language plpgsql stable set search_path='' as $$
begin
 if not exists(select 1 from shots.admins where user_id=auth.uid()) then
  raise exception 'La cuenta no tiene acceso administrativo.' using errcode='42501';
 end if;
end $$;
create function public.catalogo_admin() returns jsonb language plpgsql stable security definer set search_path='' as $$
begin
 perform shots.exigir_admin();
 return jsonb_build_object('revision',(select revision from shots.estado),
 'categorias',(select coalesce(jsonb_agg(to_jsonb(c) order by orden,id),'[]') from shots.categorias c),
 'consignas',(select coalesce(jsonb_agg(to_jsonb(i) order by creado,id),'[]') from shots.consignas i));
end $$;
create function public.editar_catalogo(esperada bigint, accion text, datos jsonb) returns jsonb
language plpgsql security definer set search_path='' as $$
declare rev bigint; ident uuid := (datos->>'id')::uuid; actual integer; vecino uuid; posicion integer;
begin
 perform shots.exigir_admin();
 select revision into rev from shots.estado where id for update;
 if rev is distinct from esperada then raise exception 'El catálogo cambió. Revisá los datos actualizados.' using errcode='40001'; end if;
 case accion
 when 'categoria' then
  insert into shots.categorias(id,nombre,activo,orden) values(ident,trim(datos->>'nombre'),(datos->>'activo')::boolean,
    (select coalesce(max(orden),0)+1 from shots.categorias))
  on conflict(id) do update set nombre=excluded.nombre,activo=excluded.activo;
 when 'consigna' then
  insert into shots.consignas(id,categoria,tipo,texto,activo) values(ident,(datos->>'categoria')::uuid,datos->>'tipo',trim(datos->>'texto'),(datos->>'activo')::boolean)
  on conflict(id) do update set categoria=excluded.categoria,tipo=excluded.tipo,texto=excluded.texto,activo=excluded.activo;
 when 'borrar_categoria' then delete from shots.categorias where id=ident;
 when 'borrar_consigna' then delete from shots.consignas where id=ident;
 when 'subir','bajar' then
  select orden into strict actual from shots.categorias where id=ident;
  if accion='subir' then select id,orden into vecino,posicion from shots.categorias where orden<actual order by orden desc limit 1;
  else select id,orden into vecino,posicion from shots.categorias where orden>actual order by orden limit 1; end if;
  if vecino is not null then update shots.categorias set orden=case when id=ident then posicion else actual end where id in (ident,vecino); end if;
 else raise exception 'Acción desconocida.';
 end case;
 update shots.estado set revision=revision+1;
 return public.catalogo_admin();
end $$;
revoke all on function public.catalogo_juego(), public.catalogo_admin(), public.editar_catalogo(bigint,text,jsonb) from public, anon, authenticated;
grant execute on function public.catalogo_juego() to anon,authenticated;
grant execute on function public.catalogo_admin(),public.editar_catalogo(bigint,text,jsonb) to authenticated;
commit;
