// ignore_for_file: invalid_annotation_target

import "package:freezed_annotation/freezed_annotation.dart";
import "user_model.dart";

part "../../../generated/user/auth_response_model.freezed.dart";
part "../../../generated/user/auth_response_model.g.dart";

@freezed
abstract class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    @Default("") String access,
    @Default("") String refresh,
    UserModel? user,
    @JsonKey(name: "is_new") @Default(false) bool isNew,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}
