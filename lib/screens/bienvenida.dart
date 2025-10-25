import 'package:flutter/material.dart';
import '../theme.dart';
import 'jugadores.dart';

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimario,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_drink, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
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
              child: const Text('Empezar'),
            ),
            const SizedBox(height: 162),
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
