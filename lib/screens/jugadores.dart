import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import 'tipo_juego.dart';

class PantallaJugadores extends StatefulWidget {
  const PantallaJugadores({super.key});

  @override
  State<PantallaJugadores> createState() =>
      _PantallaJugadoresState();
}

class _PantallaJugadoresState extends State<PantallaJugadores> {
  final TextEditingController _nombreController =
      TextEditingController();

  final FocusNode _nombreFocusNode = FocusNode();

  final List<JugadorRegistro> _jugadores = [];

  static const int _minimoJugadores = 2;
  static const int _maximoJugadores = 12;
  static const int _minimoCaracteres = 2;
  static const int _maximoCaracteres = 18;

  String? _errorNombre;
  bool _navegando = false;

  static const List<Color> _coloresDisponibles = [
    AppColors.primary,
    AppColors.group,
    AppColors.punishment,
    AppColors.random,
    AppColors.relaxed,
    AppColors.intense,
  ];

  bool get _puedeContinuar =>
      _jugadores.length >= _minimoJugadores;

  bool get _alcanzoMaximo =>
      _jugadores.length >= _maximoJugadores;

  int get _jugadoresFaltantes =>
      (_minimoJugadores - _jugadores.length).clamp(
        0,
        _minimoJugadores,
      );

  @override
  void dispose() {
    _nombreController.dispose();
    _nombreFocusNode.dispose();
    super.dispose();
  }

  // =========================================================
  // VALIDACIÓN Y NORMALIZACIÓN
  // =========================================================

