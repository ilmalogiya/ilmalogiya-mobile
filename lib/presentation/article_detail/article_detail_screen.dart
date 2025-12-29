import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ilmalogiya/data/models/article/article_model.dart';
import 'package:ilmalogiya/presentation/app_widgets/shimmer/image_shimmer.dart';
import 'package:ilmalogiya/presentation/articles/widget/article_app_bar.dart';
import 'package:ilmalogiya/utils/extensions/color_extensions.dart';
import 'package:ilmalogiya/utils/extensions/string_extensions.dart';
import 'package:ilmalogiya/utils/ui/app_colors.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ArticleAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(6),
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 8,
              crossAxisAlignment: .start,
              children: [
                if (article.file != null)
                  Hero(
                    tag: article.file!,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: CachedNetworkImage(
                        imageUrl: article.file!,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) =>
                            const ImageShimmer(
                              width: double.infinity,
                              height: 200,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                      ),
                    ),
                  ),
                const SizedBox.shrink(),
                Wrap(
                  spacing: 8,
                  children: List.generate(
                    article.tags.length,
                    (index) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        child: Text(
                          article.tags[index],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      article.publishedDate.toString().toUzDateTimeSimple(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.remove_red_eye,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      article.views.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  article.description.replaceAll("<br>", "\n"),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
