begin;
alter table shots.consignas alter column categoria drop not null;
alter table shots.consignas add column turnos integer;
alter table shots.consignas drop constraint consignas_tipo_check;
alter table shots.consignas add constraint consignas_ambito check (
 (tipo='especial' and categoria is null and turnos is not null and turnos>0)
 or (tipo='castigo' and turnos is null)
 or (tipo='reto' and categoria is not null and turnos is null)
);
create or replace function public.catalogo_admin() returns jsonb language plpgsql stable security definer set search_path='' as $$
begin
 perform shots.exigir_admin();
 return jsonb_build_object('revision',(select revision from shots.estado),
 'categorias',(select coalesce(jsonb_agg(to_jsonb(c) order by orden,id),'[]') from shots.categorias c),
 'consignas',(select coalesce(jsonb_agg(to_jsonb(i) || jsonb_build_object('categoria',coalesce(i.categoria::text,'general')) order by creado,id),'[]') from shots.consignas i));
end $$;
create or replace function public.editar_catalogo(esperada bigint, accion text, datos jsonb) returns jsonb
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
  insert into shots.consignas(id,categoria,tipo,texto,activo,turnos) values(ident,nullif(datos->>'categoria','general')::uuid,datos->>'tipo',trim(datos->>'texto'),(datos->>'activo')::boolean,(datos->>'turnos')::int)
  on conflict(id) do update set categoria=excluded.categoria,tipo=excluded.tipo,texto=excluded.texto,activo=excluded.activo,turnos=excluded.turnos;
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

create function public.catalogo_partida() returns jsonb language sql stable security definer set search_path='' as $$
select jsonb_build_object('categorias',public.catalogo_juego(),
 'castigosGenerales',coalesce(jsonb_agg(jsonb_build_object('id',id,'texto',texto) order by creado,id) filter(where tipo='castigo'),'[]'),
 'especiales',coalesce(jsonb_agg(jsonb_build_object('id',id,'descripcion',texto,'turnos',turnos) order by creado,id) filter(where tipo='especial'),'[]'))
 from shots.consignas where categoria is null and activo;
$$;
revoke all on function public.catalogo_partida() from public;
grant execute on function public.catalogo_partida() to anon,authenticated;
update shots.categorias set nombre='Shots ligeros' where id='a83a7161-589d-4d28-a743-c360b5f1ac43' and nombre='Pre' and not exists(select 1 from shots.categorias where lower(nombre)=lower('Shots ligeros'));
update shots.categorias set nombre='Shots picantes' where id='39de6c08-2291-4db6-840f-2f76818c7fa7' and nombre='Pasaditos' and not exists(select 1 from shots.categorias where lower(nombre)=lower('Shots picantes'));
update shots.categorias set nombre='Shots nocturnos' where id='272fb6d7-a42a-49ba-af47-dd99939b154d' and nombre='After' and not exists(select 1 from shots.categorias where lower(nombre)=lower('Shots nocturnos'));
update shots.categorias set nombre='Shots calientes' where id='40eb8dba-053c-4eeb-8fd8-ac72f8d3091c' and nombre='Hot' and not exists(select 1 from shots.categorias where lower(nombre)=lower('Shots calientes'));
update shots.categorias set nombre='Shots en pareja' where id='bcaeb589-ceb2-40ce-b3a7-a0b9ff7717e4' and nombre='Pareja' and not exists(select 1 from shots.categorias where lower(nombre)=lower('Shots en pareja'));
update shots.categorias set nombre='Shots de bar' where id='745ee906-4cc0-4915-81c6-e03eb10c856d' and nombre='Bar' and not exists(select 1 from shots.categorias where lower(nombre)=lower('Shots de bar'));
insert into shots.categorias(id,nombre,orden) select '1d3e1625-64f7-4539-a0d7-641f00f4882d','Shots para confesar',coalesce(max(orden),0)+1 from shots.categorias on conflict do nothing;
insert into shots.consignas(id,categoria,tipo,texto,turnos) values('512b5bc7-5db1-4f02-89b2-f7c131097b1d',(select id from shots.categorias where lower(nombre)='shots para confesar'),'reto','Confesá qué canción sabés de memoria.',null) on conflict do nothing;
insert into shots.consignas(id,categoria,tipo,texto,turnos) values('cb6fe631-8748-4ee8-9459-9a71ddd1df59',null,'castigo','Inventá un saludo para el grupo.',null) on conflict do nothing;
insert into shots.consignas(id,categoria,tipo,texto,turnos) values('6efd2ade-6ebb-4447-ac02-503c12dab595',null,'especial','Durante tus turnos, saludá a name con una rima.',3) on conflict do nothing;
update shots.estado set revision=revision+1;
commit;
