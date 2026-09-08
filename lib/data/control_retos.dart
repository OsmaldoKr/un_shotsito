import 'dart:math';

import 'castigos.dart';
import 'retos.dart';
import 'retos_especiales.dart';

class Reto {
  const Reto({
    required this.descripcion,
    required this.categoria,
  });

  final String descripcion;
  final String categoria;

  bool get disponible => descripcion.trim().isNotEmpty;

  @override
  String toString() {
    return 'Reto(categoria: $categoria, descripcion: $descripcion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Reto &&
            other.descripcion == descripcion &&
            other.categoria == categoria;
  }

  @override
  int get hashCode => Object.hash(descripcion, categoria);
}

/// Maneja los mazos (barajas) de textos únicos por categoría.
///
/// Evita que una misma categoría repita el último texto sacado al
/// reiniciar el mazo, y evita duplicados dentro de un mismo lote
/// cuando se extraen varios textos con [extraerVarios].
class _GestorMazos {
  _GestorMazos(this._random);

  Random _random;
  final Map<String, List<String>> _mazos = {};
  final Map<String, String?> _ultimoPorCategoria = {};

  void actualizarRandom(Random random) {
    _random = random;
    reiniciar();
  }

  void reiniciar() {
    _mazos.clear();
    _ultimoPorCategoria.clear();
  }

  String extraerUno(
    String clave,
    List<String> opciones, {
    String? anteriorForzado,
  }) {
    final anterior = anteriorForzado ?? _ultimoPorCategoria[clave];
    final texto = _extraerDelMazo(
      clave: clave,
      opcionesActuales: opciones,
      ultimoTexto: anterior,
    );
    _ultimoPorCategoria[clave] = texto;
    return texto;
  }

  /// Extrae [cantidad] textos, únicos entre sí dentro del lote,
  /// respetando el mazo persistente de la categoría.
  List<String> extraerVarios(
    String clave,
    List<String> opciones,
    int cantidad,
  ) {
    final cantidadFinal = min(cantidad, opciones.length);
    final resultado = <String>[];
    final usadosEnLote = <String>{};

    // Cota de seguridad para no entrar en bucle infinito si algo
    // inesperado ocurre con las opciones (p. ej. todas duplicadas).
    var intentosRestantes = cantidadFinal * 5 + 5;

    while (resultado.length < cantidadFinal && intentosRestantes > 0) {
      intentosRestantes--;
      final texto = extraerUno(clave, opciones);

      if (usadosEnLote.add(_normalizarTexto(texto))) {
        resultado.add(texto);
      }
    }

    return resultado;
  }

  String _extraerDelMazo({
    required String clave,
    required List<String> opcionesActuales,
    String? ultimoTexto,
  }) {
    var mazo = _mazos[clave];

    if (mazo == null ||
        mazo.isEmpty ||
        !_mazoCoincideConOpciones(mazo, opcionesActuales)) {
      mazo = _crearMazo(opcionesActuales, ultimoTexto: ultimoTexto);
      _mazos[clave] = mazo;
    }

    return mazo.removeLast();
  }

  List<String> _crearMazo(
    Iterable<String> opciones, {
    String? ultimoTexto,
  }) {
    final mazo = _limpiarListaTextos(opciones)..shuffle(_random);

    if (mazo.length > 1 && ultimoTexto != null) {
      final ultimoNormalizado = _normalizarTexto(ultimoTexto);
      final indiceFinal = mazo.length - 1;

      // removeLast() será la próxima carta: si coincide con la
      // anterior, se mueve al inicio para evitar dos ciclos seguidos
      // que empiecen con el mismo texto.
      if (_normalizarTexto(mazo[indiceFinal]) == ultimoNormalizado) {
        final repetido = mazo.removeAt(indiceFinal);
        mazo.insert(0, repetido);
      }
    }

    return mazo;
  }

  bool _mazoCoincideConOpciones(
    List<String> mazo,
    List<String> opcionesActuales,
  ) {
    final opcionesNormalizadas =
        opcionesActuales.map(_normalizarTexto).toSet();
    return mazo.every(
      (elemento) => opcionesNormalizadas.contains(_normalizarTexto(elemento)),
    );
  }
}

