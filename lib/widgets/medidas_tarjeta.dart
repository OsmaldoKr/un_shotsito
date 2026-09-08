/// Medidas compartidas entre `TarjetaReto` y `ModalCastigo` para que
/// ambas tarjetas ocupen exactamente el mismo tamaño en pantalla.
///
/// Antes cada widget tenía su propia fórmula (anchos y breakpoints
/// distintos), así que un reto y un castigo no medían lo mismo. Ahora
/// los dos deben construir sus medidas a través de esta clase.
class MedidasTarjeta {
  const MedidasTarjeta({
    required this.ancho,
    required this.alto,
    required this.padding,
    required this.pantallaBaja,
    required this.pantallaEstrecha,
  });

  /// [maxWidth] y [maxHeight]: el espacio disponible (LayoutBuilder o
  /// MediaQuery, ambos widgets deben usar la misma fuente si quieren
  /// medir igual en el mismo dispositivo).
  factory MedidasTarjeta.desde({
    required double maxWidth,
    required double maxHeight,
  }) {
    final bool pantallaEstrecha = maxWidth < 360;
    final bool pantallaBaja = maxHeight < 480;

    final double ancho = maxWidth < _anchoMaximo ? maxWidth : _anchoMaximo;

    final double altoPreferido = pantallaBaja
        ? maxHeight
        : maxHeight.clamp(390.0, 560.0).toDouble();

    final double alturaMinima = maxHeight < 300.0 ? maxHeight : 300.0;

    final double alto =
        altoPreferido.clamp(alturaMinima, maxHeight).toDouble();

    final double padding;
    if (pantallaEstrecha) {
      padding = 20.0;
    } else if (pantallaBaja) {
      padding = 22.0;
    } else {
      padding = 28.0;
    }

    return MedidasTarjeta(
      ancho: ancho,
      alto: alto,
      padding: padding,
      pantallaBaja: pantallaBaja,
      pantallaEstrecha: pantallaEstrecha,
    );
  }

  static const double _anchoMaximo = 520.0;

  final double ancho;
  final double alto;
  final double padding;
  final bool pantallaBaja;
  final bool pantallaEstrecha;

  /// Tamaño de fuente sugerido según cuánto texto haya que mostrar,
  /// ajustado por los mismos breakpoints de pantalla.
  double tamanoTexto(int longitudTexto) {
    double base;

    if (longitudTexto > 180) {
      base = 18.0;
    } else if (longitudTexto > 120) {
      base = 20.0;
    } else if (longitudTexto > 75) {
      base = 22.0;
    } else {
      base = 25.0;
    }

    if (pantallaEstrecha) base -= 2.0;
    if (pantallaBaja) base -= 1.0;

    return base.clamp(17.0, 26.0).toDouble();
  }
}
