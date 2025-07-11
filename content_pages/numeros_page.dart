import 'package:flutter/material.dart';
import 'dart:math';

class NumerosPage extends StatefulWidget {
  const NumerosPage({super.key});

  @override
  State<NumerosPage> createState() => _NumerosPageState();
}

class _NumerosPageState extends State<NumerosPage> {
  List<int> _numbers = [];
  int _winStreak = 0;
  int _attempts = 0;

  // NUEVO: Guarda el índice del primer número seleccionado para el intercambio.
  // Es 'nullable' (puede ser nulo) porque al principio no hay nada seleccionado.
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      final allNumbers = List<int>.generate(10, (i) => i + 1);
      allNumbers.shuffle();
      _numbers = allNumbers.sublist(0, 5);
      _attempts = 0;
      _selectedIndex = null; // Resetea la selección en cada nuevo juego
    });
  }

  // NUEVA LÓGICA: Se activa cuando el niño toca un número.
  void _onNumberTapped(int tappedIndex) {
    setState(() {
      if (_selectedIndex == null) {
        // PRIMER TOQUE: No hay nada seleccionado, así que seleccionamos este número.
        _selectedIndex = tappedIndex;
      } else {
        // SEGUNDO TOQUE: Ya había un número seleccionado.
        if (_selectedIndex != tappedIndex) {
          // Intercambiamos los números de posición
          final int temp = _numbers[_selectedIndex!];
          _numbers[_selectedIndex!] = _numbers[tappedIndex];
          _numbers[tappedIndex] = temp;
        }
        // Después del intercambio (o si se toca el mismo número), reiniciamos la selección.
        _selectedIndex = null;
      }
    });
  }

  void _checkOrder() {
    final List<int> sortedNumbers = List<int>.from(_numbers)..sort();

    bool isCorrect = true;
    for (int i = 0; i < _numbers.length; i++) {
      if (_numbers[i] != sortedNumbers[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      setState(() {
        _winStreak++;
      });
      _showResultDialog(
        title: '¡Felicidades!',
        content: '¡Has ordenado los números correctamente!',
        onOkPressed: () {
          Navigator.of(context).pop();
          _resetGame();
        },
      );
    } else {
      setState(() {
        _attempts++;
      });
      if (_attempts >= 2) {
        _showResultDialog(
          title: '¡Oh no!',
          content:
              'El orden correcto era: ${sortedNumbers.join(', ')}.\n¡La próxima vez lo lograrás!',
          onOkPressed: () {
            setState(() {
              _winStreak = 0;
            });
            Navigator.of(context).pop();
            _resetGame();
          },
        );
      } else {
        _showResultDialog(
          title: '¡Casi!',
          content: 'No es el orden correcto. ¡Inténtalo de nuevo!',
          onOkPressed: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  void _showResultDialog({
    required String title,
    required String content,
    required VoidCallback onOkPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(onPressed: onOkPressed, child: const Text('OK')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordena los Números'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Racha de victorias: $_winStreak',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Instrucción actualizada
            Text(
              _selectedIndex == null
                  ? 'Toca un número para seleccionarlo...'
                  : 'Ahora toca otro para intercambiarlo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),

            // WIDGET MODIFICADO: De ReorderableListView a ListView.builder
            Expanded(
              child: ListView.builder(
                itemCount: _numbers.length,
                itemBuilder: (context, index) {
                  final number = _numbers[index];
                  // Determina si esta tarjeta es la que está seleccionada
                  final bool isSelected = index == _selectedIndex;

                  return GestureDetector(
                    // Llama a nuestra nueva función de lógica al tocar
                    onTap: () => _onNumberTapped(index),
                    child: Card(
                      // Cambia el color si está seleccionada para dar feedback visual
                      color: isSelected
                          ? Colors.lightBlue.shade100
                          : Colors.white,
                      elevation: isSelected ? 8 : 2,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      // Añade un borde resaltado si está seleccionado
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.transparent,
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          '$number',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.blue.shade900
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _checkOrder,
                child: const Text('Comprobar', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
