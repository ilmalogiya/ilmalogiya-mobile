import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/app.dart';
import '../app_widgets/shimmer/card_item_shimmer.dart';
import 'widget/articles_tag_widget.dart';
import '../../cubit/articles/articles_cubit.dart';
import '../app_widgets/article_app_bar.dart';
import 'widget/article_card_widget.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  ScrollController scrollController = ScrollController();
  final AppLinks _appLinks = AppLinks();
  StreamSubscription? _sub;

  @override
  void initState() {
    initAppLink();
    handleNotifications();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<ArticlesCubit>().fetchArticles();
      }
    });

    super.initState();
  }

  void handleNotifications() {
    notificationStreamController.stream.listen((data) {
      if (mounted && data.containsKey('slug')) {
        context.read<ArticlesCubit>().fetchArticle(
          context: context,
          slug: data['slug'],
          forDetail: true,
        );
      }
    });
  }

  void initAppLink() async {
    _sub = _appLinks.uriLinkStream.listen((uri) {
      final segments = uri.pathSegments;
      if (segments.length == 2 && mounted) {
        final String slug = segments[1];
        context.read<ArticlesCubit>().fetchArticle(
          context: context,
          slug: slug,
          forDetail: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: const ArticleAppBar(),
        body: BlocBuilder<ArticlesCubit, ArticlesState>(
          builder: (context, state) {
            if (state.status == .submissionFailure) {
              return errorBuilder();
            }
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<ArticlesCubit>().fetchArticles(setInitial: true),
              child: ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const .symmetric(horizontal: 16.0),
                itemCount: state.isLoading()
                    ? 20
                    : 1 +
                          state.articles.length +
                          (state.isAllPagesLoaded ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .start,
                      mainAxisSize: .min,
                      children: [
                        ArticlesTagWidget(
                          tags: state.tags,
                          selectedTags: context
                              .read<ArticlesCubit>()
                              .currentTags,
                          onTagSelected: (tags) {
                            context.read<ArticlesCubit>().fetchArticles(
                              setInitial: true,
                              tags: tags,
                            );
                          },
                        ),
                        if (state.articles.isEmpty && !state.isLoading()) ...[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),

                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                'Kechirasiz, siz tanlagan taglar bo\'yicha hali maqolalar mavjud emas',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: .center,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }
                  index -= 1;

                  return index == state.articles.length || state.isLoading()
                      ? const ArticleCardShimmer()
                      : ArticleCardWidget(article: state.articles[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget errorBuilder() => Center(
    child: Column(
      mainAxisAlignment: .center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 8),
          child: Text(
            'Voy nimadur xato ketdi qayta urinib ko\'ring :)',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: .center,
          ),
        ),
        FilledButton(
          onPressed: () {
            context.read<ArticlesCubit>().fetchArticles(setInitial: true);
          },
          child: const Row(
            mainAxisSize: .min,
            spacing: 4,
            children: [Icon(Icons.refresh), Text("Qayta urinish")],
          ),
        ),
      ],
    ),
  );
}
