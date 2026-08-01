import 'dart:math';

import 'castigos.dart';
import 'retos.dart';
import 'retos_especiales.dart';

/// Generador aleatorio compartido por todas las funciones.
///
/// Puede reemplazarse en pruebas para obtener resultados predecibles.
Random _random = Random();

/// Permite establecer un generador personalizado.
///
/// Resulta útil para pruebas unitarias:
///
/// ```dart
/// configurarGeneradorAleatorio(Random(10));
/// ```
void configurarGeneradorAleatorio(Random random) {
  _random = random;
}

/// Modelo utilizado para representar un reto normal.
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
    return 'Reto('
        'categoria: $categoria, '
        'descripcion: $descripcion'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Reto &&
            other.descripcion == descripcion &&
            other.categoria == categoria;
  }

  @override
  int get hashCode => Object.hash(
        descripcion,
        categoria,
      );
}

// ===========================================================
// RETOS NORMALES
// ===========================================================

/// Obtiene un reto aleatorio perteneciente a una categoría.
///
/// La búsqueda intenta primero una coincidencia exacta. Si no existe,
/// compara los nombres ignorando mayúsculas, minúsculas y espacios
/// externos.
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

  final entradaCategoria = _buscarCategoria(
    categoriaLimpia,
  );

  if (entradaCategoria == null ||
      entradaCategoria.value.isEmpty) {
    return Reto(
      descripcion:
          'No hay retos disponibles para esta categoría.',
      categoria: categoriaLimpia,
    );
  }

  final retosDisponibles = _limpiarListaTextos(
    entradaCategoria.value,
  );

  if (retosDisponibles.isEmpty) {
    return Reto(
      descripcion:
          'No hay retos disponibles para esta categoría.',
      categoria: entradaCategoria.key,
    );
  }

  final descripcion = _seleccionarTextoAleatorio(
    opciones: retosDisponibles,
    textoAnterior: descripcionAnterior,
  );

  return Reto(
    descripcion: descripcion,
    categoria: entradaCategoria.key,
  );
}

/// Obtiene varios retos aleatorios de una categoría sin repetir.
///
/// Si la cantidad solicitada supera el total disponible, devuelve
/// todos los retos válidos de la categoría.
List<Reto> obtenerRetosAleatorios(
  String categoria, {
  int cantidad = 3,
}) {
  if (cantidad <= 0) {
    return [];
  }

  final categoriaLimpia = _limpiarTexto(categoria);
  final entradaCategoria = _buscarCategoria(
    categoriaLimpia,
  );

  if (entradaCategoria == null) {
    return [];
  }

  final retosDisponibles = _limpiarListaTextos(
    entradaCategoria.value,
  )..shuffle(_random);

  final cantidadFinal = min(
    cantidad,
    retosDisponibles.length,
  );

  return retosDisponibles
      .take(cantidadFinal)
      .map(
        (descripcion) => Reto(
          descripcion: descripcion,
          categoria: entradaCategoria.key,
        ),
      )
      .toList(growable: false);
}

// ===========================================================
// CASTIGOS
// ===========================================================

/// Obtiene un castigo aleatorio.
///
/// Puede recibir el castigo anterior para reducir la posibilidad de
/// mostrar la misma opción dos veces seguidas.
String obtenerCastigoAleatorio({
  String? castigoAnterior,
}) {
  final castigosDisponibles = _limpiarListaTextos(
    getCastigos(),
  );

  if (castigosDisponibles.isEmpty) {
    return 'No hay castigos disponibles.';
  }

  return _seleccionarTextoAleatorio(
    opciones: castigosDisponibles,
    textoAnterior: castigoAnterior,
  );
}

/// Obtiene varios castigos aleatorios sin repetir.
List<String> obtenerCastigosAleatorios({
  int cantidad = 3,
}) {
  if (cantidad <= 0) {
    return [];
  }

  final castigosDisponibles = _limpiarListaTextos(
    getCastigos(),
  )..shuffle(_random);

  final cantidadFinal = min(
    cantidad,
    castigosDisponibles.length,
  );

  return castigosDisponibles
      .take(cantidadFinal)
      .toList(growable: false);
}

// ===========================================================
// RETOS ESPECIALES
// ===========================================================

/// Obtiene una nueva instancia de un reto especial aleatorio.
///
/// La copia reinicia sus turnos y actualiza su fecha de creación para
/// que cada reto activo tenga un estado independiente.
RetoEspecial? obtenerRetoEspecialCompletoAleatorio({
  String? ultimoId,
}) {
  final retosValidos = _obtenerRetosEspecialesValidos();

  if (retosValidos.isEmpty) {
    return null;
  }

  final opciones = retosValidos.length > 1 &&
          ultimoId != null &&
          ultimoId.trim().isNotEmpty
      ? retosValidos
          .where(
            (reto) =>
                reto.id.trim() != ultimoId.trim(),
          )
          .toList()
      : retosValidos;

  final listaFinal =
      opciones.isEmpty ? retosValidos : opciones;

  final retoBase =
      listaFinal[_random.nextInt(listaFinal.length)];

  return _crearInstanciaRetoEspecial(retoBase);
}

/// Obtiene solamente la descripción de un reto especial aleatorio.
///
/// Esta función se conserva para mantener compatibilidad con el código
/// existente.
String obtenerRetoEspecialAleatorio({
  String? ultimoId,
}) {
  final reto = obtenerRetoEspecialCompletoAleatorio(
    ultimoId: ultimoId,
  );

  return reto?.descripcion ??
      'No hay retos especiales disponibles.';
}

