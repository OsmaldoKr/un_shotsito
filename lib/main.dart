import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const UnShotsitoApp());

class UnShotsitoApp extends StatelessWidget {
  const UnShotsitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnShotsito',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
          brightness: Brightness.dark,
        ),
      ),
      home: const PantallaBienvenida(),
    );
  }
}

/// ---------------------------
///  PANTALLA DE BIENVENIDA
/// ---------------------------
class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 191, 0, 194),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_drink, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text(
              '🍻 ¡Bienvenido a UnShotsito! 🍻',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaJugadores()),
              ),
              child: const Text('Empezar'),
            ),
            const SizedBox(height: 40),
            const Text(
              'Creado por FratresPixel',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
///  PANTALLA DE JUGADORES
/// ---------------------------
class PantallaJugadores extends StatefulWidget {
  const PantallaJugadores({super.key});

  @override
  State<PantallaJugadores> createState() => _PantallaJugadoresState();
}

class _PantallaJugadoresState extends State<PantallaJugadores> {
  final TextEditingController _controller = TextEditingController();
  List<String> jugadores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jugadores')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre del jugador',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        jugadores.add(_controller.text.trim());
                        _controller.clear();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Cambiado: usamos Wrap con Chips para mostrar los jugadores
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: jugadores
                      .asMap()
                      .entries
                      .map(
                        (entry) => Chip(
                          label: Text(entry.value),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() => jugadores.removeAt(entry.key));
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: jugadores.isEmpty
                  ? null
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PantallaModo(jugadores: jugadores),
                      ),
                    ),
              child: const Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
///  PANTALLA DE MODO DE JUEGO
/// ---------------------------
class PantallaModo extends StatefulWidget {
  final List<String> jugadores;
  const PantallaModo({super.key, required this.jugadores});

  @override
  State<PantallaModo> createState() => _PantallaModoState();
}

class _PantallaModoState extends State<PantallaModo> {
  String? modoSeleccionado;
  final Map<String, List<int>> modos = {
    'Leve': [1, 2],
    'Normal': [1, 3],
    'Piruca': [1, 5],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona el modo de Shots')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...modos.keys.map(
              (modo) => RadioListTile<String>(
                title: Text(
                  '$modo (${modos[modo]![0]}-${modos[modo]![1]} shots)',
                ),
                value: modo,
                // ignore: deprecated_member_use
                groupValue: modoSeleccionado,
                // ignore: deprecated_member_use
                onChanged: (value) {
                  setState(() {
                    modoSeleccionado = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: modoSeleccionado == null
                  ? null
                  : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PantallaTipoJuego(
                          jugadores: widget.jugadores,
                          modo: modoSeleccionado!,
                          rango: modos[modoSeleccionado!]!,
                        ),
                      ),
                    ),
              child: const Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------
///  PANTALLA DE TIPO DE JUEGO
/// ---------------------------
class PantallaTipoJuego extends StatelessWidget {
  final List<String> jugadores;
  final String modo;
  final List<int> rango;

  PantallaTipoJuego({
    super.key,
    required this.jugadores,
    required this.modo,
    required this.rango,
  });

  final List<String> tipos = [
    'Pre',
    'Pasaditos',
    'After',
    'Hot',
    'Pareja',
    'Bar',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona el tipo de juego')),
      body: ListView(
        children: tipos
            .map(
              (t) => ListTile(
                title: Text(t),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PantallaReto(
                      jugadores: jugadores,
                      modo: modo,
                      rango: rango,
                      tipo: t,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// ---------------------------
///  PANTALLA DE RETOS
/// ---------------------------
class PantallaReto extends StatefulWidget {
  final List<String> jugadores;
  final String modo;
  final List<int> rango;
  final String tipo;

  const PantallaReto({
    super.key,
    required this.jugadores,
    required this.modo,
    required this.rango,
    required this.tipo,
  });

  @override
  State<PantallaReto> createState() => _PantallaRetoState();
}

class _PantallaRetoState extends State<PantallaReto> {
  final random = Random();
  String? jugadorActual;
  String? retoActual;
  int? shotsActual;

  // Lista de palabras clave que activan el "spam"
  final List<String> efectosEspeciales = [
    "A CAMBIAR!",
    "Los que usen Android",
    "Los que usen iPhone",
  ];

  void mostrarSpam(String clave) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Atención! Reto especial detectado: $clave',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.purple,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  final Map<String, List<String>> retosPorModo = {
    'Pre': [
      "cuenta un chiste malo o bebe 3 shots.",
      "El que vaya vestido todo de negro toma 3 tragos, no es funeral pendejo.",
      "Los que usen Android pueden repartir 2 tragos.",
      "Los que usen iPhone pueden repartir 2 tragos.",
      "Los de pelo claro reparten 3 shots.",
      "Los de pelo chino reparten 2 tragos.",
      "Los que traigan jeans puestos se toman 2 shots.",
      "Los amigos de la infancia, tómense 3 shots juntos.",
      "Eh, quien esté leyendo esto, tómese 3 shots seguiditos.",
      "A CAMBIAR! Cambia tu vaso con el jugador de la derecha.",
      "El más desmadroso de los jugadores puede repartir 3 shots.",
    ],
    'Pasaditos': [
      "Name, hazle una pregunta en secreto a Name (por ejemplo, ¿Quién es el más guapo?) y debe señalar a la persona.",
      "Ahora Name, reta a Name a piedra papel o tijeras. Si ganas, tendrás que decir la pregunta que hiciste.",
      "El último en darle un galletazo a Name se tiene que acabar su bebida.",
      "Los foráneos toman 3 shots.",
      "Si fumas, tómate 3 shots.",
      "Los que dejan abajo a sus compas por sus parejas, 5 shots.",
      "Name, sirve un vaso que reemplazará la bebida de Name hasta que se la acabe.",
      "Name, cuenta lo peor que has hecho por amor. 1 shot por pendejo.",
      "El que saque un billete de mayor valor puede escoger dárselo a un jugador o fondearse su bebida.",
      "El primero en aventarle algo a Name reparte 4 shots.",
      "Name, di 'Me gusta tomar' en otros 2 idiomas, si no puedes, toma 2 shots.",
      "Los que se hayan ligado al ex de un amig@ que se tomen 3 shots.",
      "El último que se haya peleado con su pareja se toma 3 shots.",
      "Si te has despertado en un lugar sin saber cómo llegaste, tómate 5 shots.",
    ],
    'After': [
      "Name, tómate un video mientras te fondeas tu bebida.",
      "Name, toma un trago de cada bebida de todos.",
      "Name, deja que Name te eche un hielo en la espalda o tómate 6 tragos.",
      "Name, jálale los pelos a Name mientras tomas de tu bebida; cuando Name ya no pueda, paras.",
      "Tómate 5 shots si eres intolerante a la lactosa.",
      "Si has tenido sexo en un carro, tómate 3 shots.",
      "Si te das con alguno de los jugadores, tómate 3 shots por cada uno.",
      "Name, toma tantos shots como puedas; también se los tomará la persona de la derecha.",
      "Name, toma 5 shots sin usar las manos.",
      "Si no te gusta el olor del cigarro, tómate 3 shots.",
      "A los que les haga falta una rasuradita, tómense 3 shots.",
      "Si usas TikTok, tómate 5 shots.",
    ],
    'Pareja': [
      "Name, haz un reto con tu pareja 🤝",
      "Name, bésense durante 5 segundos 😘",
      "Bailen juntos 15 segundos 💃🕺",
      "Digan una cualidad que aman del otro ❤️",
      "Si no cumplen, ¡ambos shots! 🥃",
      "Name, si le has prestado ropa a alguno de los jugadores, hazlo beber 3 shots.",
      "Name, di el nombre completo de todos los jugadores; 1 shot por cada uno que no sepas.",
      "Name, si hay tequila, dale un shot a Name; si no, tómate 3.",
    ],
    'Bar': [
      "Haz que el bartender te recomiende un trago 🍸",
      "Haz un brindis con un desconocido 🍻",
      "Canta algo en voz alta 🎶",
      "Haz un reto grupal con alguien fuera del grupo 🎉",
      "Cuenta una anécdota graciosa de una noche de bar 😂",
      "Escojan a la persona más inteligente, que tendrá que acabarse su bebida.",
      "Name, sirve un poco de alcohol a las copas de todos.",
    ],
    'Hot': [
      "CASTIGO… Shot de boca a boca 😈",
      "Sube una historia con el celular de Name a close friends que diga lo que quieras.",
      "Name, ahora puedes escoger si borrarla o darle 10 shots en la boca a Name.",
      "Name, di un fetiche de Name; si Name lo acepta, repártele 2 tragos; si no, bébetelos.",
      "Name, comenta un emoji enamorado en la publicación de Instagram que Name te diga, o tómate 5 shots.",
      "Name, dale dos tragos en la boca a Name.",
      "Name, sube una historia que diga 'Mándame mensaje si estás caliente' o fondeate la mitad de tu bebida.",
      "Name, si te has besado con una persona de tu mismo sexo, toma 3 shots.",
      "Name, si te has besado con alguien, toma 3 shots.",
      "Name, si te has dado con alguien del grupo, toma 2 shots.",
      "Name, si alguno de los jugadores te ha invitado a tomar, agradéceles y dales en la boca los tragos que quieras.",
    ],
  };

  void generarReto() {
    final retos = retosPorModo[widget.modo] ?? retosPorModo['Pre']!;
    setState(() {
      jugadorActual = widget.jugadores[random.nextInt(widget.jugadores.length)];
      retoActual = retos[random.nextInt(retos.length)];
      shotsActual =
          random.nextInt(widget.rango[1] - widget.rango[0] + 1) +
          widget.rango[0];
    });

    // Spam para retos especiales
    if (retoActual != null) {
      for (var clave in efectosEspeciales) {
        if (retoActual!.contains(clave)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mostrarSpam(clave);
          });
          break;
        }
      }
    }
  }

  void mostrarSpamS(String clave) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Atención! Reto especial: $clave', textAlign: TextAlign.center),
        backgroundColor: Colors.purple,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    generarReto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.tipo} - ${widget.modo}')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Jugador:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                jugadorActual ?? '',
                style: const TextStyle(fontSize: 28, color: Colors.amber),
              ),
              const SizedBox(height: 20),
              Text(
                retoActual ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Text(
                'Si no cumples, son $shotsActual shots',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: generarReto,
                icon: const Icon(Icons.refresh),
                label: const Text('Siguiente reto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}