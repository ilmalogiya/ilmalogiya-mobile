// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../data/models/article/article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) =>
    _ArticleModel(
      id: (json['id'] as num).toInt(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      title: json['title'] as String? ?? "Article title",
      description: json['description'] as String? ?? "Article description",
      filePath: json['filePath'] as String?,
      views: (json['views'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ArticleModelToJson(_ArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tags': instance.tags,
      'title': instance.title,
      'description': instance.description,
      'filePath': instance.filePath,
      'views': instance.views,
    };
