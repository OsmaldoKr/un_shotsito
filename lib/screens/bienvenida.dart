import 'package:flutter/material.dart';
import '../theme.dart';
import 'jugadores.dart';
import 'dart:math';
class PantallaBienvenida extends StatefulWidget {
  const PantallaBienvenida({super.key});

  @override
  State<PantallaBienvenida> createState() => _PantallaBienvenidaState();
}

class _PantallaBienvenidaState extends State<PantallaBienvenida>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeText;
  late Animation<double> _slideUp;
  late Animation<double> _scaleButton;

  bool _mostrarAviso = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _fadeText = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );

    _slideUp = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    );

    _scaleButton = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cerrarAviso() {
    setState(() {
      _mostrarAviso = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mobileWidth = size.width.clamp(320.0, 400.0);

    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Fondo shots profesional
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.2, -0.3),
                colors: [
                  colorPrimario,                    // Crema fiesta cálida
                  colorPrimario.withAlpha(230),
                  fondoClaro.withAlpha(204),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
            child: CustomPaint(painter: _ShotGlassPainter(), size: size),
          ),

          // 📱 Contenido principal
          SafeArea(
            child: Center(
              child: Container(
                width: mobileWidth,
                constraints: const BoxConstraints(maxWidth: 360),
                child: FadeTransition(
                  opacity: _fadeText,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 🥃 Logo shots principal
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(_slideUp),
                        child: Column(
                          children: [
                            Text(
                              'Un Shotsito',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: colorSecundario,
                                letterSpacing: 2.0,
                                height: 1.05,
                                shadows: [
                                  Shadow(
                                    color: textoPrincipal.withAlpha(153),
                                    offset: Offset(0, 4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 📝 Tagline profesional
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'La fiesta perfecta',
                          style: TextStyle(
                            fontSize: 18,
                            color: textoPrincipal,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // 🚀 Botón play shots
                      ScaleTransition(
                        scale: _scaleButton,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PantallaJugadores(),
                              ),
                            );
                          },
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorSecundario,
                                  shotsNaranja,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colorSecundario.withAlpha(153),
                                  offset: const Offset(0, 12),
                                  blurRadius: 32,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: textoPrincipal.withAlpha(102),
                                  offset: const Offset(0, 6),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 70,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(0, 3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),

                      // 👨‍💻 Footer brand
                      Column(
                        children: [
                          Text(
                            'Desarrollado por',
                            style: TextStyle(
                              fontSize: 13,
                              color: textoSecundario.withAlpha(204),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'FratresPixel',
                            style: TextStyle(
                              fontSize: 16,
                              color: textoPrincipal,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ⚠️ Aviso legal profesional
          if (_mostrarAviso) _buildAvisoLegal(context),
        ],
      ),
    );
  }

  Widget _buildAvisoLegal(BuildContext context) {
    return Container(
      color: textoPrincipal.withAlpha(140),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withAlpha(230),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: textoPrincipal.withAlpha(140),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Consumo Responsable',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: textoPrincipal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Para mayores de 18 años.\n'
                'Juega y bebe responsablemente.\n'
                'No conduzcas bajo efectos del alcohol.\n'
                'Tu seguridad primero.',
                style: TextStyle(
                  fontSize: 15,
                  color: textoSecundario,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cerrarAviso,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorSecundario,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '¡Empezar la fiesta!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🥃 Pintor vasos shots sutiles
class _ShotGlassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorSecundario.withAlpha(20)
      ..style = PaintingStyle.fill;

    final glassPaint = Paint()
      ..color = Colors.white.withAlpha(30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final now = DateTime.now().millisecondsSinceEpoch / 2000.0;

    // 4 vasos shots flotantes
    final positions = [
      Offset(size.width * 0.2, size.height * 0.3 + sin(now) * 10),
      Offset(size.width * 0.8, size.height * 0.6 + cos(now * 1.3) * 12),
      Offset(size.width * 0.15, size.height * 0.8 + sin(now * 0.7) * 8),
      Offset(size.width * 0.75, size.height * 0.25 + cos(now * 1.1) * 10),
    ];

    for (final pos in positions) {
      // Vaso shot outline
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: pos, width: 28, height: 42),
          const Radius.circular(6),
        ),
        glassPaint,
      );
      
      // Líquido shot
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(pos.dx, pos.dy + 8),
            width: 22,
            height: 20,
          ),
          const Radius.circular(4),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
