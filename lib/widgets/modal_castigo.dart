import 'package:flutter/material.dart';
import '../theme.dart';

class ModalCastigo extends StatelessWidget {
  final String textoCastigo;
  final VoidCallback onCerrar;

  const ModalCastigo({
    super.key,
    required this.textoCastigo,
    required this.onCerrar,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            color: Colors.black.withAlpha((80 * value).toInt()),
            child: Center(
              child: Transform.scale(
                scale: value,
                child: Container(
                  margin: const EdgeInsets.all(32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorSecundario,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: acentoDivertido.withAlpha(80),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        textoCastigo,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          color: textoPrincipal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: onCerrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: acentoDivertido,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          "Continuar",
                          style: TextStyle(
                            fontSize: 20,
                            color: textoPrincipal,
                            fontWeight: FontWeight.bold,
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
      },
    );
  }
}
