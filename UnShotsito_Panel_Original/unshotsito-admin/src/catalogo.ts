import { createClient } from "@supabase/supabase-js";
import ejemplo from "./ejemplo.json";
export type Categoria = {
  id: string;
  nombre: string;
  activo: boolean;
  orden: number;
};
export type Tipo = "reto" | "castigo" | "especial";
export type Consigna = {
  id: string;
  categoria: string;
  tipo: Tipo;
  turnos?: number | null;
  texto: string;
  activo: boolean;
};
export type Catalogo = {
  revision: number;
  categorias: Categoria[];
  consignas: Consigna[];
};
export type Accion =
  | "categoria"
  | "consigna"
  | "subir"
  | "bajar"
  | "borrar_categoria"
  | "borrar_consigna";
export type Datos = Categoria | Consigna | { id: string };
const url = import.meta.env.VITE_SUPABASE_URL,
  key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY;
export const incompleto = Boolean(url) !== Boolean(key);
export const db = url && key ? createClient(url, key) : null;
const demoKey = "fratrespixel.catalogo.original.v2";
function demo(): Catalogo {
  const value = localStorage.getItem(demoKey);
  return value ? JSON.parse(value) : (structuredClone(ejemplo) as Catalogo);
}
export async function leer(): Promise<Catalogo> {
  if (!db) return demo();
  const { data, error } = await db.rpc("catalogo_admin");
  if (error) throw error;
  return data;
}
export async function guardar(
  revision: number,
  accion: Accion,
  datos: Datos,
): Promise<Catalogo> {
  if (db) {
    const { data, error } = await db.rpc("editar_catalogo", {
      esperada: revision,
      accion,
      datos,
    });
    if (error) throw error;
    return data;
  }
  const c = demo(),
    id = datos.id,
    n = c.categorias.findIndex((x) => x.id === id);
  if (c.revision !== revision)
    throw Object.assign(
      new Error("El catálogo cambió. Revisá los datos actualizados."),
      { code: "40001" },
    );
  if (accion === "categoria") {
    const cat = datos as Categoria;
    if (
      c.categorias.some(
        (x) =>
          x.id !== id && x.nombre.toLowerCase() === cat.nombre.toLowerCase(),
      )
    )
      throw new Error("Ya existe una categoría con ese nombre.");
    if (n < 0)
      c.categorias.push({
        ...cat,
        orden: Math.max(0, ...c.categorias.map((x) => x.orden)) + 1,
      });
    else c.categorias[n] = { ...cat, orden: c.categorias[n].orden };
  } else if (accion === "consigna") {
    const i = c.consignas.findIndex((x) => x.id === id);
    if (i < 0) c.consignas.push(datos as Consigna);
    else c.consignas[i] = datos as Consigna;
  } else if (accion === "borrar_consigna")
    c.consignas = c.consignas.filter((x) => x.id !== id);
  else if (accion === "borrar_categoria") {
    c.categorias = c.categorias.filter((x) => x.id !== id);
    c.consignas = c.consignas.filter((x) => x.categoria !== id);
  } else {
    const other = c.categorias[n + (accion === "subir" ? -1 : 1)];
    if (other) {
      [other.orden, c.categorias[n].orden] = [
        c.categorias[n].orden,
        other.orden,
      ];
      c.categorias.sort((a, b) => a.orden - b.orden);
    }
  }
  c.revision++;
  localStorage.setItem(demoKey, JSON.stringify(c));
  return c;
}
