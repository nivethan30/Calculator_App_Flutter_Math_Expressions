import '../widgets/button_widget.dart';
import '../model/button_model.dart';
import '../utils/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _textController =
      TextEditingController(text: '0');

  @override

  /// Releases the resources used by this [State] object. This method is
  /// typically called by the framework when the [State] object is no longer
  /// needed. It is always safe to call this method, even if the [State] object
  /// is still in use. If the [State] object is currently in a tree, the
  /// framework will call this method when the tree is disposed. If the
  /// [State] object is not currently in a tree, the framework will call this
  /// method when the [State] object is finalized.
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override

  /// Returns a [Widget] that is the main screen of the app.
  ///
  /// The screen contains a [TextField] that displays the current calculation
  /// result at the top, and a [GridView] of [ButtonWidget]s below it.
  ///
  /// The [GridView] is arranged in a 4-column layout, with the buttons
  /// arranged in a grid. The buttons are arranged in the same order as the
  /// [buttons] list.
  ///
  /// The [ButtonWidget]s are styled with a grey background and white text.
  /// The [TextField] is styled with a black border and white text.
  ///
  /// The [TextField] is read-only, and the user cannot edit it. Instead,
  /// the user can tap on the buttons to enter numbers and perform calculations.
  ///
  /// The [ButtonWidget]s call the [textValue] callback when they are tapped.
  /// The callback takes a [String] argument, which is the value of the button
  /// that was tapped.
  ///
  /// The [textValue] callback is responsible for updating the [TextField]
  /// with the new calculation result.
  ///
  /// The screen also has a [SizedBox] that wraps the [GridView], which
  /// sets the height of the [GridView] to 60% of the screen height.
  ///
  /// The screen also has a [SafeArea] widget that wraps the entire screen,
  /// which ensures that the screen is safe to use on devices with a notch
  /// or other screen cutouts.
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: height * 0.25,
                width: double.infinity,
                child: TextField(
                  readOnly: true,
                  maxLines: 3,
                  minLines: 1,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 50),
                  controller: _textController,
                  onTap: null,
                  decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: height * 0.60,
                width: double.infinity,
                child: Center(
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: buttons.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 3,
                              crossAxisSpacing: 3,
                              crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        ButtonModel button = buttons[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: ButtonWidget(
                              button: button, textValue: textValue),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// Handles the button press events in the calculator. This function is
  /// called whenever a button is pressed.
  ///
  /// If the current text is "Infinity" or "Error", it resets the value to
  /// "0". If the current text is "0" and the length of the current text is
  /// 1, it clears the text.
  ///
  /// If the button pressed is an operator, it checks if the last character of
  /// the current text is also an operator. If it is, it removes the last
  /// character of the current text.
  ///
  /// If the button pressed is "AC", it clears the text. If the button pressed
  /// is "C", it removes the last character of the current text if the current
  /// text is not "0" and not empty.
  ///
  /// If the button pressed is an operator and the current text is empty, it
  /// adds "0" to the beginning of the current text before adding the operator.
  ///
  /// If the button pressed is "=", it evaluates the expression in the current
  /// text and sets the result to the current text. If the evaluation throws an
  /// exception, it sets the current text to "Error".

  void textValue(String value) {
    if (_textController.text == "Infinity" || _textController.text == "Error") {
      _textController.text = "0";
    }

    if (_textController.text.length == 1 && _textController.text == "0") {
      _textController.clear();
    }

    if (isOperator(value)) {
      if (_textController.text.isNotEmpty &&
          isOperator(_textController.text[_textController.text.length - 1])) {
        _textController.text =
            _textController.text.substring(0, _textController.text.length - 1);
      }
    }

    switch (value) {
      case "AC":
        _textController.clear();
        break;
      case "C":
        if (_textController.text.isNotEmpty && _textController.text != "0") {
          _textController.text = _textController.text
              .substring(0, _textController.text.length - 1);
        }
        break;
      case "+":
      case "-":
      case "*":
      case "%":
      case "/":
        if (_textController.text.isEmpty) {
          _textController.text = "0$value";
        } else {
          _textController.text += value;
        }
        break;
      case "=":
        try {
          String expressionText = _textController.text;
          expressionText = expressionText.replaceAll("%", "/100*");
          final parser = Parser();
          final expression = parser.parse(expressionText);
          final cm = ContextModel();
          final result = expression.evaluate(EvaluationType.REAL, cm);
          _textController.text = result.toString();
        } catch (e) {
          _textController.text = "Error";
        }
        break;
      default:
        _textController.text += value;
        break;
    }

    if (_textController.text.isEmpty) {
      _textController.text = "0";
    }
  }

  /// Checks if the given [value] is one of the operator symbols: +, -, *, /, %.
  ///
  /// Returns true if [value] is an operator symbol, false otherwise.
  bool isOperator(String value) {
    return value == "+" ||
        value == "-" ||
        value == "*" ||
        value == "/" ||
        value == "%";
  }

  /// Builds an app bar with the title "Calculator" and a font size of 30.
  AppBar appBar() {
    return AppBar(
        title: const Text(
      'Calculator',
      style: TextStyle(fontSize: 30),
    ));
  }
}
