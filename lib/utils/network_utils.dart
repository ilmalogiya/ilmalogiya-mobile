import 'dart:convert';

import 'package:http/http.dart' as http;
import '../data/network/custom_http_response.dart';

CustomHttpResponse handleHttpErrors(http.Response response) {
  String error = jsonDecode(response.body)["message"] ?? "Error!";
  return CustomHttpResponse(error: error, statusCode: response.statusCode);
}
