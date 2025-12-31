import 'package:flutter/material.dart';
import 'dart:math';
import 'package:un_shotsito/theme.dart';
import 'tipo_juego.dart';

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
      shotsNaranja,
      limaParty,
      fucsiaFiesta,
      turquesaFiesta,
      violetaParty,
      rojoCocktail,
    ];
    return colores[random.nextInt(colores.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimario,
      body: Column(
        children: [
          // 🎯 Header shots curva profesional
          ClipPath(
  clipper: CurvaHeader(),
  child: Container(
    height: 160,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [colorSecundario, acentoDivertido],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: SafeArea(
      child: Center(
        child: const Text(
          'JUGADORES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
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
                  
                  // 📊 Contador jugadores
                  Text(
                    "${jugadores.length} jugador${jugadores.length != 1 ? 'es' : ''} listo${jugadores.length != 1 ? 's' : ''}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    "Mínimo 2 jugadores",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textoSecundario.withAlpha(204),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // ⌨️ Input jugadores shots
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          fondoOscuro.withAlpha(77),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorSecundario.withAlpha(102),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorSecundario.withAlpha(77),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: textoPrincipal,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nombre del jugador...',
                        hintStyle: TextStyle(
                          color: textoSecundario.withAlpha(204),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.only(right: 12),
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
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [colorExito, shotsNaranja],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorExito.withAlpha(128),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
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
                  
                  // 👥 Lista chips jugadores
                  Expanded(
                    child: jugadores.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: textoSecundario.withAlpha(51),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.groups_outlined,
                                    size: 50,
                                    color: textoSecundario.withAlpha(204),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Aún no hay jugadores",
                                  style: TextStyle(
                                    color: textoPrincipal,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "¡Agrega los primeros para empezar!",
                                  style: TextStyle(
                                    color: textoSecundario,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 14,
                              runSpacing: 14,
                              alignment: WrapAlignment.center,
                              children: jugadores.map((nombre) {
                                final colorJugador = coloresJugadores[nombre] ??
                                    obtenerColorAleatorio();
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorJugador,
                                        colorJugador.withAlpha(230),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorJugador.withAlpha(128),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Flexible(
                                        child: Text(
                                          nombre,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            jugadores.remove(nombre);
                                            coloresJugadores.remove(nombre);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(179),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            color: Colors.white,
                                            size: 18,
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
                  
                  const SizedBox(height: 28),
                  
                  // 🚀 Botón siguiente shots
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: jugadores.length < 2
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PantallaTipoJuego(
                                    jugadores: jugadores,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: jugadores.length < 2
                            ? textoSecundario.withAlpha(128)
                            : colorSecundario,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: jugadores.length < 2 ? 0 : 12,
                        shadowColor: colorSecundario.withAlpha(153),
                      ),
                      child: Text(
                        jugadores.length < 2
                            ? 'Mínimo 2 jugadores'
                            : '¡Siguiente!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
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

class CurvaHeader extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
