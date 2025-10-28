import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/bienvenida.dart';

void main() {
  runApp(const UnShotsitoApp());
}

class UnShotsitoApp extends StatelessWidget {
  const UnShotsitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnShotsito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: fondoOscuro,
        colorScheme: ColorScheme.dark(
          primary: colorPrimario,
          secondary: colorSecundario,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textoSecundario),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const PantallaSplash(),
    );
  }
}

/// 🌟 Pantalla animada de carga antes de la bienvenida
class PantallaSplash extends StatefulWidget {
  const PantallaSplash({super.key});

  @override
  State<PantallaSplash> createState() => _PantallaSplashState();
}

class _PantallaSplashState extends State<PantallaSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const PantallaBienvenida(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorPrimario, // Gris Mapache
              fondoOscuro,   // Gris Nocturno
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeIn,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'UnShotsito',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: textoSecundario,
                    letterSpacing: 1.4,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Donde los retos... ¡se ponen buenos!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 40),

                // 🍸 Indicador de carga con color de acento sólido
                const CircularProgressIndicator(
                  color: colorSecundario, // Rosa mejilla de la paleta
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
