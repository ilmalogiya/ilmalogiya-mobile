import 'package:ilmalogiya/data/network/custom_http_response.dart';
import 'package:ilmalogiya/data/network/http_requests_service.dart';
import 'package:ilmalogiya/utils/constants/endpoint_constants.dart';

class ArticleRepository {
  Future<CustomHttpResponse> getArticles(int page) =>
      HttpRequestsService.getRequest(
        endPoint: UrlConstants.articles,
        queryParams: {'page': page.toString()},
      );

  Future<CustomHttpResponse> getTags() =>
      HttpRequestsService.getRequest(endPoint: UrlConstants.tags);
}
