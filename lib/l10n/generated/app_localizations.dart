import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'BuSic'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @scanToLogin.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code with Bilibili app to login'**
  String get scanToLogin;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @repeatOne.
  ///
  /// In en, this message translates to:
  /// **'Repeat One'**
  String get repeatOne;

  /// No description provided for @sequential.
  ///
  /// In en, this message translates to:
  /// **'Sequential'**
  String get sequential;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// No description provided for @createPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create Playlist'**
  String get createPlaylist;

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist'**
  String get deletePlaylist;

  /// No description provided for @renamePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Rename Playlist'**
  String get renamePlaylist;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get addToPlaylist;

  /// No description provided for @removeFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Playlist'**
  String get removeFromPlaylist;

  /// No description provided for @editMetadata.
  ///
  /// In en, this message translates to:
  /// **'Edit Metadata'**
  String get editMetadata;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @cover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get cover;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @parseInput.
  ///
  /// In en, this message translates to:
  /// **'Enter keyword, BV number or URL...'**
  String get parseInput;

  /// No description provided for @parsing.
  ///
  /// In en, this message translates to:
  /// **'Parsing...'**
  String get parsing;

  /// No description provided for @parseFailed.
  ///
  /// In en, this message translates to:
  /// **'Parse failed'**
  String get parseFailed;

  /// No description provided for @selectPages.
  ///
  /// In en, this message translates to:
  /// **'Select Pages'**
  String get selectPages;

  /// No description provided for @confirmSelection.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmSelection;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloading;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get downloaded;

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// No description provided for @retryAll.
  ///
  /// In en, this message translates to:
  /// **'Retry All'**
  String get retryAll;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @clearCompleted.
  ///
  /// In en, this message translates to:
  /// **'Clear completed'**
  String get clearCompleted;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @cachePath.
  ///
  /// In en, this message translates to:
  /// **'Cache Path'**
  String get cachePath;

  /// No description provided for @autoCache.
  ///
  /// In en, this message translates to:
  /// **'Auto Cache'**
  String get autoCache;

  /// No description provided for @preferredQuality.
  ///
  /// In en, this message translates to:
  /// **'Preferred Quality'**
  String get preferredQuality;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @followUs.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get followUs;

  /// No description provided for @followUsDesc.
  ///
  /// In en, this message translates to:
  /// **'Find us on social media'**
  String get followUsDesc;

  /// No description provided for @noSongs.
  ///
  /// In en, this message translates to:
  /// **'No songs yet'**
  String get noSongs;

  /// No description provided for @noPlayingMusic.
  ///
  /// In en, this message translates to:
  /// **'No music playing'**
  String get noPlayingMusic;

  /// No description provided for @noPlaylists.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet'**
  String get noPlaylists;

  /// No description provided for @unknownArtist.
  ///
  /// In en, this message translates to:
  /// **'Unknown Artist'**
  String get unknownArtist;

  /// No description provided for @unknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown Title'**
  String get unknownTitle;

  /// No description provided for @downloadSong.
  ///
  /// In en, this message translates to:
  /// **'Download Song'**
  String get downloadSong;

  /// No description provided for @selectQuality.
  ///
  /// In en, this message translates to:
  /// **'Select Quality'**
  String get selectQuality;

  /// No description provided for @cached.
  ///
  /// In en, this message translates to:
  /// **'Cached'**
  String get cached;

  /// No description provided for @downloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Download started'**
  String get downloadStarted;

  /// No description provided for @noQualities.
  ///
  /// In en, this message translates to:
  /// **'No available qualities'**
  String get noQualities;

  /// No description provided for @loginForHighQuality.
  ///
  /// In en, this message translates to:
  /// **'Login for higher quality'**
  String get loginForHighQuality;

  /// No description provided for @deleteDownload.
  ///
  /// In en, this message translates to:
  /// **'Delete Download'**
  String get deleteDownload;

  /// No description provided for @deleteDownloadConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the downloaded file?'**
  String get deleteDownloadConfirm;

  /// No description provided for @activeDownloads.
  ///
  /// In en, this message translates to:
  /// **'Active Downloads'**
  String get activeDownloads;

  /// No description provided for @completedDownloads.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedDownloads;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @showWindow.
  ///
  /// In en, this message translates to:
  /// **'Show BuSic'**
  String get showWindow;

  /// No description provided for @quitApp.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quitApp;

  /// No description provided for @sharePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Share Playlist'**
  String get sharePlaylist;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// No description provided for @offlineShare.
  ///
  /// In en, this message translates to:
  /// **'Offline Share'**
  String get offlineShare;

  /// No description provided for @generateShareLink.
  ///
  /// In en, this message translates to:
  /// **'Generate Share Link'**
  String get generateShareLink;

  /// No description provided for @onlineShareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Online Share (Coming Soon)'**
  String get onlineShareComingSoon;

  /// No description provided for @importPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Import Playlist'**
  String get importPlaylist;

  /// No description provided for @importPlaylistPreview.
  ///
  /// In en, this message translates to:
  /// **'Import Playlist Preview'**
  String get importPlaylistPreview;

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Playlist Name'**
  String get playlistName;

  /// No description provided for @songCount.
  ///
  /// In en, this message translates to:
  /// **'Song Count'**
  String get songCount;

  /// No description provided for @songList.
  ///
  /// In en, this message translates to:
  /// **'Song List'**
  String get songList;

  /// No description provided for @confirmImport.
  ///
  /// In en, this message translates to:
  /// **'Confirm Import'**
  String get confirmImport;

  /// No description provided for @importFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Import from Clipboard'**
  String get importFromClipboard;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get importSuccess;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importFailed;

  /// No description provided for @importResult.
  ///
  /// In en, this message translates to:
  /// **'Imported {imported}, reused {reused}, failed {failed}'**
  String importResult(int imported, int reused, int failed);

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export Backup'**
  String get exportBackup;

  /// No description provided for @exportBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Export all playlists and songs to a file'**
  String get exportBackupDesc;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import Backup'**
  String get importBackup;

  /// No description provided for @importBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Restore data from a backup file'**
  String get importBackupDesc;

  /// No description provided for @importDataBackup.
  ///
  /// In en, this message translates to:
  /// **'Import Data Backup'**
  String get importDataBackup;

  /// No description provided for @backupTime.
  ///
  /// In en, this message translates to:
  /// **'Backup Time'**
  String get backupTime;

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersionLabel;

  /// No description provided for @playlistCount.
  ///
  /// In en, this message translates to:
  /// **'Playlist Count'**
  String get playlistCount;

  /// No description provided for @importStrategy.
  ///
  /// In en, this message translates to:
  /// **'Import Strategy'**
  String get importStrategy;

  /// No description provided for @mergeStrategy.
  ///
  /// In en, this message translates to:
  /// **'Merge (Recommended)'**
  String get mergeStrategy;

  /// No description provided for @mergeStrategyDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep existing data, only add new content'**
  String get mergeStrategyDesc;

  /// No description provided for @overwriteStrategy.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwriteStrategy;

  /// No description provided for @overwriteStrategyDesc.
  ///
  /// In en, this message translates to:
  /// **'Clear playlists before importing'**
  String get overwriteStrategyDesc;

  /// No description provided for @overwriteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Overwrite'**
  String get overwriteConfirmTitle;

  /// No description provided for @overwriteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Overwriting will clear all existing playlists and associations. This cannot be undone. Continue?'**
  String get overwriteConfirmMessage;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export successful'**
  String get exportSuccess;

  /// No description provided for @backupExportedTo.
  ///
  /// In en, this message translates to:
  /// **'Backup exported to: {path}'**
  String backupExportedTo(String path);

  /// No description provided for @backupImportResult.
  ///
  /// In en, this message translates to:
  /// **'Created {created} playlists, merged {merged}, created {songs} songs'**
  String backupImportResult(int created, int merged, int songs);

  /// No description provided for @clipboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'Clipboard is empty'**
  String get clipboardEmpty;

  /// No description provided for @notBusicData.
  ///
  /// In en, this message translates to:
  /// **'Clipboard content is not BuSic playlist data'**
  String get notBusicData;

  /// No description provided for @dataFormatError.
  ///
  /// In en, this message translates to:
  /// **'Data format error, cannot parse'**
  String get dataFormatError;

  /// No description provided for @dataCorrupted.
  ///
  /// In en, this message translates to:
  /// **'Playlist data corrupted or version incompatible'**
  String get dataCorrupted;

  /// No description provided for @pleaseUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Please upgrade BuSic before importing'**
  String get pleaseUpgrade;

  /// No description provided for @emptyPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Playlist has no songs'**
  String get emptyPlaylist;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importing;

  /// No description provided for @downloadAll.
  ///
  /// In en, this message translates to:
  /// **'Download All'**
  String get downloadAll;

  /// No description provided for @downloadAllUncached.
  ///
  /// In en, this message translates to:
  /// **'Download uncached songs'**
  String get downloadAllUncached;

  /// No description provided for @allSongsCached.
  ///
  /// In en, this message translates to:
  /// **'All songs are already cached'**
  String get allSongsCached;

  /// No description provided for @downloadAllStarted.
  ///
  /// In en, this message translates to:
  /// **'Started downloading {count} songs'**
  String downloadAllStarted(int count);

  /// No description provided for @downloadAllFailed.
  ///
  /// In en, this message translates to:
  /// **'Batch download failed: {error}'**
  String downloadAllFailed(String error);

  /// No description provided for @downloadingQueue.
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get downloadingQueue;

  /// No description provided for @pendingQueue.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingQueue;

  /// No description provided for @noUncachedSongs.
  ///
  /// In en, this message translates to:
  /// **'No uncached songs to download'**
  String get noUncachedSongs;

  /// No description provided for @changeCover.
  ///
  /// In en, this message translates to:
  /// **'Change Cover'**
  String get changeCover;

  /// No description provided for @resetCover.
  ///
  /// In en, this message translates to:
  /// **'Reset Cover'**
  String get resetCover;

  /// No description provided for @selectLocalImage.
  ///
  /// In en, this message translates to:
  /// **'Select Local Image'**
  String get selectLocalImage;

  /// No description provided for @selectSongCover.
  ///
  /// In en, this message translates to:
  /// **'Use Song Cover'**
  String get selectSongCover;

  /// No description provided for @selectCoverSource.
  ///
  /// In en, this message translates to:
  /// **'Select Cover Source'**
  String get selectCoverSource;

  /// No description provided for @coverUpdated.
  ///
  /// In en, this message translates to:
  /// **'Cover updated'**
  String get coverUpdated;

  /// No description provided for @coverReset.
  ///
  /// In en, this message translates to:
  /// **'Cover reset to default'**
  String get coverReset;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @selectSongAsCover.
  ///
  /// In en, this message translates to:
  /// **'Select a song to use its cover'**
  String get selectSongAsCover;

  /// No description provided for @importLabel.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importLabel;

  /// No description provided for @createLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get createLabel;

  /// No description provided for @fetchingMetadata.
  ///
  /// In en, this message translates to:
  /// **'Fetching song info...'**
  String get fetchingMetadata;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @selectedSongCount.
  ///
  /// In en, this message translates to:
  /// **'Selected {count}/{total}'**
  String selectedSongCount(int count, int total);

  /// No description provided for @noSongsSelected.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one song'**
  String get noSongsSelected;

  /// No description provided for @existsLocallyLabel.
  ///
  /// In en, this message translates to:
  /// **'Exists locally'**
  String get existsLocallyLabel;

  /// No description provided for @metadataFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Fetch failed'**
  String get metadataFetchFailed;

  /// No description provided for @fetchMetadataError.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch song info'**
  String get fetchMetadataError;

  /// No description provided for @importingPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Importing playlist...'**
  String get importingPlaylist;

  /// No description provided for @checkForUpdate.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdate;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get updateAvailable;

  /// No description provided for @updateChangelog.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get updateChangelog;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @skipThisVersion.
  ///
  /// In en, this message translates to:
  /// **'Skip this version'**
  String get skipThisVersion;

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get downloadComplete;

  /// No description provided for @installing.
  ///
  /// In en, this message translates to:
  /// **'Installing update...'**
  String get installing;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'You\'re up to date'**
  String get upToDate;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Update check failed'**
  String get updateError;

  /// No description provided for @forceUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Required update'**
  String get forceUpdateTitle;

  /// No description provided for @forceUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported. Please update to continue using BuSic.'**
  String get forceUpdateMessage;

  /// No description provided for @downloadLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Download latest version'**
  String get downloadLatestVersion;

  /// No description provided for @selectDownloadChannel.
  ///
  /// In en, this message translates to:
  /// **'Select download channel'**
  String get selectDownloadChannel;

  /// No description provided for @channelGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get channelGithub;

  /// No description provided for @channelGithubDesc.
  ///
  /// In en, this message translates to:
  /// **'Official source, may require proxy'**
  String get channelGithubDesc;

  /// No description provided for @channelLanzou.
  ///
  /// In en, this message translates to:
  /// **'Lanzou Cloud'**
  String get channelLanzou;

  /// No description provided for @channelLanzouDesc.
  ///
  /// In en, this message translates to:
  /// **'Domestic high-speed download'**
  String get channelLanzouDesc;

  /// No description provided for @channelNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available for this version'**
  String get channelNotAvailable;

  /// No description provided for @downloadPaused.
  ///
  /// In en, this message translates to:
  /// **'Download paused'**
  String get downloadPaused;

  /// No description provided for @tapToPause.
  ///
  /// In en, this message translates to:
  /// **'Tap to pause'**
  String get tapToPause;

  /// No description provided for @tapToResume.
  ///
  /// In en, this message translates to:
  /// **'Tap to resume'**
  String get tapToResume;

  /// No description provided for @longPressToCancel.
  ///
  /// In en, this message translates to:
  /// **'Long press to cancel'**
  String get longPressToCancel;

  /// No description provided for @cancelDownloadConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel the current download?'**
  String get cancelDownloadConfirm;

  /// No description provided for @rollbackVersion.
  ///
  /// In en, this message translates to:
  /// **'Rollback to previous version'**
  String get rollbackVersion;

  /// No description provided for @selectTargetVersion.
  ///
  /// In en, this message translates to:
  /// **'Select target version'**
  String get selectTargetVersion;

  /// No description provided for @noHistoryVersions.
  ///
  /// In en, this message translates to:
  /// **'No history versions available'**
  String get noHistoryVersions;

  /// No description provided for @installUpdate.
  ///
  /// In en, this message translates to:
  /// **'Install update'**
  String get installUpdate;

  /// No description provided for @downloadCompleteReady.
  ///
  /// In en, this message translates to:
  /// **'Download complete, ready to install'**
  String get downloadCompleteReady;

  /// No description provided for @retryDownload.
  ///
  /// In en, this message translates to:
  /// **'Retry download'**
  String get retryDownload;

  /// No description provided for @goToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to My Favorites'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from My Favorites'**
  String get removedFromFavorites;

  /// No description provided for @favoritesCannotDelete.
  ///
  /// In en, this message translates to:
  /// **'My Favorites playlist cannot be deleted'**
  String get favoritesCannotDelete;

  /// No description provided for @favoritesCannotRename.
  ///
  /// In en, this message translates to:
  /// **'My Favorites playlist cannot be renamed'**
  String get favoritesCannotRename;

  /// No description provided for @createPlaylistManual.
  ///
  /// In en, this message translates to:
  /// **'Create Manually'**
  String get createPlaylistManual;

  /// No description provided for @createPlaylistManualDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter a name to create an empty playlist'**
  String get createPlaylistManualDesc;

  /// No description provided for @importFromBiliFav.
  ///
  /// In en, this message translates to:
  /// **'Import from Bilibili Favorites'**
  String get importFromBiliFav;

  /// No description provided for @importFromBiliFavDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign in to import from your favorite folders'**
  String get importFromBiliFavDesc;

  /// No description provided for @selectFavFolder.
  ///
  /// In en, this message translates to:
  /// **'Select Favorite Folder'**
  String get selectFavFolder;

  /// No description provided for @loadingFavItems.
  ///
  /// In en, this message translates to:
  /// **'Fetching favorites ({fetched}/{total})'**
  String loadingFavItems(int fetched, int total);

  /// No description provided for @favFolderEmpty.
  ///
  /// In en, this message translates to:
  /// **'This favorite folder is empty'**
  String get favFolderEmpty;

  /// No description provided for @importPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Preview'**
  String get importPreviewTitle;

  /// No description provided for @importingProgress.
  ///
  /// In en, this message translates to:
  /// **'Importing ({current}/{total})'**
  String importingProgress(int current, int total);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @pleaseLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to Bilibili first'**
  String get pleaseLoginFirst;

  /// No description provided for @biliFavSongCount.
  ///
  /// In en, this message translates to:
  /// **'{count} songs'**
  String biliFavSongCount(int count);

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noComments;

  /// No description provided for @loadCommentsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load comments'**
  String get loadCommentsFailed;

  /// No description provided for @allCommentsLoaded.
  ///
  /// In en, this message translates to:
  /// **'All comments loaded'**
  String get allCommentsLoaded;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @loginToComment.
  ///
  /// In en, this message translates to:
  /// **'Login to comment'**
  String get loginToComment;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get writeComment;

  /// No description provided for @replyTo.
  ///
  /// In en, this message translates to:
  /// **'Reply to @{username}'**
  String replyTo(String username);

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Send failed'**
  String get sendFailed;

  /// No description provided for @commentCount.
  ///
  /// In en, this message translates to:
  /// **'Comments {count}'**
  String commentCount(int count);

  /// No description provided for @repliesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} replies'**
  String repliesCount(int count);

  /// No description provided for @viewAllReplies.
  ///
  /// In en, this message translates to:
  /// **'View all {count} replies >'**
  String viewAllReplies(int count);

  /// No description provided for @commentSection.
  ///
  /// In en, this message translates to:
  /// **'Comment Section'**
  String get commentSection;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// No description provided for @loginToLike.
  ///
  /// In en, this message translates to:
  /// **'Login to like'**
  String get loginToLike;

  /// No description provided for @loginToReply.
  ///
  /// In en, this message translates to:
  /// **'Login to reply'**
  String get loginToReply;

  /// No description provided for @colorScheme.
  ///
  /// In en, this message translates to:
  /// **'Color Scheme'**
  String get colorScheme;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorTeal;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// No description provided for @colorIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get colorIndigo;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorCyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get colorCyan;

  /// No description provided for @lyricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get lyricsTitle;

  /// No description provided for @noLyrics.
  ///
  /// In en, this message translates to:
  /// **'No lyrics available'**
  String get noLyrics;

  /// No description provided for @lyricsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading lyrics...'**
  String get lyricsLoading;

  /// No description provided for @lyricsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load lyrics'**
  String get lyricsError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
