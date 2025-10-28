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
  int shotsActual = 0;
  int contadorRetos = 0;

  // Castigos dinámicos
  List<String> get castigos => [
        "Los de pelo claro reparten $shotsActual shots.",
        "El más callado del grupo bebe $shotsActual shots.",
        "Los que traigan algo rojo reparten $shotsActual tragos.",
        "Todos los que hayan dicho 'ya no tomo' hoy, tómense $shotsActual shots.",
        "El más lento en levantar la mano se toma $shotsActual tragos.",
        "Shot de boca a boca 🔥",
        "El que vaya vestido todo de negro toma $shotsActual tragos.",
        "Los que usen Android reparten $shotsActual tragos.",
        "Los que usen iPhone reparten $shotsActual tragos.",
        "El más desmadroso reparte $shotsActual shots.",
        "Cada vez que alguien se ría, deberá beber 1 shot.",
        "Si has tenido sexo en un carro, tómate $shotsActual shots.",
      ];

  final Map<String, List<String>> retosPorModo = {
    'Pre': [
      "Name, cuenta un chiste malo.",
      "Name, si alguno te ha invitado a tomar, agradécele y dale en la boca los tragos que quieras.",
    ],
    'Pasaditos': [
      "Name, di un fetiche de Name; si Name lo acepta, repártele 2 tragos; si no, bébetelos.",
      "Name, hazle una pregunta en secreto a Name y debe señalar a la persona.",
      "El último en darle un galletazo a Name se acaba su bebida.",
    ],
    'After': ["Name, grábate mientras te fondeas tu bebida."],
    'Pareja': [
      "Name y Name, bésense 5 segundos.",
      "Name y Name, bailen juntos 15 segundos",
    ],
    'Bar': [
      "Haz que el bartender te recomiende un trago",
      "Canta algo en voz alta",
    ],
    'Hot': [
      "Name, comenta un emoji enamorado en la publicación que Name te diga, o tómate 5 shots.",
    ],
  };

  String procesarRetoAvanzado(
      String texto, String jugadorPrincipal, List<String> jugadores) {
    if (!texto.contains("Name") && !texto.contains("name")) {
      return "$jugadorPrincipal, ${texto[0].toLowerCase()}${texto.substring(1)}";
    }

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
        return jugadorPrincipal;
      } else {
        return jugadorSecundario;
      }
    });
  }

  void generarReto() async {
    final retos = retosPorModo[widget.tipo] ?? retosPorModo['Pre']!;

    setState(() {
      jugadorActual = widget.jugadores[random.nextInt(widget.jugadores.length)];
      shotsActual = random.nextInt(widget.rango[1] - widget.rango[0] + 1) +
          widget.rango[0];
      retoActual = procesarRetoAvanzado(
        retos[random.nextInt(retos.length)],
        jugadorActual!,
        widget.jugadores,
      );
      contadorRetos++;
    });

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
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textoPrincipal,
              fontWeight: FontWeight.bold,
            ),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generarReto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [colorSecundario, acentoDivertido],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    retoActual!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: textoSecundario,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: generarReto,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text(
                    "Cumplió",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorExito,
                    foregroundColor: textoSecundario,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: fondoClaro,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text(
                          "Castigo Sorpresa",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          castigos[random.nextInt(castigos.length)],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: textoPrincipal,
                            fontSize: 18,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              generarReto();
                            },
                            child: const Text(
                              "Continuar",
                              style: TextStyle(color: textoPrincipal),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.local_fire_department,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Castigo",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: acentoDivertido,
                    foregroundColor: textoSecundario,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
