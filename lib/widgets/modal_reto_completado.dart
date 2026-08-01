import 'package:flutter/material.dart';

import '../theme.dart';

class ModalRetoCompletado extends StatelessWidget {
  const ModalRetoCompletado({
    super.key,
    required this.descripcionReto,
    required this.onCerrar,
  });

  final String descripcionReto;
  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final pantallaEstrecha = screenSize.width < 360;
    final pantallaBaja = screenSize.height < 650;
    final pantallaAmplia = screenSize.width >= 600;

    final horizontalPadding = pantallaEstrecha ? 16.0 : 22.0;

    final imageSize = pantallaBaja
        ? 96.0
        : pantallaAmplia
            ? 144.0
            : 122.0;

    return Material(
      color: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ),
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
                        horizontal: horizontalPadding,
                        vertical: pantallaBaja ? 14 : 20,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 460,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(
                            pantallaEstrecha ? 20 : 26,
                            pantallaBaja ? 20 : 26,
                            pantallaEstrecha ? 20 : 26,
                            pantallaBaja ? 18 : 24,
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: imageSize + 26,
                                    height: imageSize + 26,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.successBackground,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusLarge,
                                      ),
                                      border: Border.all(
                                        color: AppColors.success.withValues(
                                          alpha: 0.18,
                                        ),
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/images/shot_reto_especial_completado.png',
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
                                        return Icon(
                                          Icons.sentiment_dissatisfied_rounded,
                                          size: imageSize * 0.52,
                                          color: AppColors.success,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: pantallaBaja ? 14 : 20,
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
                                              pantallaEstrecha ? 23 : 27,
                                          fontWeight: FontWeight.w900,
                                          height: 1.1,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
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
                                  SizedBox(
                                    height: pantallaBaja ? 15 : 20,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    constraints: BoxConstraints(
                                      maxHeight: pantallaBaja ? 150 : 190,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          pantallaEstrecha ? 15 : 18,
                                      vertical:
                                          pantallaBaja ? 14 : 17,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.successBackground,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusLarge,
                                      ),
                                      border: Border.all(
                                        color: AppColors.success.withValues(
                                          alpha: 0.18,
                                        ),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      physics:
                                          const BouncingScrollPhysics(),
                                      child: Text(
                                        descripcionReto.trim().isEmpty
                                            ? 'Reto especial completado.'
                                            : descripcionReto.trim(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: AppColors.textPrimary,
                                              fontSize:
                                                  pantallaEstrecha ? 15 : 17,
                                              fontWeight: FontWeight.w600,
                                              height: 1.45,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: pantallaBaja ? 14 : 18,
                                  ),
                                  Text(
                                    'Excelente trabajo',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  SizedBox(
                                    height: pantallaBaja ? 18 : 24,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: pantallaBaja ? 52 : 58,
                                    child: ElevatedButton(
                                      onPressed: onCerrar,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.success,
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
                                          fontSize: 17,
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
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
