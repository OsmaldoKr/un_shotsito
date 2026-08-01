class RetoEspecial {
  final String id;
  final String descripcion;
  final int turnosRestantes;
  final int turnosTotales;
  final DateTime creado;

  const RetoEspecial({
    required this.id,
    required this.descripcion,
    required this.turnosRestantes,
    required this.turnosTotales,
    required this.creado,
  })  : assert(turnosTotales > 0),
        assert(turnosRestantes >= 0),
        assert(turnosRestantes <= turnosTotales);

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

  double get progreso {
    if (turnosTotales <= 0) return 0;
    return (turnosTotales - turnosRestantes) / turnosTotales;
  }

  double get progresoRestante {
    if (turnosTotales <= 0) return 0;
    return turnosRestantes / turnosTotales;
  }

  bool get activo => turnosRestantes > 0;

  bool get completado => turnosRestantes == 0;

  RetoEspecial reducirTurno() {
    if (!activo) return this;

    return copyWith(
      turnosRestantes: turnosRestantes - 1,
    );
  }

  RetoEspecial reiniciar() {
    return copyWith(
      turnosRestantes: turnosTotales,
      creado: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'turnosRestantes': turnosRestantes,
      'turnosTotales': turnosTotales,
      'creado': creado.toIso8601String(),
    };
  }

  factory RetoEspecial.fromJson(Map<String, dynamic> json) {
    return RetoEspecial(
      id: json['id'] as String,
      descripcion: json['descripcion'] as String,
      turnosRestantes: json['turnosRestantes'] as int,
      turnosTotales: json['turnosTotales'] as int,
      creado: DateTime.parse(json['creado'] as String),
    );
  }
}

RetoEspecial crearReto({
  required String id,
  required String descripcion,
  required int turnos,
}) {
  return RetoEspecial(
    id: id,
    descripcion: descripcion,
    turnosRestantes: turnos,
    turnosTotales: turnos,
    creado: DateTime.now(),
  );
}

