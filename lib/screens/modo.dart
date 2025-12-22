import 'package:flutter/material.dart';
import 'tipo_juego.dart';
import 'package:un_shotsito/theme.dart';

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

  final List<Map<String, dynamic>> infoModos = const [
    {
      'titulo': 'Leve',
      'descripcion': 'Ideal para empezar tranqui',
      'colorPrimario': Color(0xFFFF9800),  // shotsNaranja
      'colorSecundario': Color(0xFFCDDC39), // limaParty
      'icono': Icons.spa_rounded,
    },
    {
      'titulo': 'Normal',
      'descripcion': 'El punto justo entre risas',
      'colorPrimario': Color(0xFFE91E63),  // fucsiaFiesta
      'colorSecundario': Color(0xFF00BCD4), // turquesaFiesta
      'icono': Icons.local_drink_rounded,
    },
    {
      'titulo': 'Piruca',
      'descripcion': 'Solo para los valientes sin retorno',
      'colorPrimario': Color(0xFFF44336),  // rojoCocktail
      'colorSecundario': Color(0xFF9C27B0), // violetaParty
      'icono': Icons.local_fire_department_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimario,
      body: Column(
        children: [
          ClipPath(
            clipper: CurvaHeader(),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorSecundario,
                    acentoDivertido,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "¡Elige tu nivel de shots!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 2),
                          blurRadius: 6,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: infoModos.length,
                      itemBuilder: (context, index) {
                        final modo = infoModos[index];
                        final seleccionado = modoSeleccionado == modo['titulo'];
                        final colorPrimario = modo['colorPrimario'] as Color;
                        final colorSecundario = modo['colorSecundario'] as Color;

                        return GestureDetector(
                          onTap: () => setState(
                            () => modoSeleccionado = modo['titulo'] as String,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.elasticOut,
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: colorPrimario.withAlpha(102),
                                  blurRadius: 20,
                                  offset: const Offset(0, 12),
                                ),
                                BoxShadow(
                                  color: textoPrincipal.withAlpha(77),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: seleccionado
                                  ? Border.all(color: Colors.white, width: 4)
                                  : null,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                children: [
                                  // Gradiente vibrante
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [colorPrimario, colorSecundario],
                                      ),
                                    ),
                                  ),
                                  // Overlay para texto
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withAlpha(153),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Contenido
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Row(
                                      children: [
                                        // Icono grande
                                        Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(77),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withAlpha(153),
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            modo['icono'] as IconData,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                modo['titulo'] as String,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 1.0,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black87,
                                                      offset: Offset(0, 2),
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                modo['descripcion'] as String,
                                                style: TextStyle(
                                                  color: Colors.white.withAlpha(230),
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Check animado
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: seleccionado 
                                                ? Colors.white 
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withAlpha(153),
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            seleccionado
                                                ? Icons.check_rounded
                                                : Icons.radio_button_unchecked_rounded,
                                            color: seleccionado 
                                                ? colorPrimario 
                                                : Colors.white.withAlpha(153),
                                            size: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: modoSeleccionado == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PantallaTipoJuego(
                                    jugadores: widget.jugadores,
                                    modo: modoSeleccionado!,
                                    rango: modos[modoSeleccionado!]!,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: modoSeleccionado == null
                            ? textoSecundario.withAlpha(128)
                            : colorSecundario,
                        foregroundColor: textoPrincipal,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: modoSeleccionado == null ? 0 : 12,
                        shadowColor: colorSecundario.withAlpha(153),
                      ),
                      child: Text(
                        modoSeleccionado == null 
                            ? 'Elige un modo' 
                            : 'Siguiente',
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
