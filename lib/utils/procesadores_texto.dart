import 'dart:math';

class ProcesadorTexto {
  ProcesadorTexto({
    Random? random,
  }) : _random = random ?? Random();

  final Random _random;

  static final RegExp _marcadorNombre = RegExp(
    r'\bname\b',
    caseSensitive: false,
  );

  static final RegExp _cantidadShots = RegExp(
    r'\b\d+\s*shots?\b',
    caseSensitive: false,
  );

  static final RegExp _espaciosMultiples = RegExp(r'\s+');

  /// Reemplaza cada marcador `name` con jugadores aleatorios.
  ///
  /// Cuando existen al menos dos jugadores distintos, alterna entre
  /// ambos para evitar que una frase mencione dos veces a la misma
  /// persona de forma innecesaria.
  String procesarRetoConJugadores(
    String texto,
    List<String> jugadores,
  ) {
    final textoLimpio = texto.trim();

    if (textoLimpio.isEmpty) {
      return texto;
    }

    if (!_marcadorNombre.hasMatch(textoLimpio)) {
      return texto;
    }

    final jugadoresValidos = _normalizarJugadores(
      jugadores,
    );

    if (jugadoresValidos.isEmpty) {
      return texto;
    }

    jugadoresValidos.shuffle(_random);

    final jugadorPrincipal = jugadoresValidos.first;

    final jugadorSecundario = jugadoresValidos.length > 1
        ? jugadoresValidos[1]
        : jugadorPrincipal;

    var contadorReemplazos = 0;

    return texto.replaceAllMapped(
      _marcadorNombre,
      (match) {
        final jugadorSeleccionado =
            contadorReemplazos.isEven
                ? jugadorPrincipal
                : jugadorSecundario;

        contadorReemplazos++;

        return jugadorSeleccionado;
      },
    );
  }

  /// Sustituye las cantidades escritas antes de `shot` o `shots`
  /// por una cantidad aleatoria dentro del rango indicado.
  ///
  /// Ejemplo:
  ///
  /// `Toma 2 shots` con el rango `[1, 4]` podría convertirse en
  /// `Toma 3 shots`.
  String procesarShotsEnReto(
    String texto,
    List<int> rango,
  ) {
    if (texto.trim().isEmpty) {
      return texto;
    }

    if (rango.length < 2) {
      return texto;
    }

    var minimo = rango[0];
    var maximo = rango[1];

    if (minimo > maximo) {
      final temporal = minimo;
      minimo = maximo;
      maximo = temporal;
    }

    minimo = max(0, minimo);
    maximo = max(0, maximo);

    if (!_cantidadShots.hasMatch(texto)) {
      return texto;
    }

    return texto.replaceAllMapped(
      _cantidadShots,
      (match) {
        final cantidad = _generarCantidadAleatoria(
          minimo: minimo,
          maximo: maximo,
        );

        final unidad = cantidad == 1
            ? 'shot'
            : 'shots';

        return '$cantidad $unidad';
      },
    );
  }

  /// Procesa nombres y cantidades de shots en una sola llamada.
  String procesarTextoCompleto({
    required String texto,
    required List<String> jugadores,
    required List<int> rangoShots,
  }) {
    final textoConJugadores = procesarRetoConJugadores(
      texto,
      jugadores,
    );

    return procesarShotsEnReto(
      textoConJugadores,
      rangoShots,
    );
  }

  /// Devuelve una lista limpia, sin nombres vacíos ni duplicados.
  List<String> _normalizarJugadores(
    List<String> jugadores,
  ) {
    final nombresUnicos = <String, String>{};

    for (final jugador in jugadores) {
      final nombreLimpio = jugador
          .trim()
          .replaceAll(_espaciosMultiples, ' ');

      if (nombreLimpio.isEmpty) {
        continue;
      }

      final claveNormalizada =
          nombreLimpio.toLowerCase();

      nombresUnicos.putIfAbsent(
        claveNormalizada,
        () => nombreLimpio,
      );
    }

    return nombresUnicos.values.toList();
  }

  int _generarCantidadAleatoria({
    required int minimo,
    required int maximo,
  }) {
    if (minimo == maximo) {
      return minimo;
    }

    return minimo +
        _random.nextInt(
          maximo - minimo + 1,
        );
  }
}
