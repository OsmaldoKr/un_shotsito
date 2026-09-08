import 'package:flutter/material.dart';

import '../data/retos_especiales.dart';
import '../theme.dart';
import 'control_estadisticas_retos.dart';
import 'medidas_tarjeta.dart';

class TarjetaReto extends StatelessWidget {
  const TarjetaReto({
    required this.textoReto,
    required this.fadeAnimation,
    required this.estadisticas,
    required this.turnoActual,
    super.key,
    this.retoEspecial,
  });

  final String textoReto;
  final RetoEspecial? retoEspecial;
  final Animation<double> fadeAnimation;
  final ControlEstadisticasRetos estadisticas;
  final int turnoActual;

  bool get _esEspecial => retoEspecial != null;

  String get _textoVisible {
    final texto = _esEspecial ? retoEspecial!.descripcion : textoReto;
    return texto.trim().isEmpty ? 'Preparando el reto...' : texto;
  }

  String get _nombreJugador {
    return estadisticas.jugadorEnTurno(turnoActual)?.nombre ?? 'Jugador';
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: LayoutBuilder(
        builder: (context, limites) {
          final medidas = MedidasTarjeta.desde(
            maxWidth: limites.maxWidth,
            maxHeight: limites.maxHeight,
          );

          return Center(
            child: SizedBox(
              width: medidas.ancho,
              height: medidas.alto,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: _decoracionTarjeta(),
                child: Stack(
                  children: [
                    if (_esEspecial) const _FondoEspecial(),
                    _LineaSuperior(esEspecial: _esEspecial),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        medidas.padding,
                        medidas.padding + 4,
                        medidas.padding,
                        medidas.padding,
                      ),
                      child: Column(
                        children: [
                          _EncabezadoReto(
                            nombreJugador: _nombreJugador,
                            esEspecial: _esEspecial,
                            pantallaBaja: medidas.pantallaBaja,
                          ),
                          _Separador(pantallaBaja: medidas.pantallaBaja),
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  _textoVisible,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: medidas.tamanoTexto(
                                      _textoVisible.length,
                                    ),
                                    fontWeight: FontWeight.w800,
                                    height: 1.36,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: medidas.pantallaBaja ? 12 : 18),
                          _PieReto(
                            retoEspecial: retoEspecial,
                            pantallaEstrecha: medidas.pantallaEstrecha,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _decoracionTarjeta() {
    return BoxDecoration(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppSizes.radiusExtraLarge),
      border: Border.all(
        color: _esEspecial
            ? AppColors.primary.withValues(alpha: 0.30)
            : AppColors.border,
        width: _esEspecial ? 1.4 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: _esEspecial
              ? AppColors.primary.withValues(alpha: 0.18)
              : AppColors.shadow,
          blurRadius: _esEspecial ? 26 : 20,
          spreadRadius: _esEspecial ? 1 : 0,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}

class _EncabezadoReto extends StatelessWidget {
  const _EncabezadoReto({
    required this.nombreJugador,
    required this.esEspecial,
    required this.pantallaBaja,
  });

  final String nombreJugador;
  final bool esEspecial;
  final bool pantallaBaja;

  @override
  Widget build(BuildContext context) {
    final tamanoLogo = pantallaBaja ? 64.0 : 78.0;

    return Column(
      children: [
        _LogoReto(tamano: tamanoLogo),
        SizedBox(height: pantallaBaja ? 10 : 14),
        Text(
          esEspecial
              ? '$nombreJugador, reto especial'
              : '$nombreJugador, tu reto',
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _LogoReto extends StatelessWidget {
  const _LogoReto({required this.tamano});

  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.surfaceElevated.withValues(alpha: 0.60),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          _PuntoLogo(
            top: tamano * 0.15,
            right: tamano * 0.17,
            tamano: tamano * 0.13,
          ),
          _PuntoLogo(
            bottom: tamano * 0.15,
            left: tamano * 0.17,
            tamano: tamano * 0.13,
          ),
        ],
      ),
    );
  }
}

class _PuntoLogo extends StatelessWidget {
  const _PuntoLogo({
    required this.tamano,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  final double tamano;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary.withValues(alpha: 0.22),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _PieReto extends StatelessWidget {
  const _PieReto({
    required this.retoEspecial,
    required this.pantallaEstrecha,
  });

  final RetoEspecial? retoEspecial;
  final bool pantallaEstrecha;

  @override
  Widget build(BuildContext context) {
    if (retoEspecial == null) {
      return const _EtiquetaPie(texto: 'Decide si cumpliste el reto');
    }

    final turnos = retoEspecial!.turnosTotales < 0
        ? 0
        : retoEspecial!.turnosTotales;
    return _EtiquetaPie(
      texto: 'Duración: $turnos ${turnos == 1 ? 'turno' : 'turnos'}',
      advertencia: true,
      anchoCompleto: true,
    );
  }
}

class _EtiquetaPie extends StatelessWidget {
  const _EtiquetaPie({
    required this.texto,
    this.advertencia = false,
    this.anchoCompleto = false,
  });

  final String texto;
  final bool advertencia;
  final bool anchoCompleto;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: anchoCompleto ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: advertencia
            ? AppColors.warningBackground
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: advertencia
            ? Border.all(color: AppColors.warning.withValues(alpha: 0.18))
            : null,
      ),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Separador extends StatelessWidget {
  const _Separador({required this.pantallaBaja});

  final bool pantallaBaja;

  @override
  Widget build(BuildContext context) {
    final espacio = pantallaBaja ? 14.0 : 20.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: espacio),
      child: const Divider(height: 1, color: AppColors.divider),
    );
  }
}

class _LineaSuperior extends StatelessWidget {
  const _LineaSuperior({required this.esEspecial});

  final bool esEspecial;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: esEspecial ? 7 : 5,
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
      ),
    );
  }
}

class _FondoEspecial extends StatelessWidget {
  const _FondoEspecial();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -48,
          right: -38,
          child: _CirculoDecorativo(
            tamano: 155,
            color: AppColors.primary.withValues(alpha: 0.06),
          ),
        ),
        Positioned(
          bottom: -58,
          left: -45,
          child: _CirculoDecorativo(
            tamano: 175,
            color: AppColors.secondary.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }
}

class _CirculoDecorativo extends StatelessWidget {
  const _CirculoDecorativo({required this.tamano, required this.color});

  final double tamano;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
