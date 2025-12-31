import 'dart:math';
import 'package:flutter/material.dart';
import 'package:un_shotsito/theme.dart';
import '../data/control_retos.dart';
import '../data/retos_especiales.dart';
import '../utils/procesadores_texto.dart';
import '../widgets/tarjeta_reto.dart';
import '../widgets/modal_castigo.dart';
import '../widgets/modal_reto_especial.dart';
import '../widgets/modal_reto_completado.dart';
import '../widgets/icono_reto_especial.dart';

class PantallaReto extends StatefulWidget {
  final List<String> jugadores;
  final String tipo;

  const PantallaReto({
    super.key,
    required this.jugadores,
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
  String? retoCompletadoDescripcion;
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

    setState(() {
      textoReto = reto;
      mostrandoCastigo = false;
      textoCastigo = '';
    });
    _animationController.value = 1.0;
  }

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

    if (retosCompletados.isNotEmpty) {
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
      
      setState(() => textoReto = reto);
      await _animationController.forward();
    }
  }

  void generarNuevoReto() async {
    await _animationController.reverse();

    final retoObj = obtenerRetoAleatorio(widget.tipo);
    String reto = _procesador.procesarRetoConJugadores(
        retoObj.descripcion, widget.jugadores);

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
      backgroundColor: colorPrimario,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorSecundario, acentoDivertido],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorSecundario.withAlpha(102),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.tipo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tarjeta de reto principal
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
                            
                            // Íconos retos especiales activos
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
                      
                      const SizedBox(height: 32),
                      
                      // Botones
                      if (retoEspecialPendiente != null)
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _aceptarRetoEspecial,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: colorSecundario,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 12,
                              shadowColor: colorSecundario.withAlpha(153),
                            ),
                            child: const Text(
                              "¡Aceptar Reto Especial!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Cumplí
                            SizedBox(
                              width: 140,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () => completarReto(cumplio: true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorExito,
                                  foregroundColor: textoPrincipal,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 8,
                                  shadowColor: colorExito.withAlpha(153),
                                ),
                                child: const Text(
                                  "¡Cumplí!",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            // Castigo
                            SizedBox(
                              width: 140,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: mostrarCastigo,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: acentoDivertido,
                                  foregroundColor: textoPrincipal,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 8,
                                  shadowColor: acentoDivertido.withAlpha(153),
                                ),
                                child: const Text(
                                  "¡Castigo!",
                                  style: TextStyle(
                                    fontSize: 18,
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
