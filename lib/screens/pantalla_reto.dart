import 'package:flutter/material.dart';
import 'package:un_shotsito/theme.dart';
import '../data/control_retos.dart';

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
  String textoReto = '';
  String textoCastigo = '';
  bool mostrandoCastigo = false;

  @override
  void initState() {
    super.initState();
    generarNuevoReto();
  }

  String _procesarRetoConJugadores(String texto) {
    if (!texto.contains('Name')) return texto;

    final jugadores = List<String>.from(widget.jugadores)..shuffle();
    final jugador1 = jugadores.isNotEmpty ? jugadores.first : 'Jugador 1';
    final jugador2 = jugadores.length > 1 ? jugadores[1] : jugador1;

    return texto.replaceFirst('Name', jugador1).replaceAll('Name', jugador2);
  }

  void generarNuevoReto() {
    // Obtenemos el objeto Reto
    final retoObj = obtenerRetoAleatorio(widget.tipo);
    // Extraemos el texto y lo procesamos con los jugadores
    final String reto = _procesarRetoConJugadores(retoObj.descripcion);

    setState(() {
      textoReto = reto;
      mostrandoCastigo = false;
      textoCastigo = '';
    });
  }

  void mostrarCastigo() {
    final String castigo = _procesarRetoConJugadores(obtenerCastigoAleatorio());
    setState(() {
      textoCastigo = castigo;
      mostrandoCastigo = true;
    });
  }

  void cerrarCastigo() {
    setState(() {
      mostrandoCastigo = false;
      textoCastigo = '';
    });
  }

  void completarReto({required bool cumplio}) {
    if (!cumplio) {
      mostrarCastigo();
    } else {
      generarNuevoReto();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: const BoxDecoration(
              color: fondoClaro,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: Text(
                widget.tipo,
                style: const TextStyle(
                  color: textoPrincipal,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: fondoClaro,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(40),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                textoReto.isEmpty
                                    ? '🎯 Pulsa un botón para comenzar'
                                    : textoReto,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: textoPrincipal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => completarReto(cumplio: true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorExito,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              "Cumplí",
                              style: TextStyle(
                                fontSize: 20,
                                color: textoPrincipal,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: mostrarCastigo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: acentoDivertido,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              "Castigo",
                              style: TextStyle(
                                fontSize: 20,
                                color: textoPrincipal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (mostrandoCastigo)
                  Container(
                    color: Colors.black.withAlpha(80),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(32),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorSecundario,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: acentoDivertido.withAlpha(80),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              textoCastigo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 26,
                                color: textoPrincipal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: cerrarCastigo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: acentoDivertido,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                "Continuar",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: textoPrincipal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
