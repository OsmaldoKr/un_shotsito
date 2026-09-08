import 'package:flutter/material.dart';

import '../theme.dart';

/// Color de estado compartido para representar la urgencia de un reto
/// especial según su progreso (1.0 = recién comenzado / muchos turnos
/// restantes, 0.0 = a punto de terminar).
///
/// Se usa tanto en `IconoRetoEspecial` como en `ModalRetoEspecial` para
/// que ambos muestren siempre el mismo color para el mismo reto, en
/// vez de que cada widget calcule su propia versión y puedan
/// desincronizarse.
Color colorEstadoRetoEspecial(double progreso) {
  final progresoValido = progreso.clamp(0.0, 1.0);

  if (progresoValido <= 0.25) {
    return AppColors.error;
  }

  if (progresoValido <= 0.50) {
    return AppColors.warning;
  }

  return AppColors.primary;
}
