import 'package:flutter/material.dart';
import 'package:ilmalogiya/generated/assets/assets.gen.dart';
import 'package:ilmalogiya/utils/constants/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // init();
    super.initState();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.articlesRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(Assets.logos.logoBanner.path)),
    );
  }
}
