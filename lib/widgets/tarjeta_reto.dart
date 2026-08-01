import 'dart:math';

import 'package:flutter/material.dart';

import '../data/retos_especiales.dart';
import '../theme.dart';

class TarjetaReto extends StatelessWidget {
  const TarjetaReto({
    super.key,
    required this.textoReto,
    required this.fadeAnimation,
    this.retoEspecial,
  });

  final String textoReto;
  final RetoEspecial? retoEspecial;
  final Animation<double> fadeAnimation;

  @override
  Widget build(BuildContext context) {
    final esRetoEspecial = retoEspecial != null;

    return FadeTransition(
      opacity: fadeAnimation,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final anchoDisponible = constraints.maxWidth;
          final altoDisponible = constraints.maxHeight;

          final pantallaEstrecha = anchoDisponible < 360;
          final pantallaBaja = altoDisponible < 480;

          final anchoTarjeta = min(
            anchoDisponible,
            520.0,
          );

          final alturaPreferida = pantallaBaja
              ? altoDisponible
              : altoDisponible.clamp(390.0, 560.0);

          final alturaTarjeta = alturaPreferida
              .clamp(
                min(300.0, altoDisponible),
                altoDisponible,
              )
              .toDouble();

          final padding = pantallaEstrecha
              ? 20.0
              : pantallaBaja
                  ? 22.0
                  : 28.0;

          final tamanoTexto = _calcularTamanoTexto(
            texto: esRetoEspecial
                ? retoEspecial!.descripcion
                : textoReto,
            anchoDisponible: anchoTarjeta,
            pantallaBaja: pantallaBaja,
          );

          return Center(
            child: SizedBox(
              width: anchoTarjeta,
              height: alturaTarjeta,
              child: _ContenidoTarjeta(
                esRetoEspecial: esRetoEspecial,
                retoEspecial: retoEspecial,
                textoReto: textoReto,
                padding: padding,
                tamanoTexto: tamanoTexto,
                pantallaBaja: pantallaBaja,
                pantallaEstrecha: pantallaEstrecha,
              ),
            ),
          );
        },
      ),
    );
  }

  double _calcularTamanoTexto({
    required String texto,
    required double anchoDisponible,
    required bool pantallaBaja,
  }) {
    double tamano;

    if (texto.length > 180) {
      tamano = 18;
    } else if (texto.length > 120) {
      tamano = 20;
    } else if (texto.length > 75) {
      tamano = 22;
    } else {
      tamano = 25;
    }

    if (anchoDisponible < 350) {
      tamano -= 2;
    }

    if (pantallaBaja) {
      tamano -= 1;
    }

    return tamano.clamp(17, 26).toDouble();
  }
}

class _ContenidoTarjeta extends StatelessWidget {
  const _ContenidoTarjeta({
    required this.esRetoEspecial,
    required this.retoEspecial,
    required this.textoReto,
    required this.padding,
    required this.tamanoTexto,
    required this.pantallaBaja,
    required this.pantallaEstrecha,
  });

  final bool esRetoEspecial;
  final RetoEspecial? retoEspecial;
  final String textoReto;

  final double padding;
  final double tamanoTexto;

  final bool pantallaBaja;
  final bool pantallaEstrecha;

