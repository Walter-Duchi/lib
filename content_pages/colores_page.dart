import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ColoresPage extends StatefulWidget {
  const ColoresPage({super.key});

  @override
  State<ColoresPage> createState() => _ColoresPageState();
}

class _ColoresPageState extends State<ColoresPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Map<String, dynamic>> _colors = [
    {
      'name': 'Rojo',
      'color': Colors.red,
      'textColor': Colors.white,
      'sound': 'rojo.wav',
      'image': 'assets/images/rojo.jpg',
    },
    {
      'name': 'Azul',
      'color': Colors.blue,
      'textColor': Colors.white,
      'sound': 'azul.wav',
      'image': 'assets/images/azul.jpg',
    },
    {
      'name': 'Amarillo',
      'color': Colors.yellow,
      'textColor': Colors.black,
      'sound': 'amarillo.wav',
      'image': 'assets/images/amarillo.jpg',
    },
    {
      'name': 'Verde',
      'color': Colors.green,
      'textColor': Colors.black,
      'sound': 'verde.wav',
      'image': 'assets/images/hierba.jpg',
    },
    {
      'name': 'Naranja',
      'color': Colors.orange,
      'textColor': Colors.black,
      'sound': 'naranja.wav',
      'image': 'assets/images/naranja.jpg',
    },
    {
      'name': 'Morado',
      'color': Colors.purple,
      'textColor': Colors.white,
      'sound': 'morado.wav',
      'image': 'assets/images/morado.jpg',
    },
    {
      'name': 'Rosa',
      'color': Colors.pink,
      'textColor': Colors.black,
      'sound': 'rosa.wav',
      'image': 'assets/images/rosa.jpg',
    },
    {
      'name': 'Marrón',
      'color': Colors.brown,
      'textColor': Colors.white,
      'sound': 'marron.wav',
      'image': 'assets/images/marron.jpg',
    },
    {
      'name': 'Negro',
      'color': Colors.black,
      'textColor': Colors.white,
      'sound': 'negro.wav',
      'image': 'assets/images/negro.jpg',
    },
    {
      'name': 'Blanco',
      'color': Colors.white,
      'textColor': Colors.black,
      'sound': 'blanco.wav',
      'image': 'assets/images/blanco.jpg',
    },
    {
      'name': 'Gris',
      'color': Colors.grey,
      'textColor': Colors.white,
      'sound': 'gris.wav',
      'image': 'assets/images/gris.jpg',
    },
    {
      'name': 'Celeste',
      'color': Colors.lightBlue,
      'textColor': Colors.black,
      'sound': 'celeste.wav',
      'image': 'assets/images/celeste.jpg',
    },
  ];

  int _currentColorIndex = 0;
  bool _isPlayingAll = false;
  bool _showImageOverlay = false;
  String _currentImagePath = '';

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String soundFile) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('sounds/$soundFile'));
  }

  Future<void> _playAllColors() async {
    if (!_isPlayingAll) {
      return;
    }

    if (_currentColorIndex >= _colors.length) {
      setState(() {
        _isPlayingAll = false;
        _showImageOverlay = false;
        _currentColorIndex = 0;
      });
      return;
    }

    final color = _colors[_currentColorIndex];

    setState(() {
      _showImageOverlay = true;
      _currentImagePath = color['image'];
    });

    await _audioPlayer.stop();

    try {
      await _audioPlayer.play(AssetSource('sounds/${color['sound']}'));
      await _audioPlayer.onPlayerComplete.first;
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _currentColorIndex++;
      });

      if (_isPlayingAll) {
        _playAllColors();
      }
    } catch (e) {
      print('Error al reproducir: $e');
      setState(() {
        _isPlayingAll = false;
        _currentColorIndex = 0;
      });
    }
  }

  void _stopPlayingAll() {
    setState(() {
      _isPlayingAll = false;
      _showImageOverlay = false;
      _currentColorIndex = 0;
    });
    _audioPlayer.stop();
  }

  void _animateCard(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final animation = AnimationController(
        vsync: Scaffold.of(context),
        duration: const Duration(milliseconds: 100),
      );
      final scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 1.1,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

      animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animation.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animation.dispose();
        }
      });

      animation.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colores'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Colores Básicos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isPlayingAll
                      ? null
                      : () {
                          setState(() {
                            _isPlayingAll = true;
                            _currentColorIndex = 0;
                          });
                          _playAllColors();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Reproducir Todos'),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final cardKey = GlobalKey();

                    return Card(
                      key: cardKey,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_isPlayingAll) {
                            _stopPlayingAll();
                          }
                          _animateCard(cardKey);
                          setState(() {
                            _showImageOverlay = true;
                            _currentImagePath = color['image'];
                          });
                          _playSound(color['sound']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color['color'],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              color['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: color['textColor'],
                                shadows: [
                                  Shadow(
                                    color: color['textColor'] == Colors.white
                                        ? Colors.black
                                        : Colors.white,
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          if (_showImageOverlay)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showImageOverlay = false;
                });
                _audioPlayer.stop();
              },
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Image.asset(
                    _currentImagePath,
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
