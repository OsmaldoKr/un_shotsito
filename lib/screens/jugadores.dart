import 'package:flutter/material.dart';
import 'dart:math';
import 'modo.dart';
import 'package:un_shotsito/theme.dart';

class PantallaJugadores extends StatefulWidget {
  const PantallaJugadores({super.key});

  @override
  State<PantallaJugadores> createState() => _PantallaJugadoresState();
}

class _PantallaJugadoresState extends State<PantallaJugadores> {
  final TextEditingController _controller = TextEditingController();
  List<String> jugadores = [];
  final Map<String, Color> coloresJugadores = {};
  final random = Random();

  Color obtenerColorAleatorio() {
    final colores = [
      colorSecundario,
      colorExito,
      acentoDivertido,
      moradoSuave,
      azulFrio,
    ];
    return colores[random.nextInt(colores.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      body: Column(
        children: [
          // 🔹 Encabezado Curvo
          ClipPath(
            clipper: CurvaHeader(),
            child: Container(
              height: 180,
              color: colorPrimario,
              child: Center(
                child: Text(
                  "UnShotsito",
                  style: TextStyle(
                    color: textoPrincipal,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Agrega los nombres de los jugadores",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textoSecundario,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de texto
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: colorSecundario.withAlpha(50)),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: textoSecundario),
                      decoration: InputDecoration(
                        hintText: 'Nombre del jugador...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.person_add,
                            color: acentoDivertido,
                          ),
                          onPressed: () {
                            if (_controller.text.trim().isNotEmpty) {
                              final nombre = _controller.text.trim();
                              setState(() {
                                jugadores.add(nombre);
                                coloresJugadores[nombre] =
                                    obtenerColorAleatorio();
                                _controller.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Lista de jugadores
                  Expanded(
                    child: jugadores.isEmpty
                        ? const Center(
                            child: Text(
                              "Aún no hay jugadores",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: jugadores.map((nombre) {
                                final colorJugador =
                                    coloresJugadores[nombre] ??
                                    obtenerColorAleatorio();

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorJugador,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorJugador.withAlpha(80),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        nombre,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            jugadores.remove(nombre);
                                            coloresJugadores.remove(nombre);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ),

                  const SizedBox(height: 10),

                  // Botón siguiente
                  ElevatedButton(
                    onPressed: jugadores.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PantallaModo(jugadores: jugadores),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: jugadores.isEmpty
                          ? Colors.grey
                          : colorSecundario,
                      foregroundColor: textoPrincipal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Clase que dibuja la curva del encabezado
class CurvaHeader extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height, // punto medio del arco
      size.width,
      size.height - 50, // final del arco
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
