import "dart:convert";

import "package:http/http.dart" as http;

import "../data/network/custom_http_response.dart";

CustomHttpResponse handleHttpErrors(http.Response response) {
  try {
    final decoded = jsonDecode(response.body);
    if (decoded is Map) {
      final dynamic raw = decoded["message"] ??
          decoded["detail"] ??
          decoded["error"] ??
          (decoded.values.isNotEmpty ? decoded.values.first : null);
      final String error =
          raw is List ? raw.join(", ") : (raw?.toString() ?? "Xatolik yuz berdi!");
      return CustomHttpResponse(error: error, statusCode: response.statusCode);
    }
  } catch (_) {}
  return CustomHttpResponse(
    error: "Xatolik (${response.statusCode})",
    statusCode: response.statusCode,
  );
}
