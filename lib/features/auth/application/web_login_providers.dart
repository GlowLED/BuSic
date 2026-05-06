import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/platform_utils.dart';
import '../data/bili_web_login_cookie_store.dart';

final webLoginSupportedProvider = Provider<bool>((ref) {
  return !PlatformUtils.isLinux;
});

final biliWebLoginCookieStoreProvider =
    Provider<BiliWebLoginCookieStore>((ref) {
  return InAppBiliWebLoginCookieStore();
});
