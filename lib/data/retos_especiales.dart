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

// 🔥 35 RETOS ESPECIALES LIMPIOS Y DIVERTIDOS
final List<RetoEspecial> retosEspecialesLista = [
  // ORIGINALES (6)
  RetoEspecial(
    id: '1',
    descripcion: 'será la perra de name hasta nueva orden, te va a ayudar a lo que quieras y le tienes que decir "buen perro"',
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
    descripcion: 'tiene que hablar en otro idioma hasta nuevo aviso',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '5',
    descripcion: 'tiene que bailar cada vez que alguien beba',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '6',
    descripcion: 'no puede usar su celular por los próximos turnos',
    turnosRestantes: 5,
    turnosTotales: 5,
    creado: DateTime.now(),
  ),

  // 💪 FÍSICOS BRUTALES (8)
  RetoEspecial(
    id: '7',
    descripcion: '50 burpees seguidos sin parar de una vez',
    turnosRestantes: 2,
    turnosTotales: 2,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '8',
    descripcion: 'plancha 1 minuto completo sin moverte',
    turnosRestantes: 2,
    turnosTotales: 2,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '9',
    descripcion: '100 jumping jacks gritando "¡TEAM UNSHOTSITO!"',
    turnosRestantes: 2,
    turnosTotales: 2,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '10',
    descripcion: '20 flexiones de 1 brazo por reto perdido',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '11',
    descripcion: 'correr 2 minutos sin parar por la casa',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '12',
    descripcion: 'hacer 75 sentadillas gritando "¡MÁS DURO!"',
    turnosRestantes: 2,
    turnosTotales: 2,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '13',
    descripcion: 'hacer 60 jumping jacks sin parar',
    turnosRestantes: 2,
    turnosTotales: 2,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '14',
    descripcion: 'hacer 100 sentadillas gritando "¡MÁS!"',
    turnosRestantes: 2,
    turnosTotales: 2,
    creado: DateTime.now(),
  ),

  // 😂 CHISTOSOS HUMILLANTES (12)
  RetoEspecial(
    id: '15',
    descripcion: 'hablar con voz de Pitufo maricón toda la noche',
    turnosRestantes: 5,
    turnosTotales: 5,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '16',
    descripcion: 'llamar "mamacita" a todos los hombres del grupo',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '17',
    descripcion: 'confesar tu amor a la botella de alcohol',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '18',
    descripcion: 'hacer el baile de la gallina cada vez que hables',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '19',
    descripcion: 'pedir permiso para ir al baño como niño pequeño',
    turnosRestantes: 5,
    turnosTotales: 5,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '20',
    descripcion: 'gritar "¡OTRO SHOT!" cada vez que alguien beba',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '21',
    descripcion: 'hablar en tercera persona todo el tiempo',
    turnosRestantes: 5,
    turnosTotales: 5,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '22',
    descripcion: 'llamar "jefe/a" a quien le toque reto',
    turnosRestantes: 5,
    turnosTotales: 5,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '23',
    descripcion: 'habla rimando TODO lo que diga',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '24',
    descripcion: 'debe contar chistes malos antes de cada reto',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '25',
    descripcion: 'grita "¡TEAM UNSHOTSITO!" cada vez que hable',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '26',
    descripcion: 'habla con acento maricón exagerado todo el rato',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),

  // 🕺 BAILES LOCOS (7)
  RetoEspecial(
    id: '27',
    descripcion: 'debe hacer moonwalk para moverse por la habitación',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '28',
    descripcion: 'tiene que twerkear 5 segundos cada ronda',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '29',
    descripcion: 'cada reto que cumple baila perreo 10 segundos',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '30',
    descripcion: 'debe bailar salsa cada vez que suene música',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '31',
    descripcion: 'cada vez que beba tiene que hacer 5 sentadillas',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '32',
    descripcion: 'no puede sentarse, debe estar de pie todo el tiempo',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '33',
    descripcion: 'cada castigo que saque lo hace EL DOBLE',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '34',
    descripcion: 'debe hacer una flexión cada vez que pierda un turno',
    turnosRestantes: 3,
    turnosTotales: 3,
    creado: DateTime.now(),
  ),
  RetoEspecial(
    id: '35',
    descripcion: 'cada vez que pierda hace 10 jumping jacks',
    turnosRestantes: 4,
    turnosTotales: 4,
    creado: DateTime.now(),
  ),
];
