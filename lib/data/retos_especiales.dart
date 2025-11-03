class RetoEspecial {
  final String id;
  final String descripcion;
  final int turnosRestantes;
  final int turnosTotales;
  final DateTime creado;

  RetoEspecial({
    required this.id,
    required this.descripcion,
    required this.turnosRestantes,
    required this.turnosTotales,
    required this.creado,
  });

  RetoEspecial copyWith({
    String? id,
    String? descripcion,
    int? turnosRestantes,
    int? turnosTotales,
    DateTime? creado,
  }) {
    return RetoEspecial(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      turnosRestantes: turnosRestantes ?? this.turnosRestantes,
      turnosTotales: turnosTotales ?? this.turnosTotales,
      creado: creado ?? this.creado,
    );
  }

  double get progreso => turnosRestantes / turnosTotales;
  bool get activo => turnosRestantes > 0;
}

// Lista de retos especiales predefinidos
final List<RetoEspecial> retosEspecialesLista = [
  RetoEspecial(
    id: '1',
    descripcion: 'Name será la perra de name hasta nueva orden, te va a ayudar a lo que quieras y le tienes que decir "buen perro"',
    turnosRestantes: 5,
    turnosTotales: 5,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '2',
    descripcion: 'todas las mujeres sirven las bebidas hasta que lo digas',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '3',
    descripcion: 'todos los hombres sirven las bebidas hasta que lo digas',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '4',
    descripcion: 'Name tiene que hablar en otro idioma hasta nuevo aviso',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '5',
    descripcion: 'Name tiene que bailar cada vez que alguien beba',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '6',
    descripcion: 'Name no puede usar su celular por los próximos turnos',
    turnosRestantes: 5,
    turnosTotales: 5,
    creado: DateTime.now(),
  ),
];
