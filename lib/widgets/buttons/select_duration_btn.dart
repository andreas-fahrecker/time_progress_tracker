import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class SelectDurationBtn extends StatelessWidget {
  final Duration duration;
  final void Function(Duration) updateDuration;

  const SelectDurationBtn({
    super.key,
    required this.duration,
    required this.updateDuration,
  });

  void _onPickerConfirm(Picker picker, List<int> values) {
    int years = values[0], months = values[1], days = values[2];
    days = (years * 365) + (months * 31) + days;
    Duration newDuration = Duration(days: days);
    updateDuration(newDuration);
  }

  void _onButtonPressed(BuildContext context, ThemeData appTheme) => Picker(
          adapter: NumberPickerAdapter(data: [
            const NumberPickerColumn(begin: 0, end: 999, suffix: Text(" Y")),
            const NumberPickerColumn(begin: 0, end: 11, suffix: Text(" M")),
            const NumberPickerColumn(begin: 0, end: 31, suffix: Text(" D")),
          ]),
          hideHeader: false,
          title: const Text("Default Duration"),
          selectedTextStyle: TextStyle(color: appTheme.colorScheme.secondary),
          onConfirm: _onPickerConfirm)
      .showModal(context);

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    int years = duration.inDays ~/ 365;
    int months = (duration.inDays - (365 * years)) ~/ 30;
    int days = duration.inDays - (365 * years) - (30 * months);
    return TextButton(
        onPressed: () => _onButtonPressed(context, appTheme),
        style: TextButton.styleFrom(
          foregroundColor: appTheme.primaryTextTheme.labelLarge?.color,
          backgroundColor: appTheme.colorScheme.secondary,
        ),
        child: Text("$years Years $months Months $days Days"));
  }
}
