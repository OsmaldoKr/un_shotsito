import 'package:flutter/material.dart';
import 'control_retos.dart';
import 'tipo_juego.dart';

void main() => runApp(MaterialApp(
  title: 'Catálogo UnShotsito',
  theme: ThemeData.dark(),
  home: const EjemploPartida(),
));

class EjemploPartida extends StatefulWidget {
  const EjemploPartida({super.key});
  @override
  State<EjemploPartida> createState() => _EjemploPartidaState();
}

class _EjemploPartidaState extends State<EjemploPartida> {
  ControlRetos? control;
  String texto = '';
  @override
  Widget build(BuildContext context) {
    final partida = control;
    if (partida == null) {
      return TipoJuego(alElegir: (elegido) => setState(() {
        control = elegido;
        texto = elegido.siguienteReto('Ana', 'Luis');
      }));
    }
    return Scaffold(appBar: AppBar(title: Text(partida.categoria.nombre)),
      body: Padding(padding: const EdgeInsets.all(24), child: ListView(children: [
        Text(texto, style: Theme.of(context).textTheme.headlineSmall),
        ElevatedButton(onPressed: () => setState(() => texto = partida.siguienteReto('Ana', 'Luis')),
            child: const Text('Otro reto')),
        if (partida.categoria.castigos.isNotEmpty)
          TextButton(onPressed: () => setState(() => texto = partida.castigoOpcional('Ana', 'Luis')!),
              child: const Text('Ver castigo opcional')),
        TextButton(onPressed: () => setState(() => control = null),
            child: const Text('Nueva partida')),
      ])),
    );
  }
}
