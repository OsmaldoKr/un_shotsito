import 'dart:math';

class ProcesadorTexto {
  final Random _random = Random();

  String procesarRetoConJugadores(String texto, List<String> jugadores) {
    if (!texto.contains('Name') && !texto.contains('name')) return texto;

    final jugadoresAleatorios = List<String>.from(jugadores)..shuffle();
    if (jugadoresAleatorios.isEmpty) return texto;

    final jugador1 = jugadoresAleatorios[0];
    final jugador2 = jugadoresAleatorios.length > 1
        ? jugadoresAleatorios[1]
        : jugadoresAleatorios[0];

    int contadorReemplazos = 0;

    texto = texto.replaceAllMapped(
      RegExp(r'Name|name'),
      (match) {
        contadorReemplazos++;
        return contadorReemplazos == 1 ? jugador1 : jugador2;
      },
    );

    return texto;
  }

  String procesarShotsEnReto(String texto, List<int> rango) {
    return texto.replaceAllMapped(
      RegExp(r'(\d+)\s*(shot|shots)', caseSensitive: false),
      (match) {
        final minShots = rango[0];
        final maxShots = rango[1];
        final cantidadShots =
            minShots + _random.nextInt(maxShots - minShots + 1);
        return '$cantidadShots ${match.group(2)}';
      },
    );
  }
}
