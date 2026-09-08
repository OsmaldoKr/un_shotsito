import 'package:flutter/material.dart';

import '../theme.dart';
import 'medidas_tarjeta.dart';

class ModalRetoCompletado extends StatelessWidget {
  const ModalRetoCompletado({
    required this.descripcionReto,
    required this.onCerrar,
    super.key,
  });

  final String descripcionReto;
  final VoidCallback onCerrar;

  String get _textoVisible {
    final texto = descripcionReto.trim();
    return texto.isEmpty ? 'Reto especial completado.' : texto;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutBack,
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
                    // Mismas medidas que TarjetaReto y ModalCastigo,
                    // para que los tres midan exactamente lo mismo en
                    // el mismo dispositivo.
                    final medidas = MedidasTarjeta.desde(
                      maxWidth: limites.maxWidth,
                      maxHeight: limites.maxHeight,
                    );

                    final imageSize = medidas.pantallaBaja ? 82.0 : 106.0;

                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: SizedBox(
                          width: medidas.ancho,
                          height: medidas.alto,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            padding: EdgeInsets.fromLTRB(
                              medidas.padding,
                              medidas.padding + 4,
                              medidas.padding,
                              medidas.padding,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusExtraLarge,
                              ),
                              border: Border.all(
                                color: AppColors.success.withValues(
                                  alpha: 0.28,
                                ),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success.withValues(
                                    alpha: 0.20,
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
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: -70,
                                  right: -55,
                                  child: IgnorePointer(
                                    child: Container(
                                      width: 170,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(
                                          alpha: 0.07,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -85,
                                  left: -65,
                                  child: IgnorePointer(
                                    child: Container(
                                      width: 190,
                                      height: 190,
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(
                                          alpha: 0.05,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: imageSize,
                                      height: imageSize,
                                      child: Image.asset(
                                        'assets/images/shot_reto_completado.png',
                                        width: imageSize,
                                        height: imageSize,
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                        gaplessPlayback: true,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: medidas.pantallaBaja ? 10 : 14,
                                    ),
                                    Text(
                                      '¡Reto completado!',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: AppColors.success,
                                            fontSize:
                                                medidas.pantallaEstrecha
                                                    ? 21
                                                    : 25,
                                            fontWeight: FontWeight.w900,
                                            height: 1.1,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Has terminado un reto especial',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    _Separador(
                                      pantallaBaja: medidas.pantallaBaja,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Text(
                                            _textoVisible,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color:
                                                      AppColors.textPrimary,
                                                  fontSize:
                                                      medidas.tamanoTexto(
                                                    _textoVisible.length,
                                                  ),
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.4,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: medidas.pantallaBaja ? 12 : 18,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: medidas.pantallaBaja ? 50 : 56,
                                      child: ElevatedButton(
                                        onPressed: onCerrar,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.success,
                                          foregroundColor:
                                              AppColors.textOnPrimary,
                                          disabledBackgroundColor:
                                              AppColors.disabledBackground,
                                          disabledForegroundColor:
                                              AppColors.textMuted,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                              AppSizes.radiusLarge,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Continuar',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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

class _Separador extends StatelessWidget {
  const _Separador({required this.pantallaBaja});

  final bool pantallaBaja;

  @override
  Widget build(BuildContext context) {
    final espacio = pantallaBaja ? 12.0 : 16.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: espacio),
      child: const Divider(height: 1, color: AppColors.divider),
    );
  }
}
