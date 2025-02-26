import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: FadingTextAnimation(toggleTheme: toggleTheme),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final VoidCallback toggleTheme;
  const FadingTextAnimation({super.key, required this.toggleTheme});

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.blue;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void changeColor(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  void openColorPicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Pick a Text Color"),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _textColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Done"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fading Animation"),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.nightlight_round
                  : Icons.wb_sunny,
            ),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: openColorPicker,
          ),
        ],
      ),
      body: PageView(
        children: [_buildMainScreen(), _buildSecondAnimationScreen()],
      ),
    );
  }

  Widget _buildMainScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: Text(
              "Hello, Flutter!",
              style: TextStyle(fontSize: 24, color: _textColor),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text("Toggle Fade"),
            onPressed: toggleVisibility,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondAnimationScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 3),
            curve: Curves.easeInOut,
            child: const Text(
              "Second Screen Fade!",
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedRotation(
            turns: _isVisible ? 1 : 0,
            duration: const Duration(seconds: 2),
            child: const Icon(Icons.refresh, size: 50, color: Colors.green),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text("Toggle Fade"),
            onPressed: toggleVisibility,
          ),
        ],
      ),
    );
  }
}
