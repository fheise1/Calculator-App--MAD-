import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _display = '';
  String _operator = '';
  int? _firstNumber;
  int? _secondNumber;

  void _onNumberPress(int number) {
    setState(() {
      _display += number.toString();
    });
  }

  void _onOperatorPress(String operator) {
    if (_display.isNotEmpty) {
      setState(() {
        _firstNumber = int.parse(_display);
        _operator = operator;
        _display = '';
      });
    }
  }

  void _onEqualsPress() {
    if (_firstNumber != null && _operator.isNotEmpty && _display.isNotEmpty) {
      _secondNumber = int.parse(_display);
      int result = 0;

      switch (_operator) {
        case '+':
          result = _firstNumber! + _secondNumber!;
          break;
        case '-':
          result = _firstNumber! - _secondNumber!;
          break;
        case '*':
          result = _firstNumber! * _secondNumber!;
          break;
        case '/':
          if (_secondNumber == 0) {
            _display = 'Error';
            return;
          }
          result = _firstNumber! ~/ _secondNumber!;
          break;
      }

      setState(() {
        _display = result.toString();
        _firstNumber = null;
        _secondNumber = null;
        _operator = '';
      });
    }
  }

  void _onClearPress() {
    setState(() {
      _display = '';
      _firstNumber = null;
      _secondNumber = null;
      _operator = '';
    });
  }

  Widget _buttonMaker(String text, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  VoidCallback _getOnPressedFunction(String text) {
    if (text == 'C') {
      return _onClearPress;
    } else if (text == '=') {
      return _onEqualsPress;
    } else if (['+', '-', '*', '/'].contains(text)) {
      return () => _onOperatorPress(text);
    } else {
      return () => _onNumberPress(int.parse(text));
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(16),
              child: Text(_display, style: const TextStyle(fontSize: 32)),
            ),
          ),
          for (var row in [
            ['7', '8', '9', '/'],
            ['4', '5', '6', '*'],
            ['1', '2', '3', '-'],
            ['C', '0', '=', '+']
          ])
            Row(
              children: row.map((text) {
                return _buttonMaker(text, _getOnPressedFunction(text));
              }).toList(),
            ),
        ],
      ),
    );
  }
}