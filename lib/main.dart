import 'dart:async';

import 'package:flutter/material.dart';

import 'screens/bienvenida.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const UnShotsitoApp());
}

class UnShotsitoApp extends StatelessWidget {
  const UnShotsitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnShotsito',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: const PantallaSplash(),
    );
  }
}

/// Pantalla inicial de carga de UnShotsito.
///
/// Utiliza la ilustración oficial de bienvenida y se adapta a
/// teléfonos pequeños, medianos y tablets.
class PantallaSplash extends StatefulWidget {
  const PantallaSplash({super.key});

  @override
  State<PantallaSplash> createState() =>
      _PantallaSplashState();
}

class _PantallaSplashState extends State<PantallaSplash>
    with SingleTickerProviderStateMixin {
  static const Duration _duracionAnimacion =
      Duration(milliseconds: 1300);

  static const Duration _duracionSplash =
      Duration(milliseconds: 2600);

  static const Duration _duracionTransicion =
      Duration(milliseconds: 550);

  late final AnimationController _controller;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  Timer? _navigationTimer;

  bool _navegando = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _duracionAnimacion,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    _navigationTimer = Timer(
      _duracionSplash,
      _irABienvenida,
    );
  }

  void _irABienvenida() {
    if (!mounted || _navegando) return;

    _navegando = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: _duracionTransicion,
        reverseTransitionDuration:
            const Duration(milliseconds: 350),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return const PantallaBienvenida();
        },
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );

          final scaleAnimation = Tween<double>(
            begin: 0.985,
            end: 1,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducirAnimaciones =
        MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          final isSmallScreen = screenWidth < 360;
          final isCompactHeight = screenHeight < 650;
          final isLargeScreen = screenWidth >= 600;

          final horizontalPadding = isSmallScreen
              ? 18.0
              : isLargeScreen
                  ? 40.0
                  : 26.0;

          final imageSize = _responsiveValue(
            preferred: screenWidth * 0.48,
            minimum: isCompactHeight ? 145 : 170,
            maximum: isLargeScreen ? 300 : 235,
          );

          final titleSize = _responsiveValue(
            preferred: screenWidth * 0.098,
            minimum: 31,
            maximum: isLargeScreen ? 46 : 39,
          );

          final subtitleSize = _responsiveValue(
            preferred: screenWidth * 0.041,
            minimum: 14,
            maximum: 17,
          );

          final content = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ImagenSplash(
                size: imageSize,
              ),
              SizedBox(
                height: isCompactHeight ? 14 : 20,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'UnShotsito',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: -0.8,
                    height: 1.05,
                  ),
                ),
              ),
              const SizedBox(height: 11),
              Text(
                'Donde los retos se ponen buenos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              SizedBox(
                height: isCompactHeight ? 24 : 38,
              ),
              const _IndicadorCarga(),
            ],
          );

          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.background,
                  AppColors.surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: isCompactHeight ? 16 : 26,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth:
                          AppSizes.maximumContentWidth,
                    ),
                    child: reducirAnimaciones
                        ? content
                        : FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: content,
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

  double _responsiveValue({
    required double preferred,
    required double minimum,
    required double maximum,
  }) {
    return preferred
        .clamp(minimum, maximum)
        .toDouble();
  }
}

/// Ilustración principal de la pantalla splash.
class _ImagenSplash extends StatelessWidget {
  const _ImagenSplash({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Mascota de UnShotsito dando la bienvenida',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Brillo suave detrás del personaje.
            Container(
              width: size * 0.76,
              height: size * 0.76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(
                  alpha: 0.07,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: 0.14,
                    ),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),

            Positioned.fill(
              child: Image.asset(
                'assets/images/bienvenida_shot.png',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                gaplessPlayback: true,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return _ImagenError(
                    size: size,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Respaldo visual si la ilustración no carga.
class _ImagenError extends StatelessWidget {
  const _ImagenError({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 0.72,
      height: size * 0.72,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(
          size * 0.22,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Icon(
        Icons.pets_rounded,
        color: AppColors.primary,
        size: size * 0.30,
      ),
    );
  }
}

/// Indicador inferior mientras termina el splash.
class _IndicadorCarga extends StatelessWidget {
  const _IndicadorCarga();

  @override
  Widget build(BuildContext context) {
    final reducirAnimaciones =
        MediaQuery.disableAnimationsOf(context);

    return Semantics(
      label: 'Preparando los retos',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: reducirAnimaciones
                ? Image.asset(
                    'assets/images/logo_UnShotsito.png',
                    width: 34,
                    height: 34,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Icon(
                        Icons.pets_rounded,
                        color: AppColors.primary,
                        size: 29,
                      );
                    },
                  )
                : const CircularProgressIndicator(
                    strokeWidth: 3.2,
                    color: AppColors.primary,
                    backgroundColor:
                        AppColors.surfaceMuted,
                    strokeCap: StrokeCap.round,
                  ),
          ),
          const SizedBox(height: 13),
          Text(
            'Preparando los retos...',
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
          ),
        ],
      ),
    );
  }
}
