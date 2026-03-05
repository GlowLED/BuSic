// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BuSic';

  @override
  String get home => 'Home';

  @override
  String get playlists => 'Playlists';

  @override
  String get search => 'Search';

  @override
  String get downloads => 'Downloads';

  @override
  String get settings => 'Settings';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get scanToLogin => 'Scan QR code with Bilibili app to login';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get repeat => 'Repeat';

  @override
  String get repeatOne => 'Repeat One';

  @override
  String get sequential => 'Sequential';

  @override
  String get volume => 'Volume';

  @override
  String get queue => 'Queue';

  @override
  String get createPlaylist => 'Create Playlist';

  @override
  String get deletePlaylist => 'Delete Playlist';

  @override
  String get renamePlaylist => 'Rename Playlist';

  @override
  String get addToPlaylist => 'Add to Playlist';

  @override
  String get removeFromPlaylist => 'Remove from Playlist';

  @override
  String get editMetadata => 'Edit Metadata';

  @override
  String get title => 'Title';

  @override
  String get artist => 'Artist';

  @override
  String get cover => 'Cover';

  @override
  String get duration => 'Duration';

  @override
  String get parseInput => 'Enter keyword, BV number or URL...';

  @override
  String get parsing => 'Parsing...';

  @override
  String get parseFailed => 'Parse failed';

  @override
  String get selectPages => 'Select Pages';

  @override
  String get confirmSelection => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get reset => 'Reset';

  @override
  String get downloading => 'Downloading';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String get retryAll => 'Retry All';

  @override
  String get pending => 'Pending';

  @override
  String get clearCompleted => 'Clear completed';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get language => 'Language';

  @override
  String get cachePath => 'Cache Path';

  @override
  String get autoCache => 'Auto Cache';

  @override
  String get preferredQuality => 'Preferred Quality';

  @override
  String get about => 'About';

  @override
  String get followUs => 'Follow Us';

  @override
  String get followUsDesc => 'Find us on social media';

  @override
  String get noSongs => 'No songs yet';

  @override
  String get noPlayingMusic => 'No music playing';

  @override
  String get noPlaylists => 'No playlists yet';

  @override
  String get unknownArtist => 'Unknown Artist';

  @override
  String get unknownTitle => 'Unknown Title';

  @override
  String get downloadSong => 'Download Song';

  @override
  String get selectQuality => 'Select Quality';

  @override
  String get cached => 'Cached';

  @override
  String get downloadStarted => 'Download started';

  @override
  String get noQualities => 'No available qualities';

  @override
  String get loginForHighQuality => 'Login for higher quality';

  @override
  String get deleteDownload => 'Delete Download';

  @override
  String get deleteDownloadConfirm => 'Are you sure you want to delete the downloaded file?';

  @override
  String get activeDownloads => 'Active Downloads';

  @override
  String get completedDownloads => 'Completed';

  @override
  String get confirm => 'Confirm';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get paused => 'Paused';

  @override
  String get showWindow => 'Show BuSic';

  @override
  String get quitApp => 'Quit';

  @override
  String get sharePlaylist => 'Share Playlist';

  @override
  String get copyToClipboard => 'Copy to Clipboard';

  @override
  String get offlineShare => 'Offline Share';

  @override
  String get generateShareLink => 'Generate Share Link';

  @override
  String get onlineShareComingSoon => 'Online Share (Coming Soon)';

  @override
  String get importPlaylist => 'Import Playlist';

  @override
  String get importPlaylistPreview => 'Import Playlist Preview';

  @override
  String get playlistName => 'Playlist Name';

  @override
  String get songCount => 'Song Count';

  @override
  String get songList => 'Song List';

  @override
  String get confirmImport => 'Confirm Import';

  @override
  String get importFromClipboard => 'Import from Clipboard';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get importSuccess => 'Import successful';

  @override
  String get importFailed => 'Import failed';

  @override
  String importResult(int imported, int reused, int failed) {
    return 'Imported $imported, reused $reused, failed $failed';
  }

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportBackup => 'Export Backup';

  @override
  String get exportBackupDesc => 'Export all playlists and songs to a file';

  @override
  String get importBackup => 'Import Backup';

  @override
  String get importBackupDesc => 'Restore data from a backup file';

  @override
  String get importDataBackup => 'Import Data Backup';

  @override
  String get backupTime => 'Backup Time';

  @override
  String get appVersionLabel => 'App Version';

  @override
  String get playlistCount => 'Playlist Count';

  @override
  String get importStrategy => 'Import Strategy';

  @override
  String get mergeStrategy => 'Merge (Recommended)';

  @override
  String get mergeStrategyDesc => 'Keep existing data, only add new content';

  @override
  String get overwriteStrategy => 'Overwrite';

  @override
  String get overwriteStrategyDesc => 'Clear playlists before importing';

  @override
  String get overwriteConfirmTitle => 'Confirm Overwrite';

  @override
  String get overwriteConfirmMessage => 'Overwriting will clear all existing playlists and associations. This cannot be undone. Continue?';

  @override
  String get exportSuccess => 'Export successful';

  @override
  String backupExportedTo(String path) {
    return 'Backup exported to: $path';
  }

  @override
  String backupImportResult(int created, int merged, int songs) {
    return 'Created $created playlists, merged $merged, created $songs songs';
  }

  @override
  String get clipboardEmpty => 'Clipboard is empty';

  @override
  String get notBusicData => 'Clipboard content is not BuSic playlist data';

  @override
  String get dataFormatError => 'Data format error, cannot parse';

  @override
  String get dataCorrupted => 'Playlist data corrupted or version incompatible';

  @override
  String get pleaseUpgrade => 'Please upgrade BuSic before importing';

  @override
  String get emptyPlaylist => 'Playlist has no songs';

  @override
  String get importing => 'Importing...';

  @override
  String get downloadAll => 'Download All';

  @override
  String get downloadAllUncached => 'Download uncached songs';

  @override
  String get allSongsCached => 'All songs are already cached';

  @override
  String downloadAllStarted(int count) {
    return 'Started downloading $count songs';
  }

  @override
  String downloadAllFailed(String error) {
    return 'Batch download failed: $error';
  }

  @override
  String get downloadingQueue => 'Downloading';

  @override
  String get pendingQueue => 'Pending';

  @override
  String get noUncachedSongs => 'No uncached songs to download';

  @override
  String get changeCover => 'Change Cover';

  @override
  String get resetCover => 'Reset Cover';

  @override
  String get selectLocalImage => 'Select Local Image';

  @override
  String get selectSongCover => 'Use Song Cover';

  @override
  String get selectCoverSource => 'Select Cover Source';

  @override
  String get coverUpdated => 'Cover updated';

  @override
  String get coverReset => 'Cover reset to default';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get selectSongAsCover => 'Select a song to use its cover';

  @override
  String get importLabel => 'Import';

  @override
  String get createLabel => 'New';

  @override
  String get fetchingMetadata => 'Fetching song info...';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String selectedSongCount(int count, int total) {
    return 'Selected $count/$total';
  }

  @override
  String get noSongsSelected => 'Please select at least one song';

  @override
  String get existsLocallyLabel => 'Exists locally';

  @override
  String get metadataFetchFailed => 'Fetch failed';

  @override
  String get fetchMetadataError => 'Failed to fetch song info';

  @override
  String get importingPlaylist => 'Importing playlist...';

  @override
  String get checkForUpdate => 'Check for updates';

  @override
  String get updateAvailable => 'New version available';

  @override
  String get updateChangelog => 'What\'s new';

  @override
  String get updateNow => 'Update now';

  @override
  String get updateLater => 'Later';

  @override
  String get skipThisVersion => 'Skip this version';

  @override
  String get downloadComplete => 'Download complete';

  @override
  String get installing => 'Installing update...';

  @override
  String get upToDate => 'You\'re up to date';

  @override
  String get updateError => 'Update check failed';

  @override
  String get forceUpdateTitle => 'Required update';

  @override
  String get forceUpdateMessage => 'This version is no longer supported. Please update to continue using BuSic.';

  @override
  String get downloadLatestVersion => 'Download latest version';

  @override
  String get selectDownloadChannel => 'Select download channel';

  @override
  String get channelGithub => 'GitHub';

  @override
  String get channelGithubDesc => 'Official source, may require proxy';

  @override
  String get channelLanzou => 'Lanzou Cloud';

  @override
  String get channelLanzouDesc => 'Domestic high-speed download';

  @override
  String get channelNotAvailable => 'Not available for this version';

  @override
  String get downloadPaused => 'Download paused';

  @override
  String get tapToPause => 'Tap to pause';

  @override
  String get tapToResume => 'Tap to resume';

  @override
  String get longPressToCancel => 'Long press to cancel';

  @override
  String get cancelDownloadConfirm => 'Cancel the current download?';

  @override
  String get rollbackVersion => 'Rollback to previous version';

  @override
  String get selectTargetVersion => 'Select target version';

  @override
  String get noHistoryVersions => 'No history versions available';

  @override
  String get installUpdate => 'Install update';

  @override
  String get downloadCompleteReady => 'Download complete, ready to install';

  @override
  String get retryDownload => 'Retry download';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get addedToFavorites => 'Added to My Favorites';

  @override
  String get removedFromFavorites => 'Removed from My Favorites';

  @override
  String get favoritesCannotDelete => 'My Favorites playlist cannot be deleted';

  @override
  String get favoritesCannotRename => 'My Favorites playlist cannot be renamed';

  @override
  String get createPlaylistManual => 'Create Manually';

  @override
  String get createPlaylistManualDesc => 'Enter a name to create an empty playlist';

  @override
  String get importFromBiliFav => 'Import from Bilibili Favorites';

  @override
  String get importFromBiliFavDesc => 'Sign in to import from your favorite folders';

  @override
  String get selectFavFolder => 'Select Favorite Folder';

  @override
  String loadingFavItems(int fetched, int total) {
    return 'Fetching favorites ($fetched/$total)';
  }

  @override
  String get favFolderEmpty => 'This favorite folder is empty';

  @override
  String get importPreviewTitle => 'Import Preview';

  @override
  String importingProgress(int current, int total) {
    return 'Importing ($current/$total)';
  }

  @override
  String get retry => 'Retry';

  @override
  String get pleaseLoginFirst => 'Please sign in to Bilibili first';

  @override
  String biliFavSongCount(int count) {
    return '$count songs';
  }

  @override
  String get comments => 'Comments';

  @override
  String get noComments => 'No comments yet';

  @override
  String get loadCommentsFailed => 'Failed to load comments';

  @override
  String get allCommentsLoaded => 'All comments loaded';

  @override
  String get popular => 'Popular';

  @override
  String get latest => 'Latest';

  @override
  String get loginToComment => 'Login to comment';

  @override
  String get writeComment => 'Write a comment...';

  @override
  String replyTo(String username) {
    return 'Reply to @$username';
  }

  @override
  String get sendFailed => 'Send failed';

  @override
  String commentCount(int count) {
    return 'Comments $count';
  }

  @override
  String repliesCount(int count) {
    return '$count replies';
  }

  @override
  String viewAllReplies(int count) {
    return 'View all $count replies >';
  }

  @override
  String get commentSection => 'Comment Section';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get loginToLike => 'Login to like';

  @override
  String get loginToReply => 'Login to reply';

  @override
  String get colorScheme => 'Color Scheme';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorIndigo => 'Indigo';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorRed => 'Red';

  @override
  String get colorCyan => 'Cyan';

  @override
  String get lyricsTitle => 'Lyrics';

  @override
  String get noLyrics => 'No lyrics available';

  @override
  String get lyricsLoading => 'Loading lyrics...';

  @override
  String get lyricsError => 'Failed to load lyrics';
}
