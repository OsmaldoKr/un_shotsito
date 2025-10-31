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
  late Animation<double> _fadeLogo;
  late Animation<double> _fadeText;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _fadeLogo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _fadeText = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: fondoOscuro, // Fondo sólido para legibilidad
        child: FadeTransition(
          opacity: _fadeLogo,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🥂 Logo animado
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      "assets/images/logo_UnShotsito.png",
                      width: size.width * 0.6,
                      height: size.height * 0.3,
                    ),
                  ),

                  const SizedBox(height: 20),

                  FadeTransition(
                    opacity: _fadeText,
                    child: Column(
                      children: [
                        const Text(
                          '¡Bienvenido a UnShotsito!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textoSecundario,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ✨ Botón con color sólido de la paleta
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorSecundario, // Rosa mejilla
                            foregroundColor: textoPrincipal,     // Texto blanco
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PantallaJugadores(),
                              ),
                            );
                          },
                          child: const Text(
                            'Empezar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        const Text(
                          'Creado por FratresPixel',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: textoSecundario,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
