import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';
import 'control_estadisticas_retos.dart';
import 'estadistica_jugador.dart';

Future<void> mostrarPanelEstadisticasRetos({
  required BuildContext context,
  required ControlEstadisticasRetos control,
  required int turnoActual,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar estadísticas',
    barrierColor: Colors.black.withValues(alpha: 0.38),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, _, _) => Align(
      alignment: Alignment.centerRight,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: min(MediaQuery.sizeOf(context).width * 0.88, 390.0),
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(-8, 0),
                ),
              ],
            ),
            child: PanelEstadisticasRetos(
              control: control,
              turnoActual: turnoActual,
            ),
          ),
        ),
      ),
    ),
    transitionBuilder: (_, animacion, _, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animacion, curve: Curves.easeOutCubic),
      ),
      child: child,
    ),
  );
}

class PanelEstadisticasRetos extends StatelessWidget {
  const PanelEstadisticasRetos({
    required this.control,
    required this.turnoActual,
    super.key,
  });

  final ControlEstadisticasRetos control;
  final int turnoActual;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: control,
      builder: (context, _) {
        final jugadorActual = control.jugadorEnTurno(turnoActual);

        return Column(
          children: [
            _EncabezadoPanel(
              cumplidos: control.totalCumplidos,
              noCumplidos: control.totalNoCumplidos,
            ),
            const Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: control.jugadores.isEmpty
                  ? const _SinJugadores()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: control.jugadores.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, indice) {
                        final jugador = control.jugadores[indice];
                        return _FilaJugador(
                          jugador: jugador,
                          esTurnoActual: jugador.id == jugadorActual?.id,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _EncabezadoPanel extends StatelessWidget {
  const _EncabezadoPanel({
    required this.cumplidos,
    required this.noCumplidos,
  });

  final int cumplidos;
  final int noCumplidos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 12, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resultados de la partida',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$cumplidos cumplidos · $noCumplidos no cumplidos',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textSecondary,
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }
}

class _FilaJugador extends StatelessWidget {
  const _FilaJugador({
    required this.jugador,
    required this.esTurnoActual,
  });

  final EstadisticaJugador jugador;
  final bool esTurnoActual;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: esTurnoActual
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: esTurnoActual
              ? AppColors.primary.withValues(alpha: 0.30)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: AppColors.primary.withValues(alpha: 0.14),
            child: Text(
              jugador.nombre.characters.first.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              jugador.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _Contador(
            icono: Icons.check_rounded,
            cantidad: jugador.retosCumplidos,
            color: const Color(0xFF3F9B67),
          ),
          const SizedBox(width: 7),
          _Contador(
            icono: Icons.close_rounded,
            cantidad: jugador.retosNoCumplidos,
            color: const Color(0xFFD65454),
          ),
        ],
      ),
    );
  }
}

class _Contador extends StatelessWidget {
  const _Contador({
    required this.icono,
    required this.cantidad,
    required this.color,
  });

  final IconData icono;
  final int cantidad;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, color: color, size: 15),
          const SizedBox(width: 3),
          Text(
            '$cantidad',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SinJugadores extends StatelessWidget {
  const _SinJugadores();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Todavía no hay jugadores',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
