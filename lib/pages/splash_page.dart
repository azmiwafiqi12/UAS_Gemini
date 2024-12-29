import 'package:flutter/material.dart';
import 'package:uas_app/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Fungsi untuk navigasi ke halaman berikutnya
  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 141, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar Ikon Aplikasi
            Image.asset(
              'assets/gemini.png', // Ganti dengan path ikon aplikasi Anda
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // Teks Nama Aplikasi
            const Text(
              'Chat To Gemini',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lebih sedikit cerdas menggunakan Gemini Chat',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 255, 255, 255)),
            )
          ],
        ),
      ),
    );
  }
}
