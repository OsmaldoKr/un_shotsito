import 'package:flutter/material.dart';
import 'pantalla_reto.dart';
import 'package:un_shotsito/theme.dart';

class PantallaTipoJuego extends StatelessWidget {
  final List<String> jugadores;

  const PantallaTipoJuego({
    super.key,
    required this.jugadores,
  });

  final List<Map<String, dynamic>> tiposJuego = const [
    {
      'titulo': 'SHOTS LIGEROS',
      'descripcion': 'Calentamiento con shots suaves',
      'color': Color(0xFFFF9800),  // shotsNaranja
      'emoji': '🥃',
    },
    {
      'titulo': 'SHOTS PICANTES',
      'descripcion': 'Retos + shots que queman',
      'color': Color(0xFFE91E63),  // fucsiaFiesta
      'emoji': '🍸',
    },
    {
      'titulo': 'SHOTS NOCTURNOS',
      'descripcion': 'After con shots infinitos',
      'color': Color(0xFFFFD93D),  // amarilloBrillante
      'emoji': '🍹',
    },
    {
      'titulo': 'SHOTS CALIENTES',
      'descripcion': 'Retos hot + shots dobles',
      'color': Color(0xFFF44336),  // rojoCocktail
      'emoji': '❤️',
    },
    {
      'titulo': 'SHOTS EN PAREJA',
      'descripcion': 'Shots compartidos íntimos',
      'color': Color(0xFF00BCD4),  // turquesaFiesta
      'emoji': '💕',
    },
    {
      'titulo': 'SHOTS DE BAR',
      'descripcion': 'Clásicos de bar + retos',
      'color': Color(0xFFFF5722),  // colorSecundario
      'emoji': '🍻',
    },
    {
      'titulo': 'SHOTS PARA CONFESAR',
      'descripcion': 'Verdades + shot castigo',
      'color': Color(0xFF9C27B0),  // violetaParty
      'emoji': '🗣️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimario,
      body: CustomScrollView(
        slivers: [
          // 🎯 HEADER SHOTS ORIGINAL
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorSecundario, acentoDivertido],
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
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          '¡Elige tu shot de retos!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 🎨 CARDS SHOTS ULTRA FIESTA
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tipo = tiposJuego[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ShotModeCard(
                      tipo: tipo,
                      jugadores: jugadores,
                      onTap: () => _navigateToReto(context, tipo),
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

  void _navigateToReto(BuildContext context, Map<String, dynamic> tipo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaReto(
          jugadores: jugadores,
          tipo: tipo['titulo'] as String,
        ),
      ),
    );
  }
}

class ShotModeCard extends StatelessWidget {
  final Map<String, dynamic> tipo;
  final List<String> jugadores;
  final VoidCallback onTap;

  const ShotModeCard({
    super.key,
    required this.tipo,
    required this.jugadores,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorShot = tipo['color'] as Color;
    final emojiShot = tipo['emoji'] as String;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: colorShot,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: colorShot.withAlpha(128),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: textoPrincipal.withAlpha(77),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Shot glass effect
              Positioned(
                right: 16,
                top: 16,
                child: Transform.rotate(
                  angle: -0.1,
                  child: Container(
                    width: 44,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withAlpha(128),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(128),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Shot emoji HERO
                    Hero(
                      tag: 'shot-${tipo['titulo']}',
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(153),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(77),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            emojiShot,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  offset: Offset(1, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 20),
                    
                    // Shot info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tipo['titulo'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
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
                          Flexible(
                            child: Text(
                              tipo['descripcion'] as String,
                              style: TextStyle(
                                color: Colors.white.withAlpha(230),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Shot arrow
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(230),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(102),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: textoPrincipal,
                        size: 20,
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