Random _random = Random();
final _GestorMazos _gestorRetos = _GestorMazos(_random);
final _GestorMazos _gestorCastigos = _GestorMazos(_random);

List<String> _mazoRetosEspeciales = [];
String? _ultimoRetoEspecialId;

void configurarGeneradorAleatorio(Random random) {
  _random = random;
  _gestorRetos.actualizarRandom(random);
  _gestorCastigos.actualizarRandom(random);
  reiniciarMazos();
}

void reiniciarMazos() {
  _gestorRetos.reiniciar();
  _gestorCastigos.reiniciar();
  _mazoRetosEspeciales = [];
  _ultimoRetoEspecialId = null;
}

Reto obtenerRetoAleatorio(
  String categoria, {
  String? descripcionAnterior,
}) {
  final categoriaLimpia = _limpiarTexto(categoria);

  if (categoriaLimpia.isEmpty) {
    return const Reto(
      descripcion: 'La categoría seleccionada no es válida.',
      categoria: 'Sin categoría',
    );
  }

  final entradaCategoria = _buscarCategoria(categoriaLimpia);

  if (entradaCategoria == null || entradaCategoria.value.isEmpty) {
    return Reto(
      descripcion: 'No hay retos disponibles para esta categoría.',
      categoria: categoriaLimpia,
    );
  }

  final retosValidos = _limpiarListaTextos(entradaCategoria.value);

  if (retosValidos.isEmpty) {
    return Reto(
      descripcion: 'No hay retos disponibles para esta categoría.',
      categoria: entradaCategoria.key,
    );
  }

  final claveCategoria = _normalizarTexto(entradaCategoria.key);
  final descripcion = _gestorRetos.extraerUno(
    claveCategoria,
    retosValidos,
    anteriorForzado: descripcionAnterior,
  );

  return Reto(
    descripcion: descripcion,
    categoria: entradaCategoria.key,
  );
}

List<Reto> obtenerRetosAleatorios(
  String categoria, {
  int cantidad = 3,
}) {
  if (cantidad <= 0) {
    return [];
  }

  final categoriaLimpia = _limpiarTexto(categoria);
  final entradaCategoria = _buscarCategoria(categoriaLimpia);

  if (entradaCategoria == null) {
    return [];
  }

  final retosValidos = _limpiarListaTextos(entradaCategoria.value);
  final claveCategoria = _normalizarTexto(entradaCategoria.key);

  final descripciones = _gestorRetos.extraerVarios(
    claveCategoria,
    retosValidos,
    cantidad,
  );

  return List.unmodifiable(
    descripciones.map(
      (d) => Reto(descripcion: d, categoria: entradaCategoria.key),
    ),
  );
}

String obtenerCastigoAleatorio({
  String? categoria,
  String? castigoAnterior,
}) {
  final categoriaResuelta = categoria == null
      ? castigoGeneral
      : resolverCategoriaCastigo(categoria);
  final castigosValidos = _limpiarListaTextos(
    getCastigos(categoria: categoriaResuelta),
  );

  if (castigosValidos.isEmpty) {
    return 'No hay castigos disponibles.';
  }

  final claveCategoria = _normalizarTexto(categoriaResuelta);
  return _gestorCastigos.extraerUno(
    claveCategoria,
    castigosValidos,
    anteriorForzado: castigoAnterior,
  );
}

/// Devuelve un castigo cuya categoría corresponde a la del [reto] que
/// no se cumplió. Útil para el flujo: reto fallado -> castigo a juego.
String obtenerCastigoParaReto(
  Reto reto, {
  String? castigoAnterior,
}) {
  final categoriaCastigo = _mapearCategoriaRetoACastigo(reto.categoria);
  return obtenerCastigoAleatorio(
    categoria: categoriaCastigo,
    castigoAnterior: castigoAnterior,
  );
}

