import 'package:flutter/material.dart';
import 'modo.dart';

class PantallaJugadores extends StatefulWidget {
  const PantallaJugadores({super.key});

  @override
  State<PantallaJugadores> createState() => _PantallaJugadoresState();
}

class _PantallaJugadoresState extends State<PantallaJugadores> {
  final TextEditingController _controller = TextEditingController();
  List<String> jugadores = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jugadores')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre del jugador',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        jugadores.add(_controller.text.trim());
                        _controller.clear();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: jugadores
                      .asMap()
                      .entries
                      .map(
                        (entry) => Chip(
                          label: Text(entry.value),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() => jugadores.removeAt(entry.key));
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: jugadores.isEmpty
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PantallaModo(jugadores: jugadores),
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
