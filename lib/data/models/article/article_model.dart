// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ilmalogiya/data/models/converters/image_filter_converter.dart';

part '../../../generated/article/article_model.freezed.dart';
part '../../../generated/article/article_model.g.dart';

@freezed
abstract class ArticleModel with _$ArticleModel {
  const factory ArticleModel({
    required int id,
    @Default(<String>[]) List<String> tags,
    @Default("Article title") String title,
    @Default("Article description") String description,
    @ImageFilterConverter() String? file,
    @Default(0) int views,
    String? slug,
    DateTime? publishedDate,
    @Default(false) bool forDetail,
    String? imgblur,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  static List<ArticleModel> fromList(List? list) =>
      list?.map((e) => ArticleModel.fromJson(e)).toList() ?? [];

  static ArticleModel empty() => const ArticleModel(id: 0);
}
