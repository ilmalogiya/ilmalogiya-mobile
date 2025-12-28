import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/article/article_model.freezed.dart';
part '../../../generated/article/article_model.g.dart';

@freezed
abstract class ArticleModel with _$ArticleModel {
  const factory ArticleModel({
    required int id,
    @Default(<String>[]) List<String> tags,
    String? title,
    String? description,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  static List<ArticleModel> fromList(List? list) =>
      list?.map((e) => ArticleModel.fromJson(e)).toList() ?? [];

  static Map<String, dynamic> customToJson(ArticleModel instance) =>
      <String, dynamic>{};
}
