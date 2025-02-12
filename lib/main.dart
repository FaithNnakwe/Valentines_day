import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';

void main() {
  runApp(HeartbeatApp());
}

class HeartbeatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HeartbeatScreen(),
    );
  }
}

class HeartbeatScreen extends StatefulWidget {
  @override
  _HeartbeatScreenState createState() => _HeartbeatScreenState();
}

class _HeartbeatScreenState extends State<HeartbeatScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  int _countdown = 5;
  Timer? _timer;
  late ConfettiController _confettiController;

  // List of pre-written Valentine's Day messages or love quotes
  List<String> _messages = [
    "Love is in the air 💕",
    "You’re so beautiful when you smile.",
    "You have a piece of my heart 💖",
    "Happy Valentine's Day babe! 😘",
    "My Love  for you will never fail.",
  ];

  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Fade transition for the message text
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _confettiController = ConfettiController(duration: Duration(seconds: 4));

    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 10; // Reset Countdown to initial value
    });

    _timer?.cancel(); // Cancels the existing timer.

    // Restart the heart animation
    _controller.reset();
    _controller.repeat(reverse: true);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        _controller.stop();
      }
    });

    // Cycle through messages after each reset
    setState(() {
      _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
    });
  }

  void _showConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ConfettiWidget( // Confetti controller.
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  emissionFrequency: 0.1,
                  numberOfParticles: 100, 
                  gravity: 0.2,
                  colors: [Colors.red, Colors.blue, Colors.green, Colors.yellow],
                ),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 100,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Fading message
            FadeTransition( // Fade in Transitions for messages.
              opacity: _fadeAnimation,
              child: Text(
                _messages[_currentMessageIndex],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Timer: $_countdown', // Displays Timer.
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showConfetti,
              child: Text("Celebrate 🎉"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startCountdown,
              child: Text('Reset Timer'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
