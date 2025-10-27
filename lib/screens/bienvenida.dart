import 'package:flutter/material.dart';
import '../theme.dart';
import 'jugadores.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
            "assets/images/logo_UnShotsito.png",
            width: 800,
            height: 600,
            ),

            const Text(
              '¡Bienvenido a UnShotsito!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PantallaJugadores()),
              ),
              child: const Text(
                'Empezar',
                style: TextStyle(
                  color: colorSecundario,
                )),
            ),
            const SizedBox(height: 50),
            const Text(
              'Creado por FratresPixel',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
