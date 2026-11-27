import { useEffect, useRef, useState } from "react";
import type { FormEvent, ReactNode } from "react";
import { createRoot } from "react-dom/client";
import {
  Layers3,
  Dices,
  Plus,
  Zap,
  Flame,
  Moon,
  Heart,
  Music2,
  Sun,
  LayoutGrid,
  SlidersHorizontal,
  Search,
  Pencil,
  Trash2,
  ArrowUp,
  ArrowDown,
  Eye,
  Monitor,
  LogOut,
  X,
  Check,
  ChevronRight,
  CopyPlus,
} from "lucide-react";
import { db, incompleto, leer, guardar } from "./catalogo";
import type {
  Catalogo,
  Categoria,
  Consigna,
  Tipo,
  Datos,
  Accion,
} from "./catalogo";
import "./style.css";

const icons = [Sun, Zap, Moon, Flame, Heart, Music2, Layers3];
const nombres = [
  "Shots ligeros",
  "Shots picantes",
  "Shots nocturnos",
  "Shots calientes",
  "Shots en pareja",
  "Shots de bar",
  "Shots para confesar",
];
function Insignia({ nombre }: { nombre: string }) {
  const i = nombres.indexOf(nombre),
    Icon = icons[i] || Layers3;
  return (
    <span className={"insignia tono" + i}>
      <Icon size={19} />
    </span>
  );
}
function muestra(texto: string) {
  let i = 0;
  return texto
    .replace(/\bname\b/gi, () => (i++ % 2 ? "Luis" : "Ana"))
    .replaceAll("{jugador}", "Ana")
    .replaceAll("{otroJugador}", "Luis");
}
function cantidad(n: number, palabra: string) {
  return n + " " + palabra + (n === 1 ? "" : "s");
}
function Marca() {
  return (
    <span className="marca">
      <i>
        <Dices size={24} />
      </i>
      UnShotsito<span className="punto">.</span>
    </span>
  );
}
function errorTexto(e: unknown) {
  const err = e as { message?: string; code?: string };
  return err.code === "23505"
    ? "Ya existe una categoría con ese nombre."
    : err.message || "No se pudo completar la operación.";
}
function Modal({
  titulo,
  children,
  cerrar,
  busy,
}: {
  titulo: string;
  children: ReactNode;
  cerrar: () => void;
  busy: boolean;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  useEffect(() => {
    const el = ref.current!;
    el.showModal();
    return () => el.close();
  }, []);
  return (
    <dialog
      aria-label={titulo}
      ref={ref}
      onCancel={(e) => {
        e.preventDefault();
        if (!busy) cerrar();
      }}
    >
      <header>
        <h2>{titulo}</h2>
        <button
          className="icon"
          aria-label="Cerrar"
          disabled={busy}
          onClick={cerrar}
        >
          <X />
        </button>
      </header>
      {children}
    </dialog>
  );
}
type Editor =
  | { clase: "categoria"; obj: Categoria }
  | { clase: "consigna"; obj: Consigna }
  | { clase: "borrar_categoria"; obj: Categoria }
  | { clase: "borrar_consigna"; obj: Consigna };
function Formulario({
  editor,
  c,
  busy,
  onSave,
  cerrar,
  error,
}: {
  editor: Editor;
  c: Catalogo;
  busy: boolean;
  onSave: (a: Accion, d: Datos) => void;
  cerrar: () => void;
  error: string;
}) {
  const obj = editor.obj,
    cat = "nombre" in obj,
    borrar = editor.clase.startsWith("borrar");
  const [texto, T] = useState(cat ? obj.nombre : obj.texto),
    [activo, A] = useState(obj.activo),
    [dest, D] = useState(cat ? "" : obj.categoria);
  const [turnos, setTurnos] = useState(!cat ? (obj.turnos ?? 3) : 3);
  const textarea = useRef<HTMLTextAreaElement>(null);
  const existe = (cat ? c.categorias : c.consignas).some(
    (x) => x.id === obj.id,
  );
  const sustantivo = cat ? "categoría" : obj.tipo;
  const titulo =
    (borrar ? "Eliminar " : existe ? "Editar " : cat ? "Nueva " : "Agregar ") +
    sustantivo;
  const insert = (token: string) => {
    const el = textarea.current!;
    const inicio = el.selectionStart,
      fin = el.selectionEnd;
    const next = texto.slice(0, inicio) + token + texto.slice(fin);
    if (next.length > 600) return;
    T(next);
    requestAnimationFrame(() => {
      el.focus();
      el.setSelectionRange(inicio + token.length, inicio + token.length);
    });
  };
  function submit(e: FormEvent) {
    e.preventDefault();
    if (busy) return;
    if (borrar) {
      onSave(editor.clase, { id: obj.id });
      return;
    }
    if (!texto.trim()) return;
    onSave(
      editor.clase,
      cat
        ? { ...obj, nombre: texto.trim(), activo }
        : {
            ...obj,
            texto: texto.trim(),
            activo,
            categoria: dest,
            turnos: obj.tipo === "especial" ? turnos : null,
          },
    );
  }
  const relacionados = c.consignas.filter((i) => i.categoria === obj.id);
  return (
    <Modal titulo={titulo} busy={busy} cerrar={cerrar}>
      <form onSubmit={submit}>
        {borrar ? (
          <p>
            {cat
              ? "Se eliminará «" +
                obj.nombre +
                "» con " +
                cantidad(
                  relacionados.filter((x) => x.tipo === "reto").length,
                  "reto",
                ) +
                " y " +
                cantidad(
                  relacionados.filter((x) => x.tipo === "castigo").length,
                  "castigo",
                ) +
                "."
              : "Se eliminará «" + obj.texto + "»."}{" "}
            Esta acción es definitiva.
          </p>
        ) : (
          <>
            {cat ? (
              <label>
                Nombre de la categoría
                <input
                  autoFocus
                  required
                  maxLength={60}
                  value={texto}
                  onChange={(e) => T(e.target.value)}
                />
              </label>
            ) : (
              <>
                {obj.tipo !== "especial" && (
                  <label>
                    Categoría
                    <select value={dest} onChange={(e) => D(e.target.value)}>
                      {obj.tipo === "castigo" && (
                        <option value="general">General</option>
                      )}
                      {c.categorias.map((x) => (
                        <option key={x.id} value={x.id}>
                          {x.nombre}
                        </option>
                      ))}
                    </select>
                  </label>
                )}
                {obj.tipo === "especial" && (
                  <label>
                    Duración en turnos
                    <input
                      type="number"
                      required
                      min="1"
                      step="1"
                      value={turnos || ""}
                      onChange={(e) => setTurnos(Number(e.target.value))}
                    />
                  </label>
                )}
                <label>
                  Texto de la consigna
                  <textarea
                    autoFocus
                    ref={textarea}
                    required
                    maxLength={600}
                    rows={3}
                    value={texto}
                    onChange={(e) => T(e.target.value)}
                  />
                </label>
                <div className="tokens">
                  {[
                    ["nombre aleatorio", "name"],
                    ["jugador actual", "{jugador}"],
                    ["otro jugador", "{otroJugador}"],
                  ].map(([nombre, token]) => (
                    <button
                      type="button"
                      key={token}
                      onClick={() => insert(token)}
                    >
                      <CopyPlus size={14} />
                      Insertar {nombre}
                    </button>
                  ))}
                </div>
                <div className="vista">
                  <small>
                    <Eye size={14} />
                    Vista previa
                  </small>
                  {muestra(texto) || "La consigna aparecerá aquí."}
                </div>
              </>
            )}
            <label className="check">
              <input
                type="checkbox"
                role="switch"
                checked={activo}
                onChange={(e) => A(e.target.checked)}
              />
              Activo
            </label>
          </>
        )}
        {error && (
          <p role="alert" className="error">
            {error}
          </p>
        )}
        <footer>
          <button type="button" onClick={cerrar} disabled={busy}>
            Cancelar
          </button>
          <button
            className="primary"
            disabled={busy || (!borrar && !texto.trim())}
          >
            {busy ? "Guardando…" : borrar ? "Eliminar" : "Guardar"}
          </button>
        </footer>
      </form>
    </Modal>
  );
}
function Panel({
  c,
  setC,
  salir,
}: {
  c: Catalogo;
  setC: (c: Catalogo) => void;
  salir?: () => void;
}) {
  const [id, S] = useState(c.categorias[0]?.id),
    [tipo, P] = useState<Tipo>("reto"),
    [q, Q] = useState(""),
    [estado, F] = useState("todos");
  const [editor, E] = useState<Editor | null>(null),
    [busy, B] = useState(false),
    [mensaje, M] = useState(""),
    [error, Err] = useState("");
  const global = id === "general";
  const cat = global
    ? { id: "general", nombre: "General", activo: true, orden: 0 }
    : c.categorias.find((x) => x.id === id) || c.categorias[0];
  const contenidos = c.consignas.filter((x) => x.categoria === cat?.id),
    rows = contenidos.filter((x) => x.tipo === tipo);
  const filtradas = rows.filter(
    (x) =>
      x.texto.toLocaleLowerCase().includes(q.trim().toLocaleLowerCase()) &&
      (estado === "todos" || x.activo === (estado === "activos")),
  );
  const seleccionar = (v: string) => {
    S(v);
    P(v === "general" ? "especial" : "reto");
    Q("");
    F("todos");
    M("");
    Err("");
  };
  const abrir = (e: Editor) => {
    Err("");
    M("");
    E(e);
  };
  const nuevo = () =>
    abrir({
      clase: "consigna",
      obj: {
        id: crypto.randomUUID(),
        categoria: cat.id,
        tipo,
        texto: "",
        activo: true,
      },
    });
  async function save(a: Accion, d: Datos) {
    if (busy) return;
    B(true);
    Err("");
    M("");
    try {
      const next = await guardar(c.revision, a, d);
      setC(next);
      if (a === "categoria") seleccionar(d.id);
      E(null);
      M(
        db
          ? "Cambios guardados en el catálogo."
          : "Cambios guardados en este navegador.",
      );
    } catch (e) {
      if ((e as { code: string }).code === "40001") {
        E(null);
        try {
          setC(await leer());
        } catch {
          /* Se conserva la última lectura. */
        }
      }
      Err(errorTexto(e));
    } finally {
      B(false);
    }
  }
  return (
    <>
      <nav>
        <div className="wrap navin">
          <Marca />
          <span className="navsep" />
          <span className="adminlabel">Administración</span>
          <span className="right mode">
            <Monitor size={14} />
            {db ? "Panel conectado" : "Demo local"}
          </span>
          {salir && (
            <button onClick={salir}>
              <LogOut size={14} />
              Salir
            </button>
          )}
        </div>
      </nav>
      <main className="wrap">
        <section className="hero">
          <div>
            <div className="over">
              <span /> FRATRESPIXEL
            </div>
            <h1>
              Catálogo de juego<span>.</span>
            </h1>
            <p>Administrá las categorías, retos y castigos de UnShotsito.</p>
          </div>
          <div className="arte" aria-hidden="true">
            <b className="tarjeta una">
              <Zap />
            </b>
            <b className="tarjeta dos">
              <Dices />
            </b>
            <i>✦</i>
          </div>
        </section>
        <div className="layout">
          <aside>
            <header>
              <h2>
                <LayoutGrid size={18} />
                Categorías
              </h2>
              <em>{c.categorias.length}</em>
            </header>
            <button
              className="addcat"
              onClick={() =>
                abrir({
                  clase: "categoria",
                  obj: {
                    id: crypto.randomUUID(),
                    nombre: "",
                    activo: true,
                    orden: 0,
                  },
                })
              }
            >
              <Plus size={16} />
              Nueva categoría
            </button>
            <div className="catlist">
              {c.categorias.map((x) => (
                <button
                  key={x.id}
                  className={x.id === cat?.id ? "selected" : ""}
                  aria-pressed={x.id === cat?.id}
                  onClick={() => seleccionar(x.id)}
                >
                  <Insignia nombre={x.nombre} />
                  <strong>{x.nombre}</strong>
                  {!x.activo && <small>Inactiva</small>}
                  <ChevronRight size={16} />
                </button>
              ))}
            </div>
            <select
              className="mobile"
              aria-label="Seleccionar categoría"
              value={cat?.id || ""}
              onChange={(e) => seleccionar(e.target.value)}
            >
              <option value="general">Reglas generales</option>
              {c.categorias.map((x) => (
                <option key={x.id} value={x.id}>
                  {x.nombre}
                  {x.activo ? "" : " · Inactiva"}
                </option>
              ))}
            </select>
            <button
              className={"globalnav " + (global ? "selected" : "")}
              onClick={() => seleccionar("general")}
            >
              <Layers3 size={16} />
              Reglas generales
            </button>
          </aside>
          <section className="contenido">
            {cat ? (
              <>
                <header className="cathead">
                  <div>
                    <small>
                      {global ? "TODAS LAS CATEGORÍAS" : "CATEGORÍA"}
                    </small>
                    <h2>
                      {global ? "Reglas generales" : cat.nombre}{" "}
                      {!global && (
                        <span
                          className={"badge " + (cat.activo ? "on" : "off")}
                        >
                          ● {cat.activo ? "Activa" : "Inactiva"}
                        </span>
                      )}
                    </h2>
                  </div>
                  {!global && (
                    <button
                      onClick={() => abrir({ clase: "categoria", obj: cat })}
                    >
                      <Pencil size={14} />
                      Editar categoría
                    </button>
                  )}
                </header>
                {!global && (
                  <div className="tools">
                    <span>
                      Orden {c.categorias.indexOf(cat) + 1} de{" "}
                      {c.categorias.length}
                    </span>
                    <button
                      disabled={busy || cat === c.categorias[0]}
                      onClick={() => save("subir", cat)}
                    >
                      <ArrowUp />
                      Subir
                    </button>
                    <button
                      disabled={busy || cat === c.categorias.at(-1)}
                      onClick={() => save("bajar", cat)}
                    >
                      <ArrowDown />
                      Bajar
                    </button>
                    <button
                      className="delcat"
                      onClick={() =>
                        abrir({ clase: "borrar_categoria", obj: cat })
                      }
                    >
                      <Trash2 />
                      Eliminar categoría
                    </button>
                  </div>
                )}
                <div className="tabs">
                  {(global
                    ? (["especial", "castigo"] as const)
                    : (["reto", "castigo"] as const)
                  ).map((t) => (
                    <button
                      key={t}
                      aria-pressed={tipo === t}
                      className={tipo === t ? "current" : ""}
                      onClick={() => {
                        P(t);
                        Q("");
                        F("todos");
                      }}
                    >
                      {t === "reto" ? <Zap size={17} /> : <Flame size={17} />}{" "}
                      {t === "especial"
                        ? "Especiales"
                        : t === "reto"
                          ? "Retos"
                          : "Castigos"}{" "}
                      <em>{contenidos.filter((x) => x.tipo === t).length}</em>
                    </button>
                  ))}
                </div>
                <div className="panelbody">
                  <div className="listhead">
                    <h3>
                      {global
                        ? tipo === "especial"
                          ? "Retos especiales"
                          : "Castigos generales"
                        : (tipo === "reto" ? "Retos de " : "Castigos de ") +
                          cat.nombre}
                    </h3>
                    <button className="primary" onClick={nuevo}>
                      <Plus size={16} />
                      Agregar {rows.length ? "" : "primer "}
                      {tipo}
                    </button>
                  </div>
                  <div className="filtros">
                    <label>
                      <Search size={17} />
                      <input
                        aria-label="Buscar consigna"
                        placeholder={"Buscar " + tipo + "…"}
                        value={q}
                        onChange={(e) => Q(e.target.value)}
                      />
                    </label>
                    <label>
                      <SlidersHorizontal size={15} />
                      <select
                        aria-label="Filtrar por estado"
                        value={estado}
                        onChange={(e) => F(e.target.value)}
                      >
                        <option value="todos">Todos los estados</option>
                        <option value="activos">Activos</option>
                        <option value="inactivos">Inactivos</option>
                      </select>
                    </label>
                  </div>
                  <div className="rows">
                    {filtradas.map((x) => (
                      <article key={x.id}>
                        <div className="rowicon">
                          {tipo === "reto" ? (
                            <Zap size={18} />
                          ) : (
                            <Flame size={18} />
                          )}
                        </div>
                        <div className="rowbody">
                          <p>
                            {x.texto
                              .split(/(\{(?:jugador|otroJugador)\})/g)
                              .map((s, i) =>
                                s.startsWith("{") ? (
                                  <mark key={i}>{s}</mark>
                                ) : (
                                  s
                                ),
                              )}
                          </p>
                          <div className="rowmeta">
                            {x.turnos && (
                              <span className="badge off">
                                {cantidad(x.turnos, "turno")}
                              </span>
                            )}
                            <span
                              className={"badge " + (x.activo ? "on" : "off")}
                            >
                              ● {x.activo ? "Activo" : "Inactivo"}
                            </span>
                            <button
                              onClick={() =>
                                abrir({ clase: "consigna", obj: x })
                              }
                            >
                              <Pencil />
                              Editar
                            </button>
                            <button
                              onClick={() =>
                                abrir({ clase: "borrar_consigna", obj: x })
                              }
                            >
                              <Trash2 />
                              Eliminar
                            </button>
                          </div>
                        </div>
                      </article>
                    ))}
                  </div>
                  {!filtradas.length && (
                    <p className="empty">
                      {rows.length
                        ? "Ninguna consigna coincide con los filtros."
                        : "Esta categoría todavía no tiene " + tipo + "s."}
                    </p>
                  )}
                </div>
              </>
            ) : (
              <p className="empty">
                Creá tu primera categoría para cargar consignas.
              </p>
            )}
          </section>
        </div>
        <div className="footbrand">
          <Dices size={15} />
          UnShotsito <span>por FratresPixel</span>
        </div>
      </main>
      {mensaje && (
        <div role="status" className="toast">
          <Check size={16} />
          {mensaje}
          <button aria-label="Cerrar aviso" onClick={() => M("")}>
            <X size={14} />
          </button>
        </div>
      )}
      {error && !editor && (
        <div role="alert" className="toast error">
          {error}
          <button onClick={() => Err("")}>Cerrar</button>
        </div>
      )}
      {editor && (
        <Formulario
          editor={editor}
          c={c}
          busy={busy}
          cerrar={() => {
            E(null);
            Err("");
          }}
          onSave={save}
          error={error}
        />
      )}
    </>
  );
}
function App() {
  const [auth, setAuth] = useState<string | null | undefined>(
      db ? undefined : "demo",
    ),
    [c, C] = useState<Catalogo | null>(null),
    [error, Err] = useState(""),
    [busy, B] = useState(false),
    [intento, R] = useState(0);
  useEffect(() => {
    if (!db) return;
    const { data } = db.auth.onAuthStateChange((_e, s) => {
      setAuth(s?.user.id ?? null);
    });
    return () => data.subscription.unsubscribe();
  }, []);
  useEffect(() => {
    let vivo = true;
    C(null);
    Err("");
    if (auth && !incompleto)
      leer()
        .then((v) => {
          if (vivo) C(v);
        })
        .catch((e) => {
          if (vivo) Err(errorTexto(e));
        });
    return () => {
      vivo = false;
    };
  }, [auth, intento]);
  async function login(e: FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const form = new FormData(e.currentTarget);
    B(true);
    Err("");
    try {
      const { error } = await db!.auth.signInWithPassword({
        email: String(form.get("email")),
        password: String(form.get("password")),
      });
      if (error) throw error;
    } catch (e) {
      Err(errorTexto(e));
    } finally {
      B(false);
    }
  }
  const salir = async () => {
    const r = await db!.auth.signOut({ scope: "local" });
    if (r.error) Err(r.error.message);
  };
  if (c && auth)
    return <Panel key={auth} c={c} setC={C} salir={db ? salir : undefined} />;
  return (
    <section className="auth">
      <Marca />
      {incompleto ? (
        <p>Completá ambas variables de Supabase y volvé a compilar el panel.</p>
      ) : auth === null ? (
        <form onSubmit={login}>
          <h1>Ingresar al panel</h1>
          <label>
            Correo
            <input name="email" type="email" autoComplete="username" required />
          </label>
          <label>
            Contraseña
            <input
              name="password"
              type="password"
              autoComplete="current-password"
              required
            />
          </label>
          <button className="primary" disabled={busy}>
            Ingresar
          </button>
        </form>
      ) : (
        !error && <p>Cargando catálogo…</p>
      )}
      {error && (
        <p role="alert" className="error">
          {error}
        </p>
      )}
      {auth && error && (
        <>
          <button onClick={() => R(intento + 1)}>Reintentar</button>
          {db && <button onClick={salir}>Cerrar sesión</button>}
        </>
      )}
    </section>
  );
}
createRoot(document.getElementById("root")!).render(<App />);
