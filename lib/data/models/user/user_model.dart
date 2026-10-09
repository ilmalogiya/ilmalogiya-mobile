// ignore_for_file: invalid_annotation_target

import "package:freezed_annotation/freezed_annotation.dart";

part "../../../generated/user/user_model.freezed.dart";
part "../../../generated/user/user_model.g.dart";

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @Default(0) int id,
    @Default("") String email,
    @JsonKey(name: "full_name") @Default("") String fullName,
    String? avatar,
    String? bio,
    @JsonKey(name: "social_links")
    @Default(<String>[])
    List<String> socialLinks,
    @JsonKey(name: "date_joined") String? dateJoined,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  static UserModel empty() => const UserModel();
}

extension UserModelX on UserModel {
  bool get isEmpty => id == 0;
  bool get isNotEmpty => !isEmpty;
}
