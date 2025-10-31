// ignore_for_file: file_names

import 'dart:math';
import 'retos.dart';
import 'castigos.dart';

int shotsActual = Random().nextInt(3) + 2;

/// Clase Reto
class Reto {
  final String descripcion;
  final String? castigo; // opcional, si quieres tener castigo específico
  Reto({required this.descripcion, this.castigo});
}

/// 🔹 Obtiene un reto según la categoría de juego
List<Reto> getRetosPorTipo(String tipoJuego) {
  final retos = retosPorCategoria[tipoJuego];
  if (retos == null) return [];

  // Convertimos cada String a un Reto
  return retos.map((r) => Reto(descripcion: r)).toList();
}

/// 🔹 Obtiene un reto aleatorio según la categoría
Reto obtenerRetoAleatorio(String tipoJuego) {
  final retos = getRetosPorTipo(tipoJuego);
  if (retos.isEmpty) {
    return Reto(
      descripcion: 'No hay retos disponibles para esta categoría',
      castigo: null,
    );
  }
  return retos[Random().nextInt(retos.length)];
}

/// 🔹 Obtiene un castigo aleatorio
String obtenerCastigoAleatorio() {
  final castigos = getCastigos();
  return castigos[Random().nextInt(castigos.length)];
}

