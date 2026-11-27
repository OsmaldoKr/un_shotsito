import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'retos_especiales.dart' show RetoEspecial, crearReto;

class CategoriaGrupal {
  CategoriaGrupal(Map<String, dynamic> fila)
    : id = fila['id'] as String,
      nombre = fila['nombre'] as String,
      retos = _textos(fila['retos']),
      castigos = _textos(fila['castigos']);

  final String id, nombre;
  final List<String> retos, castigos;
}

List<String> _textos(dynamic lista) => List<String>.unmodifiable(
  (lista as List)
      .map((x) => (x['texto'] as String).trim())
      .where((x) => x.isNotEmpty)
      .toSet(),
);

class CatalogoGrupal {
  CatalogoGrupal(Map<String, dynamic> json)
    : categorias = List.unmodifiable(
        (json['categorias'] as List).map(
          (x) => CategoriaGrupal(x as Map<String, dynamic>),
        ),
      ),
      generales = _textos(json['castigosGenerales']),
      especiales = List.unmodifiable(
        (json['especiales'] as List).map(
          (x) => crearReto(
            id: x['id'] as String,
            descripcion: x['descripcion'] as String,
            turnos: x['turnos'] as int,
          ),
        ),
      );

  final List<CategoriaGrupal> categorias;
  final List<String> generales;
  final List<RetoEspecial> especiales;

  static Future<CatalogoGrupal> cargar() async {
    const url = String.fromEnvironment('SUPABASE_URL');
    const clave = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
    if (url.isEmpty || clave.isEmpty) {
      throw StateError(
        'Configurá SUPABASE_URL y SUPABASE_PUBLISHABLE_KEY en VS Code.',
      );
    }
    final uri = Uri.parse(url).resolve('/rest/v1/rpc/catalogo_grupal');
    final r = await http
        .post(
          uri,
          headers: {'apikey': clave, 'Content-Type': 'application/json'},
          body: '{}',
        )
        .timeout(const Duration(seconds: 15));
    if (r.statusCode != 200) {
      throw StateError(
        'Supabase respondió HTTP ${r.statusCode}. Revisá la configuración y el script 04.',
      );
    }
    return CatalogoGrupal(
      jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>,
    );
  }
}

class MazoGrupal {
  MazoGrupal(Iterable<String> textos, this.azar)
    : opciones = textos.toSet().toList();

  final List<String> opciones;
  final Random azar;
  final List<String> _pendientes = [];
  String? _anterior;
  String sacar() {
    if (_pendientes.isEmpty) {
      _pendientes.addAll(opciones);
      _pendientes.shuffle(azar);
      if (_pendientes.length > 1 && _pendientes.last == _anterior) {
        _pendientes.insert(0, _pendientes.removeLast());
      }
    }
    return _anterior = _pendientes.removeLast();
  }
}
