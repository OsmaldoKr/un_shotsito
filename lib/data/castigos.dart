const String castigoGeneral = 'General';
const String castigoConfesiones = 'Confesiones';
const String castigoShotsLigeros = 'Shots ligeros';
const String castigoPicantes = 'Picantes';
const String castigoNocturnos = 'Nocturnos';
const String castigoPareja = 'Shot en pareja';
const String castigoCalientes = 'Shots calientes';
const String castigoBar = 'Shot de bar';

const Map<String, List<String>> castigosPorCategoria = {
  castigoGeneral: [
    'Toma 1 shot.',
    'Reparte 2 tragos entre dos personas.',
    'Elige a alguien para brindar contigo.',
    'Haz 15 sentadillas.',
    'Habla con un acento diferente durante una ronda.',
    'Haz una pasarela improvisada durante veinte segundos.',
    'Imita a una persona del grupo hasta que alguien adivine quién es.',
    'No puedes utilizar tu teléfono hasta tu próximo turno.',
    'Cuenta un chiste; si nadie se ríe, realiza otro castigo.',
    'El grupo elige un apodo para ti durante dos rondas.',
    'Juega piedra, papel o tijera con alguien; quien pierda cumple otro castigo.',
    'Realiza el siguiente reto utilizando solamente una mano.',
  ],
  castigoConfesiones: [
    'Responde una pregunta adicional elegida por el grupo.',
    'Revela la inicial de tu último interés romántico.',
    'Cuenta una verdad que nunca hayas dicho durante una fiesta.',
    'Permite que el grupo elija entre dos preguntas incómodas para ti.',
    'Describe tu peor cita utilizando solamente cinco palabras.',
    'Lee el último mensaje romántico que puedas compartir.',
    'Muestra la última persona que buscaste en redes sociales.',
    'Cuenta una mentira y una verdad; el grupo debe distinguirlas.',
    'Confiesa qué participante te causó la mejor primera impresión.',
    'Responde la siguiente pregunta sin utilizar sí, no o nunca.',
    'Deja que una persona formule una pregunta que solamente puedas responder con un nombre.',
    'Toma 1 shot y responde una pregunta breve elegida al azar.',
  ],
  castigoShotsLigeros: [
    'Haz tu mejor imitación de alguien enamorado.',
    'Mantén una moneda sobre tu frente durante quince segundos.',
    'Di cinco palabras que rimen en menos de diez segundos.',
    'Baila sin música durante veinte segundos.',
    'Habla utilizando solamente preguntas hasta tu próximo turno.',
    'Haz equilibrio sobre un pie mientras dices el abecedario.',
    'Representa una película mediante gestos.',
    'Permite que el grupo elija tu pose para una fotografía.',
    'Canta el coro de una canción elegida por los demás.',
    'Cuenta hasta veinte alternando números con otra persona.',
    'Haz una declaración dramática de amor a un objeto.',
    'Toma 1 shot mientras realizas un brindis creativo.',
  ],
  castigoPicantes: [
    'Responde una pregunta sexual elegida por el grupo.',
    'Dile a alguien qué característica suya te resulta más provocativa.',
    'Describe una fantasía utilizando solamente tres palabras.',
    'Haz tu mejor mirada seductora a una persona de tu elección.',
    'Revela cuál es tu mayor debilidad durante la intimidad.',
    'Elige entre besar, tener una cita o vivir una aventura con tres participantes.',
    'Lee una frase atrevida con contacto visual hacia alguien.',
    'Menciona una práctica íntima que te produzca curiosidad.',
    'Confiesa qué tipo de beso consigue hacerte perder el control.',
    'Permite que alguien te haga una pregunta sexual que responderás con sí o no.',
    'Representa cómo invitarías a alguien a compartir una habitación.',
    'Toma 1 shot y completa: cuando estoy excitado no puedo evitar...',
  ],
  castigoNocturnos: [
    'Envía un emoji de luna a una persona de confianza.',
    'Cuenta una decisión cuestionable tomada después de medianoche.',
    'Muestra la última canción que escuchaste durante la madrugada.',
    'Revela quién sería tu primera llamada si no quisieras dormir solo.',
    'Describe la invitación nocturna que te resultaría más difícil rechazar.',
    'Cuenta una historia que comience con eran más de las tres de la mañana.',
    'Muestra el último mensaje nocturno que puedas compartir.',
    'Elige a quien acompañarías a observar el amanecer.',
    'Completa: después de medianoche dejo de preocuparme por...',
    'Representa cómo pedirías que alguien se quede hasta la mañana.',
    'Confiesa qué persona podría sacarte de casa con una llamada nocturna.',
    'Toma 1 shot y dedica un brindis a una madrugada inolvidable.',
  ],
  castigoPareja: [
    'Cada uno debe mencionar una cualidad que admira del otro.',
    'Respondan simultáneamente quién se pone celoso con mayor facilidad.',
    'Dense un beso de diez segundos, únicamente si ambos aceptan.',
    'Cada uno debe revelar una experiencia que desea vivir junto al otro.',
    'Representen cómo fue su primera cita o cómo imaginan que habría sido.',
    'Escriban qué parte de su relación consideran más fuerte y comparen.',
    'Cada uno debe confesar qué comportamiento del otro le provoca celos.',
    'Mantengan contacto visual mientras dicen qué desean mejorar juntos.',
    'Describan por separado su noche perfecta y comparen las respuestas.',
    'Cada uno debe formular una pregunta íntima que nunca había realizado.',
    'Elijan una canción que describa su relación y expliquen la elección.',
    'Brinden juntos y cada uno responda qué teme perder de la relación.',
  ],
  castigoCalientes: [
    'Haz un baile sensual frente a una persona que acepte participar.',
    'Susúrrale a alguien qué fue lo primero que te atrajo de esa persona.',
    'Mantén tu rostro cerca del de alguien durante veinte segundos, si ambos aceptan.',
    'Dile a una persona dónde te gustaría recibir un beso.',
    'Permite que alguien te abrace por la cintura durante una ronda, si ambos aceptan.',
    'Describe cómo intentarías seducir a alguien sin tocarlo.',
    'Elige a quien confiarías explorar una fantasía nueva contigo.',
    'Representa cómo pedirías permiso antes de quitar una prenda.',
    'Deja que alguien te diga al oído qué considera atractivo de ti.',
    'Pregunta a una persona si tendría curiosidad por descubrir tu lado íntimo.',
    'Completa mirando a alguien: si estuviéramos completamente solos...',
    'Toma 1 shot y realiza una pose provocativa elegida por el grupo.',
  ],
  castigoBar: [
    'Inventa un cóctel inspirado en tu personalidad.',
    'Haz un brindis dedicado a las malas decisiones que repetirías.',
    'Representa cómo intentarías conquistar a alguien desde la barra.',
    'Describe tu situación sentimental utilizando nombres de bebidas.',
    'Imita a alguien intentando aparentar que todavía está sobrio.',
    'Crea un nombre y un eslogan para un bar de personas solteras.',
    'Menciona cinco bebidas diferentes en menos de diez segundos.',
    'Cuenta la anécdota más extraña que te ocurrió durante una salida.',
    'Elige una canción que debería comenzar a sonar en este momento.',
    'Representa cómo pedirías la última ronda de la noche.',
    'Asigna una bebida a cada uno de dos participantes según su personalidad.',
    'Toma 1 shot y presenta un brindis como si cerraras el bar.',
  ],
};

