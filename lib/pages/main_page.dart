import 'package:flutter/material.dart';
import 'package:uas_app/fragment/fragment_generate_image.dart';
import 'package:uas_app/fragment/fragment_generate_text.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Membersihkan TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 141, 255),
        centerTitle: true,
        title: const Text(
          'Gemini AI Apps',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color.fromARGB(255, 255, 255, 255),
          unselectedLabelColor: Colors.black26,
          indicatorColor: const Color.fromARGB(255, 255, 255, 255),
          tabs: const [
            Tab(
              text: 'Generate Text',
              icon: Icon(Icons.text_fields),
            ),
            Tab(
              text: 'Generate Image',
              icon: Icon(Icons.image_search),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FragmentGenerateText(),
          FragmentGenerateImage(),
        ],
      ),
    );
  }
}