/// Traduce el nombre de una categoría de RETO al nombre de categoría de
/// CASTIGO que le corresponde. Ajusta este mapa si tus categorías de
/// `retos.dart` usan nombres distintos a las claves de la izquierda.
const Map<String, String> _categoriaRetoACastigo = {
  'general': castigoGeneral,
  'confesiones': castigoConfesiones,
  'shots para confesar': castigoConfesiones,
  'shots ligeros': castigoShotsLigeros,
  'ligeros': castigoShotsLigeros,
  'picantes': castigoPicantes,
  'nocturnos': castigoNocturnos,
  'pareja': castigoPareja,
  'shot en pareja': castigoPareja,
  'calientes': castigoCalientes,
  'shots calientes': castigoCalientes,
  'bar': castigoBar,
  'shot de bar': castigoBar,
};

String _mapearCategoriaRetoACastigo(String categoriaReto) {
  final normalizada = _normalizarTexto(categoriaReto);
  return _categoriaRetoACastigo[normalizada] ?? castigoGeneral;
}

List<String> obtenerCastigosAleatorios({
  String? categoria,
  int cantidad = 3,
}) {
  if (cantidad <= 0) {
    return [];
  }

  final categoriaResuelta = categoria == null
      ? castigoGeneral
      : resolverCategoriaCastigo(categoria);
  final castigosValidos = _limpiarListaTextos(
    getCastigos(categoria: categoriaResuelta),
  );
  final claveCategoria = _normalizarTexto(categoriaResuelta);

  return _gestorCastigos.extraerVarios(
    claveCategoria,
    castigosValidos,
    cantidad,
  );
}

RetoEspecial? obtenerRetoEspecialCompletoAleatorio({
  String? ultimoId,
}) {
  final retosValidos = _obtenerRetosEspecialesValidos();

  if (retosValidos.isEmpty) {
    return null;
  }

  final idsValidos = retosValidos.map((reto) => reto.id.trim()).toList();
  final anterior = ultimoId ?? _ultimoRetoEspecialId;

  if (!_mazoCoincideConOpcionesGlobal(_mazoRetosEspeciales, idsValidos)) {
    _mazoRetosEspeciales = _crearMazoGlobal(
      idsValidos,
      ultimoTexto: anterior,
    );
  }

  if (_mazoRetosEspeciales.isEmpty) {
    _mazoRetosEspeciales = _crearMazoGlobal(
      idsValidos,
      ultimoTexto: anterior,
    );
  }

  final idSeleccionado = _mazoRetosEspeciales.removeLast();
  _ultimoRetoEspecialId = idSeleccionado;

  final retoBase = retosValidos.firstWhere(
    (reto) => reto.id.trim() == idSeleccionado,
  );

  return _crearInstanciaRetoEspecial(retoBase);
}

String obtenerRetoEspecialAleatorio({
  String? ultimoId,
}) {
  final reto = obtenerRetoEspecialCompletoAleatorio(
    ultimoId: ultimoId,
  );

  return reto?.descripcion ?? 'No hay retos especiales disponibles.';
}

RetoEspecial? obtenerRetoEspecialPorId(String id) {
  final idLimpio = id.trim();

  if (idLimpio.isEmpty) {
    return null;
  }

  for (final reto in retosEspecialesLista) {
    if (reto.id.trim() == idLimpio) {
      return reto;
    }
  }

  return null;
}

RetoEspecial? obtenerRetoEspecialPorDescripcion(String descripcion) {
  final descripcionNormalizada = _normalizarTexto(descripcion);

  if (descripcionNormalizada.isEmpty) {
    return null;
  }

  for (final reto in retosEspecialesLista) {
    if (_normalizarTexto(reto.descripcion) == descripcionNormalizada) {
      return reto;
    }
  }

  return null;
}

int obtenerTurnosRetoEspecialPorId(
  String id, {
  int valorPorDefecto = 3,
}) {
  final reto = obtenerRetoEspecialPorId(id);
  return _validarTurnos(
    reto?.turnosTotales,
    valorPorDefecto: valorPorDefecto,
  );
}