  @override
  Widget build(BuildContext context) {
    final texto = esRetoEspecial
        ? retoEspecial!.descripcion
        : textoReto;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(
          AppSizes.radiusExtraLarge,
        ),
        border: Border.all(
          color: esRetoEspecial
              ? AppColors.primary.withValues(alpha: 0.30)
              : AppColors.border,
          width: esRetoEspecial ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: esRetoEspecial
                ? AppColors.primary.withValues(alpha: 0.18)
                : AppColors.shadow,
            blurRadius: esRetoEspecial ? 26 : 20,
            spreadRadius: esRetoEspecial ? 1 : 0,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (esRetoEspecial) ...[
            Positioned(
              top: -48,
              right: -38,
              child: Container(
                width: 155,
                height: 155,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.06,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -58,
              left: -45,
              child: Container(
                width: 175,
                height: 175,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(
                    alpha: 0.05,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],

          // Línea decorativa superior.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: esRetoEspecial ? 7 : 5,
              decoration: BoxDecoration(
                gradient: esRetoEspecial
                    ? AppColors.mainGradient
                    : const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                      ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              padding,
              padding + 4,
              padding,
              padding,
            ),
            child: Column(
              children: [
                if (esRetoEspecial)
                  _EncabezadoEspecial(
                    pantallaBaja: pantallaBaja,
                  )
                else
                  _EncabezadoNormal(
                    pantallaBaja: pantallaBaja,
                  ),

                SizedBox(
                  height: pantallaBaja ? 14 : 20,
                ),

                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.divider,
                ),

                SizedBox(
                  height: pantallaBaja ? 14 : 20,
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      child: Text(
                        texto.isEmpty
                            ? 'Preparando el reto...'
                            : texto,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: tamanoTexto,
                          fontWeight: FontWeight.w800,
                          height: 1.36,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: pantallaBaja ? 12 : 18,
                ),

                if (esRetoEspecial)
                  _IndicadorTurnos(
                    reto: retoEspecial!,
                    pantallaEstrecha: pantallaEstrecha,
                  )
                else
                  const _IndicadorRetoNormal(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EncabezadoNormal extends StatelessWidget {
  const _EncabezadoNormal({
    required this.pantallaBaja,
  });

  final bool pantallaBaja;

  @override
  Widget build(BuildContext context) {
    final tamanoLogo = pantallaBaja ? 64.0 : 78.0;

    return Column(
      children: [
        Container(
          width: tamanoLogo,
          height: tamanoLogo,
          decoration: BoxDecoration(
            gradient: AppColors.mainGradient,
            borderRadius: BorderRadius.circular(
              AppSizes.radiusLarge,
            ),
            border: Border.all(
              color: AppColors.surfaceElevated.withValues(
                alpha: 0.60,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: 0.20,
                ),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: tamanoLogo * 0.15,
                right: tamanoLogo * 0.17,
                child: Container(
                  width: tamanoLogo * 0.13,
                  height: tamanoLogo * 0.13,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withValues(
                      alpha: 0.22,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: tamanoLogo * 0.15,
                left: tamanoLogo * 0.17,
                child: Container(
                  width: tamanoLogo * 0.13,
                  height: tamanoLogo * 0.13,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withValues(
                      alpha: 0.22,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: pantallaBaja ? 10 : 14,
        ),
        Text(
          'Tu reto',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                color: AppColors.primary,
                fontSize: pantallaBaja ? 18 : 20,
                fontWeight: FontWeight.w900,
              ),
        ),
      ],
    );
  }
}

class _EncabezadoEspecial extends StatelessWidget {
  const _EncabezadoEspecial({
    required this.pantallaBaja,
  });

  final bool pantallaBaja;

  @override
  Widget build(BuildContext context) {
    final tamanoIcono = pantallaBaja ? 54.0 : 62.0;

    return Row(
      children: [
        Container(
          width: tamanoIcono,
          height: tamanoIcono,
          decoration: BoxDecoration(
            gradient: AppColors.mainGradient,
            borderRadius: BorderRadius.circular(
              AppSizes.radiusLarge,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: 0.20,
                ),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reto especial',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      color: AppColors.primary,
                      fontSize: pantallaBaja ? 18 : 21,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                'Permanecerá activo varios turnos',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.3,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IndicadorRetoNormal extends StatelessWidget {
  const _IndicadorRetoNormal();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(
          AppSizes.radiusMedium,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 7),
          Text(
            'Decide si cumpliste el reto',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _IndicadorTurnos extends StatelessWidget {
  const _IndicadorTurnos({
    required this.reto,
    required this.pantallaEstrecha,
  });

  final RetoEspecial reto;
  final bool pantallaEstrecha;

  @override
  Widget build(BuildContext context) {
    final turnos = reto.turnosTotales < 0
        ? 0
        : reto.turnosTotales;

    final textoTurnos = turnos == 1
        ? '1 turno'
        : '$turnos turnos';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pantallaEstrecha ? 12 : 15,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: AppColors.warningBackground,
        borderRadius: BorderRadius.circular(
          AppSizes.radiusMedium,
        ),
        border: Border.all(
          color: AppColors.warning.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Duración: $textoTurnos',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: pantallaEstrecha ? 13 : 14,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
