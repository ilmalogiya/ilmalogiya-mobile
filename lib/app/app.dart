import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilmalogiya/cubit/articles/articles_cubit.dart';
import 'package:ilmalogiya/data/network/app_repository.dart';
import 'package:ilmalogiya/presentation/router.dart';
import 'package:ilmalogiya/utils/constants/routes.dart';
import 'package:ilmalogiya/utils/extensions/color_extensions.dart';
import 'package:ilmalogiya/utils/ui/app_theme.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:loader_overlay/loader_overlay.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AppRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ArticlesCubit(appRepository: context.read<AppRepository>()),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: AdaptiveTheme(
        light: AppTheme.lightTheme,
        dark: AppTheme.lightTheme,
        initial: .light,
        builder: (light, dark) => GlobalLoaderOverlay(
          overlayColor: Colors.grey.withOpacityCustom(0.1),

          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: dark,
            theme: light,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: RouteNames.articlesRoute,
            navigatorKey: navigatorKey,
            builder: (context, child) {
              return SafeArea(
                top: false,
                right: false,
                left: false,
                child: child!,
              );
            },
          ),
        ),
      ),
    );
  }
}
