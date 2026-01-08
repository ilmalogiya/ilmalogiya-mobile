import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../utils/constants/endpoint_constants.dart';
import '../../utils/network_utils.dart';
import '../../utils/app_logger.dart';
import 'custom_http_response.dart';

class HttpRequestsService {
  static Duration durationTimeout = const Duration(seconds: 30);

  static Map<String, String> getHeaders() => {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "uz",
  };

  static Future<CustomHttpResponse> getRequest({
    Map<String, dynamic>? queryParams = const {},
    required String endPoint,
  }) async {
    Uri uri = Uri.https(UrlConstants.baseApiUrl, "/api/$endPoint", queryParams);

    AppLogger.logRequest(
      method: "GET",
      url: uri.toString(),
      headers: getHeaders(),
      queryParams: queryParams,
    );

    try {
      http.Response response = await http
          .get(uri, headers: getHeaders())
          .timeout(durationTimeout);

      AppLogger.logResponse(
        url: uri.toString(),
        statusCode: response.statusCode,
        body: response.body, // Log raw body string or decoded json if preferred
      );

      if (response.statusCode == HttpStatus.ok) {
        var result = jsonDecode(response.body);
        return CustomHttpResponse(
          data: result,
          statusCode: response.statusCode,
          message: 'Success',
        );
      }
      return handleHttpErrors(response);
    } on SocketException {
      AppLogger.e("Internet Error for $uri");
      return CustomHttpResponse(
        message: "Internet Error!",
        error: "Internet Error!",
      );
    } on FormatException {
      AppLogger.e("Format Error for $uri");
      return CustomHttpResponse(
        message: "Format Error!",
        error: "Format Error!",
      );
    } catch (err, stack) {
      AppLogger.e("Unknown Error for $uri", err, stack);
      return CustomHttpResponse(message: err.toString(), error: err.toString());
    }
  }
}
