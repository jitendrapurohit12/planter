class Failure {
  final String message;
  final int code;

  Failure({this.code, this.message});

  @override
  String toString() => '[code: $code, message: $message]';
}
