import 'dart:convert';
import 'dart:developer' as developer;

class AppLogger {
  // ANSI colors
  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _yellow = '\x1B[33m';
  static const String _green = '\x1B[32m';
  static const String _blue = '\x1B[34m';

  static void i(String message) {
    developer.log('$_green[INFO] $message$_reset', name: 'AppLogger');
  }

  static void w(String message) {
    developer.log('$_yellow[WARNING] $message$_reset', name: 'AppLogger');
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log(
      '$_red[ERROR] $message$_reset',
      name: 'AppLogger',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void logRequest({
    required String method,
    required String url,
    required Map<String, dynamic> headers,
    required Map<String, dynamic>? queryParams,
    dynamic body,
  }) {
    final sb = StringBuffer();
    sb.writeln(
      '$_blue┌──────────────────────────────────────────────────────────────────┐$_reset',
    );
    sb.writeln('$_blue│ REQUEST: $method $_reset');
    sb.writeln('$_blue│ URL: $url $_reset');
    if (queryParams != null && queryParams.isNotEmpty) {
      sb.writeln('$_blue│ Params: $queryParams $_reset');
    }
    sb.writeln('$_blue│ Headers: $headers $_reset');
    if (body != null) {
      sb.writeln(
        '$_blue│ Body: ${body is String ? body : jsonEncode(body)} $_reset',
      );
    }
    sb.writeln(
      '$_blue└──────────────────────────────────────────────────────────────────┘$_reset',
    );
    developer.log(sb.toString(), name: 'AppLogger');
  }

  static void logResponse({
    required String url,
    required int statusCode,
    dynamic body,
    String? errorMessage,
  }) {
    final color = statusCode >= 200 && statusCode < 300 ? _green : _red;
    final sb = StringBuffer();
    sb.writeln(
      '$color┌──────────────────────────────────────────────────────────────────┐$_reset',
    );
    sb.writeln('$color│ RESPONSE: $statusCode $_reset');
    sb.writeln('$color│ URL: $url $_reset');
    if (errorMessage != null) {
      sb.writeln('$color│ Error: $errorMessage $_reset');
    }
    if (body != null) {
      // Limit body log size if needed, but for now log all
      String bodyString = body is String ? body : jsonEncode(body);
      if (bodyString.length > 3000) {
        bodyString = '${bodyString.substring(0, 3000)}... (truncated)';
      }
      sb.writeln('$color│ Body: $bodyString $_reset');
    }
    sb.writeln(
      '$color└──────────────────────────────────────────────────────────────────┘$_reset',
    );
    developer.log(sb.toString(), name: 'AppLogger');
  }
}
