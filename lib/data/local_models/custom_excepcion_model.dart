import 'dart:convert';

class CustomException implements Exception {
  final String message;
  final int statusCode;

  CustomException({this.message = '', required this.statusCode});

  @override
  String toString() => json.encode({
    'message': message,
    'statusCode': statusCode,
  });
}