import 'dart:async';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatBotSplashScreen extends StatefulWidget {
  const ChatBotSplashScreen({super.key});

  @override
  _ChatBotSplashScreenState createState() => _ChatBotSplashScreenState();
}

class _ChatBotSplashScreenState extends State<ChatBotSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _cowAnimation;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _circleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _cowAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
    _bubbleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.5, 1.0, curve: Curves.elasticOut)),
    );
    _circleAnimation = Tween<double>(begin: 0, end: 2 * 3.14).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _controller.repeat();

    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/farm_background.avif',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade600.withOpacity(0.3),
                    Colors.green.shade800.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                  stops: [0.7, 1.0],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _circleAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: CircleFramePainter(_circleAnimation.value),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.1),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ScaleTransition(
                                scale: _cowAnimation,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.shade300.withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/images/splash_cow.png',
                                    height: screenHeight * 0.25,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.pets,
                                        size: screenHeight * 0.25,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                top: screenHeight * 0.0,
                                right: screenWidth * 0.0,
                                child: ScaleTransition(
                                  scale: _bubbleAnimation,
                                  child: CustomPaint(
                                    painter: SpeechBubblePainter(),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Hello!',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade900,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'How Can I Help You Today?',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w400,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      CustomLoadingIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircleFramePainter extends CustomPainter {
  final double rotation;

  CircleFramePainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius1 = size.width * 0.4;
    final radius2 = size.width * 0.45;
    final radius3 = size.width * 0.5;

    final paint1 = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.green.shade300],
      ).createShader(Rect.fromCircle(center: center, radius: radius1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius1),
      rotation,
      5 * 3.14 / 4,
      false,
      paint1,
    );

    final paint2 = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.green.shade300],
      ).createShader(Rect.fromCircle(center: center, radius: radius2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius2),
      3.14 / 2 + rotation,
      5 * 3.14 / 4,
      false,
      paint2,
    );

    final paint3 = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white, Colors.green.shade300],
      ).createShader(Rect.fromCircle(center: center, radius: radius3))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius3),
      3.14 + rotation,
      5 * 3.14 / 4,
      false,
      paint3,
    );
  }

  @override
  bool shouldRepaint(covariant CircleFramePainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}

class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade800
      ..style = PaintingStyle.fill;

    final bubblePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(20),
        ),
      );
    canvas.drawPath(bubblePath, paint);
    canvas.drawShadow(bubblePath, Colors.black26, 4, true);

    final tailPath = Path()
      ..moveTo(0, size.height - 20)
      ..lineTo(-10, size.height - 10)
      ..lineTo(20, size.height - 10)
      ..close();
    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({super.key});

  @override
  _CustomLoadingIndicatorState createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.14,
              child: Icon(
                Icons.pets,
                size: 24,
                color: Colors.green.shade700,
              ),
            );
          },
        ),
        SizedBox(width: 8),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              children: [
                Dot(opacity: (_controller.value * 3).clamp(0, 1)),
                SizedBox(width: 4),
                Dot(opacity: ((_controller.value * 3) - 1).clamp(0, 1)),
                SizedBox(width: 4),
                Dot(opacity: ((_controller.value * 3) - 2).clamp(0, 1)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  final double opacity;

  const Dot({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.3, 1.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
