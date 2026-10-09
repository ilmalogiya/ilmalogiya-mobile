import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;

import "../../utils/constants/endpoint_constants.dart";
import "../../utils/network_utils.dart";
import "../../utils/app_logger.dart";
import "custom_http_response.dart";

class HttpRequestsService {
  static Duration durationTimeout = const Duration(seconds: 30);

  static Map<String, String> getHeaders({String? token}) => {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Accept-Language": "uz",
    if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
  };

  static Future<CustomHttpResponse> getRequest({
    Map<String, dynamic>? queryParams = const {},
    required String endPoint,
    String? token,
  }) async {
    final Uri uri = Uri.https(
      UrlConstants.baseApiUrl,
      "/api/$endPoint",
      queryParams,
    );

    AppLogger.logRequest(
      method: "GET",
      url: uri.toString(),
      headers: getHeaders(token: token),
      queryParams: queryParams,
    );

    try {
      final http.Response response = await http
          .get(uri, headers: getHeaders(token: token))
          .timeout(durationTimeout);

      AppLogger.logResponse(
        url: uri.toString(),
        statusCode: response.statusCode,
        body: response.body, // Log raw body string or decoded json if preferred
      );

      if (response.statusCode == HttpStatus.ok) {
        final result = jsonDecode(response.body);
        return CustomHttpResponse(
          data: result,
          statusCode: response.statusCode,
          message: "Success",
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

  static Future<CustomHttpResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final Uri uri = Uri.https(
      UrlConstants.baseApiUrl,
      "/api/$endPoint",
    );

    AppLogger.logRequest(
      method: "POST",
      url: uri.toString(),
      headers: getHeaders(token: token),
      queryParams: null,
      body: body,
    );

    try {
      final http.Response response = await http
          .post(
            uri,
            headers: getHeaders(token: token),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(durationTimeout);

      AppLogger.logResponse(
        url: uri.toString(),
        statusCode: response.statusCode,
        body: response.body,
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        final result = jsonDecode(response.body);
        return CustomHttpResponse(
          data: result,
          statusCode: response.statusCode,
          message: "Success",
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
