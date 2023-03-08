import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:sortapp/inner/collector1.dart';

class SplashScreen2 extends StatefulWidget {
  String email;
  SplashScreen2({required this.email});

  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2500,
      splash: 'assets/images/logo.jpg',
      nextScreen: Collector1(email: widget.email),
      splashTransition: SplashTransition.slideTransition,
    );
  }
}
