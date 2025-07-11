import 'package:flutter/material.dart';

class VocalesPage extends StatelessWidget {
  const VocalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocales'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Contenido de Vocales', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
