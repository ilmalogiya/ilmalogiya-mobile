import 'package:ilmalogiya/cubit/base_cubit/base_cubit.dart';
import 'package:ilmalogiya/data/models/article/article_model.dart';
import 'package:ilmalogiya/data/models/status/form_status.dart';

part 'articles_state.dart';

class ArticlesCubit extends BaseCubit<ArticlesState> {
  ArticlesCubit({required super.appRepository}) : super(state: .initial());
}
