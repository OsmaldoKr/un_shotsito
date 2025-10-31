import 'package:flutter/material.dart';
import 'pantalla_reto.dart';
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
      'color': colorExito,
      'icono': Icons.flash_on,
    },
    {
      'titulo': 'Pasaditos',
      'descripcion': 'Las cosas empiezan a subir de tono',
      'color': colorSecundario,
      'icono': Icons.local_fire_department,
    },
    {
      'titulo': 'After',
      'descripcion': 'El modo para los que no se rinden',
      'color': colorPrimario,
      'icono': Icons.nightlife,
    },
    {
      'titulo': 'Hot',
      'descripcion': 'Nivel picante: solo para valientes',
      'color': acentoDivertido,
      'icono': Icons.favorite,
    },
    {
      'titulo': 'Pareja',
      'descripcion': 'Ideal para parejas o amigos con confianza',
      'color': colorExito,
      'icono': Icons.favorite_outline,
    },
    {
      'titulo': 'Bar',
      'descripcion': 'Perfecto para jugar en un bar o con desconocidos',
      'color': colorSecundario,
      'icono': Icons.local_bar,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final alturaPantalla = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: fondoOscuro,
      body: Column(
        children: [
          // 🔹 AppBar moderno SIN flecha de regreso
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: const BoxDecoration(
              color: colorPrimario,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: const Center(
              child: Text(
                'Elige el modo',
                style: TextStyle(
                  color: textoSecundario,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 🔹 Cuerpo con tarjetas tipo PageView
          Expanded(
            child: PageView.builder(
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
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    height: alturaPantalla * 0.7,
                    decoration: BoxDecoration(
                      color: tipo['color'], // 🔸 Color sólido del theme
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: tipo['color'].withOpacity(0.4),
                          blurRadius: 10,
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
                              color: textoSecundario.withAlpha(220),
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
          ),
        ],
      ),
    );
  }
}
