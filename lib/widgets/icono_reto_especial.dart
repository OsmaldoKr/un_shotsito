import 'package:flutter/material.dart';

import '../data/retos_especiales.dart';
import '../theme.dart';

class IconoRetoEspecial extends StatefulWidget {
  const IconoRetoEspecial({
    required this.reto, required this.onTap, super.key,
  });

  final RetoEspecial reto;
  final VoidCallback onTap;

  @override
  State<IconoRetoEspecial> createState() =>
      _IconoRetoEspecialState();
}

class _IconoRetoEspecialState extends State<IconoRetoEspecial> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.sizeOf(context).width;

    final tamano = anchoPantalla < 360
        ? 58.0
        : anchoPantalla >= 600
            ? 72.0
            : 64.0;

    final progreso = widget.reto.turnosTotales <= 0
        ? 0.0
        : widget.reto.turnosRestantes /
            widget.reto.turnosTotales;

    final turnosRestantes = widget.reto.turnosRestantes
        .clamp(0, widget.reto.turnosTotales);

    final colorEstado = _obtenerColorEstado(
      progreso.clamp(0, 1),
    );

    return Semantics(
      button: true,
      label:
          'Reto especial con $turnosRestantes turnos restantes',
      child: AnimatedScale(
        scale: _presionado ? 0.93 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            AppSizes.radiusLarge,
          ),
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (valor) {
              setState(() {
                _presionado = valor;
              });
            },
            borderRadius: BorderRadius.circular(
              AppSizes.radiusLarge,
            ),
            splashColor: AppColors.primary.withValues(
              alpha: 0.10,
            ),
            highlightColor: AppColors.primary.withValues(
              alpha: 0.05,
            ),
            child: Container(
              width: tamano,
              height: tamano,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusLarge,
                ),
                border: Border.all(
                  color: colorEstado.withValues(
                    alpha: 0.28,
                  ),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        'assets/images/shot_reto_especial.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Indicador circular de progreso.
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CircularProgressIndicator(
                        value: progreso.clamp(0, 1),
                        strokeWidth: 2.5,
                        strokeCap: StrokeCap.round,
                        color: colorEstado,
                        backgroundColor:
                            AppColors.surfaceMuted,
                      ),
                    ),
                  ),

                  // Contador de turnos.
                  Positioned(
                    right: -5,
                    top: -5,
                    child: AnimatedSwitcher(
                      duration:
                          const Duration(milliseconds: 220),
                      transitionBuilder: (
                        child,
                        animation,
                      ) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        key: ValueKey(turnosRestantes),
                        constraints: const BoxConstraints(
                          minWidth: 27,
                          minHeight: 27,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colorEstado,
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                AppColors.surfaceElevated,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$turnosRestantes',
                          style: const TextStyle(
                            color: AppColors.textOnPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Indicador táctil.
                  Positioned(
                    left: -3,
                    bottom: -3,
                    child: Container(
                      width: 21,
                      height: 21,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _obtenerColorEstado(double progreso) {
    if (progreso <= 0.25) {
      return AppColors.error;
    }

    if (progreso <= 0.50) {
      return AppColors.warning;
    }

    return AppColors.punishment;
  }
}
