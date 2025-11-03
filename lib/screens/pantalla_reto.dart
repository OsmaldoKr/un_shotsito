import 'dart:math';
import 'package:flutter/material.dart';
import 'package:un_shotsito/theme.dart';
import '../data/control_retos.dart';
import '../data/retos_especiales.dart';
import '../utils/procesadores_texto.dart';
import '../widgets/tarjeta_reto.dart';
import '../widgets/modal_castigo.dart';
import '../widgets/modal_reto_especial.dart';
import '../widgets/modal_reto_completado.dart'; // ← NUEVO IMPORT
import '../widgets/icono_reto_especial.dart';

class PantallaReto extends StatefulWidget {
  final List<String> jugadores;
  final String modo;
  final List<int> rango;
  final String tipo;

  const PantallaReto({
    super.key,
    required this.jugadores,
    required this.modo,
    required this.rango,
    required this.tipo,
  });

  @override
  State<PantallaReto> createState() => _PantallaRetoState();
}

class _PantallaRetoState extends State<PantallaReto>
    with SingleTickerProviderStateMixin {
  String textoReto = '';
  String textoCastigo = '';
  bool mostrandoCastigo = false;
  final Random _random = Random();
  final ProcesadorTexto _procesador = ProcesadorTexto();
  
  List<RetoEspecial> retosEspecialesActivos = [];
  RetoEspecial? retoEspecialExpandido;
  RetoEspecial? retoEspecialPendiente;
  String? retoCompletadoDescripcion; // ← NUEVO
  int contadorTurnos = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _cargarPrimerReto();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _cargarPrimerReto() {
    final retoObj = obtenerRetoAleatorio(widget.tipo);
    String reto = _procesador.procesarRetoConJugadores(
        retoObj.descripcion, widget.jugadores);
    reto = _procesador.procesarShotsEnReto(reto, widget.rango);

    setState(() {
      textoReto = reto;
      mostrandoCastigo = false;
      textoCastigo = '';
    });
    _animationController.value = 1.0;
  }

  // ← FUNCIÓN ACTUALIZADA
  void _actualizarRetosEspeciales() {
    List<RetoEspecial> retosActualizados = [];
    List<RetoEspecial> retosCompletados = [];

    for (var reto in retosEspecialesActivos) {
      final retoActualizado = reto.copyWith(
        turnosRestantes: reto.turnosRestantes - 1,
      );

      if (retoActualizado.activo) {
        retosActualizados.add(retoActualizado);
      } else {
        retosCompletados.add(reto);
      }
    }

    setState(() {
      retosEspecialesActivos = retosActualizados;
    });

    // Mostrar notificación para cada reto completado
    if (retosCompletados.isNotEmpty) {
      // Mostrar el primero
      setState(() {
        retoCompletadoDescripcion = retosCompletados.first.descripcion;
      });
    }
  }

  void _agregarRetoEspecial() {
    if (_random.nextDouble() < 0.2 && retoEspecialPendiente == null) {
      final descripcion = obtenerRetoEspecialAleatorio();
      final descripcionProcesada = _procesador.procesarRetoConJugadores(
          descripcion, widget.jugadores);
      final turnos = obtenerTurnosRetoEspecial(descripcion);

      final nuevoReto = RetoEspecial(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        descripcion: descripcionProcesada,
        turnosRestantes: turnos,
        turnosTotales: turnos,
        creado: DateTime.now(),
      );

      setState(() => retoEspecialPendiente = nuevoReto);
    }
  }

  void _aceptarRetoEspecial() async {
    if (retoEspecialPendiente != null) {
      await _animationController.reverse();
      
      setState(() {
        retosEspecialesActivos.add(retoEspecialPendiente!);
        retoEspecialPendiente = null;
      });
      
      final retoObj = obtenerRetoAleatorio(widget.tipo);
      String reto = _procesador.procesarRetoConJugadores(
          retoObj.descripcion, widget.jugadores);
      reto = _procesador.procesarShotsEnReto(reto, widget.rango);
      
      setState(() => textoReto = reto);
      await _animationController.forward();
    }
  }

  void generarNuevoReto() async {
    await _animationController.reverse();

    final retoObj = obtenerRetoAleatorio(widget.tipo);
    String reto = _procesador.procesarRetoConJugadores(
        retoObj.descripcion, widget.jugadores);
    reto = _procesador.procesarShotsEnReto(reto, widget.rango);

    _actualizarRetosEspeciales();
    _agregarRetoEspecial();
    contadorTurnos++;

    setState(() {
      textoReto = reto;
      mostrandoCastigo = false;
      textoCastigo = '';
    });

    await _animationController.forward();
  }

  void mostrarCastigo() {
    String castigo = _procesador.procesarRetoConJugadores(
        obtenerCastigoAleatorio(), widget.jugadores);
    castigo = _procesador.procesarShotsEnReto(castigo, widget.rango);

    setState(() {
      textoCastigo = castigo;
      mostrandoCastigo = true;
    });
  }

  void completarReto({required bool cumplio}) {
    if (!cumplio) {
      mostrarCastigo();
    } else {
      generarNuevoReto();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoOscuro,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: const BoxDecoration(
              color: fondoClaro,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: Text(
                widget.tipo,
                style: const TextStyle(
                  color: textoPrincipal,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tarjeta de reto
                      Expanded(
                        child: Stack(
                          children: [
                            Center(
                              child: TarjetaReto(
                                textoReto: textoReto,
                                retoEspecial: retoEspecialPendiente,
                                fadeAnimation: _fadeAnimation,
                              ),
                            ),
                            
                            // Íconos de retos especiales activos
                            if (retosEspecialesActivos.isNotEmpty)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: retosEspecialesActivos
                                      .map((reto) => IconoRetoEspecial(
                                            reto: reto,
                                            onTap: () => setState(() =>
                                                retoEspecialExpandido = reto),
                                          ))
                                      .toList(),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Botones
                      if (retoEspecialPendiente != null)
                        ElevatedButton(
                          onPressed: _aceptarRetoEspecial,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFFF9800),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Aceptar Reto",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => completarReto(cumplio: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorExito,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "Cumplí",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: textoPrincipal,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: mostrarCastigo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: acentoDivertido,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "Castigo",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: textoPrincipal,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Modales
                if (mostrandoCastigo)
                  ModalCastigo(
                    textoCastigo: textoCastigo,
                    onCerrar: () => setState(() {
                      mostrandoCastigo = false;
                      textoCastigo = '';
                    }),
                  ),

                if (retoEspecialExpandido != null)
                  ModalRetoEspecial(
                    reto: retoEspecialExpandido!,
                    onCerrar: () =>
                        setState(() => retoEspecialExpandido = null),
                  ),

                // ← NUEVO MODAL DE RETO COMPLETADO
                if (retoCompletadoDescripcion != null)
                  ModalRetoCompletado(
                    descripcionReto: retoCompletadoDescripcion!,
                    onCerrar: () =>
                        setState(() => retoCompletadoDescripcion = null),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
