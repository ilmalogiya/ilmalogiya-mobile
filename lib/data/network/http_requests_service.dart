import 'dart:convert';
import 'dart:io';

import 'custom_http_response.dart';
import '../../utils/constants/endpoint_constants.dart';
import 'package:http/http.dart' as http;
import '../../utils/network_utils.dart';

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
    try {
      http.Response response = await http.get(uri, headers: getHeaders());

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
      return CustomHttpResponse(
        message: "Internet Error!",
        error: "Internet Error!",
      );
    } on FormatException {
      return CustomHttpResponse(
        message: "Format Error!",
        error: "Format Error!",
      );
    } catch (err) {
      return CustomHttpResponse(message: err.toString(), error: err.toString());
    }
  }
}
