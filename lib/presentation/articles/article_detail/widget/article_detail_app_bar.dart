import 'package:flutter/material.dart';
import '../../../../generated/assets/assets.gen.dart';
import '../../../../utils/ui/app_colors.dart';
import 'package:share_plus/share_plus.dart';

class ArticleDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ArticleDetailAppBar({super.key, required this.shareParams});

  final ShareParams shareParams;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          InkWell(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            onTap: () => Navigator.of(context).pop(),
            child: const Padding(
              padding: .only(right: 8),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ),
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
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onTap: () {
            SharePlus.instance.share(shareParams);
          },
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: .circle,
              color: AppColors.primaryColor,
            ),
            child: Padding(
              padding: .all(6.0),
              child: Icon(Icons.share, size: 16, color: AppColors.cardColor),
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
