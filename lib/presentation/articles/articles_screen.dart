import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilmalogiya/cubit/articles/articles_cubit.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: .dark,
          statusBarBrightness: .light,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) {
          if (state.status == .submissionInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == .submissionFailure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          return ListView.builder(
            itemCount: state.articles.length,
            itemBuilder: (context, index) {
              final article = state.articles[index];
              return ListTile(
                title: Text(article.title),
                subtitle: Text(
                  article.description,
                  maxLines: 3,
                  overflow: .ellipsis,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
