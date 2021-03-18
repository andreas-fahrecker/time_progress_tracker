import 'package:flutter/material.dart';
import 'package:time_progress_tracker/ui/buttons/select_duration_btn.dart';

class DurationSettingsWidget extends StatelessWidget {
  final Duration duration;
  final void Function(Duration) updateDuration;

  DurationSettingsWidget({
    required this.duration,
    required this.updateDuration,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    int years = duration.inDays ~/ 365;
    int months = (duration.inDays - (365 * years)) ~/ 30;
    int days = duration.inDays - (365 * years) - (30 * months);
    return Column(
      children: [
        Expanded(
          child: Text(
            "Duration Settings",
            style: appTheme.textTheme.headline6,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SelectDurationBtn(
                duration: duration,
                updateDuration: updateDuration,
              ),
            )
          ],
        )
      ],
    );
  }
}
