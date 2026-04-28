import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/bili_dio.dart';
import '../../auth/application/auth_notifier.dart';
import '../data/parse_repository.dart';
import '../data/parse_repository_impl.dart';
import '../domain/models/bili_fav_folder.dart';

final videoFavoriteFoldersRepositoryProvider = Provider<ParseRepository>((ref) {
  return ParseRepositoryImpl(biliDio: BiliDio());
});

/// Loads the current user's Bilibili favorite folders for video collection.
final videoFavoriteFoldersProvider =
    FutureProvider.autoDispose<List<BiliFavFolder>>((ref) async {
  final user = await ref.watch(authNotifierProvider.future);
  if (user == null || !user.isLoggedIn) {
    throw StateError('pleaseLoginFirst');
  }

  final mid = int.tryParse(user.userId);
  if (mid == null) {
    throw StateError('pleaseLoginFirst');
  }

  final repository = ref.watch(videoFavoriteFoldersRepositoryProvider);
  return repository.getFavoriteFolders(mid);
});
