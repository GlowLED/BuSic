import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Domain model representing a Bilibili user session.
///
/// Contains authentication credentials and basic profile info.
@freezed
class User with _$User {
  const factory User({
    /// Bilibili user ID (DedeUserID).
    required String userId,

    /// Display nickname.
    required String nickname,

    /// Avatar image URL.
    String? avatarUrl,

    /// SESSDATA cookie value for authenticated requests.
    required String sessdata,

    /// bili_jct CSRF token cookie value.
    required String biliJct,

    /// Whether the user session is valid / not expired.
    @Default(false) bool isLoggedIn,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
