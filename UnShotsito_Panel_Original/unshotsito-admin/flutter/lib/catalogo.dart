import 'dart:convert';
import 'package:http/http.dart' as http;

class Consigna {
  const Consigna(this.id, this.texto);
  factory Consigna.fromJson(Map<String, dynamic> json) =>
      Consigna(json['id'] as String, json['texto'] as String);
  final String id;
  final String texto;
}

class Categoria {
  Categoria.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        nombre = json['nombre'] as String,
        retos = _leerLista(json['retos'] as List),
        castigos = _leerLista(json['castigos'] as List);
  final String id;
  final String nombre;
  final List<Consigna> retos;
  final List<Consigna> castigos;

  static List<Consigna> _leerLista(List datos) =>
      List.unmodifiable(datos.map((v) => Consigna.fromJson(v as Map<String, dynamic>)));
}

Future<List<Categoria>> cargarCatalogo() async {
  const url = String.fromEnvironment('SUPABASE_URL');
  const clave = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  if (url.isEmpty || clave.isEmpty) {
    throw StateError('Configurá la URL y la clave pública de Supabase.');
  }
  final respuesta = await http.post(
    Uri.parse('$url/rest/v1/rpc/catalogo_juego'),
    headers: {'apikey': clave, 'Content-Type': 'application/json'},
    body: '{}',
  ).timeout(const Duration(seconds: 15));
  if (respuesta.statusCode != 200) {
    throw Exception('No se pudo cargar el catálogo (HTTP ${respuesta.statusCode}).');
  }
  final datos = jsonDecode(utf8.decode(respuesta.bodyBytes)) as List;
  return List.unmodifiable(datos.map((v) => Categoria.fromJson(v as Map<String, dynamic>)));
}
