import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Importa localizaciones
import 'package:parecido_examen/app_drawer.dart';
import 'database_helper.dart';

class PantallaVotar extends StatefulWidget {
  const PantallaVotar({super.key});

  @override
  State<PantallaVotar> createState() => _PantallaVotarState();
}

class _PantallaVotarState extends State<PantallaVotar> {
  List<Map<String, dynamic>> _cardenales = [];
  int? _idSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarCardenales();
  }

  Future<void> _cargarCardenales() async {
    final cardenales = await DatabaseHelper().getCardenales();
    setState(() {
      _cardenales = cardenales;
      if (_cardenales.isNotEmpty) {
        _idSeleccionado = _cardenales.first['id'];
      }
    });
  }

  Future<void> _votar() async {
    if (_idSeleccionado != null) {
      await DatabaseHelper().insertarVoto(_idSeleccionado!);
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.voteRegistered)),  // ¡Voto registrado!
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.voteCardinal)), // "Votar Cardenal"
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _cardenales.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(loc.selectCardinal), // "Selecciona un Cardenal"
                      trailing: DropdownButton<int>(
                        value: _idSeleccionado,
                        items: _cardenales
                            .map((cardenal) => DropdownMenuItem<int>(
                                  value: cardenal['id'],
                                  child: Text(cardenal['nombre']),
                                ))
                            .toList(),
                        onChanged: (valor) {
                          setState(() {
                            _idSeleccionado = valor;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _votar,
                    child: Text(loc.voteButton),  // "Votar"
                  ),
                ],
              ),
      ),
    );
  }
}
