import 'package:flutter/material.dart';
import 'package:parecido_examen/app_drawer.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class PantallaAjustes extends StatefulWidget {
  const PantallaAjustes({super.key});

  @override
  State<PantallaAjustes> createState() => _PantallaAjustesState();
}

class _PantallaAjustesState extends State<PantallaAjustes> {
  String _lenguajeSeleccionado = 'Español';

  final List<String> _languages = ['Español', 'Inglés'];

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = themeNotifier.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text('Tema'),
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    themeNotifier.toggleTheme(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text('Idioma'),
                trailing: DropdownButton<String>(
                  value: _lenguajeSeleccionado,
                  items: _languages
                      .map((lang) => DropdownMenuItem<String>(
                            value: lang,
                            child: Text(lang),
                          ))
                      .toList(),
                  onChanged: (newLang) {
                    setState(() {
                      _lenguajeSeleccionado = newLang!;
                    });
                    
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
