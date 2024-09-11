import '../model/button_model.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final ButtonModel button;
  final Function(String value) textValue;
  const ButtonWidget(
      {super.key, required this.button, required this.textValue});

  @override

  /// Returns a widget that displays a button with the [ButtonModel] given
  /// in the constructor.
  ///
  /// The [ButtonModel] is used to style the button and to set the text
  /// and value of the button. The [textValue] callback is called when the
  /// button is pressed with the value of the button as an argument.
  ///
  /// The button is an [ElevatedButton] with a rounded rectangle shape
  /// and an ink sparkle splash factory. The button is also centered in
  /// the parent widget.
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          splashFactory: InkSparkle.splashFactory,
          elevation: 10,
          backgroundColor: button.tileColor,
          padding: const EdgeInsets.all(6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          textValue(button.value);
        },
        child: Center(
          child: Text(
            button.text,
            style: TextStyle(fontSize: 24, color: button.textColor),
          ),
        ));
  }
}
