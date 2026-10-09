import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../data/network/app_repository.dart";
import "../../generated/assets/assets.gen.dart";
import "../../utils/constants/routes.dart";
import "../../utils/ui/app_colors.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final appRepo = context.read<AppRepository>();
    final bool isLoggedIn = await appRepo.authRepository.isLoggedIn();
    final bool isGuest = await appRepo.authRepository.isGuest();

    if (!mounted) return;

    if (isLoggedIn || isGuest) {
      Navigator.pushReplacementNamed(context, RouteNames.articlesRoute);
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: Center(
        child: Assets.logos.logoBanner.image(
          width: 220,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
