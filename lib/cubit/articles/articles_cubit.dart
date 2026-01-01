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

  List<ArticleModel> temp = [];

  Future<void> fetchArticles({
    BuildContext? context,
    bool setInitial = false,
  }) async {
    if (state.isAllPagesLoaded && !setInitial) return;
    if (setInitial) {
      temp = [];
      emit(ArticlesState.initial());
    }
    processApiRequest(
      context: context,
      showError: true,
      showLoader: true,
      request: appRepository.articleRepository.getArticles(state.page),
      onSuccess: (result) {
        if (state.page == 1) {
          temp = [];
        }
        List<ArticleModel> newArticles = ArticleModel.fromList(
          result['results'],
        );
        temp.addAll(newArticles);
        emit(
          state.copyWith(
            articles: temp,
            isAllPagesLoaded: result['next'] == null,
            page: state.page + 1,
          ),
        );
      },
    );
  }

  Future<ArticleModel> fetchArticle({
    required BuildContext context,
    required String slug,
  }) async {
    ArticleModel article = ArticleModel.empty();
    await processLessApiRequest(
      context: context,
      showError: true,
      showLoader: false,
      request: appRepository.articleRepository.getArticle(slug),
      onSuccess: (result) {
        if (state.page == 1) {}
        article = ArticleModel.fromJson(result);
        fetchArticles();
      },
    );
    return article;
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
}
