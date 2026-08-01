import 'package:flutter/material.dart';

import '../theme.dart';

class ModalCastigo extends StatelessWidget {
  const ModalCastigo({
    super.key,
    required this.textoCastigo,
    required this.onCerrar,
  });

  final String textoCastigo;
  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    final pantallaPequena = screenSize.width < 360;
    final pantallaBaja = screenSize.height < 650;
    final pantallaAmplia = screenSize.width >= 600;

    final horizontalPadding = pantallaPequena ? 16.0 : 22.0;

    final imageSize = pantallaBaja
        ? 96.0
        : pantallaAmplia
            ? 142.0
            : 122.0;

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
                        horizontal: horizontalPadding,
                        vertical: pantallaBaja ? 14 : 22,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 460,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(
                            pantallaPequena ? 20 : 26,
                            pantallaBaja ? 20 : 26,
                            pantallaPequena ? 20 : 26,
                            pantallaBaja ? 18 : 24,
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
                                      color: AppColors.textOnPrimary.withValues(
                                        alpha: 0.06,
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
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: AppColors.textOnPrimary.withValues(
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
                                    width: imageSize + 24,
                                    height: imageSize + 24,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.textOnPrimary.withValues(
                                        alpha: 0.10,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusLarge,
                                      ),
                                      border: Border.all(
                                        color: AppColors.textOnPrimary
                                            .withValues(alpha: 0.16),
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/images/castigo.png',
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
                                          Icons.sentiment_very_satisfied_rounded,
                                          size: imageSize * 0.52,
                                          color: AppColors.textOnPrimary,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: pantallaBaja ? 16 : 22,
                                  ),
                                  Text(
                                    'CASTIGO',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          pantallaPequena ? 22 : 26,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textOnPrimary,
                                      letterSpacing: 1.2,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
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
                                  SizedBox(
                                    height: pantallaBaja ? 16 : 22,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          pantallaBaja ? 150 : 210,
                                    ),
                                    padding: EdgeInsets.all(
                                      pantallaPequena ? 16 : 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.textOnPrimary
                                          .withValues(alpha: 0.11),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusLarge,
                                      ),
                                      border: Border.all(
                                        color: AppColors.textOnPrimary
                                            .withValues(alpha: 0.16),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      physics:
                                          const BouncingScrollPhysics(),
                                      child: Text(
                                        textoCastigo.trim().isEmpty
                                            ? 'Preparando el castigo...'
                                            : textoCastigo.trim(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize:
                                              pantallaPequena ? 19 : 22,
                                          color: AppColors.textOnPrimary,
                                          fontWeight: FontWeight.w800,
                                          height: 1.38,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: pantallaBaja ? 18 : 25,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: pantallaBaja ? 52 : 58,
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
                                        padding:
                                            const EdgeInsets.symmetric(
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
