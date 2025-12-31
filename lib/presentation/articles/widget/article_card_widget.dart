import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/routes.dart';
import '../../../utils/extensions/string_extensions.dart';
import '../../../data/models/article/article_model.dart';
import '../../app_widgets/shimmer/image_shimmer.dart';
import '../../../utils/extensions/color_extensions.dart';
import '../../../utils/ui/app_colors.dart';

class ArticleCardWidget extends StatelessWidget {
  const ArticleCardWidget({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteNames.articleDetailRoute,
            arguments: article,
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: .circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacityCustom(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              if (article.file != null)
                Hero(
                  tag: article.file!,
                  child: ClipRRect(
                    borderRadius: const .vertical(top: .circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: article.file!,
                      height: 200,
                      width: .infinity,
                      fit: .cover,
                      progressIndicatorBuilder: (context, url, progress) =>
                          const ImageShimmer(
                            width: .infinity,
                            height: 200,
                            borderRadius: .vertical(top: .circular(16)),
                          ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey.withOpacityCustom(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const .all(16),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 8,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: List.generate(
                        article.tags.length,
                        (index) => DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBackgroundColor,
                            borderRadius: .circular(50),
                          ),
                          child: Padding(
                            padding: const .symmetric(
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
                    Text(
                      article.description.removeHtmlTags(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 6,
                      overflow: .ellipsis,
                    ),

                    const Row(
                      crossAxisAlignment: .start,
                      children: [
                        Text("To'liq o'qish"),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_right_alt),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
