import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilmalogiya/app/app.dart';
import 'package:ilmalogiya/cubit/articles/articles_cubit.dart';
import 'package:ilmalogiya/data/network/app_repository.dart';
import 'package:ilmalogiya/presentation/articles/search_article/cubit/search_articles_cubit.dart';
import 'package:ilmalogiya/presentation/articles/search_article/widgte/search_app_bar.dart';
import 'package:ilmalogiya/presentation/articles/widget/article_card_widget.dart';
import 'package:ilmalogiya/utils/search_delayer.dart';

class SearchArticleScreen extends StatefulWidget {
  const SearchArticleScreen({super.key});

  @override
  State<SearchArticleScreen> createState() => _SearchArticleScreenState();
}

class _SearchArticleScreenState extends State<SearchArticleScreen>
    with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final SearchDelayer _searchDelayer = SearchDelayer();
  late final SearchArticlesCubit _searchCubit;

  @override
  void initState() {
    _searchCubit = SearchArticlesCubit(
      appRepository: context.read<AppRepository>(),
    );

    _scrollController.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _searchFocusNode.unfocus();
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    _searchFocusNode.unfocus();
    _searchController.dispose();
    _searchFocusNode.dispose();

    _searchCubit.clear();
    _searchCubit.close();
    routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void didPushNext() {
    _searchFocusNode.unfocus();
    super.didPushNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SearchAppBar(
        searchController: _searchController,
        searchFocusNode: _searchFocusNode,
        onChanged: (String query) {
          if (query.isEmpty) _searchCubit.clear();
          if (query.length < 2) return;
          _searchDelayer.run(() {
            _searchCubit.searchArticles(query: _searchController.text);
          });
        },
      ),
      body: BlocProvider<SearchArticlesCubit>.value(
        value: _searchCubit,
        child: BlocBuilder<SearchArticlesCubit, ArticlesState>(
          builder: (context, state) {
            if (state.status == .submissionInProgress) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_searchController.text.isEmpty) {
              return const Center(child: Text('Qidiruvni boshlang… :)'));
            }
            if (state.articles.isEmpty) {
              return const Center(child: Text('Hmm… bu safar natija yo‘q :('));
            }
            return ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const .all(16.0),
              itemCount: state.articles.length,
              itemBuilder: (context, index) =>
                  ArticleCardWidget(article: state.articles[index]),
            );
          },
        ),
      ),
    );
  }
}
