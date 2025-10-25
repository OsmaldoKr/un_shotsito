import 'package:flutter/material.dart';
import 'tipo_juego.dart';

class PantallaModo extends StatefulWidget {
  final List<String> jugadores;
  const PantallaModo({super.key, required this.jugadores});

  @override
  State<PantallaModo> createState() => _PantallaModoState();
}

class _PantallaModoState extends State<PantallaModo> {
  String? modoSeleccionado;
  final Map<String, List<int>> modos = {
    'Leve': [1, 2],
    'Normal': [1, 3],
    'Piruca': [1, 5],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona el modo de Shots')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...modos.keys.map(
              (modo) => RadioListTile<String>(
                title: Text('$modo (${modos[modo]![0]}-${modos[modo]![1]} shots)'),
                value: modo,
                // ignore: deprecated_member_use
                groupValue: modoSeleccionado,
                // ignore: deprecated_member_use
                onChanged: (value) {
                  setState(() => modoSeleccionado = value);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: modoSeleccionado == null
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PantallaTipoJuego(
                            jugadores: widget.jugadores,
                            modo: modoSeleccionado!,
                            rango: modos[modoSeleccionado!]!,
                          ),
                        ),
                      ),
              child: const Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
