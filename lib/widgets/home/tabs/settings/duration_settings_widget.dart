import 'package:flutter/material.dart';
import 'package:time_progress_tracker/widgets/buttons/select_duration_btn.dart';

class DurationSettingsWidget extends StatelessWidget {
  final Duration duration;
  final void Function(Duration) updateDuration;

  const DurationSettingsWidget({
    super.key,
    required this.duration,
    required this.updateDuration,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = Theme.of(context);

    //int years = duration.inDays ~/ 365;
    //int months = (duration.inDays - (365 * years)) ~/ 30;
    //int days = duration.inDays - (365 * years) - (30 * months);
    return Column(
      children: [
        Expanded(
          child: Text(
            "Duration Settings",
            style: appTheme.textTheme.titleLarge,
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
