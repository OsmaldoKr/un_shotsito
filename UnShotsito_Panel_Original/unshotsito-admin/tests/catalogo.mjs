import { PGlite } from "@electric-sql/pglite";
import fs from "node:fs/promises";
import assert from "node:assert/strict";
const db = new PGlite(),
  admin = "00000000-0000-4000-a000-000000000001";
await db.exec(
  "create role anon;create role authenticated;create schema auth;create table auth.users(id uuid primary key);create function auth.uid() returns uuid language sql as $$select nullif(current_setting('app.uid',true),'')::uuid$$",
);
for (const file of ["01_schema", "02_ejemplos", "03_panel_original"])
  await db.exec(await fs.readFile("supabase/" + file + ".sql", "utf8"));
await db.exec(
  "insert into auth.users values('" +
    admin +
    "');insert into shots.admins values('" +
    admin +
    "');set role anon",
);
const rpc = async (q, p = []) =>
  Object.values((await db.query(q, p)).rows[0])[0];
const publicRead = () => rpc("select public.catalogo_juego()");
assert.equal((await publicRead()).length, 7);
await assert.rejects(() => db.query("select public.catalogo_admin()"));
await assert.rejects(() => db.query("select * from shots.consignas"));
await db.exec("set role authenticated");
await assert.rejects(() => db.query("select public.catalogo_admin()"));
await assert.rejects(() =>
  db.query("select public.editar_catalogo(1,'subir','{}')"),
);
await db.query("select set_config('app.uid',$1,false)", [admin]);
let state = await rpc("select public.catalogo_admin()");
const save = async (a, d) =>
  (state = await rpc("select public.editar_catalogo($1,$2,$3)", [
    state.revision,
    a,
    JSON.stringify(d),
  ]));
const leerPartida = () => rpc("select public.catalogo_partida()");
const inicial = await leerPartida();
assert.equal(inicial.categorias.length, 7);
assert.equal(inicial.castigosGenerales.length, 1);
const especial = {
  id: crypto.randomUUID(),
  categoria: "general",
  tipo: "especial",
  turnos: 4,
  texto: "Cantá una rima.",
  activo: true,
};
await save("consigna", especial);
assert.equal(
  (await leerPartida()).especiales.find((x) => x.id === especial.id).turnos,
  4,
);
await save("consigna", { ...especial, activo: false });
assert.ok(!(await leerPartida()).especiales.some((x) => x.id === especial.id));
await assert.rejects(() => save("consigna", { ...especial, turnos: 0 }));
const id = crypto.randomUUID();
await save("categoria", { id, nombre: "Mímica", activo: true });
const items = ["reto", "reto", "castigo"].map((tipo, i) => ({
  id: crypto.randomUUID(),
  categoria: id,
  tipo,
  texto: "Consigna " + i,
  activo: true,
}));
for (const item of items) await save("consigna", item);
const first = (await publicRead()).find((x) => x.id === id);
assert.equal(first.retos.length, 2);
assert.equal(first.castigos.length, 1);
await save("consigna", { ...items[0], activo: false });
assert.equal((await publicRead()).find((x) => x.id === id).retos.length, 1);
assert.equal(first.retos.length, 2);
await assert.rejects(() =>
  db.query("select public.editar_catalogo(0,'borrar_categoria',$1)", [
    JSON.stringify({ id }),
  ]),
);
await save("subir", { id });
assert.equal(state.categorias.at(-2).id, id);
await save("categoria", { id, nombre: "Gestos", activo: false });
assert.ok(!(await publicRead()).some((x) => x.id === id));
await save("consigna", { ...items[2], categoria: state.categorias[0].id });
await save("borrar_categoria", { id });
assert.ok(!state.consignas.some((x) => x.categoria === id));
assert.ok(state.consignas.some((x) => x.id === items[2].id));
console.log(
  "OK: esquema, permisos, datos, CRUD, orden, conflictos y dos partidas de Mímica.",
);
await db.close();
