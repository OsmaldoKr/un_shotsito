import 'package:flutter/material.dart';
import '../data/retos_especiales.dart';
import '../theme.dart';

class ModalRetoEspecial extends StatelessWidget {
  const ModalRetoEspecial({
    super.key,
    required this.reto,
    required this.onCerrar,
  });

  final RetoEspecial reto;
  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final pantallaEstrecha = screenSize.width < 360;
    final pantallaBaja = screenSize.height < 650;
    final pantallaAmplia = screenSize.width >= 600;

    final progreso = reto.progreso.clamp(0.0, 1.0);

    final turnosRestantes = reto.turnosRestantes < 0
        ? 0
        : reto.turnosRestantes;

    final colorEstado = _obtenerColorEstado(progreso);

    return Material(
      color: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ),
        duration: const Duration(milliseconds: 340),
        curve: Curves.easeOutCubic,
        builder: (context, animationValue, child) {
          final opacity = animationValue.clamp(0.0, 1.0);
          final scale = 0.92 + (opacity * 0.08);

          return Opacity(
            opacity: opacity,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.overlay.withValues(
                alpha: 0.78 * opacity,
              ),
              child: SafeArea(
                child: Center(
                  child: Transform.scale(
                    scale: scale,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: pantallaEstrecha ? 16 : 22,
                        vertical: 20,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: pantallaAmplia ? 500 : 460,
                        ),
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: pantallaBaja ? 360 : 430,
                            maxHeight: pantallaBaja ? 540 : 650,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusExtraLarge,
                            ),
                            border: Border.all(
                              color: AppColors.primary.withValues(
                                alpha: 0.26,
                              ),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.18,
                                ),
                                blurRadius: 28,
                                spreadRadius: 1,
                                offset: const Offset(0, 14),
                              ),
                              const BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusExtraLarge,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -55,
                                  right: -45,
                                  child: Container(
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.06),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -65,
                                  left: -50,
                                  child: Container(
                                    width: 185,
                                    height: 185,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary
                                          .withValues(alpha: 0.05),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    pantallaEstrecha ? 20 : 26,
                                    pantallaBaja ? 20 : 26,
                                    pantallaEstrecha ? 20 : 26,
                                    pantallaBaja ? 18 : 24,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _EncabezadoRetoEspecial(
                                        pantallaBaja: pantallaBaja,
                                      ),
                                      SizedBox(
                                        height: pantallaBaja ? 16 : 22,
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                pantallaEstrecha ? 16 : 20,
                                            vertical:
                                                pantallaBaja ? 16 : 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.08),
                                            borderRadius:
                                                BorderRadius.circular(
                                              AppSizes.radiusLarge,
                                            ),
                                            border: Border.all(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.16),
                                            ),
                                          ),
                                          child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Text(
                                              reto.descripcion.isEmpty
                                                  ? 'Reto especial activo.'
                                                  : reto.descripcion,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize:
                                                        pantallaEstrecha
                                                            ? 19
                                                            : 22,
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    height: 1.38,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: pantallaBaja ? 16 : 22,
                                      ),
                                      _EstadoRetoEspecial(
                                        turnosRestantes:
                                            turnosRestantes,
                                        progreso: progreso,
                                        colorEstado: colorEstado,
                                      ),
                                      SizedBox(
                                        height: pantallaBaja ? 18 : 24,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: onCerrar,
                                          label: const Text(
                                            'Entendido',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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

    return AppColors.primary;
  }
}

class _EncabezadoRetoEspecial extends StatelessWidget {
  const _EncabezadoRetoEspecial({
    required this.pantallaBaja,
  });

  final bool pantallaBaja;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: pantallaBaja ? 62 : 72,
          height: pantallaBaja ? 62 : 72,
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
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        SizedBox(
          height: pantallaBaja ? 14 : 18,
        ),
        Text(
          'Reto especial',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
                color: AppColors.primary,
                fontSize: pantallaBaja ? 23 : 27,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
        ),
        const SizedBox(height: 7),
        Text(
          'Este reto permanece activo durante varios turnos',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
        ),
      ],
    );
  }
}

class _EstadoRetoEspecial extends StatelessWidget {
  const _EstadoRetoEspecial({
    required this.turnosRestantes,
    required this.progreso,
    required this.colorEstado,
  });

  final int turnosRestantes;
  final double progreso;
  final Color colorEstado;

  @override
  Widget build(BuildContext context) {
    final textoTurnos = turnosRestantes == 1
        ? '1 turno restante'
        : '$turnosRestantes turnos restantes';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppSizes.radiusLarge,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorEstado.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(
                    AppSizes.radiusMedium,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  textoTurnos,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Text(
                '${(progreso * 100).round()}%',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                      color: colorEstado,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              color: colorEstado,
              backgroundColor: AppColors.surfaceMuted,
            ),
          ),
        ],
      ),
    );
  }
}
