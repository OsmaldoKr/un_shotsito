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
  
  // Variable para controlar la visibilidad del aviso
  bool _mostrarAviso = true;

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

  void _cerrarAviso() {
    setState(() {
      _mostrarAviso = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Contenido principal
          Container(
            width: double.infinity,
            height: double.infinity,
            color: fondoOscuro,
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
                                backgroundColor: colorSecundario,
                                foregroundColor: textoPrincipal,
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

          // Aviso de responsabilidad (modal)
          if (_mostrarAviso)
            Container(
              color: Colors.black.withAlpha(7),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: fondoClaro,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ícono de advertencia
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: acentoDivertido,
                            size: 60,
                          ),
                          const SizedBox(height: 16),

                          // Título
                          const Text(
                            'Consumo Responsable',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textoPrincipal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Mensaje
                          const Text(
                            'Esta aplicación está diseñada únicamente para mayores de edad.\n\n'
                            'Bebe con responsabilidad y conoce tus límites. '
                            'No conduzcas bajo los efectos del alcohol.\n\n'
                            'El consumo excesivo de alcohol es dañino para la salud.',
                            style: TextStyle(
                              fontSize: 16,
                              color: textoSecundario,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Botón de aceptar
                          ElevatedButton(
                            onPressed: _cerrarAviso,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorExito,
                              foregroundColor: textoPrincipal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Entendido',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Botón X en la esquina superior derecha
                      Positioned(
                        top: -8,
                        right: -8,
                        child: IconButton(
                          onPressed: _cerrarAviso,
                          icon: const Icon(
                            Icons.close,
                            color: textoSecundario,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
