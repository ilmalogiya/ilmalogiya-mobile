import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilmalogiya/cubit/articles/articles_cubit.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (article.slug != null) {
            context.read<ArticlesCubit>().fetchArticle(
              context: context,
              slug: article.slug!,
            );
          }
        },
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
          child: Column(
            crossAxisAlignment: .start,
            children: [
              if (article.file != null)
                Hero(
                  tag: article.file!,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: article.file!,
                      height: 200,
                      width: double.infinity,
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
              Padding(
                padding: const EdgeInsets.all(16),
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
                    Text(
                      article.description.replaceAll("<br>", "\n"),
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
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
