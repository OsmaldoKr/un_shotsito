import 'package:flutter/material.dart';
import 'reto.dart';

class PantallaTipoJuego extends StatelessWidget {
  final List<String> jugadores;
  final String modo;
  final List<int> rango;

  PantallaTipoJuego({
    super.key,
    required this.jugadores,
    required this.modo,
    required this.rango,
  });

  final List<String> tipos = [
    'Pre',
    'Pasaditos',
    'After',
    'Hot',
    'Pareja',
    'Bar',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona el tipo de juego')),
      body: ListView(
        children: tipos
            .map(
              (t) => ListTile(
                title: Text(t),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PantallaReto(
                      jugadores: jugadores,
                      modo: modo,
                      rango: rango,
                      tipo: t,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
