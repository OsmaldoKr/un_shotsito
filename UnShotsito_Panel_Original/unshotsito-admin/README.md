# UnShotsito · Administración del catálogo

Panel de FratresPixel en React, TypeScript y Vite. Administrá las siete categorías de tu app, sus retos y sus castigos opcionales. El juego Flutter descarga el catálogo activo al comenzar cada partida.

## Actualizar tu instalación anterior

Si ya ejecutaste los scripts 01 y 02, ejecutá **solo** `supabase/03_panel_original.sql` una vez en SQL Editor. La migración conserva los UUID, las cuentas administradoras y las consignas existentes. Actualiza los seis nombres iniciales que aún coinciden con el ejemplo y agrega Shots para confesar. Si ya personalizaste un nombre, lo respeta. El panel incluye consignas de muestra de mímica, música y juegos de grupo.

En **Reglas generales** se administran los castigos compartidos y los especiales con duración en turnos. El botón **Insertar nombre aleatorio** agrega el marcador `name` del juego original. Para probar el resultado en SQL Editor ejecutá `select jsonb_pretty(public.catalogo_partida());`. Esta consulta devuelve las categorías, los castigos generales y las definiciones activas de los especiales. La duración de un especial se guarda en Supabase; el juego lleva los turnos restantes en cada partida. El ejemplo Flutter incluido consume la consulta de categorías anterior. La conexión de la app original a esta consulta ampliada requiere integrarla en su código.

## Probar el panel en tu PC

Instalá Node.js 22.12 o posterior. Abrí esta carpeta en VS Code y ejecutá en la terminal:

```sh
npm ci
npm run dev
```

Abrí la dirección indicada por Vite. Con las dos variables de Supabase vacías aparece **Demo local**. Los cambios de ese modo quedan en ese navegador. El catálogo compartido se inicializa con los scripts SQL. Para verificar el proyecto, ejecutá `npm test` y `npm run build`.

## Conectar Supabase y habilitar al primer administrador

1. Creá un proyecto Supabase con la Data API habilitada y el esquema público expuesto. En SQL Editor ejecutá primero `supabase/01_schema.sql` (una vez) y después `supabase/02_ejemplos.sql` y `supabase/03_panel_original.sql`, en ese orden.
2. En **Authentication → Users → Add user → Create new user**, creá tu usuario con correo y contraseña y confirmá el correo. Copiá su UUID.
3. En SQL Editor ejecutá lo siguiente después de sustituir el UUID:

```sql
insert into shots.admins(user_id)
values ('REEMPLAZAR-POR-UUID'::uuid)
on conflict do nothing;
```

4. Copiá `.env.example` a `.env.local`. En Windows PowerShell podés usar `Copy-Item .env.example .env.local`. Completá `VITE_SUPABASE_URL` con la URL HTTPS del proyecto y `VITE_SUPABASE_PUBLISHABLE_KEY` con su clave **publishable**. Reiniciá Vite e ingresá con el usuario del paso 2. Usá exclusivamente la clave pública en Vite y Flutter.
5. Los jugadores consultan `public.catalogo_juego()` sin cuenta. Las tablas están en el esquema privado `shots`, con RLS activa y sin acceso directo para clientes. Las funciones de administración verifican `auth.uid()` contra la lista de administradores en cada lectura y escritura. El guardado es transaccional. Si otro administrador cambió el catálogo, el panel recarga los datos para que revises la edición.

## Publicar en GitHub Pages

1. Subí el contenido de esta carpeta a la raíz de tu repositorio en la rama `main`, incluyendo `.github/workflows/pages.yml`, `.gitignore` y `package-lock.json`.
2. En **Settings → Pages → Build and deployment → Source**, seleccioná **GitHub Actions**.
3. En **Settings → Secrets and variables → Actions → Variables**, creá dos variables de repositorio con los mismos nombres y valores públicos de `.env.local`.
4. En **Actions → Publicar panel en GitHub Pages → Run workflow**, ejecutá la publicación. Los siguientes cambios en `main` también la activan. Abrí la URL del despliegue. Los cambios de contenido que hagás desde el panel se guardan directamente en Supabase.

## Conectar tu proyecto Flutter

En tu app ejecutá `flutter pub add http`. En Android, verificá que el manifiesto principal `android/app/src/main/AndroidManifest.xml` incluya `<uses-permission android:name="android.permission.INTERNET"/>` dentro de `manifest`, antes de `application`.

- `flutter/lib/catalogo.dart` descarga una lista inmutable con una petición POST a `/rest/v1/rpc/catalogo_juego` usando la clave pública. Cada categoría contiene su UUID, nombre y las listas de retos y castigos activos.
- `flutter/lib/tipo_juego.dart` carga esa lista una vez por partida. Al elegir una categoría entrega un `ControlRetos` a la pantalla que lo solicita.
- `flutter/lib/control_retos.dart` selecciona una consigna de esa categoría y sustituye `{jugador}` y `{otroJugador}` por los nombres que le pasés desde tu lógica de turnos. Una categoría sin retos queda deshabilitada. Para una categoría sin castigos, el método opcional devuelve null.
- `flutter/lib/main.dart` muestra la integración con Ana y Luis como jugadores de ejemplo. En tu juego conservá tu pantalla de retos, tus jugadores y tu control de turnos. Incorporá la carga al iniciar cada partida.

Para ejecutar el **ejemplo independiente** en Chrome, entrá en `flutter/` y corré:

```sh
flutter create --platforms=web --project-name ejemplo_unshotsito .
flutter pub get
flutter run -d chrome --dart-define=SUPABASE_URL=https://TU-PROYECTO.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=TU_CLAVE_PUBLICA
```

Para Android, generá también la plataforma con `--platforms=android,web`, revisá el permiso de Internet y usá el identificador de tu teléfono en lugar de `chrome`.

## Prueba de aceptación

Con el panel y Flutter apuntando al mismo Supabase, creá **Mímica**, agregá dos retos activos y un castigo activo. Iniciá una partida y seleccioná Mímica. Dejá esa partida abierta y desactivá un reto en el panel. La partida en curso conserva los dos retos. Pulsá **Nueva partida** y la categoría mostrará un reto y un castigo.

La prueba automática de `tests/catalogo.mjs` ejecuta los scripts en PostgreSQL embebido (PGlite), simula los roles de Supabase y comprueba ese escenario, los permisos, el orden, el traslado entre categorías y el rechazo de escrituras desactualizadas.

[Documentación de Supabase](https://supabase.com/docs/guides/database/postgres/row-level-security) · [Vite en GitHub Pages](https://vite.dev/guide/static-deploy.html#github-pages)
