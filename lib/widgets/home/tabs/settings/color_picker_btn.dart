import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerButton extends StatelessWidget {
  final String title, dialogTitle;
  final Color selectedColor;
  final void Function(Color) onColorPicked;

  ColorPickerButton({
    @required this.title,
    @required this.dialogTitle,
    @required this.selectedColor,
    @required this.onColorPicked,
  });

  @override
  Widget build(BuildContext context) {
    Color getBtnPrimaryColor() => Color.fromARGB(
          selectedColor.alpha,
          selectedColor.alpha - selectedColor.red,
          selectedColor.alpha - selectedColor.green,
          selectedColor.alpha - selectedColor.blue,
        );

    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(dialogTitle),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: selectedColor,
                  onColorChanged: onColorPicked,
                ),
              ),
            );
          },
        );
      },
      child: Text(title),
      style: TextButton.styleFrom(
        primary: getBtnPrimaryColor(),
        backgroundColor: selectedColor,
      ),
    );
  }
}
