import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(title: 'Calculator'),
      body: Column(
        children: const [
          Expanded(flex: 4, child: CalculatorDisplay()),
          Expanded(flex: 6, child: CalculatorKeypad()),
        ],
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

class CalculatorTextField extends StatelessWidget {
  final TextEditingController controller;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSizeRatio;

  const CalculatorTextField({
    super.key,
    required this.controller,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.normal,
    this.fontSizeRatio = 0.06,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = constraints.maxWidth * fontSizeRatio;

        return TextField(
          controller: controller,
          readOnly: true,
          enabled: false,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        );
      },
    );
  }
}

class CalculatorDisplay extends StatefulWidget {
  const CalculatorDisplay({super.key});

  @override
  State<CalculatorDisplay> createState() => _CalculatorDisplayState();
}

class _CalculatorDisplayState extends State<CalculatorDisplay> {
  final TextEditingController inputController = TextEditingController(
    text: '0',
  );
  final TextEditingController resultController = TextEditingController(
    text: '0',
  );

  void updateInput(String value) {
    setState(() {
      inputController.text = value;
    });
  }

  void updateResult(String value) {
    setState(() {
      resultController.text = value;
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    resultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Color(0xff23a160)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CalculatorTextField(
                    controller: inputController,
                    textColor: Colors.white70,
                    fontSizeRatio: 0.04,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CalculatorTextField(
                    controller: resultController,
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSizeRatio: 0.05,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CalcButton extends StatelessWidget {
  final String label;
  final Function(String) onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double flex;

  const CalcButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final buttonHeight = constraints.maxHeight;

            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => onPressed(label),
              child: Center(
                // Instead of FittedBox
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: buttonHeight * 0.5, // Bigger font (was 0.4)
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressedButton(String value) {
      print('Button $value pressed');
    }

    return Container(
      color: Color(0xFF19bf98),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '7', onPressed: onPressedButton),
                CalcButton(label: '8', onPressed: onPressedButton),
                CalcButton(label: '9', onPressed: onPressedButton),
                CalcButton(
                  label: 'C',
                  backgroundColor: Colors.orange,
                  textColor: Colors.red,
                  onPressed: onPressedButton,
                ),
                CalcButton(
                  label: 'AC',
                  backgroundColor: Colors.orange,
                  textColor: Colors.red,
                  onPressed: onPressedButton,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '4', onPressed: onPressedButton),
                CalcButton(label: '5', onPressed: onPressedButton),
                CalcButton(label: '6', onPressed: onPressedButton),
                CalcButton(
                  label: '+',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressedButton,
                ),
                CalcButton(
                  label: '-',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressedButton,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '1', onPressed: onPressedButton),
                CalcButton(label: '2', onPressed: onPressedButton),
                CalcButton(label: '3', onPressed: onPressedButton),
                CalcButton(
                  label: 'x',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressedButton,
                ),
                CalcButton(
                  label: '÷',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressedButton,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '0', onPressed: onPressedButton),
                CalcButton(
                  label: '.',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressedButton,
                ),
                CalcButton(label: '00', flex: 2, onPressed: onPressedButton),
                CalcButton(
                  label: '=',
                  textColor: Color(0xFF1a1470),
                  flex: 2,
                  onPressed: onPressedButton,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
