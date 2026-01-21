import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void handlePressedButton(String value) {
    String currentInput = inputController.text;
    String lastChar = '';
    const List<String> operators = ['+', '-', 'x', '÷'];

    if (currentInput.isNotEmpty) {
      lastChar = currentInput[currentInput.length - 1];
    }

    bool lastTwoAreOperators =
        currentInput.length > 1 &&
        operators.contains(lastChar) &&
        operators.contains(currentInput[currentInput.length - 2]);

    bool isNumber(String value) {
      return int.tryParse(value) != null;
    }

    String getLastnumber(String input) {
      int lastOperatorIndex = -1;
      for (String operator in operators) {
        int index = input.lastIndexOf(operator);
        if (index > lastOperatorIndex) {
          lastOperatorIndex = index;
        }
      }
      return input.substring(lastOperatorIndex + 1);
    }

    String convertToMathExpression(String input) {
      return input.replaceAll('x', '*').replaceAll('÷', '/');
    }

    if (value == 'AC') {
      updateInput('0');
      updateResult('0');
    } else if (value == 'C') {
      if (currentInput.length > 1) {
        updateInput(currentInput.substring(0, currentInput.length - 1));
      } else {
        updateInput('0');
      }
    } else if (value == '=') {
      try {
        String mathExpression = convertToMathExpression(currentInput);
        ShuntingYardParser parser = ShuntingYardParser();
        Expression exp = parser.parse(mathExpression);
        double result = exp.evaluate(EvaluationType.REAL, ContextModel());

        result = double.parse(result.toStringAsFixed(10));

        String resultStr;
        if (result == result.toInt()) {
          resultStr = result.toInt().toString();
        } else {
          resultStr = result.toString();
        }

        updateResult(resultStr);
      } catch (e) {
        updateResult('Error');
      }
    } else if (value == '.') {
      String lastEntry = getLastnumber(currentInput);
      if (lastEntry != '' && !lastEntry.contains('.')) {
        updateInput(currentInput + value);
      } else if (lastEntry == '' && operators.contains(lastChar)) {
        const String defaultDecimal = '0.';
        updateInput(currentInput + defaultDecimal);
      }
    } else if (value == '00') {
      if (currentInput != '0') {
        updateInput(currentInput + value);
      }
    } else if (isNumber(value)) {
      if (currentInput == '0') {
        updateInput(value);
      } else {
        updateInput(currentInput + value);
      }
    } else if (operators.contains(value)) {
      if (lastChar == '-' && value == '-' && lastTwoAreOperators) {
        return;
      }
      if ((operators.contains(lastChar) || lastChar == '.') && value != '-') {
        updateInput(currentInput.substring(0, currentInput.length - 1) + value);
      } else {
        updateInput(currentInput + value);
      }
    } else {
      updateInput(currentInput + value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(title: 'Calculator'),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: CalculatorDisplay(
              input: inputController,
              result: resultController,
            ),
          ),
          Expanded(
            flex: 6,
            child: CalculatorKeypad(onPressed: handlePressedButton),
          ),
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

class CalculatorDisplay extends StatelessWidget {
  final TextEditingController input;
  final TextEditingController result;

  const CalculatorDisplay({
    super.key,
    required this.input,
    required this.result,
  });

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
                    controller: input,
                    textColor: Colors.white70,
                    fontSizeRatio: 0.04,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CalculatorTextField(
                    controller: result,
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
  final Function(String) onPressed;
  const CalculatorKeypad({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF19bf98),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '7', onPressed: onPressed),
                CalcButton(label: '8', onPressed: onPressed),
                CalcButton(label: '9', onPressed: onPressed),
                CalcButton(
                  label: 'C',
                  backgroundColor: Colors.orange,
                  textColor: Colors.red,
                  onPressed: onPressed,
                ),
                CalcButton(
                  label: 'AC',
                  backgroundColor: Colors.orange,
                  textColor: Colors.red,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '4', onPressed: onPressed),
                CalcButton(label: '5', onPressed: onPressed),
                CalcButton(label: '6', onPressed: onPressed),
                CalcButton(
                  label: '+',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressed,
                ),
                CalcButton(
                  label: '-',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '1', onPressed: onPressed),
                CalcButton(label: '2', onPressed: onPressed),
                CalcButton(label: '3', onPressed: onPressed),
                CalcButton(
                  label: 'x',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressed,
                ),
                CalcButton(
                  label: '÷',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '0', onPressed: onPressed),
                CalcButton(
                  label: '.',
                  textColor: Color(0xFF1a1470),
                  onPressed: onPressed,
                ),
                CalcButton(label: '00', flex: 2, onPressed: onPressed),
                CalcButton(
                  label: '=',
                  textColor: Color(0xFF1a1470),
                  flex: 2,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
