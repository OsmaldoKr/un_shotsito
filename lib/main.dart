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
      theme: ThemeData.light().copyWith(  
        scaffoldBackgroundColor: colorPrimario,  // Crema fiesta cálida
        colorScheme: ColorScheme.light(
          primary: colorSecundario,     // Naranja shots energética
          secondary: acentoDivertido,   // Fucsia fiesta
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textoPrincipal),  // Negro suave
          bodyMedium: TextStyle(color: textoSecundario), // Gris oscuro
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: colorSecundario,
          foregroundColor: textoPrincipal,
          elevation: 0,
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
              colorPrimario,        // Crema fiesta cálida ✅
              fondoClaro,           // Blanco puro ✅
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
                    color: colorSecundario,  // Naranja shots energética ✅
                    letterSpacing: 1.4,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Donde los retos... ¡se ponen buenos!',
                  style: TextStyle(
                    fontSize: 16,
                    color: textoSecundario,  // Gris oscuro ✅
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 40),

                // 🍸 Indicador de carga vibrante
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(colorSecundario),  // Naranja shots
                  strokeWidth: 4,  // Más grueso para impacto
                  backgroundColor: colorExito.withAlpha(102),  // Verde lima sutil
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
