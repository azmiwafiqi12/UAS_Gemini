import 'package:flutter/material.dart';
import 'package:uas_app/pages/splash_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFF9D9)),
        useMaterial3: false,
      ),
      home: const SplashPage(),
    );
  }
}
