// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/id_name/id_name_model.freezed.dart';
part '../../../generated/id_name/id_name_model.g.dart';

@freezed
abstract class IdNameModel with _$IdNameModel {
  const factory IdNameModel({required int id, required String name}) =
      _IdNameModel;

  factory IdNameModel.fromJson(Map<String, dynamic> json) =>
      _$IdNameModelFromJson(json);

  static List<IdNameModel> fromList(List? list) =>
      list?.map((e) => IdNameModel.fromJson(e)).toList() ?? [];
}
