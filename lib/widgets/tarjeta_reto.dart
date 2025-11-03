import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/retos_especiales.dart';

class TarjetaReto extends StatelessWidget {
  final String textoReto;
  final RetoEspecial? retoEspecial;
  final Animation<double> fadeAnimation;

  const TarjetaReto({
    super.key,
    required this.textoReto,
    this.retoEspecial,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final esRetoEspecial = retoEspecial != null;

    return FadeTransition(
      opacity: fadeAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: esRetoEspecial
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFB74D),
                    Color(0xFFFFA726),
                    Color(0xFFFF9800),
                  ],
                )
              : null,
          color: !esRetoEspecial ? fondoClaro : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: esRetoEspecial
                  ? const Color(0xFFFF9800).withAlpha(100)
                  : Colors.black.withAlpha(40),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (esRetoEspecial)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.red,
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "RETO ESPECIAL",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Center(
                child: Text(
                  esRetoEspecial ? retoEspecial!.descripcion : textoReto,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color: esRetoEspecial ? Colors.white : textoPrincipal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (esRetoEspecial)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${retoEspecial!.turnosTotales} turnos',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
