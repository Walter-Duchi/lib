import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/screens/home_page.dart';
import '../helpers/database_helper.dart'; // Importamos el helper
import '../models/usuario_model.dart'; // Importamos el modelo

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // Controladores para cada campo
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _dateController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedSex;

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _dateController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Función para guardar el usuario
  void _createAccount() async {
    // Validaciones básicas (puedes mejorarlas)
    if (_nombreController.text.isEmpty ||
        _cedulaController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedSex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Crear el objeto Usuario
    final newUser = Usuario(
      nombreCompleto: _nombreController.text,
      cedula: _cedulaController.text,
      fechaNacimiento: _dateController.text,
      sexo: _selectedSex!,
      password: _passwordController.text, // Guardamos la contraseña
    );

    // Insertar en la base de datos
    try {
      await DatabaseHelper.instance.insertUser(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Cuenta creada con éxito!')),
      );

      // Navegar a la página de inicio
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Manejar error de cédula duplicada
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al crear la cuenta: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nombreController, // Usar controlador
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _cedulaController, // Usar controlador
              decoration: const InputDecoration(
                labelText: 'Cédula',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Fecha de Nacimiento',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController, // Campo de contraseña
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sexo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Masculino'),
                    value: 'masculino',
                    groupValue: _selectedSex,
                    onChanged: (value) {
                      setState(() {
                        _selectedSex = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Femenino'),
                    value: 'femenino',
                    groupValue: _selectedSex,
                    onChanged: (value) {
                      setState(() {
                        _selectedSex = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _createAccount, // Llamar a nuestra nueva función
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Crear e Iniciar Sesión',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