  String _limpiarNombre(String valor) {
    return valor
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  String _normalizarNombre(String valor) {
    return _limpiarNombre(valor).toLowerCase();
  }

  String? _validarNombre(String nombre) {
    if (_alcanzoMaximo) {
      return 'Ya alcanzaste el máximo de jugadores.';
    }

    if (nombre.isEmpty) {
      return 'Escribe el nombre del jugador.';
    }

    if (nombre.length < _minimoCaracteres) {
      return 'El nombre debe tener al menos $_minimoCaracteres caracteres.';
    }

    if (nombre.length > _maximoCaracteres) {
      return 'El nombre no puede superar $_maximoCaracteres caracteres.';
    }

    final contieneLetra = RegExp(
      r'[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ]',
    ).hasMatch(nombre);

    if (!contieneLetra) {
      return 'El nombre debe contener al menos una letra.';
    }

    final nombreNormalizado = _normalizarNombre(nombre);

    final nombreRepetido = _jugadores.any(
      (jugador) =>
          _normalizarNombre(jugador.nombre) ==
          nombreNormalizado,
    );

    if (nombreRepetido) {
      return 'Ese jugador ya está en la partida.';
    }

    return null;
  }

  // =========================================================
  // ACCIONES
  // =========================================================

  void _agregarJugador() {
    final nombre = _limpiarNombre(
      _nombreController.text,
    );

    final error = _validarNombre(nombre);

    if (error != null) {
      setState(() {
        _errorNombre = error;
      });

      _nombreFocusNode.requestFocus();
      return;
    }

    final color = _coloresDisponibles[
        _jugadores.length % _coloresDisponibles.length];

    setState(() {
      _jugadores.add(
        JugadorRegistro(
          nombre: nombre,
          color: color,
        ),
      );

      _errorNombre = null;
    });

    _nombreController.clear();

    if (_alcanzoMaximo) {
      _nombreFocusNode.unfocus();
    } else {
      _nombreFocusNode.requestFocus();
    }
  }

  void _eliminarJugador(JugadorRegistro jugador) {
    setState(() {
      _jugadores.remove(jugador);
      _errorNombre = null;
    });

    if (!_alcanzoMaximo) {
      _nombreFocusNode.requestFocus();
    }
  }

  Future<void> _continuar() async {
    if (!_puedeContinuar || _navegando) return;

    setState(() {
      _navegando = true;
    });

    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration:
            const Duration(milliseconds: 340),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return PantallaTipoJuego(
            jugadores: _jugadores
                .map((jugador) => jugador.nombre)
                .toList(growable: false),
          );
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

  // =========================================================
  // INTERFAZ
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          const _EncabezadoJugadores(),
          Expanded(
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallWidth =
                      constraints.maxWidth < 360;

                  final horizontalPadding =
                      isSmallWidth ? 16.0 : 20.0;

                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16,
                      horizontalPadding,
                      14,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 680,
                        ),
                        child: Column(
                          children: [
                            _ContadorJugadores(
                              cantidad: _jugadores.length,
                              minimo: _minimoJugadores,
                              maximo: _maximoJugadores,
                            ),
                            const SizedBox(height: 16),
                            _construirCampoNombre(),
                            const SizedBox(height: 16),
                            Expanded(
                              child: _construirZonaJugadores(),
                            ),
                            const SizedBox(height: 14),
                            _construirBotonContinuar(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirCampoNombre() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppSizes.radiusLarge,
        ),
        border: Border.all(
          color: _errorNombre == null
              ? AppColors.border
              : AppColors.error,
          width: _errorNombre == null ? 1 : 1.3,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 9),
              Text(
                'Agregar jugador',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Spacer(),
              Text(
                '${_jugadores.length}/$_maximoJugadores',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nombreController,
            focusNode: _nombreFocusNode,
            enabled: !_alcanzoMaximo,
            maxLength: _maximoCaracteres,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            autocorrect: false,
            enableSuggestions: false,
            onSubmitted: (_) {
              if (!_alcanzoMaximo) {
                _agregarJugador();
              }
            },
            onChanged: (_) {
              if (_errorNombre != null) {
                setState(() {
                  _errorNombre = null;
                });
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(
                  r"[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ0-9 '\-]",
                ),
              ),
              LengthLimitingTextInputFormatter(
                _maximoCaracteres,
              ),
            ],
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: _alcanzoMaximo
                  ? 'Máximo de jugadores alcanzado'
                  : 'Nombre del jugador',
              counterText: '',
              errorText: _errorNombre,
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _BotonAgregarJugador(
                  habilitado: !_alcanzoMaximo,
                  onPressed: _agregarJugador,
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 54,
                minHeight: 54,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Usa entre $_minimoCaracteres y $_maximoCaracteres caracteres.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }

  Widget _construirZonaJugadores() {
    if (_jugadores.isEmpty) {
      return const _EstadoJugadoresVacio();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final usarDosColumnas = constraints.maxWidth >= 520;

        final anchoTarjeta = usarDosColumnas
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;

        return Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              vertical: 3,
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (var index = 0;
                    index < _jugadores.length;
                    index++)
                  SizedBox(
                    width: anchoTarjeta,
                    child: _TarjetaJugador(
                      jugador: _jugadores[index],
                      numero: index + 1,
                      onDelete: () {
                        _eliminarJugador(
                          _jugadores[index],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _construirBotonContinuar() {
    final texto = _puedeContinuar
        ? 'Elegir modo de juego'
        : _jugadoresFaltantes == 1
            ? 'Agrega 1 jugador más'
            : 'Agrega $_jugadoresFaltantes jugadores más';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            _puedeContinuar && !_navegando ? _continuar : null,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _navegando
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
                  key: ValueKey(texto),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _puedeContinuar
                          ? Icons.arrow_forward_rounded
                          : Icons.group_add_outlined,
                      size: 22,
                    ),
                    const SizedBox(width: 9),
                    Flexible(
                      child: Text(
                        texto,
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

// ===========================================================
// MODELO
// ===========================================================

class JugadorRegistro {
  const JugadorRegistro({
    required this.nombre,
    required this.color,
  });

  final String nombre;
  final Color color;
}

// ===========================================================
// ENCABEZADO
// ===========================================================

class _EncabezadoJugadores extends StatelessWidget {
  const _EncabezadoJugadores();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallWidth = screenWidth < 360;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isSmallWidth ? 14 : 18,
            10,
            isSmallWidth ? 14 : 18,
            20,
          ),
          child: Row(
            children: [
              _BotonRegresar(
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jugadores',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: AppColors.textOnPrimary,
                            fontSize: isSmallWidth ? 22 : 25,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '¿Quiénes van a jugar?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: AppColors.textOnPrimary
                                .withValues(alpha: 0.80),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppSizes.radiusMedium,
                  ),
                  border: Border.all(
                    color: AppColors.textOnPrimary.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: AppColors.textOnPrimary,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonRegresar extends StatelessWidget {
  const _BotonRegresar({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textOnPrimary.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(
        AppSizes.radiusMedium,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(
          AppSizes.radiusMedium,
        ),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppSizes.radiusMedium,
            ),
            border: Border.all(
              color: AppColors.textOnPrimary.withValues(
                alpha: 0.18,
              ),
            ),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textOnPrimary,
            size: 23,
          ),
        ),
      ),
    );
  }
}

// ===========================================================
// CONTADOR
// ===========================================================

class _ContadorJugadores extends StatelessWidget {
  const _ContadorJugadores({
    required this.cantidad,
    required this.minimo,
    required this.maximo,
  });

  final int cantidad;
  final int minimo;
  final int maximo;

  @override
  Widget build(BuildContext context) {
    final progreso = cantidad / maximo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppSizes.radiusMedium,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: cantidad >= minimo
                  ? AppColors.successBackground
                  : AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(
                AppSizes.radiusMedium,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Text(
                '$cantidad',
                key: ValueKey(cantidad),
                style: TextStyle(
                  color: cantidad >= minimo
                      ? AppColors.success
                      : AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cantidad == 1
                      ? '1 jugador listo'
                      : '$cantidad jugadores listos',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progreso.clamp(0, 1),
                    minHeight: 6,
                    color: cantidad >= minimo
                        ? AppColors.success
                        : AppColors.primary,
                    backgroundColor: AppColors.surfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Máx. $maximo',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// BOTÓN AGREGAR
// ===========================================================

class _BotonAgregarJugador extends StatelessWidget {
  const _BotonAgregarJugador({
    required this.habilitado,
    required this.onPressed,
  });

  final bool habilitado;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Agregar jugador',
      onPressed: habilitado ? onPressed : null,
      style: IconButton.styleFrom(
        backgroundColor: habilitado
            ? AppColors.primary
            : AppColors.disabledBackground,
        foregroundColor: habilitado
            ? AppColors.textOnPrimary
            : AppColors.textMuted,
        disabledBackgroundColor: AppColors.disabledBackground,
        disabledForegroundColor: AppColors.textMuted,
        minimumSize: const Size.square(44),
        maximumSize: const Size.square(44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
      icon: const Icon(
        Icons.add_rounded,
        size: 28,
      ),
    );
  }
}

// ===========================================================
// TARJETAS DE JUGADORES
// ===========================================================

class _TarjetaJugador extends StatelessWidget {
  const _TarjetaJugador({
    required this.jugador,
    required this.numero,
    required this.onDelete,
  });

  final JugadorRegistro jugador;
  final int numero;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(
        begin: 0.94,
        end: 1,
      ),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 76,
        ),
        padding: const EdgeInsets.fromLTRB(
          12,
          11,
          8,
          11,
        ),
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
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 5,
              height: 42,
              decoration: BoxDecoration(
                color: jugador.color,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(width: 11),
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: jugador.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusMedium,
                ),
                border: Border.all(
                  color: jugador.color.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                jugador.nombre
                    .substring(0, 1)
                    .toUpperCase(),
                style: TextStyle(
                  color: jugador.color,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jugador.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Jugador $numero',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              tooltip: 'Eliminar a ${jugador.nombre}',
              onPressed: onDelete,
              style: IconButton.styleFrom(
                foregroundColor: AppColors.error,
                backgroundColor:
                    AppColors.errorBackground,
                minimumSize: const Size.square(42),
                maximumSize: const Size.square(42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================
// ESTADO VACÍO
// ===========================================================

class _EstadoJugadoresVacio extends StatelessWidget {
  const _EstadoJugadoresVacio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusLarge,
                ),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: const Icon(
                Icons.group_add_outlined,
                size: 43,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Agrega a tus amigos',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 7),
            Text(
              'Necesitas al menos dos jugadores para comenzar la partida.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
