import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/article/article_model.dart';
import '../utils/constants/routes.dart';
import 'articles/article_detail/article_detail_screen.dart';
import 'articles/articles_screen.dart';
import 'articles/search_article/search_article_screen.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.articlesRoute:
        return navigate(const ArticlesScreen());
      case RouteNames.articleDetailRoute:
        return navigate(
          ArticleDetailScreen(article: settings.arguments as ArticleModel),
        );
      case RouteNames.searchArticleRoute:
        return navigate(const SearchArticleScreen());
      default:
        return navigate(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static CupertinoPageRoute navigate(Widget widget) =>
      CupertinoPageRoute(builder: (context) => widget);
}