int obtenerTurnosRetoEspecial(
  String descripcion, {
  int valorPorDefecto = 3,
}) {
  final reto = obtenerRetoEspecialPorDescripcion(descripcion);
  return _validarTurnos(
    reto?.turnosTotales,
    valorPorDefecto: valorPorDefecto,
  );
}

RetoEspecial? obtenerRetoEspecialDiferente(String? ultimoId) {
  return obtenerRetoEspecialCompletoAleatorio(ultimoId: ultimoId);
}

List<RetoEspecial> obtenerRetosEspecialesAleatorios({
  int cantidad = 3,
  Iterable<String> idsExcluidos = const [],
}) {
  if (cantidad <= 0) {
    return [];
  }

  final idsNormalizados = idsExcluidos
      .map((id) => id.trim())
      .where((id) => id.isNotEmpty)
      .toSet();

  final retosDisponibles = _obtenerRetosEspecialesValidos()
      .where((reto) => !idsNormalizados.contains(reto.id.trim()))
      .toList()
    ..shuffle(_random);

  final cantidadFinal = min(cantidad, retosDisponibles.length);

  return retosDisponibles
      .take(cantidadFinal)
      .map(_crearInstanciaRetoEspecial)
      .toList(growable: false);
}

MapEntry<String, List<String>>? _buscarCategoria(String categoria) {
  final categoriaNormalizada = _normalizarTexto(categoria);

  for (final entrada in retosPorCategoria.entries) {
    if (_normalizarTexto(entrada.key) == categoriaNormalizada) {
      return entrada;
    }
  }

  return null;
}

List<String> _limpiarListaTextos(Iterable<String> textos) {
  final resultados = <String>[];
  final clavesVistas = <String>{};

  for (final texto in textos) {
    final textoLimpio = _limpiarTexto(texto);
    final clave = _normalizarTexto(textoLimpio);

    if (textoLimpio.isNotEmpty && clavesVistas.add(clave)) {
      resultados.add(textoLimpio);
    }
  }

  return resultados;
}

List<RetoEspecial> _obtenerRetosEspecialesValidos() {
  final idsVistos = <String>{};

  return retosEspecialesLista.where((reto) {
    final id = reto.id.trim();
    return id.isNotEmpty &&
        reto.descripcion.trim().isNotEmpty &&
        reto.turnosTotales > 0 &&
        idsVistos.add(id);
  }).toList();
}

RetoEspecial _crearInstanciaRetoEspecial(RetoEspecial retoBase) {
  return retoBase.copyWith(
    turnosRestantes: retoBase.turnosTotales,
    creado: DateTime.now(),
  );
}

int _validarTurnos(
  int? turnos, {
  required int valorPorDefecto,
}) {
  final defectoSeguro = valorPorDefecto > 0 ? valorPorDefecto : 1;
  return turnos == null || turnos <= 0 ? defectoSeguro : turnos;
}

// --- Helpers específicos del mazo de retos especiales (por id, no por
// texto) — se mantienen separados porque comparan ids, no descripciones.

List<String> _crearMazoGlobal(
  Iterable<String> opciones, {
  String? ultimoTexto,
}) {
  final mazo = opciones.toList()..shuffle(_random);

  if (mazo.length > 1 && ultimoTexto != null) {
    final indiceFinal = mazo.length - 1;
    if (mazo[indiceFinal] == ultimoTexto) {
      final repetido = mazo.removeAt(indiceFinal);
      mazo.insert(0, repetido);
    }
  }

  return mazo;
}

bool _mazoCoincideConOpcionesGlobal(
  List<String> mazo,
  List<String> opcionesActuales,
) {
  if (mazo.isEmpty) {
    return true;
  }

  final opciones = opcionesActuales.toSet();
  return mazo.every(opciones.contains);
}

String _limpiarTexto(String texto) {
  return texto.trim().replaceAll(RegExp(r'\s+'), ' ');
}

String _normalizarTexto(String texto) {
  return _limpiarTexto(texto).toLowerCase();
}
