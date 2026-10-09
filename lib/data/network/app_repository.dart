import "repositories/article_repository.dart";
import "repositories/auth_repository.dart";

class AppRepository {
  final ArticleRepository articleRepository = ArticleRepository();
  final AuthRepository authRepository = AuthRepository();
}
