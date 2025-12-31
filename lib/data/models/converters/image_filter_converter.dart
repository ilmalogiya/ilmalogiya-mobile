import 'package:freezed_annotation/freezed_annotation.dart';

class ImageFilterConverter implements JsonConverter<String?, String?> {
  const ImageFilterConverter();

  @override
  String? fromJson(String? json) {
    if (json == null) return null;

    final imageExtensions = [
      // Standart formatlar
      '.jpg',
      '.jpeg',
      '.png',
      '.webp',
    ];
    bool isImage = imageExtensions.any(
      (ext) => json.toLowerCase().endsWith(ext),
    );

    return isImage ? json : null;
  }

  @override
  String? toJson(String? object) => object;
}
