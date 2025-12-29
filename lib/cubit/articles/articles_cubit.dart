import 'package:flutter/material.dart';
import '../base_cubit/base_cubit.dart';
import '../../data/models/article/article_model.dart';
import '../../data/models/id_name/id_name_model.dart';
import '../../data/models/status/form_status.dart';

part 'articles_state.dart';

class ArticlesCubit extends BaseCubit<ArticlesState> {
  ArticlesCubit({required super.appRepository}) : super(state: .initial()) {
    fetchTags();
    fetchArticles();
  }

  Future<void> fetchTags({BuildContext? context}) => processLessApiRequest(
    context: context,
    showError: true,
    showLoader: true,
    request: appRepository.articleRepository.getTags(),
    onSuccess: (result) {
      List<IdNameModel> tags = IdNameModel.fromList(result);
      emit(state.copyWith(tags: tags));
    },
  );

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
