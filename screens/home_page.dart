// home_page.dart

import 'package:flutter/material.dart';
// Asegúrate de que las rutas a tus páginas de contenido sean correctas
import 'package:flutter_application_1/content_pages/animales_page.dart';
import 'package:flutter_application_1/content_pages/colores_page.dart';
import 'package:flutter_application_1/content_pages/numeros_page.dart';
import 'package:flutter_application_1/content_pages/rutinas_page.dart';
import 'package:flutter_application_1/content_pages/vocales_page.dart';

// --- PASO 1: IMPORTAR LA PÁGINA DE LOGIN ---
// Asegúrate de que la ruta sea la correcta en tu proyecto
import 'package:flutter_application_1/screens/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    NumerosPage(),
    RutinasPage(),
    ColoresPage(),
    AnimalesPage(),
    VocalesPage(),
  ];

  static const List<String> _titles = <String>[
    'Números',
    'Rutinas',
    'Colores',
    'Animales',
    'Vocales',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- PASO 2: ACTUALIZAR LA LÓGICA DE CIERRE DE SESIÓN ---
  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false, // Este predicado elimina todas las rutas
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout(); // Llamamos a nuestra función actualizada
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Cerrar sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered),
            label: 'Números',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Rutinas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: 'Colores',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Animales'),
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'Vocales'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
