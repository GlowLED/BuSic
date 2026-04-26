import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_tag.freezed.dart';
part 'video_tag.g.dart';

/// Bilibili video tag.
@freezed
class VideoTag with _$VideoTag {
  const factory VideoTag({
    /// Tag identifier from Bilibili.
    required int id,

    /// Tag display name.
    required String name,
  }) = _VideoTag;

  factory VideoTag.fromJson(Map<String, dynamic> json) =>
      _$VideoTagFromJson(json);
}
