import 'package:flutter/material.dart';

import '../data/retos_especiales.dart';
import '../theme.dart';
import 'estado_reto_especial.dart';
import 'medidas_tarjeta.dart';

class ModalRetoEspecial extends StatelessWidget {
  const ModalRetoEspecial({
    required this.reto,
    required this.onCerrar,
    super.key,
  });

  final RetoEspecial reto;
  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    final progreso = reto.progreso.clamp(0.0, 1.0);
    final turnosRestantes =
        reto.turnosRestantes < 0 ? 0 : reto.turnosRestantes;
    final colorEstado = colorEstadoRetoEspecial(progreso);

    return Material(
      color: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
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
              color: AppColors.overlay.withValues(alpha: 0.78 * opacity),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, limites) {
                    // Mismas medidas que TarjetaReto, ModalCastigo y
                    // ModalRetoCompletado, para que todos midan
                    // exactamente lo mismo en el mismo dispositivo.
                    final medidas = MedidasTarjeta.desde(
                      maxWidth: limites.maxWidth,
                      maxHeight: limites.maxHeight,
                    );

                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: SizedBox(
                          width: medidas.ancho,
                          height: medidas.alto,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
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
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -55,
                                  right: -45,
                                  child: Container(
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.06,
                                      ),
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
                                      color: AppColors.secondary.withValues(
                                        alpha: 0.05,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    medidas.padding,
                                    medidas.padding + 4,
                                    medidas.padding,
                                    medidas.padding,
                                  ),
                                  child: Column(
                                    children: [
                                      _EncabezadoRetoEspecial(
                                        pantallaBaja: medidas.pantallaBaja,
                                      ),
                                      SizedBox(
                                        height: medidas.pantallaBaja ? 12 : 16,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding:
                                                const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
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
                                                        medidas.tamanoTexto(
                                                      reto.descripcion.length,
                                                    ),
                                                    fontWeight:
                                                        FontWeight.w800,
                                                    height: 1.38,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: medidas.pantallaBaja ? 12 : 16,
                                      ),
                                      _EstadoRetoEspecial(
                                        turnosRestantes: turnosRestantes,
                                        progreso: progreso,
                                        colorEstado: colorEstado,
                                        pantallaBaja: medidas.pantallaBaja,
                                      ),
                                      SizedBox(
                                        height: medidas.pantallaBaja ? 14 : 18,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height:
                                            medidas.pantallaBaja ? 50 : 56,
                                        child: ElevatedButton.icon(
                                          onPressed: onCerrar,
                                          icon: const SizedBox.shrink(),
                                          label: const Text('Entendido'),
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
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
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
          width: pantallaBaja ? 56 : 66,
          height: pantallaBaja ? 56 : 66,
          decoration: BoxDecoration(
            gradient: AppColors.mainGradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.20),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        SizedBox(height: pantallaBaja ? 10 : 14),
        Text(
          'Reto especial',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontSize: pantallaBaja ? 21 : 25,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          'Este reto permanece activo durante varios turnos',
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.35,
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
    required this.pantallaBaja,
  });

  final int turnosRestantes;
  final double progreso;
  final Color colorEstado;
  final bool pantallaBaja;

  @override
  Widget build(BuildContext context) {
    final textoTurnos = turnosRestantes == 1
        ? '1 turno restante'
        : '$turnosRestantes turnos restantes';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(pantallaBaja ? 13 : 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: pantallaBaja ? 38 : 44,
                height: pantallaBaja ? 38 : 44,
                decoration: BoxDecoration(
                  color: colorEstado.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  textoTurnos,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Text(
                '${(progreso * 100).round()}%',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorEstado,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          SizedBox(height: pantallaBaja ? 10 : 13),
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
