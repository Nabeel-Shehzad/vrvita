import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const VRVitaApp());
}

class VRVitaApp extends StatelessWidget {
  const VRVitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const VRVitaApp();
}
