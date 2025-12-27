class CustomHttpResponse {
  CustomHttpResponse({
    this.message = "",
    this.error = "",
    this.data,
    this.statusCode = 0,
    this.success = true,
  });

  dynamic data;
  String message;
  bool success;
  String error;
  int statusCode;
}