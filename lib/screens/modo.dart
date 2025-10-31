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

  final List<Map<String, Object>> infoModos = const [
    {
      'titulo': 'Leve',
      'descripcion': 'Ideal para empezar tranqui',
      'color': colorExito,
      'icono': Icons.spa,
    },
    {
      'titulo': 'Normal',
      'descripcion': 'El punto justo entre risas y caos',
      'color': colorSecundario,
      'icono': Icons.local_drink,
    },
    {
      'titulo': 'Piruca',
      'descripcion': 'Solo para los valientes sin retorno',
      'color': acentoDivertido,
      'icono': Icons.local_fire_department,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      body: Column(
        children: [
          // 🔹 Encabezado moderno curvo
          ClipPath(
            clipper: CurvaHeader(),
            child: Container(
              height: 180,
              color: colorPrimario,
              child: const Center(
                child: Text(
                  "Selecciona el modo de Shots 🍻",
                  style: TextStyle(
                    color: textoPrincipal,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Lista de modos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: infoModos.length,
                      itemBuilder: (context, index) {
                        final modo = infoModos[index];
                        final seleccionado =
                            modoSeleccionado == modo['titulo'];

                        // ✅ Convertimos a Color de forma segura
                        final colorBase = modo['color'] as Color;

                        return GestureDetector(
                          onTap: () =>
                              setState(() => modoSeleccionado = modo['titulo'] as String),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: colorBase,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: colorBase.withAlpha(60),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: seleccionado
                                  ? Border.all(color: textoPrincipal, width: 3)
                                  : null,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.white.withAlpha(40),
                                radius: 28,
                                child: Icon(
                                  modo['icono'] as IconData,
                                  color: textoPrincipal,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                modo['titulo'] as String,
                                style: const TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                modo['descripcion'] as String,
                                style: TextStyle(
                                  color: textoPrincipal.withAlpha(200),
                                  fontSize: 18,
                                ),
                              ),
                              trailing: Icon(
                                seleccionado
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: textoPrincipal,
                                size: 30,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 🔹 Botón continuar
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
                      backgroundColor: modoSeleccionado == null
                          ? Colors.grey
                          : acentoDivertido,
                      foregroundColor: fondoOscuro,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 6,
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Curva decorativa del encabezado
class CurvaHeader extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
