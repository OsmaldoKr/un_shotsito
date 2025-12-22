import 'package:flutter/material.dart';
import 'pantalla_reto.dart';
import 'package:un_shotsito/theme.dart';

class PantallaTipoJuego extends StatelessWidget {
  final List<String> jugadores;
  final String modo;
  final List<int> rango;

  const PantallaTipoJuego({
    super.key,
    required this.jugadores,
    required this.modo,
    required this.rango,
  });

  final List<Map<String, dynamic>> tiposJuego = const [
    {
      'titulo': 'Pre',
      'descripcion': 'Perfecto para empezar la noche con energía',
      'colorPrimario': Color(0xFFFF9800),
      'colorSecundario': Color(0xFFCDDC39),
      'emoji': '⚡',
    },
    {
      'titulo': 'Pasaditos',
      'descripcion': 'Las cosas empiezan a subir de tono',
      'colorPrimario': Color(0xFFE91E63),
      'colorSecundario': Color(0xFF00BCD4),
      'emoji': '🔥',
    },
    {
      'titulo': 'After',
      'descripcion': 'El modo para los que no se rinden',
      'colorPrimario': Color(0xFFFFD93D),
      'colorSecundario': Color(0xFFFDC830),
      'emoji': '🌙',
    },
    {
      'titulo': 'Hot',
      'descripcion': 'Nivel picante: solo para valientes',
      'colorPrimario': Color(0xFFF44336),
      'colorSecundario': Color(0xFF9C27B0),
      'emoji': '❤️',
    },
    {
      'titulo': 'Pareja',
      'descripcion': 'Ideal para parejas o amigos con confianza',
      'colorPrimario': Color(0xFF00BCD4),
      'colorSecundario': Color(0xFF1976D2),
      'emoji': '💕',
    },
    {
      'titulo': 'Bar',
      'descripcion': 'Perfecto para jugar en un bar',
      'colorPrimario': Color(0xFFFF5722),
      'colorSecundario': Color(0xFF4CAF50),
      'emoji': '🍻',
    },
    {
      'titulo': 'Funas',
      'descripcion': 'Revela secretos para no moverte del sofá',
      'colorPrimario': Color(0xFF9C27B0), // Morado misterioso
      'colorSecundario': Color(0xFFFF4081), // Rosa chismoso
      'emoji': '🗣️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimario,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorSecundario,
                    acentoDivertido,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorSecundario.withAlpha(102),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '¡Elige tu tipo de juego!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
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
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tipo = tiposJuego[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _TarjetaTipoJuegoHorizontal(
                      tipo: tipo,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PantallaReto(
                            jugadores: jugadores,
                            modo: modo,
                            rango: rango,
                            tipo: tipo['titulo'],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: tiposJuego.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaTipoJuegoHorizontal extends StatelessWidget {
  final Map<String, dynamic> tipo;
  final VoidCallback onTap;

  const _TarjetaTipoJuegoHorizontal({
    required this.tipo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorPrimario = tipo['colorPrimario'] as Color;
    final colorSecundario = tipo['colorSecundario'] as Color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorPrimario.withAlpha(102),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: textoPrincipal.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colorPrimario, colorSecundario],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(77),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withAlpha(128),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tipo['emoji'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tipo['titulo'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Expanded(
                            child: Text(
                              tipo['descripcion'],
                              style: TextStyle(
                                color: Colors.white.withAlpha(230),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(204),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black87,
                        size: 18,
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
  }
}
