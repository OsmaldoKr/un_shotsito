import 'dart:math';
import 'package:flutter/material.dart';

class PantallaReto extends StatefulWidget {
  final List<String> jugadores;
  final String modo;
  final List<int> rango;
  final String tipo;

  const PantallaReto({
    super.key,
    required this.jugadores,
    required this.modo,
    required this.rango,
    required this.tipo,
  });

  @override
  State<PantallaReto> createState() => _PantallaRetoState();
}

class _PantallaRetoState extends State<PantallaReto> {
  final random = Random();
  String? jugadorActual;
  String? retoActual;
  int? shotsActual;

  final List<String> efectosEspeciales = [
    "A CAMBIAR!",
    "Los que usen Android",
    "Los que usen iPhone",
  ];

  final Map<String, List<String>> retosPorModo = {
    // (Tu lista completa de retos, igual que antes)
  };

  void generarReto() {
    final retos = retosPorModo[widget.tipo] ?? retosPorModo['Pre']!;
    setState(() {
      jugadorActual = widget.jugadores[random.nextInt(widget.jugadores.length)];
      retoActual = retos[random.nextInt(retos.length)];
      shotsActual =
          random.nextInt(widget.rango[1] - widget.rango[0] + 1) +
          widget.rango[0];
    });

    if (retoActual != null) {
      for (var clave in efectosEspeciales) {
        if (retoActual!.contains(clave)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('¡Atención! Reto especial detectado: $clave'),
                backgroundColor: Colors.purple,
              ),
            );
          });
          break;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    generarReto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.tipo} - ${widget.modo}')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Jugador:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(jugadorActual ?? '', style: const TextStyle(fontSize: 28, color: Colors.amber)),
              const SizedBox(height: 20),
              Text(retoActual ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Text(
                'Si no cumples, son $shotsActual shots',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: generarReto,
                icon: const Icon(Icons.refresh),
                label: const Text('Siguiente reto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
