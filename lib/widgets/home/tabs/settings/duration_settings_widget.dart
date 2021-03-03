import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class DurationSettingsWidget extends StatelessWidget {
  final Duration duration;
  final void Function(Duration) updateDuration;

  DurationSettingsWidget({
    @required this.duration,
    @required this.updateDuration,
  });

  @override
  Widget build(BuildContext context) {
    int years = duration.inDays ~/ 365;
    int months = (duration.inDays - (365 * years)) ~/ 30;
    int days = duration.inDays - (365 * years) - (30 * months);
    return Column(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              Picker(
                adapter: NumberPickerAdapter(
                  data: [
                    const NumberPickerColumn(
                      begin: 0,
                      end: 999,
                      suffix: Text(" Y"),
                    ),
                    const NumberPickerColumn(
                      begin: 0,
                      end: 11,
                      suffix: Text(" M"),
                    ),
                    const NumberPickerColumn(
                      begin: 0,
                      end: 30,
                      suffix: Text(" D"),
                    ),
                  ],
                ),
                hideHeader: true,
                confirmText: "OK",
                title: const Text("Select Duration"),
                selectedTextStyle: TextStyle(color: Colors.blue),
                onConfirm: (Picker picker, List<int> value) {
                  int years = value[0], months = value[1], days = value[2];
                  days = (years * 365) + (months * 30) + days;
                  Duration newDuration = Duration(days: days);
                  updateDuration(newDuration);
                },
              ).showDialog(context);
            },
            child: Text("Default Duration: $years Y - $months M - $days D"),
          ),
        ),
      ],
    );
  }
}
