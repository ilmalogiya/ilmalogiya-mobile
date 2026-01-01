import 'package:flutter/material.dart';
import 'package:ilmalogiya/utils/ui/app_colors.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
    required this.searchController,
    required this.searchFocusNode,
    required this.onChanged,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 70,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: .circular(50),
                border: .all(width: 1, color: AppColors.primaryColor),
              ),
              padding: const .all(12),
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                onChanged: onChanged,
                cursorWidth: 1,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: .collapsed(
                  hintText: "Nimani izlamoqchisiz?",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.close,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
