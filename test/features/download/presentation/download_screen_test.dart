import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/download/application/download_notifier.dart';
import 'package:busic/features/download/data/download_repository.dart';
import 'package:busic/features/download/domain/models/download_task.dart';
import 'package:busic/features/download/presentation/download_screen.dart';

import '../../../test_helpers/test_app.dart';

void main() {
  testWidgets('已落盘歌曲显示为本地缓存且不提供清除已完成入口', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          downloadRepositoryProvider.overrideWithValue(
            _FakeDownloadRepository(
              tasks: [
                DownloadTask(
                  id: 1,
                  songId: 42,
                  status: DownloadStatus.completed,
                  createdAt: DateTime(2026, 5, 6),
                  songTitle: 'Cached Track',
                  songArtist: 'Cached Artist',
                  fileSize: 2048,
                ),
              ],
            ),
          ),
        ],
        child: buildTestApp(const DownloadScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Local cache'), findsOneWidget);
    expect(find.text('Cached Track'), findsOneWidget);
    expect(find.text('Clear completed'), findsNothing);
    expect(find.byIcon(Icons.clear_all), findsNothing);
  });
}

class _FakeDownloadRepository implements DownloadRepository {
  const _FakeDownloadRepository({required this.tasks});

  final List<DownloadTask> tasks;

  @override
  Future<int> startDownload({
    required int songId,
    required String url,
    required String savePath,
    int quality = 0,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> cancelDownload(int taskId) {
    throw UnimplementedError();
  }

  @override
  Future<void> retryDownload(int taskId) {
    throw UnimplementedError();
  }

  @override
  Future<void> restartDownload(
    int taskId,
    String url,
    String savePath,
    int quality,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<({String bvid, int cid})?> getSongBvidCid(int songId) {
    throw UnimplementedError();
  }

  @override
  Future<int> getTaskQuality(int taskId) {
    throw UnimplementedError();
  }

  @override
  Future<void> pauseDownload(int taskId) {
    throw UnimplementedError();
  }

  @override
  Future<void> resumeDownload(int taskId) {
    throw UnimplementedError();
  }

  @override
  Stream<DownloadTask> watchTask(int taskId) {
    return Stream.fromIterable(tasks.where((task) => task.id == taskId));
  }

  @override
  Stream<List<DownloadTask>> watchAllTasks() {
    return Stream.value(tasks);
  }

  @override
  Future<List<DownloadTask>> getAllTasks() async {
    return tasks;
  }

  @override
  Future<List<DownloadTask>> getActiveTasks() async {
    return tasks
        .where((task) =>
            task.status == DownloadStatus.pending ||
            task.status == DownloadStatus.downloading)
        .toList();
  }

  @override
  Future<void> deleteTask(int taskId, {bool deleteFile = false}) {
    throw UnimplementedError();
  }
}
