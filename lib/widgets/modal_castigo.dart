import 'package:flutter/material.dart';

import '../theme.dart';
import 'medidas_tarjeta.dart';

class ModalCastigo extends StatelessWidget {
  const ModalCastigo({
    required this.textoCastigo,
    required this.onCerrar,
    super.key,
  });

  final String textoCastigo;
  final VoidCallback onCerrar;

  String get _textoVisible {
    final texto = textoCastigo.trim();
    return texto.isEmpty ? 'Preparando el castigo...' : texto;
  }

  @override
  Widget build(BuildContext context) {
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
                    // Mismas medidas que TarjetaReto, para que la
                    // tarjeta de reto y el modal de castigo midan
                    // exactamente lo mismo en el mismo dispositivo.
                    final medidas = MedidasTarjeta.desde(
                      maxWidth: limites.maxWidth,
                      maxHeight: limites.maxHeight,
                    );

                    final imageSize = medidas.pantallaBaja ? 72.0 : 92.0;

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
                              gradient: AppColors.punishmentGradient,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusExtraLarge,
                              ),
                              border: Border.all(
                                color: AppColors.textOnPrimary.withValues(
                                  alpha: 0.18,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.punishment.withValues(
                                    alpha: 0.30,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 15),
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
                                      width: 145,
                                      height: 145,
                                      decoration: BoxDecoration(
                                        color: AppColors.textOnPrimary
                                            .withValues(alpha: 0.06),
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
                                      width: 170,
                                      height: 170,
                                      decoration: BoxDecoration(
                                        color: AppColors.textOnPrimary
                                            .withValues(alpha: 0.05),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    _ImagenCastigo(tamano: imageSize),
                                    SizedBox(
                                      height: medidas.pantallaBaja ? 10 : 14,
                                    ),
                                    Text(
                                      'CASTIGO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            medidas.pantallaEstrecha
                                                ? 22
                                                : 26,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textOnPrimary,
                                        letterSpacing: 1.2,
                                        height: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'No cumpliste el reto',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textOnPrimary
                                            .withValues(alpha: 0.75),
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
                                            style: TextStyle(
                                              color: AppColors.textOnPrimary,
                                              fontSize: medidas.tamanoTexto(
                                                _textoVisible.length,
                                              ),
                                              fontWeight: FontWeight.w800,
                                              height: 1.36,
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
                                          backgroundColor:
                                              AppColors.surfaceElevated,
                                          foregroundColor:
                                              AppColors.punishment,
                                          disabledBackgroundColor:
                                              AppColors.disabledBackground,
                                          disabledForegroundColor:
                                              AppColors.textMuted,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                              AppSizes.radiusMedium,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Continuar',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
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

class _ImagenCastigo extends StatelessWidget {
  const _ImagenCastigo({required this.tamano});

  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano + 24,
      height: tamano + 24,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.textOnPrimary.withValues(alpha: 0.16),
        ),
      ),
      child: Image.asset(
        'assets/images/castigo.png',
        width: tamano,
        height: tamano,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.sentiment_very_satisfied_rounded,
            size: tamano * 0.52,
            color: AppColors.textOnPrimary,
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
      child: Divider(
        height: 1,
        color: AppColors.textOnPrimary.withValues(alpha: 0.16),
      ),
    );
  }
}
