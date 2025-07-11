import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/create_account_page.dart';
import 'package:flutter_application_1/screens/home_page.dart';
import '../helpers/database_helper.dart'; // Importamos el helper

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para el login
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _cedulaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final cedula = _cedulaController.text;
    final password = _passwordController.text;

    if (cedula.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa cédula y contraseña')),
      );
      return;
    }

    // Buscar el usuario en la base de datos
    final user = await DatabaseHelper.instance.getUser(cedula, password);

    if (user != null) {
      // Si el usuario existe, navega a la página de inicio
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Si no, muestra un error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cédula o contraseña incorrectas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _cedulaController, // Usar controlador
              decoration: const InputDecoration(
                labelText: 'Cédula', // Cambiado de 'Usuario' a 'Cédula'
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController, // Usar controlador
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _login, // Llamar a nuestra función de login
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateAccountPage(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Crear Cuenta', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
