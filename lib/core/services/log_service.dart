import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LogService {
  static final instance = LogService();

  final _logger = Logger();
  final  _isDebugMode = kDebugMode;

  void i(message) {
    if(_isDebugMode) _logger.i(message);
  }

  void e(message) {
    if(_isDebugMode) _logger.e(message);
  }

  void d(message) {
    if(_isDebugMode) _logger.d(message);
  }

  void w(message) {
    if(_isDebugMode) _logger.w(message);
  }

  void repo(message) {
    if(_isDebugMode) _logger.e("Repository => $message");
  }

  void source(message) {
    if(_isDebugMode) _logger.i("Source => $message");
  }
}