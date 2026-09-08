import 'dart:math';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import '../data/control_retos.dart';
import '../data/retos_especiales.dart';
import '../theme.dart';
import '../utils/procesadores_texto.dart';
import '../widgets/icono_reto_especial.dart';
import '../widgets/modal_reto_completado.dart';
import '../widgets/modal_reto_especial.dart';
import '../widgets/control_estadisticas_retos.dart';
import '../widgets/panel_estadisticas_retos.dart';
import '../widgets/tarjeta_reto.dart';

class PantallaReto extends StatefulWidget {
  const PantallaReto({
    required this.jugadores, required this.tipo, super.key,
  });

  final List<String> jugadores;
  final String tipo;

  @override
  State<PantallaReto> createState() => _PantallaRetoState();
}

class _PantallaRetoState extends State<PantallaReto>
    with TickerProviderStateMixin {
  // =========================================================
  // CONFIGURACIÓN
  // =========================================================

  static const double _probabilidadRetoEspecial = 0.20;
  static const int _maximoRetosEspecialesActivos = 3;

  // =========================================================
  // RETO Y CASTIGO ACTUAL
  // =========================================================

  String textoReto = '';
  String textoCastigo = '';

  bool mostrandoCastigo = false;
  bool _procesandoAccion = false;

  // =========================================================
  // UTILIDADES
  // =========================================================

  final Random _random = Random();
  final ProcesadorTexto _procesador = ProcesadorTexto();

  // =========================================================
  // RETOS ESPECIALES
  // =========================================================

  List<RetoEspecial> retosEspecialesActivos = [];

  RetoEspecial? retoEspecialPendiente;
  RetoEspecial? retoEspecialExpandido;

  final List<String> _retosCompletadosPendientes = [];
  String? _ultimoRetoEspecialId;

  int contadorTurnos = 0;
  int _turnoActual = 0;

  late final ControlEstadisticasRetos _controlEstadisticas;

  // =========================================================
  // ANIMACIONES
  // =========================================================

  late final AnimationController _entradaController;
  late final Animation<double> _fadeAnimation;

  late final AnimationController _giroController;
  late final Animation<double> _giroAnimation;

  // =========================================================
  // PROPIEDADES
  // =========================================================

  bool get _hayModalVisible =>
      retoEspecialExpandido != null ||
      _retosCompletadosPendientes.isNotEmpty;

  bool get _puedeInteractuar =>
      !_procesandoAccion && !_hayModalVisible;

  String get _nombreJugadorActual {
    return _controlEstadisticas.jugadorEnTurno(_turnoActual)?.nombre ??
        'Jugador';
  }

  String? get _retoCompletadoActual {
    if (_retosCompletadosPendientes.isEmpty) return null;
    return _retosCompletadosPendientes.first;
  }

  @override
  void initState() {
    super.initState();

    _controlEstadisticas = ControlEstadisticasRetos(widget.jugadores);
    _configurarAnimaciones();
    _cargarPrimerReto();
  }

  @override
  void dispose() {
    _entradaController.dispose();
    _giroController.dispose();
    _controlEstadisticas.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PantallaReto oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(oldWidget.jugadores, widget.jugadores)) {
      _turnoActual = 0;
      _controlEstadisticas.establecerJugadores(widget.jugadores);
    }
  }

  // =========================================================
  // CONFIGURACIÓN INICIAL
  // =========================================================

  void _configurarAnimaciones() {
    _entradaController = AnimationController(
      duration: const Duration(milliseconds: 420),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entradaController,
      curve: Curves.easeOutCubic,
    );

    _giroController = AnimationController(
      duration: const Duration(milliseconds: 650),
      reverseDuration: const Duration(milliseconds: 560),
      vsync: this,
    );

    _giroAnimation = CurvedAnimation(
      parent: _giroController,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
  }

  void _cargarPrimerReto() {
    textoReto = _obtenerRetoProcesado();
    textoCastigo = '';

    mostrandoCastigo = false;

    _entradaController.value = 1;
    _giroController.value = 0;
  }

  String _obtenerRetoProcesado() {
    final reto = obtenerRetoAleatorio(
      widget.tipo,
      descripcionAnterior: textoReto,
    );

    return _procesador.procesarRetoConJugadores(
      reto.descripcion,
      widget.jugadores,
    );
  }

  String _obtenerCastigoProcesado() {
    final castigo = obtenerCastigoAleatorio(
      castigoAnterior: textoCastigo,
    );

    return _procesador.procesarRetoConJugadores(
      castigo,
      widget.jugadores,
    );
  }

  // =========================================================
  // CREACIÓN DE RETOS ESPECIALES
  // =========================================================

  void _intentarAgregarRetoEspecial() {
    if (retoEspecialPendiente != null ||
        mostrandoCastigo ||
        retosEspecialesActivos.length >=
            _maximoRetosEspecialesActivos) {
      return;
    }

    final debeGenerarse =
        _random.nextDouble() < _probabilidadRetoEspecial;

    if (!debeGenerarse) {
      return;
    }

    final retoBase = obtenerRetoEspecialCompletoAleatorio(
      ultimoId: _ultimoRetoEspecialId,
    );

    if (retoBase == null) {
      return;
    }

    final yaExiste = retosEspecialesActivos.any(
      (reto) => reto.id == retoBase.id,
    );

    if (yaExiste) {
      return;
    }

    final descripcionProcesada =
        _procesador.procesarRetoConJugadores(
      retoBase.descripcion,
      widget.jugadores,
    );

    final nuevoReto = retoBase.copyWith(
      descripcion: descripcionProcesada,
      turnosRestantes: retoBase.turnosTotales,
      creado: DateTime.now(),
    );

    setState(() {
      retoEspecialPendiente = nuevoReto;
      _ultimoRetoEspecialId = retoBase.id;
    });
  }

  // =========================================================
  // ACEPTAR RETO ESPECIAL
  // =========================================================

  Future<void> _aceptarRetoEspecial() async {
    final retoPendiente = retoEspecialPendiente;

    if (retoPendiente == null || !_puedeInteractuar) {
      return;
    }

    _cambiarEstadoProcesando(true);

    try {
      await _entradaController.reverse();

      if (!mounted) return;

      final yaEstaActivo = retosEspecialesActivos.any(
        (reto) => reto.id == retoPendiente.id,
      );

      final nuevoReto = _obtenerRetoProcesado();

      setState(() {
        if (!yaEstaActivo) {
          retosEspecialesActivos = [
            ...retosEspecialesActivos,
            retoPendiente,
          ];
        }

        retoEspecialPendiente = null;

        textoReto = nuevoReto;
        textoCastigo = '';

        mostrandoCastigo = false;
      });

      await _entradaController.forward();
    } catch (error, stackTrace) {
      debugPrint(
        'Error al aceptar el reto especial: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      _mostrarMensaje(
        'No se pudo aceptar el reto especial.',
      );
    } finally {
      if (mounted) {
        _cambiarEstadoProcesando(false);
      }
    }
  }

  // =========================================================
  // ACTUALIZACIÓN DE RETOS ACTIVOS
  // =========================================================

  List<String> _actualizarRetosEspeciales() {
    if (retosEspecialesActivos.isEmpty) {
      return const [];
    }

    final actualizados = <RetoEspecial>[];
    final completados = <RetoEspecial>[];

    for (final reto in retosEspecialesActivos) {
      final turnosNuevos = max(
        0,
        reto.turnosRestantes - 1,
      );

      final retoActualizado = reto.copyWith(
        turnosRestantes: turnosNuevos,
      );

      if (retoActualizado.activo) {
        actualizados.add(retoActualizado);
      } else {
        completados.add(retoActualizado);
      }
    }

    retosEspecialesActivos = actualizados;

    return completados
        .map((reto) => reto.descripcion)
        .toList(growable: false);
  }

  // =========================================================
  // GENERAR NUEVO RETO
  // =========================================================

  Future<void> generarNuevoReto({
    bool avanzarTurno = true,
  }) async {
    if (!_puedeInteractuar) {
      return;
    }

    _cambiarEstadoProcesando(true);

    try {
      if (mostrandoCastigo) {
        await _giroController.reverse();

        if (!mounted) return;
      }

      await _entradaController.reverse();

      if (!mounted) return;

      final nuevoReto = _obtenerRetoProcesado();
      final retosCompletados = _actualizarRetosEspeciales();

      setState(() {
        if (avanzarTurno) {
          _avanzarTurno();
        }

        textoReto = nuevoReto;
        textoCastigo = '';

        mostrandoCastigo = false;

        if (retosCompletados.isNotEmpty) {
          _retosCompletadosPendientes.addAll(retosCompletados);
        }
      });

      if (retosCompletados.isEmpty) {
        _intentarAgregarRetoEspecial();
      }

      await _entradaController.forward();
    } catch (error, stackTrace) {
      debugPrint(
        'Error al generar un nuevo reto: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      _mostrarMensaje(
        'No se pudo cargar el siguiente reto.',
      );

      if (_entradaController.status ==
          AnimationStatus.dismissed) {
        await _entradaController.forward();
      }
    } finally {
      if (mounted) {
        _cambiarEstadoProcesando(false);
      }
    }
  }

  // =========================================================
  // MOSTRAR CASTIGO
  // =========================================================

  Future<void> mostrarCastigo() async {
    if (!_puedeInteractuar || mostrandoCastigo) {
      return;
    }

    _cambiarEstadoProcesando(true);

    try {
      final castigo = _obtenerCastigoProcesado();

      setState(() {
        textoCastigo = castigo;
        mostrandoCastigo = true;
      });

      await _giroController.forward();
    } catch (error, stackTrace) {
      debugPrint(
        'Error al mostrar el castigo: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) return;

      setState(() {
        mostrandoCastigo = false;
        textoCastigo = '';
      });

      _mostrarMensaje(
        'No se pudo mostrar el castigo.',
      );
    } finally {
      if (mounted) {
        _cambiarEstadoProcesando(false);
      }
    }
  }

  Future<void> completarReto({
    required bool cumplio,
  }) async {
    if (!_puedeInteractuar) {
      return;
    }

    _controlEstadisticas.registrarResultado(
      turnoActual: _turnoActual,
      cumplido: cumplio,
    );

    if (cumplio) {
      await generarNuevoReto();
    } else {
      await mostrarCastigo();
    }
  }

  Future<void> _terminarCastigo() async {
    if (!_puedeInteractuar) {
      return;
    }

    await generarNuevoReto();
  }

  void _avanzarTurno() {
    contadorTurnos++;

    if (widget.jugadores.isEmpty) {
      _turnoActual = 0;
      return;
    }

    _turnoActual = (_turnoActual + 1) % widget.jugadores.length;
  }

  void _mostrarEstadisticas() {
    mostrarPanelEstadisticasRetos(
      context: context,
      control: _controlEstadisticas,
      turnoActual: _turnoActual,
    );
  }

  // =========================================================
  // ESTADO Y MENSAJES
  // =========================================================

  void _cambiarEstadoProcesando(bool procesando) {
    if (!mounted) return;

    setState(() {
      _procesandoAccion = procesando;
    });
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );
  }

  // =========================================================
  // INTERFAZ PRINCIPAL
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_procesandoAccion,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _construirEncabezado(),
            Expanded(
              child: SafeArea(
                top: false,
                child: _construirContenidoPrincipal(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ENCABEZADO
  // =========================================================

  Widget _construirEncabezado() {
    final anchoPantalla =
        MediaQuery.sizeOf(context).width;

    final pantallaPequena =
        anchoPantalla < 360;

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
            pantallaPequena ? 14 : 18,
            10,
            pantallaPequena ? 14 : 18,
            18,
          ),
          child: Row(
            children: [
              _BotonEncabezado(
                tooltip: 'Volver',
                icon: Icons.arrow_back_rounded,
                habilitado: !_procesandoAccion,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: pantallaPequena ? 10 : 13,
              ),
              Container(
                width: pantallaPequena ? 42 : 48,
                height: pantallaPequena ? 42 : 48,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                    AppSizes.radiusMedium,
                  ),
                  border: Border.all(
                    color: AppColors.textOnPrimary
                        .withValues(alpha: 0.18),
                  ),
                ),
                child: Image.asset(
                  'assets/images/shot_reto_especial.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: pantallaPequena ? 10 : 13,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tipo,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            color:
                                AppColors.textOnPrimary,
                            fontSize: pantallaPequena
                                ? 19
                                : 22,
                            fontWeight:
                                FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 3),
                    AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 220,
                      ),
                      child: Text(
                        mostrandoCastigo
                            ? '$_nombreJugadorActual · Castigo'
                            : retoEspecialPendiente != null
                                ? '$_nombreJugadorActual · Reto especial'
                                : '$_nombreJugadorActual · Turno ${contadorTurnos + 1}',
                        key: ValueKey(
                          '$mostrandoCastigo-'
                          '${retoEspecialPendiente != null}-'
                          '$contadorTurnos-$_turnoActual',
                        ),
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: AppColors
                                  .textOnPrimary
                                  .withValues(
                                    alpha: 0.80,
                                  ),
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _BotonParticipantes(
                cantidad: widget.jugadores.length,
                habilitado: !_procesandoAccion,
                onPressed: _mostrarEstadisticas,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CONTENIDO
  // =========================================================

  Widget _construirContenidoPrincipal() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pantallaEstrecha =
            constraints.maxWidth < 360;

        final pantallaBaja =
            constraints.maxHeight < 600;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            pantallaEstrecha ? 14 : 20,
            pantallaBaja ? 14 : 20,
            pantallaEstrecha ? 14 : 20,
            pantallaBaja ? 14 : 20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 680,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: _TarjetaGiratoria(
                            animation: _giroAnimation,
                            frente: TarjetaReto(
                              textoReto: textoReto,
                              retoEspecial:
                                  retoEspecialPendiente,
                              fadeAnimation:
                                  _fadeAnimation,
                              estadisticas:
                                  _controlEstadisticas,
                              turnoActual: _turnoActual,
                            ),
                            reverso: _TarjetaCastigo(
                              textoCastigo:
                                  textoCastigo,
                              turno:
                                  contadorTurnos + 1,
                            ),
                          ),
                        ),

                        if (retosEspecialesActivos
                                .isNotEmpty &&
                            !mostrandoCastigo)
                          Positioned(
                            top: 8,
                            left: 8,
                            child:
                                _construirRetosEspecialesActivos(),
                          ),

                        if (_procesandoAccion)
                          const Positioned(
                            top: 12,
                            right: 12,
                            child: _IndicadorProcesando(),
                          ),

                        if (retoEspecialExpandido != null)
                          Positioned.fill(
                            child: ModalRetoEspecial(
                              reto:
                                  retoEspecialExpandido!,
                              onCerrar:
                                  _cerrarRetoEspecialExpandido,
                            ),
                          ),

                        if (_retoCompletadoActual != null)
                          Positioned.fill(
                            child: ModalRetoCompletado(
                              key: ValueKey(_retoCompletadoActual),
                              descripcionReto:
                                  _retoCompletadoActual!,
                              onCerrar:
                                  _cerrarRetoCompletado,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height:
                        pantallaBaja ? 14 : 22,
                  ),
                  _construirControles(
                    pantallaEstrecha:
                        pantallaEstrecha,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // RETOS ESPECIALES ACTIVOS
  // =========================================================

  Widget _construirRetosEspecialesActivos() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 210,
        maxWidth: 80,
      ),
      child: SingleChildScrollView(
        physics:
            const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children:
              retosEspecialesActivos.map((reto) {
            return Padding(
              key: ValueKey(reto.id),
              padding:
                  const EdgeInsets.only(bottom: 8),
              child: IconoRetoEspecial(
                reto: reto,
                onTap: () {
                  if (!_puedeInteractuar) {
                    return;
                  }

                  setState(() {
                    retoEspecialExpandido = reto;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // =========================================================
  // CONTROLES
  // =========================================================

  Widget _construirControles({
    required bool pantallaEstrecha,
  }) {
    if (mostrandoCastigo) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _puedeInteractuar
              ? _terminarCastigo
              : null,
          label: const Text(
            'Siguiente reto',
          ),
        ),
      );
    }

    if (retoEspecialPendiente != null) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _puedeInteractuar
              ? _aceptarRetoEspecial
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.punishment,
          ),
          label: const Text(
            'Aceptar reto especial',
          ),
        ),
      );
    }

    if (pantallaEstrecha) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _BotonResultado(
              texto: '¡Cumplí!',
              color: AppColors.success,
              habilitado: _puedeInteractuar,
              onPressed: () {
                completarReto(
                  cumplio: true,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: _BotonResultado(
              texto: 'No cumplí',
              color: AppColors.error,
              habilitado: _puedeInteractuar,
              onPressed: () {
                completarReto(
                  cumplio: false,
                );
              },
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _BotonResultado(
            texto: '¡Cumplí!',
            color: AppColors.success,
            habilitado: _puedeInteractuar,
            onPressed: () {
              completarReto(
                cumplio: true,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _BotonResultado(
            texto: 'No cumplí',
            color: AppColors.error,
            habilitado: _puedeInteractuar,
            onPressed: () {
              completarReto(
                cumplio: false,
              );
            },
          ),
        ),
      ],
    );
  }

  // =========================================================
  // CIERRE DE MODALES
  // =========================================================

  void _cerrarRetoEspecialExpandido() {
    if (!mounted) return;

    setState(() {
      retoEspecialExpandido = null;
    });
  }

  void _cerrarRetoCompletado() {
    if (!mounted) return;

    setState(() {
      if (_retosCompletadosPendientes.isNotEmpty) {
        _retosCompletadosPendientes.removeAt(0);
      }
    });

    if (_retosCompletadosPendientes.isEmpty) {
      _intentarAgregarRetoEspecial();
    }
  }
}

// ===========================================================
// TARJETA GIRATORIA
// ===========================================================

class _TarjetaGiratoria extends StatelessWidget {
  const _TarjetaGiratoria({
    required this.animation,
    required this.frente,
    required this.reverso,
  });

  final Animation<double> animation;
  final Widget frente;
  final Widget reverso;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final angulo =
            animation.value * pi;

        final mostrarFrente =
            angulo <= pi / 2;

        final transformacion =
            Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(angulo);

        return Transform(
          alignment: Alignment.center,
          transform: transformacion,
          child: mostrarFrente
              ? IgnorePointer(
                  ignoring:
                      animation.value != 0,
                  child: frente,
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateY(pi),
                  child: IgnorePointer(
                    ignoring:
                        animation.value != 1,
                    child: reverso,
                  ),
                ),
        );
      },
    );
  }
}

// ===========================================================
// TARJETA DE CASTIGO
// ===========================================================

class _TarjetaCastigo extends StatelessWidget {
  const _TarjetaCastigo({
    required this.textoCastigo,
    required this.turno,
  });

  final String textoCastigo;
  final int turno;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pantallaBaja =
            constraints.maxHeight < 480;

        final pantallaEstrecha =
            constraints.maxWidth < 360;

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 520,
            minHeight:
                pantallaBaja ? 300 : 390,
            maxHeight:
                constraints.maxHeight,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient:
                AppColors.punishmentGradient,
            borderRadius: BorderRadius.circular(
              AppSizes.radiusExtraLarge,
            ),
            border: Border.all(
              color: AppColors.textOnPrimary
                  .withValues(alpha: 0.20),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.punishment
                    .withValues(alpha: 0.28),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -34,
                right: -28,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary
                        .withValues(alpha: 0.07),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -45,
                left: -38,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary
                        .withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  pantallaEstrecha
                      ? 20
                      : pantallaBaja
                          ? 22
                          : 28,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                      Container(
                        width: pantallaBaja ? 58 : 64,
                        height: pantallaBaja ? 58 : 64,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.textOnPrimary.withValues(
                      alpha: 0.14,
                        ),
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusMedium,
                        ),
                      ),
                  child: Image.asset(
                    'assets/images/castigo.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                  errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
      return const Icon(
        Icons.sentiment_very_satisfied_rounded,
        color: AppColors.textOnPrimary,
        size: 30,
      );
    },
  ),
),

                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                'CASTIGO',
                                style: TextStyle(
                                  color: AppColors
                                      .textOnPrimary,
                                  fontSize:
                                      pantallaBaja
                                          ? 19
                                          : 21,
                                  fontWeight:
                                      FontWeight.w900,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              Text(
                                'Turno $turno',
                                style: TextStyle(
                                  color: AppColors
                                      .textOnPrimary
                                      .withValues(
                                        alpha: 0.75,
                                      ),
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColors.textOnPrimary
                          .withValues(alpha: 0.16),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Center(
                        child:
                            SingleChildScrollView(
                          physics:
                              const BouncingScrollPhysics(),
                          child: Text(
                            textoCastigo.isEmpty
                                ? 'Preparando el castigo...'
                                : textoCastigo,
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: AppColors
                                  .textOnPrimary,
                              fontSize:
                                  pantallaEstrecha
                                      ? 19
                                      : pantallaBaja
                                          ? 21
                                          : 25,
                              fontWeight:
                                  FontWeight.w800,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textOnPrimary
                            .withValues(alpha: 0.11),
                        borderRadius:
                            BorderRadius.circular(
                          AppSizes.radiusMedium,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              'Completa el castigo para continuar',
                              maxLines: 2,
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                color: AppColors
                                    .textOnPrimary
                                    .withValues(
                                      alpha: 0.84,
                                    ),
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ===========================================================
// INDICADOR DE PROCESAMIENTO
// ===========================================================

class _IndicadorProcesando extends StatelessWidget {
  const _IndicadorProcesando();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(
          AppSizes.radiusMedium,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const CircularProgressIndicator(
        strokeWidth: 2.8,
        color: AppColors.primary,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}

// ===========================================================
// BOTONES
// ===========================================================

class _BotonResultado extends StatelessWidget {
  const _BotonResultado({
    required this.texto,
    required this.color,
    required this.habilitado,
    required this.onPressed,
  });

  final String texto;
  final Color color;
  final bool habilitado;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: habilitado ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: habilitado ? 3 : 0,
          backgroundColor: habilitado
              ? color
              : AppColors.disabledBackground,
          foregroundColor: habilitado
              ? AppColors.textOnPrimary
              : AppColors.textMuted,
          shadowColor: color.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSizes.radiusLarge,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _BotonEncabezado extends StatelessWidget {
  const _BotonEncabezado({
    required this.tooltip,
    required this.icon,
    required this.habilitado,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final bool habilitado;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed:
          habilitado ? onPressed : null,
      style: IconButton.styleFrom(
        foregroundColor:
            AppColors.textOnPrimary,
        disabledForegroundColor:
            AppColors.textOnPrimary
                .withValues(alpha: 0.45),
        backgroundColor:
            AppColors.textOnPrimary
                .withValues(alpha: 0.12),
        disabledBackgroundColor:
            AppColors.textOnPrimary
                .withValues(alpha: 0.06),
        minimumSize:
            const Size.square(44),
        maximumSize:
            const Size.square(44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSizes.radiusMedium,
          ),
          side: BorderSide(
            color: AppColors.textOnPrimary
                .withValues(alpha: 0.18),
          ),
        ),
      ),
      icon: Icon(
        icon,
        size: 23,
      ),
    );
  }
}

class _BotonParticipantes extends StatelessWidget {
  const _BotonParticipantes({
    required this.cantidad,
    required this.habilitado,
    required this.onPressed,
  });

  final int cantidad;
  final bool habilitado;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Ver resultados de los jugadores',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: habilitado ? onPressed : null,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: AnimatedOpacity(
            opacity: habilitado ? 1 : 0.45,
            duration: const Duration(milliseconds: 180),
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 44,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: AppColors.textOnPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.groups_rounded,
                    color: AppColors.textOnPrimary,
                    size: 19,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$cantidad',
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
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
