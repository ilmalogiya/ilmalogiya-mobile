part of 'articles_cubit.dart';

class ArticlesState extends BaseState {
  const ArticlesState({
    super.status,
    super.actionMessage,
    super.errorMessage,
    required this.articles,
    required this.page,
    required this.isAllPagesLoaded,
  });

  final List<ArticleModel> articles;
  final int page;
  final bool isAllPagesLoaded;

  factory ArticlesState.initial() => ArticlesState(
    status: .pure,
    actionMessage: "",
    errorMessage: "",
    articles: [],
    page: 1,
    isAllPagesLoaded: false,
  );

  @override
  ArticlesState copyWith({
    FormStatus? status,
    String? actionMessage,
    String? errorMessage,
    List<ArticleModel>? articles,
    int? page,
    bool? isAllPagesLoaded,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      actionMessage: actionMessage ?? this.actionMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      articles: articles ?? this.articles,
      page: page ?? this.page,
      isAllPagesLoaded: isAllPagesLoaded ?? this.isAllPagesLoaded,
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionMessage,
    errorMessage,
    articles,
    page,
    isAllPagesLoaded,
  ];
}
