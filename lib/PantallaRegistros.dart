import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importa localizaciones
import 'package:parecido_examen/app_drawer.dart';
import 'database_helper.dart';

class PantallaRegistros extends StatefulWidget {
  const PantallaRegistros({super.key});

  @override
  State<PantallaRegistros> createState() => _PantallaRegistrosState();
}

class _PantallaRegistrosState extends State<PantallaRegistros> {
  List<Map<String, dynamic>> _resultados = [];

  @override
  void initState() {
    super.initState();
    _cargarResultados();
  }

  Future<void> _cargarResultados() async {
    final resultados = await DatabaseHelper().obtenerResultados();
    setState(() {
      _resultados = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;  // Instancia traducciones

    return Scaffold(
      appBar: AppBar(title: Text(loc.voteResults)), // "Resultados de la votación" / "Voting Results"
      drawer: const AppDrawer(),
      body: _resultados.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _resultados.length,
              itemBuilder: (context, index) {
                final item = _resultados[index];
                return ListTile(
                  leading: const Icon(Icons.how_to_vote),
                  title: Text(item['nombre']),
                  trailing: Text('${item['votos']} ${loc.vote.toLowerCase()}s'), 
                  // Agrega la palabra 'votos' traducida (aquí uso 'vote' y hago lowercase; puedes agregar un key específica si quieres)
                );
              },
            ),
    );
  }
}
