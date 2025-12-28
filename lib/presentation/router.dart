import 'package:flutter/material.dart';
import 'package:ilmalogiya/presentation/articles/articles_screen.dart';
import 'package:ilmalogiya/presentation/splash/splash_screen.dart';
import 'package:ilmalogiya/utils/constants/routes.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashRoute:
        return navigate(const SplashScreen());
      case RouteNames.articlesRoute:
        return navigate(const ArticlesScreen());
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
