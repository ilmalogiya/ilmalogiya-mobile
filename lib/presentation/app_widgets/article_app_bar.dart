import 'package:flutter/material.dart';
import 'package:ilmalogiya/utils/constants/routes.dart';
import '../../generated/assets/assets.gen.dart';
import '../../utils/ui/app_colors.dart';

class ArticleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ArticleAppBar({super.key, this.enableSearch = false});

  final bool enableSearch;

  @override
  Widget build(BuildContext context) {
    bool isRoot = ModalRoute.of(context)?.isFirst ?? false;
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (!isRoot)
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
      actions: !enableSearch
          ? null
          : [
              InkWell(
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.searchArticleRoute);
                },
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: AppColors.primaryColor,
                  ),
                  child: Padding(
                    padding: .all(6.0),
                    child: Icon(
                      Icons.search,
                      size: 16,
                      color: AppColors.cardColor,
                    ),
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
