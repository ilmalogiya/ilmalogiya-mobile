import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilmalogiya/presentation/app_widgets/shimmer/card_item_shimmer.dart';
import '../app_widgets/shimmer/list_shimmer.dart';
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

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<ArticlesCubit>().fetchArticles();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: const ArticleAppBar(enableSearch: true),
        body: BlocBuilder<ArticlesCubit, ArticlesState>(
          builder: (context, state) {
            if (state.status == .submissionInProgress && state.page == 1) {
              return const ListShimmer();
            }
            if (state.status == .submissionFailure) {
              return errorBuilder();
            }
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<ArticlesCubit>().fetchArticles(setInitial: true),
              child: ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const .all(16.0),
                itemCount:
                    state.articles.length + (state.isAllPagesLoaded ? 0 : 1),
                itemBuilder: (context, index) => index == state.articles.length
                    ? const ArticleCardShimmer()
                    : ArticleCardWidget(article: state.articles[index]),
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
        Text(
          'Voy nimadur xato ketdi qayta urinib ko\'ring :)',
          style: Theme.of(context).textTheme.titleMedium,
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
