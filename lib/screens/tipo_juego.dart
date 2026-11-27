import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/catalogo_grupal.dart';
import 'pantalla_reto.dart';

class PantallaTipoJuego extends StatefulWidget {
  const PantallaTipoJuego({required this.jugadores, super.key});

  final List<String> jugadores;

  @override
  State<PantallaTipoJuego> createState() => _PantallaTipoJuegoState();
}

class _PantallaTipoJuegoState extends State<PantallaTipoJuego> {
  late final PageController _pageController;

  int _paginaActual = 0;
  bool _navegando = false;

  CatalogoGrupal? _catalogo;
  List<TipoJuego> _tiposJuego = [];
  String? _error;

  Future<void> _cargar() async {
    setState(() {
      _catalogo = null;
      _error = null;
      _paginaActual = 0;
    });
    try {
      final datos = await CatalogoGrupal.cargar();
      if (!mounted) return;
      setState(() {
        _catalogo = datos;
        _tiposJuego = datos.categorias
            .map(
              (c) => TipoJuego(
                titulo: c.nombre,
                nombreVisible: c.nombre,
                descripcion: c.retos.isEmpty
                    ? 'Todavía no hay retos activos.'
                    : 'Elegí esta categoría para jugar en grupo.',
                icono: 'assets/images/logo_UnShotsito.png',
                color: AppColors.group,
                intensidad: '${c.retos.length} retos',
                iconoIntensidad: Icons.style_outlined,
              ),
            )
            .toList();
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  TipoJuego get _tipoSeleccionado => _tiposJuego[_paginaActual];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.84, keepPage: false);
    _cargar();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _abrirCategoria(TipoJuego tipo) async {
    if (_navegando) return;
    final datos = _catalogo!;
    final categoria = datos.categorias[_tiposJuego.indexOf(tipo)];
    if (categoria.retos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta categoría todavía no tiene retos activos.'),
        ),
      );
      return;
    }

    setState(() {
      _navegando = true;
    });

    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 480),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) {
          return PantallaReto(
            jugadores: List<String>.from(widget.jugadores),
            tipo: tipo.titulo,
            catalogo: datos,
            categoria: categoria,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    if (_catalogo == null || _tiposJuego.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Categorías')),
        body: Center(
          child: _catalogo == null && _error == null
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error ?? 'No hay categorías grupales activas.'),
                      TextButton(
                        onPressed: _cargar,
                        child: const Text('Volver a cargar'),
                      ),
                    ],
                  ),
                ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final pantallaEstrecha = constraints.maxWidth < 360;

            final pantallaBaja = constraints.maxHeight < 650;

            return Column(
              children: [
                _EncabezadoTipoJuego(
                  cantidadJugadores: widget.jugadores.length,
                  pantallaEstrecha: pantallaEstrecha,
                ),
                SizedBox(height: pantallaBaja ? 8 : 14),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _tiposJuego.length,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _paginaActual = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: pantallaBaja ? 10 : 18,
                          ),
                          child: TarjetaTipoJuego(
                            tipo: _tiposJuego[index],
                            seleccionado: index == _paginaActual,
                            pantallaBaja: pantallaBaja,
                            onTap: () {
                              if (index != _paginaActual) {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 320),
                                  curve: Curves.easeOutCubic,
                                );

                                return;
                              }

                              _abrirCategoria(_tiposJuego[index]);
                            },
                          ),
                        ),
                        builder: (context, child) {
                          var diferencia = 0.0;

                          if (_pageController.hasClients) {
                            final page =
                                _pageController.page ??
                                _paginaActual.toDouble();

                            diferencia = page - index;
                          }

                          final escala = (1 - diferencia.abs() * 0.08).clamp(
                            0.90,
                            1.0,
                          );

                          final opacidad = (1 - diferencia.abs() * 0.22).clamp(
                            0.72,
                            1.0,
                          );

                          return Transform.scale(
                            scale: escala,
                            child: Opacity(opacity: opacidad, child: child),
                          );
                        },
                      );
                    },
                  ),
                ),
                _IndicadoresCategorias(
                  cantidad: _tiposJuego.length,
                  seleccionado: _paginaActual,
                ),
                SizedBox(height: pantallaBaja ? 12 : 18),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    pantallaEstrecha ? 16 : 22,
                    0,
                    pantallaEstrecha ? 16 : 22,
                    pantallaBaja ? 12 : 20,
                  ),
                  child: _BotonJugarCategoria(
                    tipo: _tipoSeleccionado,
                    navegando: _navegando,
                    onPressed: () {
                      _abrirCategoria(_tipoSeleccionado);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ===========================================================
// MODELO
// ===========================================================

class TipoJuego {
  const TipoJuego({
    required this.titulo,
    required this.nombreVisible,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.intensidad,
    required this.iconoIntensidad,
  });

  final String titulo;
  final String nombreVisible;
  final String descripcion;
  final String icono;
  final Color color;
  final String intensidad;
  final IconData iconoIntensidad;
}

// ===========================================================
// ENCABEZADO
// ===========================================================

class _EncabezadoTipoJuego extends StatelessWidget {
  const _EncabezadoTipoJuego({
    required this.cantidadJugadores,
    required this.pantallaEstrecha,
  });

  final int cantidadJugadores;
  final bool pantallaEstrecha;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        pantallaEstrecha ? 14 : 18,
        10,
        pantallaEstrecha ? 14 : 18,
        8,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Volver',
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.textPrimary,
              minimumSize: const Size.square(46),
              maximumSize: const Size.square(46),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Elige una categoría',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: pantallaEstrecha ? 21 : 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Desliza para descubrir los retos',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.groups_rounded,
                  color: AppColors.primary,
                  size: 19,
                ),
                const SizedBox(width: 5),
                Text(
                  '$cantidadJugadores',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// TARJETA
// ===========================================================

class TarjetaTipoJuego extends StatelessWidget {
  const TarjetaTipoJuego({
    required this.tipo,
    required this.seleccionado,
    required this.pantallaBaja,
    required this.onTap,
    super.key,
  });

  final TipoJuego tipo;
  final bool seleccionado;
  final bool pantallaBaja;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: seleccionado,
      label: '${tipo.nombreVisible}. ${tipo.descripcion}',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusExtraLarge),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusExtraLarge),
          splashColor: tipo.color.withValues(alpha: 0.08),
          highlightColor: tipo.color.withValues(alpha: 0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppSizes.radiusExtraLarge),
              border: Border.all(
                color: seleccionado
                    ? tipo.color.withValues(alpha: 0.42)
                    : AppColors.border,
                width: seleccionado ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: seleccionado
                      ? tipo.color.withValues(alpha: 0.18)
                      : AppColors.shadow,
                  blurRadius: seleccionado ? 28 : 16,
                  spreadRadius: seleccionado ? 1 : 0,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusExtraLarge),
              child: Stack(
                children: [
                  Positioned(
                    top: -58,
                    right: -45,
                    child: Container(
                      width: 175,
                      height: 175,
                      decoration: BoxDecoration(
                        color: tipo.color.withValues(alpha: 0.06),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -68,
                    left: -50,
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        color: tipo.color.withValues(alpha: 0.04),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: seleccionado ? 7 : 5,
                      color: tipo.color,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      pantallaBaja ? 14 : 18,
                      pantallaBaja ? 16 : 20,
                      pantallaBaja ? 14 : 18,
                      pantallaBaja ? 14 : 18,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: Hero(
                              tag: 'shot-${tipo.titulo}',
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeOutCubic,
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  maxWidth: seleccionado
                                      ? pantallaBaja
                                            ? 210
                                            : 260
                                      : pantallaBaja
                                      ? 190
                                      : 235,
                                  maxHeight: seleccionado
                                      ? pantallaBaja
                                            ? 210
                                            : 260
                                      : pantallaBaja
                                      ? 190
                                      : 235,
                                ),
                                padding: EdgeInsets.all(pantallaBaja ? 4 : 6),
                                decoration: BoxDecoration(
                                  color: tipo.color.withValues(alpha: 0.055),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusExtraLarge,
                                  ),
                                ),
                                child: Image.asset(
                                  tipo.icono,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  gaplessPlayback: true,
                                  semanticLabel: tipo.nombreVisible,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 42,
                                            color: tipo.color,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Imagen no disponible',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: tipo.color,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  frameBuilder:
                                      (
                                        context,
                                        child,
                                        frame,
                                        wasSynchronouslyLoaded,
                                      ) {
                                        if (wasSynchronouslyLoaded ||
                                            frame != null) {
                                          return AnimatedOpacity(
                                            opacity: 1,
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            child: child,
                                          );
                                        }

                                        return Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            color: tipo.color,
                                          ),
                                        );
                                      },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: pantallaBaja ? 8 : 12),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(pantallaBaja ? 16 : 19),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusLarge,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    tipo.iconoIntensidad,
                                    color: tipo.color,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 7),
                                  Flexible(
                                    child: Text(
                                      tipo.intensidad,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: tipo.color,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 9),
                              Text(
                                tipo.nombreVisible,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: pantallaBaja ? 19 : 22,
                                      fontWeight: FontWeight.w900,
                                      height: 1.15,
                                    ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                tipo.descripcion,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: pantallaBaja ? 13 : 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              seleccionado
                                  ? Icons.swipe_rounded
                                  : Icons.touch_app_rounded,
                              color: AppColors.textMuted,
                              size: 18,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              seleccionado
                                  ? 'Desliza para cambiar'
                                  : 'Toca para seleccionar',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
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
    );
  }
}

// ===========================================================
// INDICADORES
// ===========================================================

class _IndicadoresCategorias extends StatelessWidget {
  const _IndicadoresCategorias({
    required this.cantidad,
    required this.seleccionado,
  });

  final int cantidad;
  final int seleccionado;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Categoría ${seleccionado + 1} de $cantidad',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(cantidad, (index) {
          final activo = index == seleccionado;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 230),
            curve: Curves.easeOut,
            width: activo ? 24 : 7,
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: activo ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(20),
            ),
          );
        }),
      ),
    );
  }
}

// ===========================================================
// BOTÓN INICIAR
// ===========================================================

class _BotonJugarCategoria extends StatelessWidget {
  const _BotonJugarCategoria({
    required this.tipo,
    required this.navegando,
    required this.onPressed,
  });

  final TipoJuego tipo;
  final bool navegando;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: navegando ? null : onPressed,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: navegando
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 23,
                  height: 23,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.textOnPrimary,
                    strokeCap: StrokeCap.round,
                  ),
                )
              : Row(
                  key: ValueKey(tipo.titulo),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow_rounded, size: 25),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Jugar ${tipo.nombreVisible}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
