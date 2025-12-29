import 'package:flutter/material.dart';
import '../../../utils/ui/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ImageShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ImageShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.scaffoldBackgroundColor,
      highlightColor: AppColors.cardColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
