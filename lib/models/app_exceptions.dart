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
      "The Start Time has to be before the end time. Therefore these values are"
      " invalid: Start Time: $startTime EndTime: $endTime";
}

class TimeProgressHasStartedException implements Exception {
  String errMsg() =>
      "This TimeProgress has started. Therefore all calculation, which assume, "
      "that the progress hasn't started yet can't be performed";
}

class TimeProgressHasNotEndedException implements Exception {
  String errMsg() =>
      "This TimeProgress hasn't ended. Therefore all calculation, which assume,"
      " that the progress has ended already can't be performed";
}
