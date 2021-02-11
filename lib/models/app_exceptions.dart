class TimeProgressInvalidNameException implements Exception {
  final invalidName;

  TimeProgressInvalidNameException(this.invalidName);

  String errMsg() => "The name of a TimeProgress can't be: $invalidName";
}

class TimeProgressStartTimeIsNotBeforeEndTimeException implements Exception {
  final startTime;
  final endTime;

  TimeProgressStartTimeIsNotBeforeEndTimeException(
      this.startTime, this.endTime);

  String errMsg() =>
      "The Start Time has to be before the end time. Therefore these values are invalid: Start Time: $startTime EndTime: $endTime";
}
