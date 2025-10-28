import 'package:flutter/material.dart';
import 'reto.dart';
import 'package:un_shotsito/theme.dart';

class PantallaTipoJuego extends StatelessWidget {
  final List<String> jugadores;
  final String modo;
  final List<int> rango;

  const PantallaTipoJuego({
    super.key,
    required this.jugadores,
    required this.modo,
    required this.rango,
  });

  final List<Map<String, dynamic>> tiposJuego = const [
    {
      'titulo': 'Pre',
      'descripcion': 'Perfecto para empezar la noche con energía',
      'color1': colorExito,       // Verde lima
      'color2': colorPrimario,    // Gris mapache
      'icono': Icons.flash_on,
    },
    {
      'titulo': 'Pasaditos',
      'descripcion': 'Las cosas empiezan a subir de tono',
      'color1': colorSecundario,  // Rosa mejilla
      'color2': acentoDivertido,  // Rojo fiesta
      'icono': Icons.local_fire_department,
    },
    {
      'titulo': 'After',
      'descripcion': 'El modo para los que no se rinden',
      'color1': colorPrimario,    // Gris mapache
      'color2': colorExito,       // Verde lima (antes gris carbón)
      'icono': Icons.nightlife,
    },
    {
      'titulo': 'Hot',
      'descripcion': 'Nivel picante: solo para valientes',
      'color1': acentoDivertido,  // Rojo fiesta
      'color2': colorSecundario,  // Rosa mejilla
      'icono': Icons.favorite,
    },
    {
      'titulo': 'Pareja',
      'descripcion': 'Ideal para parejas o amigos con confianza',
      'color1': colorExito,       // Verde lima
      'color2': colorPrimario,    // Gris mapache
      'icono': Icons.favorite_outline,
    },
    {
      'titulo': 'Bar',
      'descripcion': 'Perfecto para jugar en un bar o con desconocidos',
      'color1': colorSecundario,  // Rosa mejilla
      'color2': acentoDivertido,  // Rojo fiesta
      'icono': Icons.local_bar,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final alturaPantalla = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: fondoOscuro,
      appBar: AppBar(
        title: const Text(
          'Selecciona el tipo de juego',
          style: TextStyle(color: textoSecundario),
        ),
        backgroundColor: colorPrimario,
        centerTitle: true,
        elevation: 3,
      ),
      body: PageView.builder(
        itemCount: tiposJuego.length,
        controller: PageController(viewportFraction: 0.85),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tipo = tiposJuego[index];

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PantallaReto(
                  jugadores: jugadores,
                  modo: modo,
                  rango: rango,
                  tipo: tipo['titulo'],
                ),
              ),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              height: alturaPantalla * 0.75,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [tipo['color1'], tipo['color2']],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: tipo['color2'].withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withAlpha(60),
                      child: Icon(
                        tipo['icono'],
                        color: textoSecundario,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      tipo['titulo'],
                      style: const TextStyle(
                        color: textoSecundario,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tipo['descripcion'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textoSecundario.withAlpha(200),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
