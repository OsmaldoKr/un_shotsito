import 'dart:math';
import 'catalogo.dart';

class ControlRetos {
  ControlRetos(this.categoria);
  final Categoria categoria;
  final Random _azar = Random();

  String siguienteReto(String jugador, String otroJugador) =>
      _elegir(categoria.retos, jugador, otroJugador);

  String? castigoOpcional(String jugador, String otroJugador) =>
      categoria.castigos.isEmpty ? null : _elegir(categoria.castigos, jugador, otroJugador);

  String _elegir(List<Consigna> lista, String actual, String otro) {
    final texto = lista[_azar.nextInt(lista.length)].texto;
    return texto.replaceAllMapped(RegExp(r'\{(jugador|otroJugador)\}'),
        (m) => m.group(1) == 'jugador' ? actual : otro);
  }
}