/// Busca un reto especial mediante su identificador.
///
/// La comparación ignora espacios externos, pero mantiene el contenido
/// exacto del identificador.
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

/// Busca un reto especial mediante su descripción.
///
/// La comparación ignora mayúsculas, minúsculas y espacios múltiples.
RetoEspecial? obtenerRetoEspecialPorDescripcion(
  String descripcion,
) {
  final descripcionNormalizada = _normalizarTexto(
    descripcion,
  );

  if (descripcionNormalizada.isEmpty) {
    return null;
  }

  for (final reto in retosEspecialesLista) {
    if (_normalizarTexto(reto.descripcion) ==
        descripcionNormalizada) {
      return reto;
    }
  }

  return null;
}

/// Obtiene la cantidad total de turnos de un reto especial mediante
/// su identificador.
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

/// Obtiene la cantidad total de turnos mediante la descripción.
///
/// Se conserva para mantener compatibilidad con la implementación
/// anterior de `PantallaReto`.
int obtenerTurnosRetoEspecial(
  String descripcion, {
  int valorPorDefecto = 3,
}) {
  final reto = obtenerRetoEspecialPorDescripcion(
    descripcion,
  );

  return _validarTurnos(
    reto?.turnosTotales,
    valorPorDefecto: valorPorDefecto,
  );
}

/// Obtiene un reto especial distinto al último mostrado.
RetoEspecial? obtenerRetoEspecialDiferente(
  String? ultimoId,
) {
  return obtenerRetoEspecialCompletoAleatorio(
    ultimoId: ultimoId,
  );
}

/// Obtiene varias instancias de retos especiales sin repetir.
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
      .where(
        (reto) => !idsNormalizados.contains(
          reto.id.trim(),
        ),
      )
      .toList()
    ..shuffle(_random);

  final cantidadFinal = min(
    cantidad,
    retosDisponibles.length,
  );

  return retosDisponibles
      .take(cantidadFinal)
      .map(_crearInstanciaRetoEspecial)
      .toList(growable: false);
}

// ===========================================================
// UTILIDADES PRIVADAS
// ===========================================================

/// Busca una categoría sin depender completamente de mayúsculas o
/// espacios externos.
MapEntry<String, List<String>>? _buscarCategoria(
  String categoria,
) {
  final coincidenciaExacta =
      retosPorCategoria.entries.where(
    (entrada) => entrada.key == categoria,
  );

  if (coincidenciaExacta.isNotEmpty) {
    return coincidenciaExacta.first;
  }

  final categoriaNormalizada = _normalizarTexto(
    categoria,
  );

  for (final entrada in retosPorCategoria.entries) {
    if (_normalizarTexto(entrada.key) ==
        categoriaNormalizada) {
      return entrada;
    }
  }

  return null;
}

/// Devuelve textos válidos, limpios y sin duplicados.
List<String> _limpiarListaTextos(
  Iterable<String> textos,
) {
  final resultados = <String>[];
  final normalizados = <String>{};

  for (final texto in textos) {
    final textoLimpio = _limpiarTexto(texto);

    if (textoLimpio.isEmpty) {
      continue;
    }

    final clave = textoLimpio.toLowerCase();

    if (normalizados.add(clave)) {
      resultados.add(textoLimpio);
    }
  }

  return resultados;
}

/// Selecciona un texto aleatorio y evita repetir inmediatamente el
/// anterior cuando existen suficientes opciones.
String _seleccionarTextoAleatorio({
  required List<String> opciones,
  String? textoAnterior,
}) {
  if (opciones.isEmpty) {
    return '';
  }

  if (opciones.length == 1) {
    return opciones.first;
  }

  final anteriorNormalizado = _normalizarTexto(
    textoAnterior ?? '',
  );

  final opcionesFiltradas = anteriorNormalizado.isEmpty
      ? opciones
      : opciones
          .where(
            (opcion) =>
                _normalizarTexto(opcion) !=
                anteriorNormalizado,
          )
          .toList();

  final listaFinal = opcionesFiltradas.isEmpty
      ? opciones
      : opcionesFiltradas;

  return listaFinal[
      _random.nextInt(listaFinal.length)];
}

/// Devuelve únicamente retos especiales con información válida.
List<RetoEspecial> _obtenerRetosEspecialesValidos() {
  return retosEspecialesLista.where((reto) {
    return reto.id.trim().isNotEmpty &&
        reto.descripcion.trim().isNotEmpty &&
        reto.turnosTotales > 0;
  }).toList();
}

/// Crea una instancia independiente de un reto especial.
RetoEspecial _crearInstanciaRetoEspecial(
  RetoEspecial retoBase,
) {
  return retoBase.copyWith(
    turnosRestantes: retoBase.turnosTotales,
    creado: DateTime.now(),
  );
}

/// Garantiza una cantidad de turnos válida.
int _validarTurnos(
  int? turnos, {
  required int valorPorDefecto,
}) {
  final defectoSeguro =
      valorPorDefecto > 0 ? valorPorDefecto : 1;

  if (turnos == null || turnos <= 0) {
    return defectoSeguro;
  }

  return turnos;
}

/// Limpia espacios externos y múltiples.
String _limpiarTexto(String texto) {
  return texto
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}

/// Normaliza un texto para realizar comparaciones.
String _normalizarTexto(String texto) {
  return _limpiarTexto(texto).toLowerCase();
}
