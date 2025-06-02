import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importa localizaciones
import 'PantallaAjustes.dart';
import 'PantallaRegistros.dart';
import 'PantallaVotar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Text(
              loc.menu, // 'Menú'
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.how_to_vote),
            title: Text(loc.vote), // 'Votar'
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaVotar()),
);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: Text(loc.registers), // 'Registros'
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaRegistros()),
);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(loc.settings), // 'Ajustes'
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaAjustes()),
);
            },
          ),

        ],
      ),
    );
  }
}
