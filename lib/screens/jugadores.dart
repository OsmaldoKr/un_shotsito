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
      shotsNaranja,      // Naranja shots vibrante ✅
      limaParty,         // Lima fiesta brillante ✅
      fucsiaFiesta,      // Fucsia energética ✅
      turquesaFiesta,    // Turquesa refrescante ✅
      violetaParty,      // Violeta coqueta ✅
      rojoCocktail,      // Rojo cóctel intenso ✅
    ];
    return colores[random.nextInt(colores.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimario,  // Crema fiesta cálida ✅
      body: Column(
        children: [
          // 🔹 Encabezado curvo fiesta
          ClipPath(
            clipper: CurvaHeader(),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorSecundario,     // Naranja shots ✅
                    acentoDivertido,     // Fucsia fiesta ✅
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  "UnShotsito",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "${jugadores.length} jugador${jugadores.length != 1 ? 'es' : ''} listo${jugadores.length != 1 ? 's' : ''}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textoSecundario,  // Gris oscuro ✅
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 🎮 Campo de texto fiesta
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          fondoOscuro.withAlpha(51),  // Beige claro sutil ✅
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorSecundario.withAlpha(128), // Naranja borde
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorSecundario.withAlpha(77),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: textoPrincipal,  // Negro suave ✅
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nombre del jugador...',
                        hintStyle: TextStyle(
                          color: textoSecundario.withAlpha(204), // Gris sutil
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              if (_controller.text.trim().isNotEmpty) {
                                final nombre = _controller.text.trim();
                                setState(() {
                                  jugadores.add(nombre);
                                  coloresJugadores[nombre] = obtenerColorAleatorio();
                                  _controller.clear();
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorExito,      // Verde lima ✅
                                    shotsNaranja,    // Naranja shots ✅
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorExito.withAlpha(102),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_add_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 🎊 Lista de jugadores chips vibrantes
                  Expanded(
                    child: jugadores.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.groups_rounded,
                                  size: 80,
                                  color: textoSecundario.withAlpha(153),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Aún no hay jugadores",
                                  style: TextStyle(
                                    color: textoSecundario,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "¡Agrega los primeros!",
                                  style: TextStyle(
                                    color: textoSecundario.withAlpha(204),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.center,
                              children: jugadores.map((nombre) {
                                final colorJugador = coloresJugadores[nombre] ??
                                    obtenerColorAleatorio();

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorJugador,
                                        colorJugador.withAlpha(204),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorJugador.withAlpha(102),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        nombre,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            jugadores.remove(nombre);
                                            coloresJugadores.remove(nombre);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(153),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),

                  // 🚀 Botón siguiente fiesta
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: jugadores.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PantallaModo(jugadores: jugadores),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: jugadores.isEmpty
                            ? textoSecundario.withAlpha(128)
                            : colorSecundario,        // Naranja shots ✅
                        foregroundColor: textoPrincipal, // Negro suave ✅
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: jugadores.isEmpty ? 0 : 8,
                        shadowColor: colorSecundario.withAlpha(128),
                      ),
                      child: Text(
                        '¡Siguiente!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
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
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
