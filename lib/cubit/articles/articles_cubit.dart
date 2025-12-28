import 'package:flutter/material.dart';
import 'package:ilmalogiya/cubit/base_cubit/base_cubit.dart';
import 'package:ilmalogiya/data/models/article/article_model.dart';
import 'package:ilmalogiya/data/models/status/form_status.dart';

part 'articles_state.dart';

class ArticlesCubit extends BaseCubit<ArticlesState> {
  ArticlesCubit({required super.appRepository}) : super(state: .initial());

  Future<void> fetchArticles({BuildContext? context}) => processApiRequest(
    context: context,
    showError: true,
    showLoader: true,
    request: appRepository.articleRepository.getArticles(1),
    onSuccess: (result) {
      List<ArticleModel> articles = ArticleModel.fromList(result['results']);
      emit(state.copyWith(articles: articles));
    },
  );
}
