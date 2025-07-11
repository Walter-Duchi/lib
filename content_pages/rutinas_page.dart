import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RutinasPage extends StatefulWidget {
  const RutinasPage({super.key});

  @override
  State<RutinasPage> createState() => _RutinasPageState();
}

class _RutinasPageState extends State<RutinasPage> {
  List _rutinas = [];

  @override
  void initState() {
    super.initState();
    _cargarRutinas();
  }

  Future<void> _cargarRutinas() async {
    final String response = await rootBundle.loadString(
      'assets/data/rutinas.json',
    );
    final data = await json.decode(response);
    setState(() {
      _rutinas = data;
    });
  }

  IconData _getIconForMomento(String momento) {
    if (momento.toLowerCase().contains('mañana')) {
      return Icons.wb_sunny_outlined;
    } else if (momento.toLowerCase().contains('noche')) {
      return Icons.nightlight_round;
    }
    return Icons.schedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Rutinas'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[200],
      ),
      body: _rutinas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _rutinas.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _rutinas[index]['nombre'],
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          _rutinas[index]['descripcion'],
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 16.0),
                        const Divider(),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(
                              _getIconForMomento(
                                _rutinas[index]['momento_del_dia'],
                              ),
                              color: Colors.orangeAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Momento: ${_rutinas[index]['momento_del_dia']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
