import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// 预缓存下屏列表项的封面图，让滚动进入时无需等待网络加载。
///
/// 以 URL 幂等去重：同一 URL 在一次会话内只触发一次 `precacheImage`，
/// 因此可以从 itemBuilder 中安全地在每次重建时调用。
void precacheNextCover(BuildContext context, String? url) {
  if (url == null || url.isEmpty) return;
  if (!_precacheRequested.add(url)) return;
  precacheImage(CachedNetworkImageProvider(url), context);
}

final Set<String> _precacheRequested = {};
