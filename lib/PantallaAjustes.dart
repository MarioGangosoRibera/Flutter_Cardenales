import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parecido_examen/app_drawer.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

// Creamos un ChangeNotifier para manejar el idioma (locale)
class LocaleNotifier extends ChangeNotifier {
  Locale _currentLocale = const Locale('es');

  Locale get currentLocale => _currentLocale;

  void changeLocale(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
}

class PantallaAjustes extends StatefulWidget {
  const PantallaAjustes({super.key});

  @override
  State<PantallaAjustes> createState() => _PantallaAjustesState();
}

class _PantallaAjustesState extends State<PantallaAjustes> {
  final Map<String, String> idiomas = {
    'es': 'Español',
    'en': 'English',
  };

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final isDark = themeNotifier.isDarkMode;
    final loc = AppLocalizations.of(context)!;

    String currentLanguage = idiomas[localeNotifier.currentLocale.languageCode] ?? 'Español';

    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(loc.theme),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(loc.language),
                trailing: DropdownButton<String>(
                  value: currentLanguage,
                  items: idiomas.entries
                      .map((entry) => DropdownMenuItem<String>(
                            value: entry.value,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  onChanged: (newLang) {
                    if (newLang != null) {
                      String langCode = idiomas.entries
                          .firstWhere((entry) => entry.value == newLang)
                          .key;
                      localeNotifier.changeLocale(langCode);
                    }
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
