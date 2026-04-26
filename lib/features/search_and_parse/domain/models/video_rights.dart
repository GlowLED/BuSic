import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_rights.freezed.dart';
part 'video_rights.g.dart';

/// Bilibili video permission and copyright flags.
@freezed
class VideoRights with _$VideoRights {
  const factory VideoRights({
    /// Whether reposting is forbidden without creator authorization.
    @Default(false) bool noReprint,
  }) = _VideoRights;

  factory VideoRights.fromJson(Map<String, dynamic> json) =>
      _$VideoRightsFromJson(json);
}
