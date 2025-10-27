import 'dart:math';
import 'package:flutter/material.dart';
import 'package:un_shotsito/theme.dart';

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
  int contadorRetos = 0; // 🔹 Controla cada cuántos retos aparece un castigo

  List<String> get castigos => [
    "Los de pelo claro reparten $shotsActual shots.",
    "El más callado del grupo bebe $shotsActual shots.",
    "Los que traigan algo rojo reparten $shotsActual tragos.",
    "Todos los que hayan dicho 'ya no tomo' hoy, tómense $shotsActual shots.",
    "El más lento en levantar la mano se toma $shotsActual tragos.",
    "¡A CAMBIAR! Cambia tu vaso con el jugador de la derecha.",
    "Shot de boca a boca",
    "El que vaya vestido todo de negro toma $shotsActual tragos, no es funeral pendejo.",
    "Los que usen Android pueden repartir $shotsActual tragos.",
    "Los que usen iPhone pueden repartir $shotsActual tragos.",
    "El más desmadroso de los jugadores puede repartir $shotsActual shots.",
  ];

  final Map<String, List<String>> retosPorModo = {
    'Pre': [
      "cuenta un chiste malo o bebe 3 shots."
      ],

    'Pasaditos': [
      "Name, di un fetiche de name, si name lo acepta, repartele 2 tragos, si no, bebetelos.",
      "Name, hazle una pregunta en secreto a Name (por ejemplo, ¿Quién es el más guapo?) y debe señalar a la persona.",
      "El último en darle un galletazo a Name se tiene que acabar su bebida.",
    ],

    'After': [
      "Name, tómate un video mientras te fondeas tu bebida.",
      "Si has tenido sexo en un carro, tómate 3 shots.",
    ],

    'Pareja': [
      "Name y Name, bésense durante 5 segundos 😘",
      "Name y Name, Bailen juntos 15 segundos 💃🕺",
    ],

    'Bar': [
      "Haz que el bartender te recomiende un trago 🍸",
      "Canta algo en voz alta 🎶",
    ],

    'Hot': [
      "Name, comenta un emoji enamorado en la publicación de Instagram que Name te diga, o tómate 5 shots.",
    ],
  };

  /// Reemplaza los "Name" del texto por nombres coherentes
  /// El primer "Name" -> jugador actual
  /// Los siguientes -> un jugador aleatorio distinto
  String procesarRetoAvanzado(
    String texto,
    String jugadorPrincipal,
    List<String> jugadores,
  ) {
    if (!texto.contains("Name") && !texto.contains("name")) {
      return "$jugadorPrincipal, ${texto[0].toLowerCase()}${texto.substring(1)}";
    }

    // Escoger jugador secundario distinto
    final otrosJugadores = List<String>.from(jugadores)
      ..remove(jugadorPrincipal);
    final jugadorSecundario = otrosJugadores.isNotEmpty
        ? otrosJugadores[random.nextInt(otrosJugadores.length)]
        : jugadorPrincipal;

    bool reemplazoHecho = false;
    final exp = RegExp(r'Name', caseSensitive: false);
    return texto.replaceAllMapped(exp, (match) {
      if (!reemplazoHecho) {
        reemplazoHecho = true;
        return jugadorPrincipal; // primer Name → principal
      } else {
        return jugadorSecundario; // demás → secundario
      }
    });
  }

  void generarReto() async {
    final retos = retosPorModo[widget.tipo] ?? retosPorModo['Pre']!;

    setState(() {
      jugadorActual = widget.jugadores[random.nextInt(widget.jugadores.length)];
      retoActual = procesarRetoAvanzado(
        retos[random.nextInt(retos.length)],
        jugadorActual!,
        widget.jugadores,
      );
      shotsActual =
          random.nextInt(widget.rango[1] - widget.rango[0] + 1) +
          widget.rango[0];
      contadorRetos++;
    });

    // 🔹 Mostrar “castigo express” cada 5 o 6 retos
    if (contadorRetos % (5 + random.nextInt(2)) == 0) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: fondoClaro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '¡Castigo!',
            style: TextStyle(
              color: textoPrincipal,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            castigos[random.nextInt(castigos.length)],
            textAlign: TextAlign.center,
            style: const TextStyle(color: textoPrincipal, fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Continuar',
                style: TextStyle(color: textoPrincipal),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorSecundario,
      appBar: AppBar(
        title: const Text("Pantalla de Reto"),
        backgroundColor: colorPrimario,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (jugadorActual != null && retoActual != null)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                padding: const EdgeInsets.all(20),
                height: 250,
                width: double.infinity, // 🔹 Más ancha
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: fondoOscuro.withAlpha(100),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      retoActual!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (shotsActual != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Si no cumples son $shotsActual shots 🍻",
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ElevatedButton(
              onPressed: generarReto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "Generar Reto 🍹",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
