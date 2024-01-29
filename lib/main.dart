import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const DVDScreensaver());
}

class DVDScreensaver extends StatelessWidget {
  const DVDScreensaver({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // StarGalaxyAnimation(),
          // StarGalaxyMovingAnimation(),
          DVDLogoAnimation(),
        ],
      ),
    );
  }
}

class DVDLogoAnimation extends StatefulWidget {
  const DVDLogoAnimation({super.key});

  @override
  State<DVDLogoAnimation> createState() => _DVDLogoAnimationState();
}

class _DVDLogoAnimationState extends State<DVDLogoAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? animation;

  // Define the dimensions of the screen
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  // Define the dimensions of the DVD logo
  double logoWidth = 50;
  double logoHeight = 25;

  // Define the initial position of the logo
  double logoPositionX = 0.0;
  double logoPositionY = 0.0;

  // Define the direction and speed of the logo movement
  double dx = 1;
  double dy = 1;
  double speed = 2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 1),
    ).animate(_controller!)
      ..addListener(() {
        setState(() {
          // Update logo position based on animation values
          logoPositionX += dx * speed;
          logoPositionY += dy * speed;

          // Reverse direction if logo hits screen boundaries
          if (logoPositionX <= 0 || logoPositionX >= screenWidth - logoWidth) {
            dx *= -1;
          }
          if (logoPositionY <= 0 ||
              logoPositionY >= screenHeight - logoHeight) {
            dy *= -1;
          }
        });
      });

    _controller!.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get screen dimensions
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // Initialize logo position randomly within screen bounds
    Random random = Random();
    logoPositionX = random.nextDouble() * (screenWidth - logoWidth);
    logoPositionY = random.nextDouble() * (screenHeight - logoHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: logoPositionX,
          top: logoPositionY,
          child: CustomPaint(
            size: const Size(80, 20),
            painter: DVDTextLogoPainter(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}

class DVDTextLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define logo dimensions and colors
    double fontSize = 40.0;
    double logoWidth = fontSize * 3.0;
    double logoHeight = fontSize * 1.5;
    Color logoColor = Colors.red;
    Color backgroundColor = Colors.black;

    // Calculate logo position to center it within the canvas
    double logoPositionX = (size.width - logoWidth) / 2;
    double logoPositionY = (size.height - logoHeight) / 2;

    // Draw background
    Paint backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw DVD text logo
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: 'DVD',
        style: TextStyle(
            color: logoColor, fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(canvas, Offset(logoPositionX, logoPositionY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class StarGalaxyAnimation extends StatefulWidget {
  const StarGalaxyAnimation({super.key});

  @override
  State<StarGalaxyAnimation> createState() => _StarGalaxyAnimationState();
}

class _StarGalaxyAnimationState extends State<StarGalaxyAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  List<Offset> stars = [];
  Timer _timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _controller!.repeat();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      addStar();
    });
  }

  void addStar() {
    final random = Random();
    final x = random.nextDouble() * 400;
    final y = random.nextDouble() * 400;
    stars.add(Offset(x, y));
    if (stars.length > 100) {
      stars.removeAt(0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(400, 400),
      painter: StarGalaxyPainter(stars),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    _timer.cancel();
    super.dispose();
  }
}

class StarGalaxyPainter extends CustomPainter {
  final List<Offset> stars;

  StarGalaxyPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (var star in stars) {
      const radius = 1.0;
      canvas.drawCircle(star, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class StarGalaxyMovingAnimation extends StatefulWidget {
  const StarGalaxyMovingAnimation({super.key});

  @override
  State<StarGalaxyMovingAnimation> createState() =>
      _StarGalaxyMovingAnimationState();
}

class _StarGalaxyMovingAnimationState extends State<StarGalaxyMovingAnimation>
    with TickerProviderStateMixin {
  List<StarAnimation> stars = [];
  Timer _timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      addStar();
    });
  }

  void addStar() {
    final random = Random();
    final x = random.nextDouble() * 400;
    final y = random.nextDouble() * 400;
    final dx = random.nextDouble() * 4 - 2;
    final dy = random.nextDouble() * 4 - 2;
    final controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: random.nextInt(10) + 5),
    );
    controller.addListener(() {
      setState(() {});
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        stars.removeWhere((star) => star.controller == controller);
      }
    });
    stars.add(StarAnimation(
      position: Offset(x, y),
      dx: dx,
      dy: dy,
      controller: controller,
    ));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(400, 400),
      painter: StarGalaxyMovingPainter(stars),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var star in stars) {
      star.controller.dispose();
    }
    super.dispose();
  }
}

class StarAnimation {
  final Offset position;
  final double dx;
  final double dy;
  final AnimationController controller;

  StarAnimation({
    required this.position,
    required this.dx,
    required this.dy,
    required this.controller,
  });
}

class StarGalaxyMovingPainter extends CustomPainter {
  final List<StarAnimation> stars;

  StarGalaxyMovingPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (var star in stars) {
      const radius = 1.0;
      final x = star.position.dx + star.dx;
      final y = star.position.dy + star.dy;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
