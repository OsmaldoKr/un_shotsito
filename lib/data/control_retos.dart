import 'dart:math';
import 'retos.dart';
import 'castigos.dart';
import 'retos_especiales.dart';

// Modelo de Reto
class Reto {
  final String descripcion;
  final String categoria;

  Reto({
    required this.descripcion,
    required this.categoria,
  });
}

// Función para obtener reto aleatorio por categoría
Reto obtenerRetoAleatorio(String categoria) {
  final random = Random();
  final retosCategoria = retosPorCategoria[categoria] ?? [];
  
  if (retosCategoria.isEmpty) {
    return Reto(
      descripcion: 'No hay retos disponibles para esta categoría',
      categoria: categoria,
    );
  }
  
  final descripcion = retosCategoria[random.nextInt(retosCategoria.length)];
  return Reto(
    descripcion: descripcion,
    categoria: categoria,
  );
}

// Función para obtener castigo aleatorio
String obtenerCastigoAleatorio() {
  final castigos = getCastigos();
  
  if (castigos.isEmpty) {
    return 'Bebe 3 shots';
  }
  
  final random = Random();
  return castigos[random.nextInt(castigos.length)];
}

// Función para obtener reto especial aleatorio (devuelve la DESCRIPCIÓN)
String obtenerRetoEspecialAleatorio() {
  final random = Random();
  final reto = retosEspecialesLista[random.nextInt(retosEspecialesLista.length)];
  return reto.descripcion;  // ← Accede a la propiedad descripcion de la clase
}

// Función para obtener turnos de un reto especial (busca por DESCRIPCIÓN)
int obtenerTurnosRetoEspecial(String descripcion) {
  try {
    final reto = retosEspecialesLista.firstWhere(
      (r) => r.descripcion == descripcion,
    );
    return reto.turnosTotales;  // ← Devuelve turnosTotales de la clase
  } catch (e) {
    return 3;  // Valor por defecto si no se encuentra
  }
}
