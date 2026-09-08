import 'package:flutter/foundation.dart';

import 'estadistica_jugador.dart';

class ControlEstadisticasRetos extends ChangeNotifier {
  ControlEstadisticasRetos(List<String> nombresJugadores) {
    establecerJugadores(nombresJugadores);
  }

  final List<EstadisticaJugador> _jugadores = [];

  List<EstadisticaJugador> get jugadores => List.unmodifiable(_jugadores);

  int get totalCumplidos => _jugadores.fold(
        0,
        (total, jugador) => total + jugador.retosCumplidos,
      );

  int get totalNoCumplidos => _jugadores.fold(
        0,
        (total, jugador) => total + jugador.retosNoCumplidos,
      );

  EstadisticaJugador? jugadorEnTurno(int turnoActual) {
    if (_jugadores.isEmpty) return null;
    return _jugadores[_indiceSeguro(turnoActual)];
  }

  void establecerJugadores(List<String> nombres) {
    _jugadores
      ..clear()
      ..addAll(
        nombres.asMap().entries.map(
              (entrada) => EstadisticaJugador(
                id: entrada.key,
                nombre: _nombreSeguro(entrada.value, entrada.key),
              ),
            ),
      );
    notifyListeners();
  }

  void registrarResultado({
    required int turnoActual,
    required bool cumplido,
  }) {
    if (_jugadores.isEmpty) return;

    final indice = _indiceSeguro(turnoActual);
    final jugador = _jugadores[indice];

    _jugadores[indice] = jugador.copiarCon(
      retosCumplidos:
          cumplido ? jugador.retosCumplidos + 1 : jugador.retosCumplidos,
      retosNoCumplidos: cumplido
          ? jugador.retosNoCumplidos
          : jugador.retosNoCumplidos + 1,
    );

    notifyListeners();
  }

  void reiniciar() {
    for (var indice = 0; indice < _jugadores.length; indice++) {
      _jugadores[indice] = _jugadores[indice].copiarCon(
        retosCumplidos: 0,
        retosNoCumplidos: 0,
      );
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> exportar() {
    return _jugadores.map((jugador) => jugador.toJson()).toList();
  }

  void restaurar(List<dynamic> datos) {
    _jugadores
      ..clear()
      ..addAll(
        datos.map(
          (dato) => EstadisticaJugador.fromJson(
            Map<String, dynamic>.from(dato as Map),
          ),
        ),
      );
    notifyListeners();
  }

  int _indiceSeguro(int indice) {
    return indice.clamp(0, _jugadores.length - 1).toInt();
  }

  String _nombreSeguro(String nombre, int indice) {
    final nombreLimpio = nombre.trim();
    return nombreLimpio.isEmpty ? 'Jugador ${indice + 1}' : nombreLimpio;
  }
}
