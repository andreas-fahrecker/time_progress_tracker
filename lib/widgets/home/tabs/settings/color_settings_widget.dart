import 'package:flutter/material.dart';
import 'package:time_progress_tracker/widgets/buttons/color_picker_btn.dart';

class ColorSettingsWidget extends StatelessWidget {
  final Color doneColor, leftColor;
  final void Function(Color) updateDoneColor, updateLeftColor;

  const ColorSettingsWidget({
    super.key,
    required this.doneColor,
    required this.leftColor,
    required this.updateDoneColor,
    required this.updateLeftColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: Text(
            "Color Settings",
            style: appTheme.textTheme.titleLarge,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ColorPickerButton(
                  title: "Done Color",
                  dialogTitle: "Select Done Color",
                  selectedColor: doneColor,
                  onColorPicked: updateDoneColor,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: ColorPickerButton(
                  title: "Left Color",
                  dialogTitle: "Select Left Color",
                  selectedColor: leftColor,
                  onColorPicked: updateLeftColor,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
