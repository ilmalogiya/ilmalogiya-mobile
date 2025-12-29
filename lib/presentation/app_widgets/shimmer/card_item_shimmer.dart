import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/ui/app_colors.dart';
import '../../../utils/extensions/color_extensions.dart';

class ArticleCardShimmer extends StatelessWidget {
  const ArticleCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Shimmer.fromColors(
        baseColor: AppColors.scaffoldBackgroundColor,
        highlightColor: AppColors.cardColor,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacityCustom(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const SizedBox(height: 250, width: double.infinity),
        ),
      ),
    );
  }
}
