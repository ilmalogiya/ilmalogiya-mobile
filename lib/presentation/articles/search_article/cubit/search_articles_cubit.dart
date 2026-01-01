import 'package:flutter/material.dart';
import 'package:ilmalogiya/cubit/articles/articles_cubit.dart';
import 'package:ilmalogiya/cubit/base_cubit/base_cubit.dart';
import 'package:ilmalogiya/data/models/article/article_model.dart';

class SearchArticlesCubit extends BaseCubit<ArticlesState> {
  SearchArticlesCubit({required super.appRepository})
    : super(state: .initial());

  Future<void> searchArticles({required String query, BuildContext? context}) =>
      processApiRequest(
        context: context,
        showError: true,
        showLoader: true,
        request: appRepository.articleRepository.searchArticles(query),
        onSuccess: (result) {
          List<ArticleModel> articles = ArticleModel.fromList(
            result['results'],
          );
          emit(state.copyWith(articles: articles, isAllPagesLoaded: true));
        },
      );

  void clear() => emit(state.copyWith(articles: [], isAllPagesLoaded: false));
}
