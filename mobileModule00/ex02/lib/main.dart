import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(title: 'Calculator'),
        body: CustomDisplay(),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return AppBar(
      title: Text(title, style: TextStyle(fontSize: width * 0.03)),
      backgroundColor: Color(0xFF19bf98),
      foregroundColor: Color(0xFF1a1470),
      centerTitle: true,
      shadowColor: Color(0xFF145243),
      elevation: height * 0.03,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDisplay extends StatelessWidget {
  const CustomDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Container(width: width * 1, height: height * 0.4);
  }
}
