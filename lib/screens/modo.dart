import 'package:flutter/material.dart';
import 'tipo_juego.dart';
import 'package:un_shotsito/theme.dart';

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

  final List<Map<String, dynamic>> infoModos = const [
    {
      'titulo': 'Leve',
      'descripcion': 'Ideal para empezar tranqui',
      'color1': colorExito,
      'color2': Color(0xFF8BC34A),
      'icono': Icons.spa,
    },
    {
      'titulo': 'Normal',
      'descripcion': 'El punto justo entre risas y caos',
      'color1': colorSecundario,
      'color2': colorPrimario,
      'icono': Icons.local_drink,
    },
    {
      'titulo': 'Piruca',
      'descripcion': 'Solo para los valientes sin retorno',
      'color1': acentoDivertido,
      'color2': colorExito, // reemplazado colorTerciario por colorExito
      'icono': Icons.local_fire_department,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      appBar: AppBar(
        title: const Text(
          'Selecciona el modo de Shots',
          style: TextStyle(color: textoSecundario),
        ),
        backgroundColor: colorPrimario,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: infoModos.length,
                itemBuilder: (context, index) {
                  final modo = infoModos[index];
                  final seleccionado = modoSeleccionado == modo['titulo'];

                  return GestureDetector(
                    onTap: () => setState(() => modoSeleccionado = modo['titulo']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [modo['color1'], modo['color2']],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: seleccionado
                                ? modo['color2'].withOpacity(0.6)
                                : Colors.black.withAlpha(30),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: seleccionado
                            ? Border.all(color: textoSecundario, width: 3)
                            : null,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white.withAlpha(25),
                          radius: 28,
                          child: Icon(
                            modo['icono'],
                            color: textoSecundario,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          modo['titulo'],
                          style: const TextStyle(
                            color: textoSecundario,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          modo['descripcion'],
                          style: TextStyle(
                            color: textoSecundario.withAlpha(200),
                            fontSize: 20,
                          ),
                        ),
                        trailing: Icon(
                          seleccionado
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: seleccionado
                              ? textoSecundario
                              : Colors.white54,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: modoSeleccionado == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PantallaTipoJuego(
                            jugadores: widget.jugadores,
                            modo: modoSeleccionado!,
                            rango: modos[modoSeleccionado!]!,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    modoSeleccionado == null ? Colors.grey : acentoDivertido, // reemplazado colorTerciario
                foregroundColor: fondoOscuro,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 6,
              ),
              child: const Text(
                'Siguiente ➜',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
