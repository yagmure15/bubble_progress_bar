import 'package:bubble_progress_bar/bubble_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble Progress Bar Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const MyHomePage(title: 'Bubble Progress Bar Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _progress += 0.01;
        if (_progress > 1.0) _progress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Custom Gradient (Blue to Purple)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            BubbleProgressBar(
              value: _progress,
              height: 30,
              gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
            ),
            const SizedBox(height: 30),
            const Text('Small Bubbles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            BubbleProgressBar(
              value: _progress,
              height: 20,
              bubbleDensity: 0.6,
              minBubbleDiameter: 2,
              maxBubbleDiameter: 5,
              gradient: const LinearGradient(colors: [Colors.green, Colors.teal]),
            ),
            const SizedBox(height: 30),
            const Text('Custom Particle (Star Icon)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            BubbleProgressBar(
              value: _progress,
              height: 30,
              bubbleDensity: 0.5,
              minBubbleDiameter: 5,
              maxBubbleDiameter: 15,
              backgroundColor: Colors.amber[100],
              gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
              bubbleWidget: const Icon(Icons.star, color: Colors.white),
            ),
            const SizedBox(height: 30),
            const Text(
              'Complex Particle (Image - Balloons)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            BubbleProgressBar(
              value: _progress,
              height: 40,
              bubbleDensity: 0.4,
              minBubbleDiameter: 10,
              maxBubbleDiameter: 25,
              gradient: const LinearGradient(colors: [Colors.lightBlue, Colors.blueAccent]),
              bubbleWidget: Image.asset('assets/image/balloons.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 30),
            const Text(
              'Vector Particle (SVG - Snowflake)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            BubbleProgressBar(
              value: _progress,
              height: 30,
              bubbleDensity: 0.6,
              minBubbleDiameter: 8,
              maxBubbleDiameter: 18,
              backgroundColor: Colors.blueGrey[100],
              gradient: const LinearGradient(colors: [Colors.indigo, Colors.cyan]),
              bubbleWidget: SvgPicture.asset(
                'assets/snowflake.svg',
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 30),
            const Text('Rectangular Radius', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            BubbleProgressBar(
              value: _progress,
              height: 25,
              borderRadius: BorderRadius.circular(4), // Slightly rounded corners
              gradient: const LinearGradient(colors: [Colors.pink, Colors.purpleAccent]),
            ),
            const SizedBox(height: 30),
            const Text(
              'Directional Particle (Horizontal Plane)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            BubbleProgressBar(
              value: _progress,
              height: 40,
              bubbleDensity: 0.2,
              minBubbleDiameter: 20,
              maxBubbleDiameter: 25,
              direction: ParticleDirection.horizontal,
              gradient: const LinearGradient(colors: [Colors.lightBlueAccent, Colors.blue]),
              bubbleWidget: RotatedBox(
                quarterTurns: 1,
                child: SvgPicture.asset(
                  'assets/plane.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
