import 'package:flutter/material.dart';
import '../../../generated/assets/assets.gen.dart';
import '../../../utils/ui/app_colors.dart';

class ArticleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ArticleAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            Assets.images.brain.path,
            width: 30,
            height: 30,
            fit: .fill,
          ),
          const Text("Ilmalogiya"),
        ],
      ),
      actions: [
        InkWell(
          onTap: () {},
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: .circle,
              color: AppColors.primaryColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(Icons.search, size: 16, color: AppColors.cardColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
