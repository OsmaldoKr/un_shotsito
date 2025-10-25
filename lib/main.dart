import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/bienvenida.dart';

void main() => runApp(const UnShotsitoApp());

class UnShotsitoApp extends StatelessWidget {
  const UnShotsitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnShotsito',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorPrimario,
          brightness: Brightness.dark,
        ),
      ),
      home: const PantallaBienvenida(),
    );
  }
}
