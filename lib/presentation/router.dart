import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

import "../data/models/article/article_model.dart";
import "../utils/constants/routes.dart";
import "app_widgets/bottom_nav_blur_widget.dart";
import "articles/article_detail/article_detail_screen.dart";
import "articles/articles_screen.dart";
import "articles/search_article/search_article_screen.dart";
import "auth/login_screen.dart";
import "splash/splash_screen.dart";

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashRoute:
        return navigate(const SplashScreen(), withBlur: false);
      case RouteNames.articlesRoute:
        return navigate(const ArticlesScreen());
      case RouteNames.articleDetailRoute:
        return navigate(
          ArticleDetailScreen(article: settings.arguments as ArticleModel),
        );
      case RouteNames.searchArticleRoute:
        return navigate(const SearchArticleScreen());
      case RouteNames.loginRoute:
        return navigate(const LoginScreen(), withBlur: false);
      default:
        return navigate(
          Scaffold(
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
        );
    }
  }

  static CupertinoPageRoute navigate(Widget widget, {bool withBlur = true}) =>
      CupertinoPageRoute(
        builder: (context) => withBlur
            ? Stack(children: [widget, const BottomNavBlurWidget()])
            : widget,
      );
}
