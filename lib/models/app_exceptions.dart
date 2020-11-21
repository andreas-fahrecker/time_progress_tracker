class TimeProgressInvalidNameException implements Exception {
  final invalidName;

  TimeProgressInvalidNameException(this.invalidName);

  String errMsg() => "The name of a TimeProgress can't be: $invalidName";
}
