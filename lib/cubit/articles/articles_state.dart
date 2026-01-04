part of 'articles_cubit.dart';

class ArticlesState extends BaseState {
  const ArticlesState({
    super.status,
    super.actionMessage,
    super.errorMessage,
    required this.articles,
    required this.tags,
    required this.page,
    required this.isAllPagesLoaded,
  });

  final List<ArticleModel> articles;
  final List<IdNameModel> tags;
  final int page;
  final bool isAllPagesLoaded;

  factory ArticlesState.initial() => const ArticlesState(
    status: .pure,
    actionMessage: "",
    errorMessage: "",
    articles: <ArticleModel>[],
    tags: <IdNameModel>[],
    page: 1,
    isAllPagesLoaded: false,
  );


  bool isLoading() => status == .submissionInProgress && page == 1;

  @override
  ArticlesState copyWith({
    FormStatus? status,
    String? actionMessage,
    String? errorMessage,
    List<ArticleModel>? articles,
    List<IdNameModel>? tags,
    int? page,
    bool? isAllPagesLoaded,
  }) {
    return ArticlesState(
      status: status ?? this.status,
      actionMessage: actionMessage ?? this.actionMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      articles: articles ?? this.articles,
      tags: tags ?? this.tags,
      page: page ?? this.page,
      isAllPagesLoaded: isAllPagesLoaded ?? this.isAllPagesLoaded,
    );
  }

  @override
  List<Object?> get props => <Object>[
    status,
    actionMessage,
    errorMessage,
    articles,
    tags,
    page,
    isAllPagesLoaded,
  ];
}
