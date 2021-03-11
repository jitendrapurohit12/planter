import 'package:gmt_planter/constant/constant.dart';

class Failure {
  final String message;
  final int code;

  Failure({this.code, this.message});

  @override
  String toString() => '[code: $code, message: $message]';
}

final socketException = Failure(code: 101, message: kErrorSocket);
final timeoutException = Failure(code: 102, message: kErrorTimeout);
