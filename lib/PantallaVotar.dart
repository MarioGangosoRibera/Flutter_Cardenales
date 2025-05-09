import 'package:flutter/material.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Voto registrado!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Votar Cardenal')),
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
                      title: const Text('Selecciona un Cardenal'),
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
                    child: const Text('Votar'),
                  ),
                ],
              ),
      ),
    );
  }
}
