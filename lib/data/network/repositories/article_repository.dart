import '../custom_http_response.dart';
import '../http_requests_service.dart';
import '../../../utils/constants/endpoint_constants.dart';

class ArticleRepository {
  Future<CustomHttpResponse> getArticles(int page) =>
      HttpRequestsService.getRequest(
        endPoint: UrlConstants.articles,
        queryParams: {'page': page.toString()},
      );

  Future<CustomHttpResponse> getTags() =>
      HttpRequestsService.getRequest(endPoint: UrlConstants.tags);
}
