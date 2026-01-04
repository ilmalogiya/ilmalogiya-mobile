import '../../../utils/constants/endpoint_constants.dart';
import '../custom_http_response.dart';
import '../http_requests_service.dart';

class ArticleRepository {
  Future<CustomHttpResponse> getArticles(int page, String? tag) =>
      HttpRequestsService.getRequest(
        endPoint: UrlConstants.articles,
        queryParams: {'page': page.toString(), 'page_size': '10', if (tag != null) 'tag': tag},
      );

  Future<CustomHttpResponse> searchArticles(String query) =>
      HttpRequestsService.getRequest(
        endPoint: UrlConstants.articles,
        queryParams: {'search': query, 'page_size': '10', 'page': '1'},
      );

  Future<CustomHttpResponse> getArticle(String slug) =>
      HttpRequestsService.getRequest(endPoint: '${UrlConstants.articles}$slug');

  Future<CustomHttpResponse> getTags() =>
      HttpRequestsService.getRequest(endPoint: UrlConstants.tags);
}
