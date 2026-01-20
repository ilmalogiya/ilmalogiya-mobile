import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widget/article_detail_app_bar.dart';
import 'package:photo_opener/photo_opener.dart';
import 'package:share_plus/share_plus.dart';
import '../../../cubit/articles/articles_cubit.dart';
import '../../../data/models/article/article_model.dart';
import '../../app_widgets/shimmer/image_shimmer.dart';
import '../../../utils/extensions/color_extensions.dart';
import '../../../utils/extensions/string_extensions.dart';
import '../../../utils/ui/app_colors.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final ArticleModel article;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late ArticleModel article;

  @override
  void initState() {
    article = widget.article;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.article.slug != null && !widget.article.forDetail) {
      () async {
        await Future.delayed(const Duration(seconds: 5));
        if (!mounted) return;
        article = await context.read<ArticlesCubit>().fetchArticle(
          context: context,
          slug: widget.article.slug!,
        );
        setState(() {});
      }.call();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArticleDetailAppBar(
        shareParams: ShareParams(
          text:
              "${article.title}\n\nBatafsil o‘qish 👇\nhttps://ilmalogiya.uz/posts/${article.slug}",
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const .only(top: 8, bottom: 24, left: 12, right: 12),
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
          child: Padding(
            padding: const .all(12.0),
            child: Column(
              spacing: 8,
              crossAxisAlignment: .start,
              children: [
                if (article.file != null)
                  InkWell(
                    onTap: () {
                      onOpenPhoto(
                        closeText: "Orqaga",
                        context: context,
                        images: [article.file!],
                      );
                    },
                    child: Hero(
                      tag: article.file!,
                      child: ClipRRect(
                        borderRadius: const .all(.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: article.file!,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) =>
                              const ImageShimmer(
                                width: .infinity,
                                height: 200,
                                borderRadius: .vertical(top: .circular(16)),
                              ),
                          errorWidget: (context, url, error) => SizedBox(
                            width: .infinity,
                            height: 200,
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 48,
                                color: Colors.grey.withOpacityCustom(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox.shrink(),
                Wrap(
                  spacing: 8,
                  children: .generate(
                    article.tags.length,
                    (index) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackgroundColor,
                        borderRadius: .circular(50),
                      ),
                      child: Padding(
                        padding: const .symmetric(horizontal: 9, vertical: 3),
                        child: Text(
                          article.tags[index],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ),
                SelectableText(
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
                SelectableText(
                  article.description.removeHtmlTags(),
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