/// Mantiene compatibilidad con el código anterior:
/// `getCastigos()` devuelve todos los castigos mezclados en una sola lista.
///
/// Para obtener solamente una categoría:
/// `getCastigos(categoria: 'Picantes')`.
List<String> getCastigos({String? categoria}) {
  if (categoria == null || categoria.trim().isEmpty) {
    return castigosPorCategoria.values
        .expand((castigos) => castigos)
        .toList(growable: false);
  }

  final categoriaResuelta = resolverCategoriaCastigo(categoria);
  return List<String>.unmodifiable(
    castigosPorCategoria[categoriaResuelta] ??
        castigosPorCategoria[castigoGeneral]!,
  );
}

List<String> getCategoriasCastigos() {
  return List<String>.unmodifiable(castigosPorCategoria.keys);
}

bool existeCategoriaCastigo(String categoria) {
  final normalizada = _normalizarCategoria(categoria);
  return castigosPorCategoria.keys
      .any((nombre) => _normalizarCategoria(nombre) == normalizada);
}

String resolverCategoriaCastigo(String categoria) {
  final normalizada = _normalizarCategoria(categoria);

  const alias = {
    'general': castigoGeneral,
    'confesion': castigoConfesiones,
    'confesiones': castigoConfesiones,
    'shot ligero': castigoShotsLigeros,
    'shots ligeros': castigoShotsLigeros,
    'ligeros': castigoShotsLigeros,
    'picante': castigoPicantes,
    'picantes': castigoPicantes,
    'nocturno': castigoNocturnos,
    'nocturnos': castigoNocturnos,
    'pareja': castigoPareja,
    'shot en pareja': castigoPareja,
    'shots en pareja': castigoPareja,
    'caliente': castigoCalientes,
    'calientes': castigoCalientes,
    'shot caliente': castigoCalientes,
    'shots calientes': castigoCalientes,
    'bar': castigoBar,
    'shot de bar': castigoBar,
    'shots de bar': castigoBar,
  };

  return alias[normalizada] ?? castigoGeneral;
}

String _normalizarCategoria(String texto) {
  return texto
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), ' ');
}
