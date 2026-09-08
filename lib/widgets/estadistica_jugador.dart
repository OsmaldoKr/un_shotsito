class EstadisticaJugador {
  const EstadisticaJugador({
    required this.id,
    required this.nombre,
    this.retosCumplidos = 0,
    this.retosNoCumplidos = 0,
  });

  factory EstadisticaJugador.fromJson(
    Map<String, dynamic> json,
  ) {
    return EstadisticaJugador(
      id: json['id'] as int? ?? 0,
      nombre: json['nombre'] as String? ?? 'Jugador',
      retosCumplidos: json['retosCumplidos'] as int? ?? 0,
      retosNoCumplidos:
          json['retosNoCumplidos'] as int? ?? 0,
    );
  }

  final int id;
  final String nombre;
  final int retosCumplidos;
  final int retosNoCumplidos;

  int get retosRespondidos =>
      retosCumplidos + retosNoCumplidos;

  EstadisticaJugador copiarCon({
    String? nombre,
    int? retosCumplidos,
    int? retosNoCumplidos,
  }) {
    return EstadisticaJugador(
      id: id,
      nombre: nombre ?? this.nombre,
      retosCumplidos:
          retosCumplidos ?? this.retosCumplidos,
      retosNoCumplidos:
          retosNoCumplidos ?? this.retosNoCumplidos,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'retosCumplidos': retosCumplidos,
      'retosNoCumplidos': retosNoCumplidos,
    };
  }
}
