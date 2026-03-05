// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BuSic';

  @override
  String get home => '首页';

  @override
  String get playlists => '歌单';

  @override
  String get search => '搜索';

  @override
  String get downloads => '下载';

  @override
  String get settings => '设置';

  @override
  String get login => '登录';

  @override
  String get logout => '退出登录';

  @override
  String get scanToLogin => '使用哔哩哔哩App扫码登录';

  @override
  String get loginSuccess => '登录成功';

  @override
  String get loginFailed => '登录失败';

  @override
  String get play => '播放';

  @override
  String get pause => '暂停';

  @override
  String get next => '下一曲';

  @override
  String get previous => '上一曲';

  @override
  String get shuffle => '随机播放';

  @override
  String get repeat => '列表循环';

  @override
  String get repeatOne => '单曲循环';

  @override
  String get sequential => '顺序播放';

  @override
  String get volume => '音量';

  @override
  String get queue => '播放队列';

  @override
  String get createPlaylist => '创建歌单';

  @override
  String get deletePlaylist => '删除歌单';

  @override
  String get renamePlaylist => '重命名歌单';

  @override
  String get addToPlaylist => '添加到歌单';

  @override
  String get removeFromPlaylist => '从歌单移除';

  @override
  String get editMetadata => '编辑信息';

  @override
  String get title => '标题';

  @override
  String get artist => '歌手';

  @override
  String get cover => '封面';

  @override
  String get duration => '时长';

  @override
  String get parseInput => '输入关键词、BV号或URL链接...';

  @override
  String get parsing => '解析中...';

  @override
  String get parseFailed => '解析失败';

  @override
  String get selectPages => '选择分P';

  @override
  String get confirmSelection => '确认';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get reset => '重置';

  @override
  String get downloading => '下载中';

  @override
  String get downloaded => '已下载';

  @override
  String get downloadFailed => '下载失败';

  @override
  String get retryAll => '全部重试';

  @override
  String get pending => '等待中';

  @override
  String get clearCompleted => '清除已完成';

  @override
  String get themeMode => '主题模式';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get system => '跟随系统';

  @override
  String get language => '语言';

  @override
  String get cachePath => '缓存路径';

  @override
  String get autoCache => '自动缓存';

  @override
  String get preferredQuality => '首选音质';

  @override
  String get about => '关于';

  @override
  String get followUs => '关注我们';

  @override
  String get followUsDesc => '在社交媒体上找到我们';

  @override
  String get noSongs => '暂无歌曲';

  @override
  String get noPlayingMusic => '当前未播放音乐';

  @override
  String get noPlaylists => '暂无歌单';

  @override
  String get unknownArtist => '未知歌手';

  @override
  String get unknownTitle => '未知标题';

  @override
  String get downloadSong => '下载歌曲';

  @override
  String get selectQuality => '选择音质';

  @override
  String get cached => '已缓存';

  @override
  String get downloadStarted => '开始下载';

  @override
  String get noQualities => '无可用音质';

  @override
  String get loginForHighQuality => '登录后可获取更高音质';

  @override
  String get deleteDownload => '删除下载';

  @override
  String get deleteDownloadConfirm => '确定要删除已下载的文件吗？';

  @override
  String get activeDownloads => '正在下载';

  @override
  String get completedDownloads => '已完成';

  @override
  String get confirm => '确定';

  @override
  String get logoutConfirm => '确定要退出登录吗？';

  @override
  String get paused => '已暂停';

  @override
  String get showWindow => '显示 BuSic';

  @override
  String get quitApp => '退出';

  @override
  String get sharePlaylist => '分享歌单';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String get offlineShare => '离线分享';

  @override
  String get generateShareLink => '生成分享链接';

  @override
  String get onlineShareComingSoon => '在线分享（即将推出）';

  @override
  String get importPlaylist => '导入歌单';

  @override
  String get importPlaylistPreview => '导入歌单预览';

  @override
  String get playlistName => '歌单名称';

  @override
  String get songCount => '歌曲数量';

  @override
  String get songList => '歌曲列表';

  @override
  String get confirmImport => '确认导入';

  @override
  String get importFromClipboard => '从剪贴板导入';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get exportFailed => '导出失败';

  @override
  String get importSuccess => '导入成功';

  @override
  String get importFailed => '导入失败';

  @override
  String importResult(int imported, int reused, int failed) {
    return '导入$imported首，复用$reused首，失败$failed首';
  }

  @override
  String get dataManagement => '数据管理';

  @override
  String get exportBackup => '导出备份';

  @override
  String get exportBackupDesc => '将所有歌单和歌曲数据导出为文件';

  @override
  String get importBackup => '导入备份';

  @override
  String get importBackupDesc => '从备份文件恢复数据';

  @override
  String get importDataBackup => '导入数据备份';

  @override
  String get backupTime => '备份时间';

  @override
  String get appVersionLabel => 'App 版本';

  @override
  String get playlistCount => '歌单数量';

  @override
  String get importStrategy => '导入策略';

  @override
  String get mergeStrategy => '合并（推荐）';

  @override
  String get mergeStrategyDesc => '保留现有数据，仅添加新内容';

  @override
  String get overwriteStrategy => '覆盖';

  @override
  String get overwriteStrategyDesc => '清空歌单后导入';

  @override
  String get overwriteConfirmTitle => '确认覆盖';

  @override
  String get overwriteConfirmMessage => '覆盖将清空所有现有歌单和关联关系，此操作不可撤销。确定要继续吗？';

  @override
  String get exportSuccess => '导出成功';

  @override
  String backupExportedTo(String path) {
    return '备份已导出到: $path';
  }

  @override
  String backupImportResult(int created, int merged, int songs) {
    return '新建歌单$created个，合并$merged个，新建歌曲$songs首';
  }

  @override
  String get clipboardEmpty => '剪贴板中没有内容';

  @override
  String get notBusicData => '剪贴板内容不是 BuSic 歌单数据';

  @override
  String get dataFormatError => '数据格式错误，无法解析';

  @override
  String get dataCorrupted => '歌单数据损坏或版本不兼容';

  @override
  String get pleaseUpgrade => '请升级 BuSic 后再导入';

  @override
  String get emptyPlaylist => '歌单中没有歌曲';

  @override
  String get importing => '导入中...';

  @override
  String get downloadAll => '一键下载';

  @override
  String get downloadAllUncached => '下载未缓存的歌曲';

  @override
  String get allSongsCached => '所有歌曲都已缓存';

  @override
  String downloadAllStarted(int count) {
    return '已开始下载 $count 首歌曲';
  }

  @override
  String downloadAllFailed(String error) {
    return '批量下载失败: $error';
  }

  @override
  String get downloadingQueue => '正在下载';

  @override
  String get pendingQueue => '等待中';

  @override
  String get noUncachedSongs => '没有未缓存的歌曲';

  @override
  String get changeCover => '修改封面';

  @override
  String get resetCover => '恢复默认封面';

  @override
  String get selectLocalImage => '选择本地图片';

  @override
  String get selectSongCover => '使用歌曲封面';

  @override
  String get selectCoverSource => '选择封面来源';

  @override
  String get coverUpdated => '封面已更新';

  @override
  String get coverReset => '已恢复默认封面';

  @override
  String get noImageSelected => '未选择图片';

  @override
  String get selectSongAsCover => '选择一首歌曲作为封面';

  @override
  String get importLabel => '导入';

  @override
  String get createLabel => '新建';

  @override
  String get fetchingMetadata => '正在获取歌曲信息...';

  @override
  String get selectAll => '全选';

  @override
  String get deselectAll => '取消全选';

  @override
  String selectedSongCount(int count, int total) {
    return '已选 $count/$total';
  }

  @override
  String get noSongsSelected => '请至少选择一首歌曲';

  @override
  String get existsLocallyLabel => '本地已有';

  @override
  String get metadataFetchFailed => '信息获取失败';

  @override
  String get fetchMetadataError => '获取歌曲信息失败';

  @override
  String get importingPlaylist => '正在导入歌单...';

  @override
  String get checkForUpdate => '检查更新';

  @override
  String get updateAvailable => '发现新版本';

  @override
  String get updateChangelog => '更新内容';

  @override
  String get updateNow => '立即更新';

  @override
  String get updateLater => '稍后提醒';

  @override
  String get skipThisVersion => '跳过此版本';

  @override
  String get downloadComplete => '下载完成';

  @override
  String get installing => '正在安装更新...';

  @override
  String get upToDate => '已是最新版本';

  @override
  String get updateError => '检查更新失败';

  @override
  String get forceUpdateTitle => '必须更新';

  @override
  String get forceUpdateMessage => '当前版本已不受支持，请更新后继续使用 BuSic。';

  @override
  String get downloadLatestVersion => '下载最新版本';

  @override
  String get selectDownloadChannel => '选择下载渠道';

  @override
  String get channelGithub => 'GitHub';

  @override
  String get channelGithubDesc => '官方源，可能需要代理';

  @override
  String get channelLanzou => '蓝奏云';

  @override
  String get channelLanzouDesc => '国内高速下载';

  @override
  String get channelNotAvailable => '该版本暂无此渠道';

  @override
  String get downloadPaused => '下载已暂停';

  @override
  String get tapToPause => '点击暂停';

  @override
  String get tapToResume => '点击继续';

  @override
  String get longPressToCancel => '长按取消下载';

  @override
  String get cancelDownloadConfirm => '确定取消当前下载吗？';

  @override
  String get rollbackVersion => '回退到历史版本';

  @override
  String get selectTargetVersion => '选择目标版本';

  @override
  String get noHistoryVersions => '暂无可用的历史版本';

  @override
  String get installUpdate => '安装更新';

  @override
  String get downloadCompleteReady => '下载完成，可以安装';

  @override
  String get retryDownload => '重试下载';

  @override
  String get goToSettings => '前往设置';

  @override
  String get myFavorites => '我喜欢';

  @override
  String get addToFavorites => '收藏';

  @override
  String get removeFromFavorites => '取消收藏';

  @override
  String get addedToFavorites => '已添加到「我喜欢」';

  @override
  String get removedFromFavorites => '已从「我喜欢」移除';

  @override
  String get favoritesCannotDelete => '「我喜欢」歌单不可删除';

  @override
  String get favoritesCannotRename => '「我喜欢」歌单不可重命名';

  @override
  String get createPlaylistManual => '手动创建';

  @override
  String get createPlaylistManualDesc => '输入歌单名称创建空歌单';

  @override
  String get importFromBiliFav => '从 B 站收藏夹导入';

  @override
  String get importFromBiliFavDesc => '登录后选择收藏夹一键导入';

  @override
  String get selectFavFolder => '选择收藏夹';

  @override
  String loadingFavItems(int fetched, int total) {
    return '正在拉取收藏夹内容 ($fetched/$total)';
  }

  @override
  String get favFolderEmpty => '该收藏夹暂无内容';

  @override
  String get importPreviewTitle => '导入预览';

  @override
  String importingProgress(int current, int total) {
    return '正在导入 ($current/$total)';
  }

  @override
  String get retry => '重试';

  @override
  String get pleaseLoginFirst => '请先登录 B 站账号';

  @override
  String biliFavSongCount(int count) {
    return '$count 首';
  }

  @override
  String get comments => '评论';

  @override
  String get noComments => '暂无评论';

  @override
  String get loadCommentsFailed => '加载评论失败';

  @override
  String get allCommentsLoaded => '已加载全部评论';

  @override
  String get popular => '热门';

  @override
  String get latest => '最新';

  @override
  String get loginToComment => '登录后发表评论';

  @override
  String get writeComment => '发表评论...';

  @override
  String replyTo(String username) {
    return '回复 @$username';
  }

  @override
  String get sendFailed => '发送失败';

  @override
  String commentCount(int count) {
    return '评论 $count';
  }

  @override
  String repliesCount(int count) {
    return '$count条回复';
  }

  @override
  String viewAllReplies(int count) {
    return '查看全部$count条回复 >';
  }

  @override
  String get commentSection => '评论区';

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String hoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String daysAgo(int count) {
    return '$count天前';
  }

  @override
  String get loginToLike => '登录后可点赞';

  @override
  String get loginToReply => '登录后可回复';

  @override
  String get colorScheme => '配色方案';

  @override
  String get colorGreen => '绿色';

  @override
  String get colorBlue => '蓝色';

  @override
  String get colorTeal => '青色';

  @override
  String get colorPink => '粉色';

  @override
  String get colorPurple => '紫色';

  @override
  String get colorIndigo => '靛蓝';

  @override
  String get colorYellow => '黄色';

  @override
  String get colorOrange => '橙色';

  @override
  String get colorRed => '红色';

  @override
  String get colorCyan => '蓝绿';

  @override
  String get lyricsTitle => '歌词';

  @override
  String get noLyrics => '暂无歌词';

  @override
  String get lyricsLoading => '歌词加载中...';

  @override
  String get lyricsError => '歌词加载失败';
}
