import 'package:flutter/material.dart';
import '../theme.dart';
import 'jugadores.dart';

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
          // 🎨 Fondo degradado fiesta vibrante
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorPrimario,           // Crema fiesta cálida ✅
                  fondoClaro.withAlpha(230), // Blanco puro translúcido ✅
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: CustomPaint(painter: _ParticlePainter(), size: size),
          ),

          // Contenido principal centrado para mobile
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
                      // 🔥 Título principal vibrante
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(_slideUp),
                        child: Text(
                          '¡UnShotsito!',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w900,
                            color: const Color.fromARGB(255, 255, 60, 0),  // Naranja shots energética ✅
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: textoPrincipal.withAlpha(153), // Negro suave sombra
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 📝 Subtítulo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'La fiesta empieza aquí',
                          style: TextStyle(
                            fontSize: 18,
                            color: textoSecundario,  // Gris oscuro ✅
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // 🎮 Botón circular fiesta
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
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorSecundario,     // Naranja shots ✅
                                  acentoDivertido,     // Fucsia fiesta ✅
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colorSecundario.withAlpha(128), // Naranja sombra
                                  offset: const Offset(0, 8),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: textoPrincipal.withAlpha(102), // Negro sutil
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 64,
                                color: Colors.white,
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
                      const SizedBox(height: 80),

                      // 📝 Footer elegante
                      Column(
                        children: [
                          Text(
                            'Creado por',
                            style: TextStyle(
                              fontSize: 13,
                              color: textoSecundario.withAlpha(204), // Gris oscuro
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'FratresPixel',
                            style: TextStyle(
                              fontSize: 15,
                              color: textoPrincipal,  // Negro suave ✅
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
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

          // ⚠️ Modal de aviso mejorado
          if (_mostrarAviso) _buildAvisoMejorado(context),
        ],
      ),
    );
  }

  Widget _buildAvisoMejorado(BuildContext context) {
    return Container(
      color: textoPrincipal.withAlpha(128), // Negro suave overlay
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                fondoClaro,              // Blanco puro ✅
                fondoClaro.withAlpha(230),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: textoPrincipal.withAlpha(128), // Negro suave sombra
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: acentoDivertido.withAlpha(102), // Fucsia sutil ✅
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_bar_rounded,
                  color: acentoDivertido,  // Fucsia fiesta ✅
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Consumo Responsable',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textoPrincipal,  // Negro suave ✅
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Para mayores de 18 años.\n'
                'Disfruta responsablemente.\n'
                'No conduzcas bajo efectos del alcohol.\n'
                'Tu salud es lo primero.',
                style: TextStyle(
                  fontSize: 16,
                  color: textoSecundario,  // Gris oscuro ✅
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cerrarAviso,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorExito,     // Verde lima ✅
                    foregroundColor: textoPrincipal, // Negro suave ✅
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '¡Estoy listo!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

// ✨ Partículas decorativas fiesta
class _ParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorSecundario.withAlpha(26) // Naranja sutil ✅
      ..style = PaintingStyle.fill;

    final random = DateTime.now().millisecond / 1000;

    for (int i = 0; i < 12; i++) {
      final x = (size.width * 0.1 * i + random * 50) % size.width;
      final y = (size.height * 0.2 * i + random * 30) % size.height;
      final radius = 2 + (random * 3);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
