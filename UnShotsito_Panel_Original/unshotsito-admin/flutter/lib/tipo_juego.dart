import 'package:flutter/material.dart';
import 'catalogo.dart';
import 'control_retos.dart';

class TipoJuego extends StatefulWidget {
  const TipoJuego({super.key, required this.alElegir});
  final void Function(ControlRetos) alElegir;
  @override
  State<TipoJuego> createState() => _TipoJuegoState();
}

class _TipoJuegoState extends State<TipoJuego> {
  // Una lectura por partida, independiente de las reconstrucciones de Flutter.
  late Future<List<Categoria>> catalogo = cargarCatalogo();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Elegí una categoría')),
    body: FutureBuilder<List<Categoria>>(
      future: catalogo,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data!.isEmpty) {
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(snapshot.hasError ? '${snapshot.error}' : 'El catálogo está vacío.'),
            TextButton(onPressed: () => setState(() => catalogo = cargarCatalogo()),
                child: const Text('Volver a cargar')),
          ]));
        }
        return ListView(children: [
          for (final c in snapshot.data!)
            ListTile(title: Text(c.nombre),
              subtitle: Text('${c.retos.length} retos · ${c.castigos.length} castigos'),
              enabled: c.retos.isNotEmpty,
              onTap: () => widget.alElegir(ControlRetos(c))),
        ]);
      },
    ),
  );
}
