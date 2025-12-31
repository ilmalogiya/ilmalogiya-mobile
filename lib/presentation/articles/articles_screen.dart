import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_widgets/shimmer/list_shimmer.dart';
import '../../cubit/articles/articles_cubit.dart';
import '../app_widgets/article_app_bar.dart';
import 'widget/article_card_widget.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: const ArticleAppBar(enableSearch: true),
        body: BlocBuilder<ArticlesCubit, ArticlesState>(
          builder: (context, state) {
            if (state.status == .submissionInProgress) {
              return const ListShimmer();
            }
            if (state.status == .submissionFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      'Voy nimadur xato ketdi qayta urinib ko\'ring :)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    FilledButton(
                      onPressed: () {
                        context.read<ArticlesCubit>().fetchArticles();
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
            return RefreshIndicator(
              onRefresh: () => context.read<ArticlesCubit>().fetchArticles(),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const .all(16.0),
                itemCount: state.articles.length,
                itemBuilder: (context, index) =>
                    ArticleCardWidget(article: state.articles[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