// 🔥 RETOS ESPECIALES DIVERTIDOS Y EQUILIBRADOS
final List<RetoEspecial> retosEspecialesLista = [
  // 👑 PODERES Y REGLAS
  crearReto(
    id: '1',
    descripcion:
        'debe ayudar a name cuando se lo pida y responder: "A la orden, jefe"',
    turnos: 4,
  ),
  crearReto(
    id: '2',
    descripcion:
        'elige a una persona para que sea la encargada de servir las bebidas',
    turnos: 3,
  ),
  crearReto(
    id: '3',
    descripcion:
        'elige a una persona para que anuncie en voz alta el inicio de cada turno',
    turnos: 3,
  ),
  crearReto(
    id: '4',
    descripcion:
        'debe hablar imitando otro idioma o inventando palabras hasta nuevo aviso',
    turnos: 4,
  ),
  crearReto(
    id: '5',
    descripcion: 'debe hacer un paso de baile cada vez que alguien beba',
    turnos: 3,
  ),
  crearReto(
    id: '6',
    descripcion: 'no puede usar su celular durante los próximos turnos',
    turnos: 5,
  ),
  crearReto(
    id: '7',
    descripcion:
        'puede prohibirle una palabra a name durante los próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '8',
    descripcion:
        'elige un apodo para name y todos deben usarlo durante los próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '9',
    descripcion:
        'puede intercambiar su próximo reto con el de otra persona una sola vez',
    turnos: 5,
  ),
  crearReto(
    id: '10',
    descripcion:
        'elige una palabra prohibida; quien la diga debe hacer una pose ridícula',
    turnos: 4,
  ),

  // 💪 FÍSICOS MODERADOS
  crearReto(
    id: '11',
    descripcion: 'debe hacer 10 sentadillas lentamente',
    turnos: 2,
  ),
  crearReto(
    id: '12',
    descripcion: 'debe mantener una plancha durante 20 segundos',
    turnos: 2,
  ),
  crearReto(
    id: '13',
    descripcion: 'debe hacer 15 jumping jacks',
    turnos: 2,
  ),
  crearReto(
    id: '14',
    descripcion: 'debe hacer 5 flexiones normales o apoyando las rodillas',
    turnos: 2,
  ),
  crearReto(
    id: '15',
    descripcion: 'debe trotar en su lugar durante 20 segundos',
    turnos: 2,
  ),
  crearReto(
    id: '16',
    descripcion:
        'cada vez que pierda un reto debe hacer 3 sentadillas adicionales',
    turnos: 3,
  ),
  crearReto(
    id: '17',
    descripcion:
        'debe mantener el equilibrio sobre un pie durante 15 segundos',
    turnos: 2,
  ),
  crearReto(
    id: '18',
    descripcion:
        'debe tocarse los pies 10 veces sin doblar demasiado las rodillas',
    turnos: 2,
  ),
  crearReto(
    id: '19',
    descripcion:
        'debe caminar alrededor del grupo imitando a un personaje famoso',
    turnos: 2,
  ),
  crearReto(
    id: '20',
    descripcion:
        'debe hacer una pose de superhéroe durante 15 segundos sin reírse',
    turnos: 2,
  ),

  // 😂 VOCES Y PERSONAJES
  crearReto(
    id: '21',
    descripcion:
        'debe hablar con voz de personaje animado durante los próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '22',
    descripcion:
        'debe llamar "mamacita" o "papacito" a todos hasta que termine el reto',
    turnos: 4,
  ),
  crearReto(
    id: '23',
    descripcion:
        'debe confesarle su amor dramáticamente a una botella o vaso',
    turnos: 3,
  ),
  crearReto(
    id: '24',
    descripcion:
        'debe hacer el baile de la gallina cada vez que diga la palabra "yo"',
    turnos: 4,
  ),
  crearReto(
    id: '25',
    descripcion:
        'debe pedir permiso al grupo antes de levantarse de su asiento',
    turnos: 4,
  ),
  crearReto(
    id: '26',
    descripcion:
        'debe gritar "¡UnShotsito!" cada vez que alguien complete un reto',
    turnos: 4,
  ),
  crearReto(
    id: '27',
    descripcion: 'debe hablar de sí mismo en tercera persona',
    turnos: 5,
  ),
  crearReto(
    id: '28',
    descripcion:
        'debe llamar "jefe" o "jefa" a la persona que tenga el turno',
    turnos: 5,
  ),
  crearReto(
    id: '29',
    descripcion: 'debe intentar rimar todo lo que diga',
    turnos: 4,
  ),
  crearReto(
    id: '30',
    descripcion: 'debe contar un chiste malo antes de cada uno de sus turnos',
    turnos: 4,
  ),
  crearReto(
    id: '31',
    descripcion:
        'debe hablar como presentador de televisión durante los próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '32',
    descripcion:
        'debe responder todas las preguntas como si fuera una celebridad',
    turnos: 4,
  ),
  crearReto(
    id: '33',
    descripcion:
        'debe hablar susurrando hasta que se terminen sus turnos restantes',
    turnos: 4,
  ),
  crearReto(
    id: '34',
    descripcion:
        'debe terminar cada frase diciendo: "y esa es la verdad"',
    turnos: 4,
  ),
  crearReto(
    id: '35',
    descripcion:
        'debe imitar la risa de un villano cada vez que alguien pierda',
    turnos: 4,
  ),

  // 🕺 BAILES Y ACTUACIONES
  crearReto(
    id: '36',
    descripcion:
        'debe intentar hacer moonwalk cada vez que se mueva de lugar',
    turnos: 4,
  ),
  crearReto(
    id: '37',
    descripcion: 'debe bailar durante 5 segundos al inicio de cada ronda',
    turnos: 3,
  ),
  crearReto(
    id: '38',
    descripcion:
        'cada vez que complete un reto debe celebrar con un baile de 5 segundos',
    turnos: 3,
  ),
  crearReto(
    id: '39',
    descripcion:
        'debe bailar salsa cada vez que alguien diga la palabra "reto"',
    turnos: 4,
  ),
  crearReto(
    id: '40',
    descripcion:
        'debe inventar un paso de baile y enseñárselo a otra persona',
    turnos: 3,
  ),
  crearReto(
    id: '41',
    descripcion:
        'debe desfilar como modelo antes de realizar su próximo reto',
    turnos: 3,
  ),
  crearReto(
    id: '42',
    descripcion:
        'debe actuar como robot durante los próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '43',
    descripcion:
        'debe hacer una entrada dramática cada vez que vuelva a su asiento',
    turnos: 4,
  ),
  crearReto(
    id: '44',
    descripcion:
        'debe bailar sin música durante 10 segundos sin dejar de sonreír',
    turnos: 2,
  ),
  crearReto(
    id: '45',
    descripcion:
        'debe imitar el baile de otra persona elegida por el grupo',
    turnos: 3,
  ),

  // 💘 ROMÁNTICOS Y COQUETOS
  crearReto(
    id: '46',
    descripcion:
        'debe hacerle un cumplido sincero a name en cada uno de sus turnos',
    turnos: 3,
  ),
  crearReto(
    id: '47',
    descripcion:
        'debe mirar a name a los ojos durante 10 segundos sin reírse',
    turnos: 2,
  ),
  crearReto(
    id: '48',
    descripcion:
        'debe inventar una frase romántica dedicada a una persona del grupo',
    turnos: 2,
  ),
  crearReto(
    id: '49',
    descripcion:
        'debe tratar a name como si estuvieran en una cita elegante',
    turnos: 3,
  ),
  crearReto(
    id: '50',
    descripcion:
        'debe contar cómo sería su cita ideal con alguien del grupo',
    turnos: 2,
  ),
  crearReto(
    id: '51',
    descripcion:
        'debe dedicarle una canción romántica a una persona elegida por el grupo',
    turnos: 2,
  ),
  crearReto(
    id: '52',
    descripcion:
        'debe decir qué fue lo primero que le llamó la atención de name',
    turnos: 2,
  ),
  crearReto(
    id: '53',
    descripcion:
        'debe actuar como si estuviera declarando su amor en una novela',
    turnos: 2,
  ),
  crearReto(
    id: '54',
    descripcion:
        'debe elegir a alguien y describir tres cualidades que le parecen atractivas',
    turnos: 2,
  ),
  crearReto(
    id: '55',
    descripcion:
        'debe responder con un cumplido cada vez que name le haga una pregunta',
    turnos: 3,
  ),

  // 🤫 CONFESIONES PERSONALES
  crearReto(
    id: '56',
    descripcion:
        'debe responder con sinceridad la próxima pregunta personal del grupo',
    turnos: 2,
  ),
  crearReto(
    id: '57',
    descripcion:
        'debe contar una anécdota vergonzosa que nunca haya contado al grupo',
    turnos: 2,
  ),
  crearReto(
    id: '58',
    descripcion:
        'debe confesar cuál fue su mayor casi algo y por qué no funcionó',
    turnos: 2,
  ),
  crearReto(
    id: '59',
    descripcion:
        'debe contar qué aprendió de su última relación',
    turnos: 2,
  ),
  crearReto(
    id: '60',
    descripcion:
        'debe confesar si todavía recuerda con cariño a algún ex',
    turnos: 2,
  ),
  crearReto(
    id: '61',
    descripcion:
        'debe contar cuál ha sido su mayor arrepentimiento amoroso',
    turnos: 2,
  ),
  crearReto(
    id: '62',
    descripcion:
        'debe confesar una decisión del pasado que cambiaría',
    turnos: 2,
  ),
  crearReto(
    id: '63',
    descripcion:
        'debe contar una verdad personal que normalmente evita mencionar',
    turnos: 2,
  ),
  crearReto(
    id: '64',
    descripcion:
        'debe decir cuál es la inseguridad que más le cuesta admitir',
    turnos: 2,
  ),
  crearReto(
    id: '65',
    descripcion:
        'debe contar qué persona de su pasado le enseñó la mayor lección',
    turnos: 2,
  ),

  crearReto(
    id: '66',
    descripcion:
        'todos deben aplaudir cada vez que name termine de hablar',
    turnos: 3,
  ),
  crearReto(
    id: '67',
    descripcion:
        'nadie puede decir "sí" ni "no" durante los próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '68',
    descripcion:
        'todos deben hablar con acento inventado durante una ronda',
    turnos: 3,
  ),
  crearReto(
    id: '69',
    descripcion:
        'cada persona debe hacer una pose antes de comenzar su turno',
    turnos: 3,
  ),
  crearReto(
    id: '70',
    descripcion:
        'todos deben tratar a name como una celebridad hasta que termine el reto',
    turnos: 4,
  ),
    // 🔥 RETOS ESPECIALES ADICIONALES

  // 👑 PODERES TEMPORALES
  crearReto(
    id: '71',
    descripcion:
        'puede ordenar que name hable con un acento elegido durante sus próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '72',
    descripcion:
        'puede elegir una palabra que name deberá incluir en cada frase',
    turnos: 4,
  ),
  crearReto(
    id: '73',
    descripcion:
        'puede cambiar de asiento a dos personas del grupo',
    turnos: 2,
  ),
  crearReto(
    id: '74',
    descripcion:
        'elige a su asistente personal, quien deberá anunciar cada uno de sus turnos',
    turnos: 3,
  ),
  crearReto(
    id: '75',
    descripcion:
        'puede obligar a name a responder únicamente con preguntas',
    turnos: 3,
  ),
  crearReto(
    id: '76',
    descripcion:
        'elige una palabra prohibida para todo el grupo',
    turnos: 4,
  ),
  crearReto(
    id: '77',
    descripcion:
        'puede pedirle a name que realice su próximo reto con los ojos cerrados, siempre que sea seguro',
    turnos: 3,
  ),
  crearReto(
    id: '78',
    descripcion:
        'puede cancelar una regla especial que tenga activa otra persona',
    turnos: 2,
  ),
  crearReto(
    id: '79',
    descripcion:
        'elige a una persona que deberá presentarlo como una celebridad antes de cada turno',
    turnos: 3,
  ),
  crearReto(
    id: '80',
    descripcion:
        'puede inventar un apodo para cada persona del grupo',
    turnos: 4,
  ),

  // 😂 RIDÍCULOS Y DIVERTIDOS
  crearReto(
    id: '81',
    descripcion:
        'debe caminar como pingüino cada vez que se levante',
    turnos: 4,
  ),
  crearReto(
    id: '82',
    descripcion:
        'debe fingir que está en cámara lenta durante su próximo turno',
    turnos: 2,
  ),
  crearReto(
    id: '83',
    descripcion:
        'debe anunciar todo lo que hará como narrador de documental',
    turnos: 4,
  ),
  crearReto(
    id: '84',
    descripcion:
        'debe responder con una voz diferente cada vez que le hablen',
    turnos: 4,
  ),
  crearReto(
    id: '85',
    descripcion:
        'debe comportarse como un gato durante sus próximos turnos',
    turnos: 3,
  ),
  crearReto(
    id: '86',
    descripcion:
        'debe fingir que es un influencer grabando contenido para sus seguidores',
    turnos: 3,
  ),
  crearReto(
    id: '87',
    descripcion:
        'debe celebrar todo lo que diga el grupo como si fuera una noticia increíble',
    turnos: 4,
  ),
  crearReto(
    id: '88',
    descripcion:
        'debe hablar como si estuviera dando un discurso presidencial',
    turnos: 4,
  ),
  crearReto(
    id: '89',
    descripcion:
        'debe hacer un sonido de animal cada vez que escuche su nombre',
    turnos: 4,
  ),
  crearReto(
    id: '90',
    descripcion:
        'debe mantener una sonrisa exagerada durante su próximo turno',
    turnos: 2,
  ),
  crearReto(
    id: '91',
    descripcion:
        'debe interpretar cada pregunta como si fuera una escena dramática',
    turnos: 3,
  ),
  crearReto(
    id: '92',
    descripcion:
        'debe hablar como un anciano que cuenta historias del pasado',
    turnos: 4,
  ),
  crearReto(
    id: '93',
    descripcion:
        'debe saludar de una manera diferente cada vez que alguien lo mire',
    turnos: 4,
  ),
  crearReto(
    id: '94',
    descripcion:
        'debe inventar un comercial para cualquier objeto que elija el grupo',
    turnos: 2,
  ),
  crearReto(
    id: '95',
    descripcion:
        'debe hacer una reverencia cada vez que alguien diga su nombre',
    turnos: 4,
  ),

  // 🎭 ACTUACIÓN E IMITACIONES
  crearReto(
    id: '96',
    descripcion:
        'debe imitar a una persona del grupo hasta que alguien descubra quién es',
    turnos: 2,
  ),
  crearReto(
    id: '97',
    descripcion:
        'debe interpretar una escena de ruptura amorosa con name',
    turnos: 2,
  ),
  crearReto(
    id: '98',
    descripcion:
        'debe actuar como villano y revelar su supuesto plan para dominar el mundo',
    turnos: 2,
  ),
  crearReto(
    id: '99',
    descripcion:
        'debe interpretar una llamada imaginaria con un ex',
    turnos: 2,
  ),
  crearReto(
    id: '100',
    descripcion:
        'debe actuar como si acabara de ganar un premio internacional',
    turnos: 2,
  ),
  crearReto(
    id: '101',
    descripcion:
        'debe contar una historia sencilla como si fuera una película de terror',
    turnos: 2,
  ),
  crearReto(
    id: '102',
    descripcion:
        'debe interpretar una discusión entre dos personajes usando voces diferentes',
    turnos: 2,
  ),
  crearReto(
    id: '103',
    descripcion:
        'debe actuar como detective e investigar un misterio inventado por el grupo',
    turnos: 3,
  ),
  crearReto(
    id: '104',
    descripcion:
        'debe imitar cómo reaccionaría name al ganar la lotería',
    turnos: 2,
  ),
  crearReto(
    id: '105',
    descripcion:
        'debe realizar una declaración dramática de amistad hacia el grupo',
    turnos: 2,
  ),

  // 🕺 BAILES Y MOVIMIENTOS
  crearReto(
    id: '106',
    descripcion:
        'debe crear un baile de celebración para usar cuando supere un reto',
    turnos: 3,
  ),
  crearReto(
    id: '107',
    descripcion:
        'debe moverse como robot cada vez que cambie de asiento',
    turnos: 4,
  ),
  crearReto(
    id: '108',
    descripcion:
        'debe bailar durante 5 segundos cada vez que alguien diga "shot"',
    turnos: 4,
  ),
  crearReto(
    id: '109',
    descripcion:
        'debe enseñar al grupo un paso de baile inventado',
    turnos: 2,
  ),
  crearReto(
    id: '110',
    descripcion:
        'debe hacer una pasarela antes de comenzar su próximo turno',
    turnos: 2,
  ),
  crearReto(
    id: '111',
    descripcion:
        'debe representar una canción únicamente mediante movimientos',
    turnos: 2,
  ),
  crearReto(
    id: '112',
    descripcion:
        'debe bailar como si estuviera en una fiesta en cámara lenta',
    turnos: 2,
  ),
  crearReto(
    id: '113',
    descripcion:
        'debe hacer un baile de victoria cada vez que alguien se equivoque',
    turnos: 3,
  ),
  crearReto(
    id: '114',
    descripcion:
        'debe moverse únicamente dando pequeños pasos de baile',
    turnos: 3,
  ),
  crearReto(
    id: '115',
    descripcion:
        'debe imitar el baile favorito de name',
    turnos: 2,
  ),

  // 💘 COQUETOS Y ROMÁNTICOS
  crearReto(
    id: '116',
    descripcion:
        'debe decir qué característica física le parece más atractiva de name',
    turnos: 2,
  ),
  crearReto(
    id: '117',
    descripcion:
        'debe dedicarle una frase coqueta improvisada a alguien del grupo',
    turnos: 2,
  ),
  crearReto(
    id: '118',
    descripcion:
        'debe mirar fijamente a name durante 15 segundos sin apartar la mirada',
    turnos: 2,
  ),
  crearReto(
    id: '119',
    descripcion:
        'debe describir cómo sería una cita perfecta con name',
    turnos: 2,
  ),
  crearReto(
    id: '120',
    descripcion:
        'debe decir con quién del grupo tendría un casi algo y explicar por qué',
    turnos: 2,
  ),
  crearReto(
    id: '121',
    descripcion:
        'debe confesar quién del grupo tiene la sonrisa más atractiva',
    turnos: 2,
  ),
  crearReto(
    id: '122',
    descripcion:
        'debe elegir a alguien y dedicarle una canción romántica',
    turnos: 2,
  ),
  crearReto(
    id: '123',
    descripcion:
        'debe decir qué fue lo primero que notó de name al conocerlo',
    turnos: 2,
  ),
  crearReto(
    id: '124',
    descripcion:
        'debe inventar un apodo romántico para name y usarlo durante varios turnos',
    turnos: 3,
  ),
  crearReto(
    id: '125',
    descripcion:
        'debe confesar con quién del grupo aceptaría tener una cita',
    turnos: 2,
  ),
  crearReto(
    id: '126',
    descripcion:
        'debe describir a name como si fuera el protagonista de una novela romántica',
    turnos: 2,
  ),
  crearReto(
    id: '127',
    descripcion:
        'debe decir cuál es la mayor señal de atracción que suele dar',
    turnos: 2,
  ),
  crearReto(
    id: '128',
    descripcion:
        'debe contar cuál fue la forma más evidente en que intentó conquistar a alguien',
    turnos: 2,
  ),
  crearReto(
    id: '129',
    descripcion:
        'debe decir qué persona del grupo parece tener mejor personalidad para una relación',
    turnos: 2,
  ),
  crearReto(
    id: '130',
    descripcion:
        'debe improvisar una propuesta de matrimonio exagerada para name',
    turnos: 2,
  ),

  // 🤫 CONFESIONES ÍNTIMAS Y PERSONALES
  crearReto(
    id: '131',
    descripcion:
        'debe confesar cuál es su inseguridad más difícil de admitir',
    turnos: 2,
  ),
  crearReto(
    id: '132',
    descripcion:
        'debe contar cuál fue la última situación que lo hizo llorar',
    turnos: 2,
  ),
  crearReto(
    id: '133',
    descripcion:
        'debe confesar una mentira que todavía le genera culpa',
    turnos: 2,
  ),
  crearReto(
    id: '134',
    descripcion:
        'debe revelar cuál fue su mayor decepción amorosa',
    turnos: 2,
  ),
  crearReto(
    id: '135',
    descripcion:
        'debe contar qué persona de su pasado todavía recuerda con frecuencia',
    turnos: 2,
  ),
  crearReto(
    id: '136',
    descripcion:
        'debe confesar si alguna vez se enamoró de alguien que nunca lo supo',
    turnos: 2,
  ),
  crearReto(
    id: '137',
    descripcion:
        'debe decir cuál ha sido el error personal que más le cuesta perdonarse',
    turnos: 2,
  ),
  crearReto(
    id: '138',
    descripcion:
        'debe contar cuál es el mayor miedo que tiene sobre su futuro',
    turnos: 2,
  ),
  crearReto(
    id: '139',
    descripcion:
        'debe confesar qué relación de su pasado desearía haber manejado mejor',
    turnos: 2,
  ),
  crearReto(
    id: '140',
    descripcion:
        'debe decir cuál fue la peor decisión que tomó por amor',
    turnos: 2,
  ),
  crearReto(
    id: '141',
    descripcion:
        'debe contar una verdad sobre sí mismo que normalmente intenta ocultar',
    turnos: 2,
  ),
  crearReto(
    id: '142',
    descripcion:
        'debe confesar cuál fue la mayor traición que cometió o recibió',
    turnos: 2,
  ),
  crearReto(
    id: '143',
    descripcion:
        'debe decir qué persona merece una disculpa que nunca le ha dado',
    turnos: 2,
  ),
  crearReto(
    id: '144',
    descripcion:
        'debe contar cuál ha sido el momento más solitario de su vida',
    turnos: 2,
  ),
  crearReto(
    id: '145',
    descripcion:
        'debe confesar qué aspecto de su personalidad desearía cambiar',
    turnos: 2,
  ),

  // 📱 CELULAR Y REDES SOCIALES
  crearReto(
    id: '146',
    descripcion:
        'debe mostrar la última foto que guardó, siempre que no sea privada',
    turnos: 2,
  ),
  crearReto(
    id: '147',
    descripcion:
        'debe enseñar el último meme que envió',
    turnos: 2,
  ),
  crearReto(
    id: '148',
    descripcion:
        'debe leer en voz alta su última búsqueda, salvo que contenga información privada',
    turnos: 2,
  ),
  crearReto(
    id: '149',
    descripcion:
        'debe mostrar cuál es la aplicación que más utiliza',
    turnos: 2,
  ),
  crearReto(
    id: '150',
    descripcion:
        'debe enseñar la canción que escuchó más recientemente',
    turnos: 2,
  ),
  crearReto(
    id: '151',
    descripcion:
        'debe describir el último perfil que buscó en redes sin decir su nombre',
    turnos: 2,
  ),
  crearReto(
    id: '152',
    descripcion:
        'debe mostrar su emoji más utilizado',
    turnos: 2,
  ),
  crearReto(
    id: '153',
    descripcion:
        'debe contar cuál ha sido la publicación más vergonzosa que ha subido',
    turnos: 2,
  ),
  crearReto(
    id: '154',
    descripcion:
        'debe dejar que el grupo elija una foto graciosa para usar como fondo durante la partida',
    turnos: 3,
  ),
  crearReto(
    id: '155',
    descripcion:
        'debe enseñar la foto más antigua que tenga disponible y explicar su historia',
    turnos: 2,
  ),

  // 🎤 CANTO Y SONIDOS
  crearReto(
    id: '156',
    descripcion:
        'debe cantar el coro de una canción elegida por el grupo',
    turnos: 2,
  ),
  crearReto(
    id: '157',
    descripcion:
        'debe responder cantando durante sus próximos turnos',
    turnos: 3,
  ),
  crearReto(
    id: '158',
    descripcion:
        'debe imitar el sonido de tres animales elegidos por el grupo',
    turnos: 2,
  ),
  crearReto(
    id: '159',
    descripcion:
        'debe inventar una canción corta sobre name',
    turnos: 2,
  ),
  crearReto(
    id: '160',
    descripcion:
        'debe cantar una canción triste como si estuviera en un concierto',
    turnos: 2,
  ),
  crearReto(
    id: '161',
    descripcion:
        'debe hacer efectos de sonido mientras otra persona cuenta una historia',
    turnos: 3,
  ),
  crearReto(
    id: '162',
    descripcion:
        'debe interpretar una canción romántica mirando a name',
    turnos: 2,
  ),
  crearReto(
    id: '163',
    descripcion:
        'debe tararear una canción hasta que alguien la adivine',
    turnos: 2,
  ),
  crearReto(
    id: '164',
    descripcion:
        'debe cantar su próxima respuesta usando una melodía inventada',
    turnos: 2,
  ),
  crearReto(
    id: '165',
    descripcion:
        'debe improvisar un rap sobre lo que está ocurriendo en la partida',
    turnos: 2,
  ),

  // 🎲 REGLAS PARA EL GRUPO
  crearReto(
    id: '166',
    descripcion:
        'todos deben cambiar de asiento sin quedar junto a la misma persona',
    turnos: 2,
  ),
  crearReto(
    id: '167',
    descripcion:
        'todos deben referirse a los demás por apodos durante los próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '168',
    descripcion:
        'nadie puede mencionar nombres propios durante los próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '169',
    descripcion:
        'todos deben levantar la mano antes de hablar',
    turnos: 3,
  ),
  crearReto(
    id: '170',
    descripcion:
        'cada persona debe felicitar a quien complete un reto',
    turnos: 3,
  ),
  crearReto(
    id: '171',
    descripcion:
        'todos deben hablar como personajes de una película de acción',
    turnos: 3,
  ),
  crearReto(
    id: '172',
    descripcion:
        'nadie puede cruzar los brazos durante los próximos turnos',
    turnos: 3,
  ),
  crearReto(
    id: '173',
    descripcion:
        'cada persona debe comenzar su turno diciendo una frase motivadora',
    turnos: 3,
  ),
  crearReto(
    id: '174',
    descripcion:
        'todos deben aplaudir lentamente cuando alguien se equivoque',
    turnos: 3,
  ),
  crearReto(
    id: '175',
    descripcion:
        'nadie puede usar la palabra "reto" durante los próximos turnos',
    turnos: 4,
  ),
    // 🔥 MÁS RETOS ESPECIALES

  // 🤪 LOCURAS Y PERSONAJES
  crearReto(
    id: '176',
    descripcion:
        'debe hablar como un robot que está aprendiendo a tener sentimientos',
    turnos: 4,
  ),
  crearReto(
    id: '177',
    descripcion:
        'debe reaccionar exageradamente cada vez que alguien diga su nombre',
    turnos: 4,
  ),
  crearReto(
    id: '178',
    descripcion:
        'debe fingir que es un fantasma cada vez que se levante de su asiento',
    turnos: 3,
  ),
  crearReto(
    id: '179',
    descripcion:
        'debe narrar sus propias acciones como si fuera protagonista de una película',
    turnos: 4,
  ),
  crearReto(
    id: '180',
    descripcion:
        'debe comportarse como si todo el grupo fuera parte de la realeza',
    turnos: 4,
  ),
  crearReto(
    id: '181',
    descripcion:
        'debe fingir que tiene un micrófono imaginario cada vez que hable',
    turnos: 4,
  ),
  crearReto(
    id: '182',
    descripcion:
        'debe hablar como si estuviera transmitiendo un partido de fútbol',
    turnos: 4,
  ),
  crearReto(
    id: '183',
    descripcion:
        'debe hacer una risa falsa diferente después de cada frase',
    turnos: 3,
  ),
  crearReto(
    id: '184',
    descripcion:
        'debe actuar como si acabara de llegar del futuro',
    turnos: 3,
  ),
  crearReto(
    id: '185',
    descripcion:
        'debe responder como si fuera un asistente virtual confundido',
    turnos: 4,
  ),

  // 👑 PODERES CONTRA NAME
  crearReto(
    id: '186',
    descripcion:
        'puede elegir una palabra que name deberá evitar durante sus próximos turnos',
    turnos: 4,
  ),
  crearReto(
    id: '187',
    descripcion:
        'puede elegir la voz con la que name tendrá que hablar',
    turnos: 4,
  ),
  crearReto(
    id: '188',
    descripcion:
        'puede hacerle una pregunta personal a name, quien podrá responder o cambiarla por otra',
    turnos: 2,
  ),
  crearReto(
    id: '189',
    descripcion:
        'puede elegir un nuevo apodo para name durante el resto del reto',
    turnos: 4,
  ),
  crearReto(
    id: '190',
    descripcion:
        'puede pedirle a name que baile durante 5 segundos antes de su próximo turno',
    turnos: 2,
  ),
  crearReto(
    id: '191',
    descripcion:
        'puede elegir una frase que name deberá decir cada vez que se equivoque',
    turnos: 4,
  ),
  crearReto(
    id: '192',
    descripcion:
        'puede ordenar que name hable de sí mismo en tercera persona',
    turnos: 4,
  ),
  crearReto(
    id: '193',
    descripcion:
        'puede elegir una canción para que name la interprete dramáticamente',
    turnos: 2,
  ),
  crearReto(
    id: '194',
    descripcion:
        'puede hacer que name anuncie cada turno como presentador de televisión',
    turnos: 3,
  ),
  crearReto(
    id: '195',
    descripcion:
        'puede elegir una pose que name deberá hacer antes de responder',
    turnos: 3,
  ),

  // 💘 ÍNTIMOS Y COQUETOS
  crearReto(
    id: '196',
    descripcion:
        'debe confesar quién fue la última persona que le provocó mariposas',
    turnos: 2,
  ),
  crearReto(
    id: '197',
    descripcion:
        'debe decir con quién del grupo tendría una cita sin pensarlo demasiado',
    turnos: 2,
  ),
  crearReto(
    id: '198',
    descripcion:
        'debe confesar cuál es la característica que más le atrae de una persona',
    turnos: 2,
  ),
  crearReto(
    id: '199',
    descripcion:
        'debe contar cuál fue el beso que más recuerda de su pasado',
    turnos: 2,
  ),
  crearReto(
    id: '200',
    descripcion:
        'debe confesar si actualmente siente atracción por alguien',
    turnos: 2,
  ),
  crearReto(
    id: '201',
    descripcion:
        'debe decir cuál fue la situación más coqueta que vivió con un casi algo',
    turnos: 2,
  ),
  crearReto(
    id: '202',
    descripcion:
        'debe contar qué detalle romántico le gustaría recibir',
    turnos: 2,
  ),
  crearReto(
    id: '203',
    descripcion:
        'debe confesar si alguna vez se imaginó una relación con alguien del grupo',
    turnos: 2,
  ),
  crearReto(
    id: '204',
    descripcion:
        'debe elegir a alguien y decir qué le parecería atractivo en una cita',
    turnos: 2,
  ),
  crearReto(
    id: '205',
    descripcion:
        'debe contar la mayor locura que hizo para llamar la atención de alguien',
    turnos: 2,
  ),
  crearReto(
    id: '206',
    descripcion:
        'debe confesar cuál fue su cita más incómoda',
    turnos: 2,
  ),
  crearReto(
    id: '207',
    descripcion:
        'debe decir quién del grupo parece besar mejor y explicar su elección',
    turnos: 2,
  ),
  crearReto(
    id: '208',
    descripcion:
        'debe confesar si alguna vez coqueteó con alguien solo por diversión',
    turnos: 2,
  ),
  crearReto(
    id: '209',
    descripcion:
        'debe contar qué señal utiliza cuando alguien realmente le gusta',
    turnos: 2,
  ),
  crearReto(
    id: '210',
    descripcion:
        'debe describir su tipo ideal usando tres características',
    turnos: 2,
  ),

  // 🤫 PERSONALES Y PROFUNDOS
  crearReto(
    id: '211',
    descripcion:
        'debe confesar cuál es el pensamiento que más intenta ocultar',
    turnos: 2,
  ),
  crearReto(
    id: '212',
    descripcion:
        'debe contar cuál fue la última mentira que dijo para evitar un problema',
    turnos: 2,
  ),
  crearReto(
    id: '213',
    descripcion:
        'debe decir cuál es el recuerdo que más quisiera cambiar',
    turnos: 2,
  ),
  crearReto(
    id: '214',
    descripcion:
        'debe confesar si alguna vez fingió estar bien para no preocupar a nadie',
    turnos: 2,
  ),
  crearReto(
    id: '215',
    descripcion:
        'debe contar cuál fue la amistad que más le dolió perder',
    turnos: 2,
  ),
  crearReto(
    id: '216',
    descripcion:
        'debe confesar cuál es la crítica que más le ha dolido recibir',
    turnos: 2,
  ),
  crearReto(
    id: '217',
    descripcion:
        'debe decir qué parte de su pasado todavía le genera vergüenza',
    turnos: 2,
  ),
  crearReto(
    id: '218',
    descripcion:
        'debe contar cuándo fue la última vez que sintió que no era suficiente',
    turnos: 2,
  ),
  crearReto(
    id: '219',
    descripcion:
        'debe confesar qué oportunidad perdió por miedo',
    turnos: 2,
  ),
  crearReto(
    id: '220',
    descripcion:
        'debe decir cuál es la conversación pendiente que más evita',
    turnos: 2,
  ),
  crearReto(
    id: '221',
    descripcion:
        'debe contar cuál fue el momento que más cambió su forma de pensar',
    turnos: 2,
  ),
  crearReto(
    id: '222',
    descripcion:
        'debe confesar qué persona le cuesta más sacar de su mente',
    turnos: 2,
  ),
  crearReto(
    id: '223',
    descripcion:
        'debe decir qué cosa jamás permitiría nuevamente en una relación',
    turnos: 2,
  ),
  crearReto(
    id: '224',
    descripcion:
        'debe contar cuál fue su mayor acto de orgullo',
    turnos: 2,
  ),
  crearReto(
    id: '225',
    descripcion:
        'debe confesar cuál es la decisión que todavía duda si fue correcta',
    turnos: 2,
  ),

  // 📱 REDES Y CELULAR
  crearReto(
    id: '226',
    descripcion:
        'debe mostrar su fotografía favorita y contar por qué le gusta',
    turnos: 2,
  ),
  crearReto(
    id: '227',
    descripcion:
        'debe revelar cuántas horas de uso registra hoy su celular',
    turnos: 2,
  ),
  crearReto(
    id: '228',
    descripcion:
        'debe enseñar el último video gracioso que guardó',
    turnos: 2,
  ),
  crearReto(
    id: '229',
    descripcion:
        'debe decir qué contacto tiene el apodo más extraño en su celular',
    turnos: 2,
  ),
  crearReto(
    id: '230',
    descripcion:
        'debe mostrar cuál es su canción más reproducida actualmente',
    turnos: 2,
  ),
  crearReto(
    id: '231',
    descripcion:
        'debe contar cuál fue la última publicación que eliminó y por qué',
    turnos: 2,
  ),
  crearReto(
    id: '232',
    descripcion:
        'debe enseñar el último sticker que envió',
    turnos: 2,
  ),
  crearReto(
    id: '233',
    descripcion:
        'debe decir cuál es la red social que revisa primero al despertar',
    turnos: 2,
  ),
  crearReto(
    id: '234',
    descripcion:
        'debe mostrar una foto antigua que le provoque vergüenza divertida',
    turnos: 2,
  ),
  crearReto(
    id: '235',
    descripcion:
        'debe contar cuál fue el mensaje que más se arrepiente de haber enviado',
    turnos: 2,
  ),

  // 🎤 CANTO, RAP Y SONIDOS
  crearReto(
    id: '236',
    descripcion:
        'debe cantar una canción infantil como si fuera una balada romántica',
    turnos: 2,
  ),
  crearReto(
    id: '237',
    descripcion:
        'debe improvisar un rap mencionando a tres personas del grupo',
    turnos: 2,
  ),
  crearReto(
    id: '238',
    descripcion:
        'debe cantar su próxima respuesta con voz de ópera',
    turnos: 2,
  ),
  crearReto(
    id: '239',
    descripcion:
        'debe inventar el himno oficial de UnShotsito',
    turnos: 2,
  ),
  crearReto(
    id: '240',
    descripcion:
        'debe hacer sonidos de suspenso mientras name completa su próximo reto',
    turnos: 2,
  ),
  crearReto(
    id: '241',
    descripcion:
        'debe interpretar una canción alegre como si estuviera completamente triste',
    turnos: 2,
  ),
  crearReto(
    id: '242',
    descripcion:
        'debe imitar a un cantante famoso hasta que alguien descubra quién es',
    turnos: 2,
  ),
  crearReto(
    id: '243',
    descripcion:
        'debe crear una canción corta sobre la persona que tiene a su derecha',
    turnos: 2,
  ),
  crearReto(
    id: '244',
    descripcion:
        'debe responder cantando cada vez que name le haga una pregunta',
    turnos: 3,
  ),
  crearReto(
    id: '245',
    descripcion:
        'debe hacer la introducción de un concierto antes de comenzar su turno',
    turnos: 2,
  ),

  // 🎲 REGLAS GENERALES
  crearReto(
    id: '246',
    descripcion:
        'todos deben responder con una sola palabra durante los próximos turnos',
    turnos: 3,
  ),
  crearReto(
    id: '247',
    descripcion:
        'todos deben hacer una pose dramática cada vez que alguien complete un reto',
    turnos: 3,
  ),
  crearReto(
    id: '248',
    descripcion:
        'nadie puede señalar con el dedo durante los próximos turnos',
    turnos: 3,
  ),
  crearReto(
    id: '249',
    descripcion:
        'todos deben decir "con permiso" antes de realizar cualquier reto',
    turnos: 3,
  ),
  crearReto(
    id: '250',
    descripcion:
        'cada persona debe inventar un saludo especial para usar durante la partida',
    turnos: 3,
  ),
];