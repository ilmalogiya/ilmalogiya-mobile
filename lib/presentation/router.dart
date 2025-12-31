import 'package:flutter/material.dart';
import '../data/models/article/article_model.dart';
import 'article_detail/article_detail_screen.dart';
import 'articles/articles_screen.dart';
import '../utils/constants/routes.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.articlesRoute:
        return navigate(const ArticlesScreen());
      case RouteNames.articleDetailRoute:
        return navigate(
          ArticleDetailScreen(article: settings.arguments as ArticleModel),
        );
      default:
        return navigate(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static MaterialPageRoute navigate(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);
}
