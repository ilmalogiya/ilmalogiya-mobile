import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilmalogiya/utils/ui/app_colors.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../cubit/articles/articles_cubit.dart';
import '../data/network/app_repository.dart';
import '../presentation/router.dart';
import '../utils/constants/routes.dart';
import '../utils/extensions/color_extensions.dart';
import '../utils/ui/app_theme.dart';

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
            lazy: false,
            create: (context) =>
                ArticlesCubit(appRepository: context.read<AppRepository>()),
          ),
        ],
        child: const AppView(),
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
          overlayWidgetBuilder: (progress) {
            return const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              ),
            );
          },
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
