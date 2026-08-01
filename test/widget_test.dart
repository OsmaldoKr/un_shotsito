import 'package:flutter_test/flutter_test.dart';

import 'package:un_shotsito/main.dart';

void main() {
  testWidgets(
    'La aplicación inicia correctamente',
    (WidgetTester tester) async {
      // Construye la aplicación.
      await tester.pumpWidget(
        const UnShotsitoApp(),
      );

      // Verifica que la aplicación se haya cargado.
      expect(
        find.byType(UnShotsitoApp),
        findsOneWidget,
      );
    },
  );
}
