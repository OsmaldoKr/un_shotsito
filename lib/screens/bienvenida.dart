import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';
import 'jugadores.dart';

class PantallaBienvenida extends StatefulWidget {
  const PantallaBienvenida({super.key});

  @override
  State<PantallaBienvenida> createState() =>
      _PantallaBienvenidaState();
}

class _PantallaBienvenidaState extends State<PantallaBienvenida>
    with TickerProviderStateMixin {
  late final AnimationController _entradaController;
  late final AnimationController _fondoController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  bool _mostrarAviso = true;
  bool _navegando = false;

  @override
  void initState() {
    super.initState();

    _entradaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _entradaController,
      curve: const Interval(
        0,
        0.75,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entradaController,
        curve: const Interval(
          0.08,
          0.90,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _entradaController,
        curve: const Interval(
          0.20,
          1,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _fondoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _cerrarAviso() {
    setState(() {
      _mostrarAviso = false;
    });
  }

  Future<void> _irAJugadores() async {
    if (_navegando || _mostrarAviso) return;

    setState(() {
      _navegando = true;
    });

    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 480),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return const PantallaJugadores();
        },
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );

    if (!mounted) return;

    setState(() {
      _navegando = false;
    });
  }

  @override
  void dispose() {
    _entradaController.dispose();
    _fondoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final isSmallWidth = width < 360;
          final isCompactHeight = height < 680;
          final isTablet = width >= 600;

          final horizontalPadding = isSmallWidth
              ? 18.0
              : isTablet
                  ? 40.0
                  : 24.0;

          final logoSize = _responsiveValue(
            value: width * 0.27,
            minimum: 88,
            maximum: isTablet ? 136 : 116,
          );

          final titleSize = _responsiveValue(
            value: width * 0.10,
            minimum: 32,
            maximum: isTablet ? 48 : 40,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
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
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _ShotGlassPainter(
                        animation: _fondoController,
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: isCompactHeight ? 18 : 28,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: max(
                          0,
                          constraints.maxHeight -
                              (isCompactHeight ? 36 : 56),
                        ),
                        maxWidth: 500,
                      ),
                      child: IntrinsicHeight(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _LogoPrincipal(
                                  size: logoSize,
                                  titleSize: titleSize,
                                ),
                                SizedBox(
                                  height: isCompactHeight ? 18 : 24,
                                ),
                                Text(
                                  'La fiesta comienza con un buen reto',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontSize: isSmallWidth ? 16 : 18,
                                        fontWeight: FontWeight.w600,
                                        height: 1.35,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Agrega a tus amigos, elige un modo y deja que comience el juego.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: isSmallWidth ? 14 : 15,
                                        height: 1.45,
                                      ),
                                ),
                                SizedBox(
                                  height: isCompactHeight ? 28 : 38,
                                ),
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: _TarjetaComenzar(
                                    navegando: _navegando,
                                    onPressed: _irAJugadores,
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: isCompactHeight ? 28 : 46,
                                ),
                                const _Footer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_mostrarAviso)
                Positioned.fill(
                  child: _AvisoLegal(
                    onAccept: _cerrarAviso,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  double _responsiveValue({
    required double value,
    required double minimum,
    required double maximum,
  }) {
    return value.clamp(minimum, maximum).toDouble();
  }
}

class _LogoPrincipal extends StatelessWidget {
  const _LogoPrincipal({
    required this.size,
    required this.titleSize,
  });

  final double size;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.mainGradient,
            borderRadius: BorderRadius.circular(size * 0.30),
            border: Border.all(
              color: AppColors.surfaceElevated.withValues(alpha: 0.65),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.22),
                blurRadius: 26,
                spreadRadius: 1,
                offset: const Offset(0, 12),
              ),
              const BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(size * 0.08),
            child: Image.asset(
              'assets/images/bienvenida_shot.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            ),
          ),
        ),
        const SizedBox(height: 22),
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
      ],
    );
  }
}

class _TarjetaComenzar extends StatelessWidget {
  const _TarjetaComenzar({
    required this.navegando,
    required this.onPressed,
  });

  final bool navegando;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 430,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(
                AppSizes.radiusMedium,
              ),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preparar partida',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Agrega a los jugadores',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Semantics(
            button: true,
            label: 'Preparar partida',
            child: SizedBox(
              width: 58,
              height: 58,
              child: ElevatedButton(
                onPressed: navegando ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.square(58),
                  maximumSize: const Size.square(58),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusMedium,
                    ),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: navegando
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.textOnPrimary,
                            strokeCap: StrokeCap.round,
                          ),
                        )
                      : const Icon(
                          Icons.arrow_forward_rounded,
                          key: ValueKey('arrow'),
                          size: 27,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Desarrollado por',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                fontSize: 12,
                letterSpacing: 0.4,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          'FratresPixel',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
        ),
      ],
    );
  }
}

class _AvisoLegal extends StatelessWidget {
  const _AvisoLegal({
    required this.onAccept,
  });

  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.overlay,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                maxWidth: 410,
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusLarge,
                ),
                border: Border.all(
                  color: AppColors.border,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 32,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusLarge,
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.10),
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/seguridad.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Icon(
                          Icons.health_and_safety_rounded,
                          size: 42,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Consumo responsable',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Esta aplicación está dirigida exclusivamente a '
                    'personas mayores de 18 años.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.warningBackground,
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusMedium,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Juega y consume bebidas responsablemente. '
                            'Nunca conduzcas bajo los efectos del alcohol.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onAccept,
                      child: const Text(
                        'Soy mayor de 18 años',
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
}

class _ShotGlassPainter extends CustomPainter {
  _ShotGlassPainter({
    required this.animation,
  }) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value * 2 * pi;

    final shortestSide = min(size.width, size.height);
    final scale = (shortestSide / 700).clamp(0.75, 1.15);

    final liquidPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.055)
      ..style = PaintingStyle.fill;

    final glassPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.095)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4 * scale;

    final shinePaint = Paint()
      ..color = AppColors.surfaceElevated.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * scale;

    final positions = [
      Offset(
        size.width * 0.14,
        size.height * 0.20 + sin(progress) * 8,
      ),
      Offset(
        size.width * 0.86,
        size.height * 0.62 + cos(progress * 1.15) * 9,
      ),
      Offset(
        size.width * 0.12,
        size.height * 0.82 + sin(progress * 0.8) * 7,
      ),
      Offset(
        size.width * 0.84,
        size.height * 0.18 + cos(progress * 1.05) * 8,
      ),
    ];

    for (var index = 0; index < positions.length; index++) {
      canvas.save();

      canvas.translate(
        positions[index].dx,
        positions[index].dy,
      );

      canvas.rotate(
        sin(progress + index) * 0.06,
      );

      final glassRect = Rect.fromCenter(
        center: Offset.zero,
        width: 27 * scale,
        height: 40 * scale,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          glassRect,
          Radius.circular(6 * scale),
        ),
        glassPaint,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(0, 8 * scale),
            width: 21 * scale,
            height: 18 * scale,
          ),
          Radius.circular(4 * scale),
        ),
        liquidPaint,
      );

      canvas.drawLine(
        Offset(-8 * scale, -13 * scale),
        Offset(-8 * scale, 3 * scale),
        shinePaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(
    covariant _ShotGlassPainter oldDelegate,
  ) {
    return oldDelegate.animation != animation;
  }
}
