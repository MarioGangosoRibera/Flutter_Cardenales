import 'package:flutter/material.dart';
import 'package:parecido_examen/PantallaAjustes.dart';
import 'package:parecido_examen/PantallaVotar.dart';
import 'package:parecido_examen/theme_notifier.dart';
import 'package:provider/provider.dart';

import 'theme_notifier.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => ThemeNotifier(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elecciones',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.currentTheme,
      home: PantallaVotar(),
    );
  }
}
