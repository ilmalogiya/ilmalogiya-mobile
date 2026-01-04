import 'package:flutter/material.dart';
import '../../../data/models/id_name/id_name_model.dart';
import '../../../utils/ui/app_colors.dart';

class ArticlesTagWidget extends StatelessWidget {
  const ArticlesTagWidget({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  });

  final List<IdNameModel> tags;
  final IdNameModel? selectedTag;
  final ValueChanged<IdNameModel?> onTagSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: tags.isEmpty
          ? []
          : [
              button(context, "Hammasi", selectedTag == null, () {
                onTagSelected(null);
              }),
              for (var tag in tags)
                button(context, tag.name, selectedTag == tag, () {
                  onTagSelected(tag);
                }),
            ],
    );
  }

  Widget button(
    BuildContext context,
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) => Padding(
    padding: const .symmetric(horizontal: 2, vertical: 4),
    child: InkWell(
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.cardColor,
          borderRadius: .circular(20),
        ),
        child: Padding(
          padding: const .symmetric(horizontal: 8, vertical: 6),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    ),
  );
}
