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
  int _countdown = 5;
  Timer? _timer;
  late ConfettiController _confettiController;

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

    _confettiController = ConfettiController(duration: Duration(seconds: 4));

    _startCountdown();
  }

  void _startCountdown() {
    setState((){
      _countdown = 10; // Reset Countdown to intial value
    });

    _timer?.cancel(); // cancels the existin timer.

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
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
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
            Text(
              'Timer: $_countdown',
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
              child: Text('Reset Timer') ,
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
