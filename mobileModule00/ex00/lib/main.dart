import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.005,
                horizontal: width * 0.1,
              ),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 190, 150),
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 150, 190),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'A simple text',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 90, 0),
                  fontSize: width * 0.04,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                print('Button Pressed');
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.002,
                  horizontal: width * 0.1,
                ),
              ),
              child: Text(
                'Click Me',
                style: TextStyle(color: Colors.blue, fontSize: width * 0.03),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
