import 'package:connectivity_plus/connectivity_plus.dart';
import '../../datasources/local/article_local_data_source.dart';
import '../../models/article/article_model.dart';
import '../../../utils/constants/endpoint_constants.dart';
import '../../../utils/app_logger.dart';
import '../custom_http_response.dart';
import '../http_requests_service.dart';

class ArticleRepository {
  final ArticleLocalDataSource _localDataSource = ArticleLocalDataSource();

  Future<CustomHttpResponse> getArticles(int page, List<String>? tags) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Offline mode
      // We ignore pagination/tags for now in offline mode and return all cached articles
      // or implement local filtering if needed.
      // For MVP, returning all cached articles in 'results'.
      try {
        final List<ArticleModel> cachedArticles = await _localDataSource
            .getArticles();
        if (cachedArticles.isEmpty) {
          return CustomHttpResponse(
            message: "Internet Error!",
            error: "Internet Error!",
          );
        }
        return CustomHttpResponse(
          data: {
            'results': cachedArticles.map((e) => e.toJson()).toList(),
            'next': null, // Indicate no more pages
          },
          success: true,
          statusCode: 200,
        );
      } catch (e) {
        return CustomHttpResponse(message: e.toString(), error: e.toString());
      }
    } else {
      // Online mode
      final response = await HttpRequestsService.getRequest(
        endPoint: UrlConstants.articles,
        queryParams: {
          'page': page.toString(),
          'page_size': '10',
          if (tags != null) 'tag': tags.join(","),
        },
      );

      if (response.success &&
          response.data != null &&
          response.data['results'] != null) {
        // Cache the results
        try {
          final List<ArticleModel> articles = ArticleModel.fromList(
            response.data['results'],
          );
          await _localDataSource.saveArticles(articles);
        } catch (e) {
          // Ignore caching errors, don't block UI
          AppLogger.e("Caching error", e);
        }
      }
      return response;
    }
  }

  Future<CustomHttpResponse> searchArticles(String query) =>
      HttpRequestsService.getRequest(
        endPoint: UrlConstants.articles,
        queryParams: {'search': query, 'page_size': '10', 'page': '1'},
      );

  Future<CustomHttpResponse> getArticle(String slug) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Offline
      try {
        final ArticleModel? article = await _localDataSource.getArticle(slug);
        if (article != null) {
          return CustomHttpResponse(
            data: article.toJson(),
            success: true,
            statusCode: 200,
          );
        } else {
          return CustomHttpResponse(
            message: "Maqola topilmadi (Oflayn)",
            error: "Maqola topilmadi",
          );
        }
      } catch (e) {
        return CustomHttpResponse(message: e.toString(), error: e.toString());
      }
    } else {
      // Online
      final response = await HttpRequestsService.getRequest(
        endPoint: '${UrlConstants.articles}$slug',
      );
      if (response.success && response.data != null) {
        try {
          final ArticleModel article = ArticleModel.fromJson(response.data);
          await _localDataSource.saveArticle(article);
        } catch (e) {
          AppLogger.e("Caching error", e);
        }
      }
      return response;
    }
  }

  Future<CustomHttpResponse> getTags() =>
      HttpRequestsService.getRequest(endPoint: UrlConstants.tags);
}
