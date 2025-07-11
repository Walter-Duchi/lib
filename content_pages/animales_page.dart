import 'package:flutter/material.dart';

class AnimalesPage extends StatelessWidget {
  const AnimalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animales'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Contenido de Animales', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
