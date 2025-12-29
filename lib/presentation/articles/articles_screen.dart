import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilmalogiya/presentation/app_widgets/shimmer/list_shimmer.dart';
import '../../cubit/articles/articles_cubit.dart';
import 'widget/article_app_bar.dart';
import 'widget/article_card_widget.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ArticleAppBar(),
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) {
          if (state.status == .submissionInProgress) {
            return const ListShimmer();
          }
          if (state.status == .submissionFailure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            itemCount: state.articles.length,
            itemBuilder: (context, index) =>
                ArticleCardWidget(article: state.articles[index]),
          );
        },
      ),
    );
  }
}
