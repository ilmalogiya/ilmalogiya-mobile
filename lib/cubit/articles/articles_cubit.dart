import 'package:flutter/material.dart';
import '../../presentation/app_widgets/dialog/error_message_dialog.dart';
import '../../utils/constants/routes.dart';
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

  List<ArticleModel> temp = <ArticleModel>[];
  List<IdNameModel> currentTags = <IdNameModel>[];

  Future<void> fetchArticles({
    BuildContext? context,
    bool setInitial = false,
    List<IdNameModel>? tags,
  }) async {
    if (state.isAllPagesLoaded && !setInitial) return;
    if (setInitial) {
      temp = <ArticleModel>[];
      fetchTags();
      emit(ArticlesState.initial().copyWith(page: 1));
    }
    currentTags = tags ?? currentTags;
    processApiRequest(
      context: context,
      showError: true,
      showLoader: true,
      request: appRepository.articleRepository.getArticles(
        state.page,
        currentTags.isNotEmpty ? currentTags.map((e) => e.name).toList() : null,
      ),
      onSuccess: (result) {
        if (state.page == 1) {
          temp = <ArticleModel>[];
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
    bool forDetail = false,
  }) async {
    ArticleModel article = ArticleModel.empty();
    await processLessApiRequest(
      context: context,
      showError: false,
      showLoader: forDetail,
      request: appRepository.articleRepository.getArticle(slug),
      onSuccess: (result) {
        article = ArticleModel.fromJson(result);
        if (forDetail) {
          Navigator.pushNamed(
            context,
            RouteNames.articleDetailRoute,
            arguments: article.copyWith(forDetail: forDetail),
          );
        }
        fetchArticles(setInitial: true);
      },
      onFailure: (value) {
        showErrorMessageDialog(context: context, message: "Maqola topilmadi");
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
