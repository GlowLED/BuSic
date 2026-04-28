import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_panel.dart';
import '../../../../shared/widgets/media_cover.dart';
import '../../../../shared/widgets/playlist_picker_dialog.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../../comment/presentation/comment_section.dart';
import '../../../download/application/download_notifier.dart';
import '../../../download/presentation/widgets/quality_select_dialog.dart';
import '../../../player/application/player_notifier.dart';
import '../../../player/domain/models/audio_track.dart';
import '../../../playlist/application/playlist_notifier.dart';
import '../../application/parse_notifier.dart';
import '../../application/video_favorite_folders_provider.dart';
import '../../application/video_interaction_notifier.dart';
import '../../domain/models/bili_fav_folder.dart';
import '../../domain/models/bvid_info.dart';
import '../../domain/models/page_info.dart';
import '../../domain/models/video_interaction_state.dart';

/// Displays parsed video detail in a Bilibili-style detail layout.
class VideoDetailView extends ConsumerStatefulWidget {
  const VideoDetailView({
    super.key,
    required this.parseState,
    this.showBackButton = false,
    this.onBack,
  });

  final ParseState parseState;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  ConsumerState<VideoDetailView> createState() => _VideoDetailViewState();
}

class _VideoDetailViewState extends ConsumerState<VideoDetailView> {
  bool _isTitleExpanded = false;
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    BvidInfo? info;
    List<PageInfo> selectedPages = [];

    widget.parseState.whenOrNull(
      success: (i) {
        info = i;
        selectedPages = i.pages;
      },
      selectingPages: (i, pages) {
        info = i;
        selectedPages = pages;
      },
    );
    if (info == null) return const SizedBox.shrink();

    final videoInfo = info!;
    final isMultiPage = videoInfo.pages.length > 1;
    final aid = videoInfo.aid;
    if (aid != null) {
      final provider = videoInteractionNotifierProvider(videoInfo.bvid, aid);
      ref.listen<AsyncValue<VideoInteractionState>>(provider, (previous, next) {
        final message = next.valueOrNull?.lastError;
        if (message == null ||
            message == previous?.valueOrNull?.lastError ||
            !context.mounted) {
          return;
        }
        context.showSnackBar(_localizedInteractionError(context, message));
        ref.read(provider.notifier).clearError();
      });
    }

    return DefaultTabController(
      length: 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final contentMaxWidth = _contentMaxWidth(constraints.maxWidth);
          final mediaMaxWidth = _mediaMaxWidth(constraints.maxWidth);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentMaxWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.appSpacing.lg,
                        context.appSpacing.md,
                        context.appSpacing.lg,
                        context.appSpacing.sm,
                      ),
                      child: _buildMediaHeaderSection(
                        videoInfo,
                        selectedPages,
                        isMultiPage,
                        mediaMaxWidth,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _VideoDetailTabsDelegate(
                  videoInfo: videoInfo,
                  maxWidth: contentMaxWidth,
                ),
              ),
            ],
            body: TabBarView(
              children: [
                _buildIntroTab(
                  videoInfo,
                  selectedPages,
                  isMultiPage,
                  contentMaxWidth,
                ),
                _buildCommentTab(videoInfo, contentMaxWidth),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaHeaderSection(
    BvidInfo videoInfo,
    List<PageInfo> selectedPages,
    bool isMultiPage,
    double mediaMaxWidth,
  ) {
    final spacing = context.appSpacing;

    Widget mediaHeader() {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: mediaMaxWidth),
          child: _buildMediaHeader(
            videoInfo,
            selectedPages,
            isMultiPage,
          ),
        ),
      );
    }

    Widget backButton() {
      return _HeaderBackButton(
        tooltip: context.l10n.backToSearchResults,
        onPressed: widget.onBack,
      );
    }

    if (!widget.showBackButton) {
      return mediaHeader();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final coverMaxWidth =
            mediaMaxWidth.isFinite ? mediaMaxWidth : availableWidth;
        final coverWidth = coverMaxWidth.clamp(0.0, availableWidth).toDouble();
        final sideGutterWidth = (availableWidth - coverWidth) / 2;
        const buttonExtent = _HeaderBackButton.dimension;
        final hasSideGutter = sideGutterWidth >= buttonExtent + spacing.sm;

        if (!hasSideGutter) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              SizedBox(height: spacing.sm),
              mediaHeader(),
            ],
          );
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            mediaHeader(),
            Positioned(
              left: 0,
              top: 0,
              child: backButton(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMediaHeader(
    BvidInfo videoInfo,
    List<PageInfo> selectedPages,
    bool isMultiPage,
  ) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;
    final canPlay = !isMultiPage || selectedPages.isNotEmpty;
    final duration = _videoDuration(videoInfo);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: context.appRadii.xLargeRadius,
        boxShadow: context.appDepth.coverGlowShadow,
      ),
      child: ClipRRect(
        borderRadius: context.appRadii.xLargeRadius,
        child: Stack(
          alignment: Alignment.center,
          children: [
            MediaCover(
              key: const ValueKey('video-detail-cover'),
              coverUrl: videoInfo.coverUrl,
              width: double.infinity,
              aspectRatio: 16 / 9,
              borderRadius: BorderRadius.zero,
              placeholderIcon: Icons.video_library_rounded,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      palette.overlayStrong.withValues(alpha: 0.28),
                      palette.overlaySoft.withValues(alpha: 0.08),
                      palette.overlayStrong.withValues(alpha: 0.42),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: palette.overlayStrong.withValues(alpha: 0.58),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: canPlay
                    ? () => _playParsedVideo(
                          context,
                          videoInfo,
                          selectedPages,
                        )
                    : null,
                child: Padding(
                  padding: EdgeInsets.all(spacing.md),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 42,
                    color: canPlay
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
            Positioned(
              right: spacing.sm,
              bottom: spacing.sm,
              child: _OverlayBadge(
                label: Formatters.formatDuration(duration),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroTab(
    BvidInfo videoInfo,
    List<PageInfo> selectedPages,
    bool isMultiPage,
    double maxWidth,
  ) {
    final spacing = context.appSpacing;

    return CustomScrollView(
      primary: true,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
              spacing.lg, spacing.md, spacing.lg, spacing.lg),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOwnerRow(videoInfo),
                    SizedBox(height: spacing.md),
                    _buildTitleBlock(videoInfo),
                    SizedBox(height: spacing.sm),
                    _buildStatsRow(videoInfo),
                    if (videoInfo.rights.noReprint) ...[
                      SizedBox(height: spacing.sm),
                      _buildNoReprintNotice(),
                    ],
                    SizedBox(height: spacing.md),
                    _buildDescriptionBlock(videoInfo),
                    if (videoInfo.tags.isNotEmpty) ...[
                      SizedBox(height: spacing.md),
                      _buildTagRow(videoInfo),
                    ],
                    if (videoInfo.aid != null) ...[
                      SizedBox(height: spacing.lg),
                      _buildInteractionRow(videoInfo),
                    ],
                    SizedBox(height: spacing.lg),
                    _buildBusicActions(videoInfo, selectedPages, isMultiPage),
                    if (isMultiPage) ...[
                      SizedBox(height: spacing.lg),
                      _buildPageSelection(videoInfo, selectedPages),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTab(BvidInfo videoInfo, double maxWidth) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.appSpacing.lg,
            context.appSpacing.md,
            context.appSpacing.lg,
            context.appSpacing.lg,
          ),
          child: CommentSection(
            bvid: videoInfo.bvid,
            usePrimaryScrollController: true,
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerRow(BvidInfo videoInfo) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;
    final meta = <String>[
      if (videoInfo.ownerUid != null)
        context.l10n.videoOwnerUid(videoInfo.ownerUid!),
      if (videoInfo.tname != null && videoInfo.tname!.isNotEmpty)
        videoInfo.tname!,
    ];

    return Row(
      children: [
        MediaCover(
          coverUrl: videoInfo.ownerFace,
          width: 44,
          height: 44,
          borderRadius: context.appRadii.pillRadius,
          placeholderIcon: Icons.person_rounded,
        ),
        SizedBox(width: spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      videoInfo.owner,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.xs),
                  _TinyLabel(label: context.l10n.videoUpOwner),
                ],
              ),
              if (meta.isNotEmpty) ...[
                SizedBox(height: spacing.xxs),
                Text(
                  meta.join(' / '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleBlock(BvidInfo videoInfo) {
    final palette = context.appPalette;
    final showToggle = videoInfo.title.length > 42;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          videoInfo.title,
          maxLines: _isTitleExpanded ? null : 2,
          overflow: _isTitleExpanded ? null : TextOverflow.ellipsis,
          style: context.textTheme.titleLarge?.copyWith(
            color: palette.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (showToggle)
          TextButton(
            onPressed: () {
              setState(() => _isTitleExpanded = !_isTitleExpanded);
            },
            child: Text(
              _isTitleExpanded ? context.l10n.collapse : context.l10n.expand,
            ),
          ),
      ],
    );
  }

  Widget _buildStatsRow(BvidInfo videoInfo) {
    final badges = <Widget>[
      _VideoBadge(
        icon: Icons.visibility_rounded,
        label: context.l10n.videoStatsViews(
          _formatCompactCount(context, videoInfo.stats.view),
        ),
      ),
      _VideoBadge(
        icon: Icons.subtitles_rounded,
        label: context.l10n.videoStatsDanmaku(
          _formatCompactCount(context, videoInfo.stats.danmaku),
        ),
      ),
      _VideoBadge(
        icon: Icons.comment_rounded,
        label: context.l10n.commentCount(videoInfo.stats.reply),
      ),
      _VideoBadge(
        icon: Icons.fingerprint_rounded,
        label: videoInfo.bvid,
      ),
    ];

    if (videoInfo.pubdate != null && videoInfo.pubdate! > 0) {
      badges.insert(
        2,
        _VideoBadge(
          icon: Icons.schedule_rounded,
          label: context.l10n.videoStatsPublished(
            _formatPubdate(videoInfo.pubdate!),
          ),
        ),
      );
    }

    return Wrap(
      spacing: context.appSpacing.sm,
      runSpacing: context.appSpacing.xs,
      children: badges,
    );
  }

  Widget _buildNoReprintNotice() {
    final palette = context.appPalette;
    final spacing = context.appSpacing;

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xs),
      decoration: BoxDecoration(
        color: palette.warningSoft.withValues(alpha: 0.72),
        borderRadius: context.appRadii.largeRadius,
        border: Border.all(
          color: palette.warning.withValues(alpha: 0.3),
          width: context.appDepth.outline,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.report_problem_rounded, size: 18, color: palette.warning),
          SizedBox(width: spacing.xs),
          Expanded(
            child: Text(
              context.l10n.videoNoReprint,
              style: context.textTheme.bodySmall?.copyWith(
                color: palette.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionBlock(BvidInfo videoInfo) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;
    final description = videoInfo.description.trim();
    final displayText =
        description.isEmpty ? context.l10n.videoDescriptionEmpty : description;
    final showToggle = description.length > 120 || description.contains('\n');

    return AppPanel(
      padding: EdgeInsets.all(spacing.md),
      borderRadius: context.appRadii.largeRadius,
      boxShadow: const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayText,
            maxLines: _isDescriptionExpanded || description.isEmpty ? null : 4,
            overflow: _isDescriptionExpanded || description.isEmpty
                ? null
                : TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color:
                  description.isEmpty ? palette.textMuted : palette.textPrimary,
              height: 1.45,
            ),
          ),
          if (showToggle) ...[
            SizedBox(height: spacing.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isDescriptionExpanded = !_isDescriptionExpanded;
                  });
                },
                child: Text(
                  _isDescriptionExpanded
                      ? context.l10n.collapse
                      : context.l10n.expand,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTagRow(BvidInfo videoInfo) {
    return Wrap(
      spacing: context.appSpacing.xs,
      runSpacing: context.appSpacing.xs,
      children: [
        for (final tag in videoInfo.tags)
          Chip(
            visualDensity: VisualDensity.compact,
            label: Text(tag.name),
          ),
      ],
    );
  }

  Widget _buildInteractionRow(BvidInfo videoInfo) {
    final aid = videoInfo.aid;
    if (aid == null) return const SizedBox.shrink();

    final asyncState =
        ref.watch(videoInteractionNotifierProvider(videoInfo.bvid, aid));
    final state = asyncState.valueOrNull ?? const VideoInteractionState();
    final isBusy = state.isBusy || asyncState.isLoading;
    final spacing = context.appSpacing;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _InteractionActionButton(
            icon: state.isLiked
                ? Icons.thumb_up_alt_rounded
                : Icons.thumb_up_alt_outlined,
            label: state.isLiked
                ? context.l10n.videoLiked
                : context.l10n.videoLike,
            count: _formatCompactCount(context, videoInfo.stats.like),
            selected: state.isLiked,
            isBusy: isBusy,
            onTap: () => _handleLike(context, videoInfo),
          ),
          SizedBox(width: spacing.sm),
          _InteractionActionButton(
            icon: state.coinsGiven >= 2
                ? Icons.paid_rounded
                : Icons.paid_outlined,
            label: state.coinsGiven > 0
                ? context.l10n.videoCoined(state.coinsGiven)
                : context.l10n.videoCoin,
            count: _formatCompactCount(context, videoInfo.stats.coin),
            selected: state.coinsGiven > 0,
            isBusy: isBusy || state.coinsGiven >= 2,
            onTap: () => _handleCoin(context, videoInfo, state),
          ),
          SizedBox(width: spacing.sm),
          _InteractionActionButton(
            icon: state.isFavorited
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            label: state.isFavorited
                ? context.l10n.videoFavorited
                : context.l10n.videoFavorite,
            count: _formatCompactCount(context, videoInfo.stats.favorite),
            selected: state.isFavorited,
            isBusy: isBusy || state.isFavorited,
            onTap: () => _handleFavorite(context, videoInfo),
          ),
          SizedBox(width: spacing.sm),
          _InteractionActionButton(
            icon: Icons.ios_share_rounded,
            label: context.l10n.videoShare,
            count: _formatCompactCount(context, videoInfo.stats.share),
            selected: false,
            isBusy: isBusy,
            onTap: () => _handleShare(context, videoInfo),
          ),
        ],
      ),
    );
  }

  Widget _buildBusicActions(
    BvidInfo videoInfo,
    List<PageInfo> selectedPages,
    bool isMultiPage,
  ) {
    final spacing = context.appSpacing;
    final disabled = isMultiPage && selectedPages.isEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        final play = FilledButton.icon(
          onPressed: disabled
              ? null
              : () => _playParsedVideo(context, videoInfo, selectedPages),
          icon: const Icon(Icons.play_arrow_rounded),
          label: Text(context.l10n.play),
        );
        final add = FilledButton.tonalIcon(
          onPressed: disabled ? null : () => _addToPlaylist(context),
          icon: const Icon(Icons.playlist_add_rounded),
          label: Text(context.l10n.addToPlaylist),
        );
        final download = OutlinedButton.icon(
          onPressed: disabled
              ? null
              : () => _downloadParsedVideo(
                    context,
                    videoInfo,
                    selectedPages,
                  ),
          icon: const Icon(Icons.download_rounded),
          label: Text(context.l10n.downloads),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              play,
              SizedBox(height: spacing.sm),
              add,
              SizedBox(height: spacing.sm),
              download,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: play),
            SizedBox(width: spacing.sm),
            Expanded(child: add),
            SizedBox(width: spacing.sm),
            Expanded(child: download),
          ],
        );
      },
    );
  }

  Widget _buildPageSelection(
    BvidInfo videoInfo,
    List<PageInfo> selectedPages,
  ) {
    final notifier = ref.read(parseNotifierProvider.notifier);
    final allSelected = selectedPages.length == videoInfo.pages.length;
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return AppPanel(
      padding: EdgeInsets.all(spacing.md),
      borderRadius: context.appRadii.xLargeRadius,
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: allSelected
                    ? true
                    : selectedPages.isEmpty
                        ? false
                        : null,
                tristate: true,
                onChanged: (value) {
                  if (value == true) {
                    notifier.selectAllPages();
                  } else {
                    notifier.deselectAllPages();
                  }
                },
              ),
              SizedBox(width: spacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.selectPages,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    SizedBox(height: spacing.xxs),
                    Text(
                      context.l10n.selectedPagesCount(
                        selectedPages.length,
                        videoInfo.pages.length,
                      ),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: videoInfo.pages.length,
              separatorBuilder: (_, __) => SizedBox(height: spacing.xs),
              itemBuilder: (context, index) {
                final page = videoInfo.pages[index];
                final isSelected = selectedPages.any((p) => p.cid == page.cid);
                return _PageSelectionRow(
                  page: page,
                  isSelected: isSelected,
                  onTap: () => notifier.togglePageSelection(page),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLike(
    BuildContext context,
    BvidInfo videoInfo,
  ) async {
    final aid = videoInfo.aid;
    if (aid == null) return;
    final isLoggedIn = await _ensureLoggedIn(context);
    if (!isLoggedIn) return;
    await ref
        .read(videoInteractionNotifierProvider(videoInfo.bvid, aid).notifier)
        .toggleLike();
  }

  Future<void> _handleCoin(
    BuildContext context,
    BvidInfo videoInfo,
    VideoInteractionState interactionState,
  ) async {
    final aid = videoInfo.aid;
    if (aid == null) return;
    final isLoggedIn = await _ensureLoggedIn(context);
    if (!isLoggedIn || !context.mounted) return;
    if (interactionState.coinsGiven >= 2) {
      if (context.mounted) {
        context.showSnackBar(context.l10n.videoCoinsAlreadyMaxed);
      }
      return;
    }

    final selection = await _showCoinDialog(context, interactionState);
    if (selection == null || !context.mounted) return;

    final success = await ref
        .read(videoInteractionNotifierProvider(videoInfo.bvid, aid).notifier)
        .addCoin(
          multiply: selection.multiply,
          alsoLike: selection.alsoLike,
        );
    if (success && context.mounted) {
      context.showSnackBar(context.l10n.videoCoinAdded(selection.multiply));
    }
  }

  Future<void> _handleFavorite(
    BuildContext context,
    BvidInfo videoInfo,
  ) async {
    final aid = videoInfo.aid;
    if (aid == null) return;
    final isLoggedIn = await _ensureLoggedIn(context);
    if (!isLoggedIn || !context.mounted) return;

    final folder = await showModalBottomSheet<BiliFavFolder>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _FavoriteFolderPicker(),
    );
    if (folder == null || !context.mounted) return;

    final success = await ref
        .read(videoInteractionNotifierProvider(videoInfo.bvid, aid).notifier)
        .addToFavoriteFolder(folder.id);
    if (success && context.mounted) {
      context.showSnackBar(context.l10n.videoFavoriteAdded);
    }
  }

  Future<void> _handleShare(
    BuildContext context,
    BvidInfo videoInfo,
  ) async {
    final aid = videoInfo.aid;
    if (aid != null) {
      await ref
          .read(videoInteractionNotifierProvider(videoInfo.bvid, aid).notifier)
          .recordShare();
    }

    try {
      await Clipboard.setData(
        ClipboardData(
          text: 'https://www.bilibili.com/video/${videoInfo.bvid}',
        ),
      );
      if (context.mounted) {
        context.showSnackBar(context.l10n.copiedToClipboard);
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar(context.l10n.videoCopyFailedWithError('$e'));
      }
    }
  }

  Future<({int multiply, bool alsoLike})?> _showCoinDialog(
    BuildContext context,
    VideoInteractionState interactionState,
  ) {
    final remainingCoins = (2 - interactionState.coinsGiven).clamp(0, 2);
    var multiply = remainingCoins >= 2 ? 2 : 1;
    var alsoLike = !interactionState.isLiked;

    return showDialog<({int multiply, bool alsoLike})>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(context.l10n.videoCoinDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<int>(
                    value: 1,
                    groupValue: multiply,
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() => multiply = value);
                    },
                    title: Text(context.l10n.videoCoinOne),
                  ),
                  RadioListTile<int>(
                    value: 2,
                    groupValue: multiply,
                    onChanged: remainingCoins >= 2
                        ? (value) {
                            if (value == null) return;
                            setDialogState(() => multiply = value);
                          }
                        : null,
                    title: Text(context.l10n.videoCoinTwo),
                  ),
                  CheckboxListTile(
                    value: alsoLike,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setDialogState(() => alsoLike = value ?? false);
                    },
                    title: Text(context.l10n.videoCoinAlsoLike),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(context.l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(
                    (multiply: multiply, alsoLike: alsoLike),
                  ),
                  child: Text(context.l10n.confirm),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _ensureLoggedIn(BuildContext context) async {
    final user = await ref.read(authNotifierProvider.future);
    if (user != null && user.isLoggedIn && user.biliJct.isNotEmpty) {
      return true;
    }
    if (context.mounted) {
      context.showSnackBar(context.l10n.pleaseLoginFirst);
    }
    return false;
  }

  Future<void> _playParsedVideo(
    BuildContext context,
    BvidInfo videoInfo,
    List<PageInfo> pages,
  ) async {
    final l10n = context.l10n;
    final pagesToPlay = pages.isNotEmpty ? pages : videoInfo.pages;
    if (pagesToPlay.isEmpty) return;

    final tracks = pagesToPlay
        .map(
          (page) => AudioTrack(
            songId: 0,
            bvid: videoInfo.bvid,
            cid: page.cid,
            title: pagesToPlay.length > 1 ? page.partTitle : videoInfo.title,
            artist: videoInfo.owner,
            coverUrl: videoInfo.coverUrl,
            duration: Duration(seconds: page.duration),
          ),
        )
        .toList();

    try {
      await ref
          .read(playerNotifierProvider.notifier)
          .playTrackList(tracks, 0, playlistName: videoInfo.title);
    } catch (e) {
      if (!context.mounted) return;
      context.showSnackBar(l10n.playFailedWithError(e.toString()));
    }
  }

  Future<void> _downloadParsedVideo(
    BuildContext context,
    BvidInfo videoInfo,
    List<PageInfo> pages,
  ) async {
    final l10n = context.l10n;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final pagesToDownload = pages.isNotEmpty ? pages : videoInfo.pages;
    if (pagesToDownload.isEmpty) return;

    try {
      final songIds =
          await ref.read(parseNotifierProvider.notifier).confirmSelection();

      ref.read(parseNotifierProvider.notifier).parseInput(videoInfo.bvid);

      final qualities = await ref
          .read(downloadNotifierProvider.notifier)
          .getAvailableQualities(
            bvid: videoInfo.bvid,
            cid: pagesToDownload.first.cid,
          );

      if (qualities.isEmpty) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.noQualities),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
          ),
        );
        return;
      }

      if (!context.mounted) return;
      final isLoggedIn = ref.read(authNotifierProvider).value != null;

      showDialog(
        context: context,
        builder: (_) => QualitySelectDialog(
          qualities: qualities,
          isLoggedIn: isLoggedIn,
          onSelect: (selected) async {
            var startedCount = 0;
            for (var i = 0; i < pagesToDownload.length; i++) {
              final page = pagesToDownload[i];
              final songId = i < songIds.length ? songIds[i] : songIds.last;
              final title =
                  pagesToDownload.length > 1 ? page.partTitle : videoInfo.title;
              final started = await ref
                  .read(downloadNotifierProvider.notifier)
                  .downloadSongWithQuality(
                    songId: songId,
                    bvid: videoInfo.bvid,
                    cid: page.cid,
                    quality: selected.quality,
                    title: title,
                  );
              if (started) startedCount++;
            }
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(l10n.downloadStartedCount(startedCount)),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(
                  bottom: 80,
                  left: 16,
                  right: 16,
                ),
              ),
            );
          },
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.downloadFailedWithError(e.toString())),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
    }
  }

  Future<void> _addToPlaylist(BuildContext context) async {
    final l10n = context.l10n;
    final selectedPlaylistId = await showDialog<int>(
      context: context,
      builder: (_) => const PlaylistPickerDialog(),
    );
    if (selectedPlaylistId == null || !context.mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final songIds = await ref
        .read(parseNotifierProvider.notifier)
        .confirmSelection(playlistId: selectedPlaylistId);

    if (context.mounted && songIds.isNotEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.addedSongsToPlaylist(songIds.length)),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
      ref.invalidate(playlistListNotifierProvider);
      ref.invalidate(playlistDetailNotifierProvider(selectedPlaylistId));
    }
  }

  Duration _videoDuration(BvidInfo videoInfo) {
    if (videoInfo.duration > 0) {
      return Duration(seconds: videoInfo.duration);
    }
    final totalSeconds = videoInfo.pages.fold<int>(
      0,
      (sum, page) => sum + page.duration,
    );
    return Duration(seconds: totalSeconds);
  }

  String _formatCompactCount(BuildContext context, int count) {
    return NumberFormat.compact(locale: context.l10n.localeName).format(count);
  }

  String _formatPubdate(int timestampSeconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestampSeconds * 1000,
    );
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  String _localizedInteractionError(BuildContext context, String message) {
    if (message.contains('pleaseLoginFirst')) {
      return context.l10n.pleaseLoginFirst;
    }
    return message;
  }

  double _contentMaxWidth(double availableWidth) {
    return availableWidth >= 960 ? 920.0 : double.infinity;
  }

  double _mediaMaxWidth(double availableWidth) {
    return availableWidth >= 840 ? 680.0 : double.infinity;
  }
}

class _VideoDetailTabsDelegate extends SliverPersistentHeaderDelegate {
  const _VideoDetailTabsDelegate({
    required this.videoInfo,
    required this.maxWidth,
  });

  static const double height = kTextTabBarHeight;

  final BvidInfo videoInfo;
  final double maxWidth;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: context.appPalette.backgroundPrimary,
      child: _VideoDetailTabs(videoInfo: videoInfo, maxWidth: maxWidth),
    );
  }

  @override
  bool shouldRebuild(covariant _VideoDetailTabsDelegate oldDelegate) {
    return oldDelegate.videoInfo.bvid != videoInfo.bvid ||
        oldDelegate.videoInfo.stats.reply != videoInfo.stats.reply ||
        oldDelegate.maxWidth != maxWidth;
  }
}

class _VideoDetailTabs extends StatelessWidget {
  const _VideoDetailTabs({
    required this.videoInfo,
    required this.maxWidth,
  });

  final BvidInfo videoInfo;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: palette.borderSubtle,
            width: context.appDepth.outline,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: TabBar(
            labelColor: palette.accentStrong,
            unselectedLabelColor: palette.textSecondary,
            indicatorColor: palette.accentStrong,
            tabs: [
              Tab(text: context.l10n.videoIntroTab),
              Tab(text: context.l10n.videoCommentsTab(videoInfo.stats.reply)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteFolderPicker extends ConsumerWidget {
  const _FavoriteFolderPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(videoFavoriteFoldersProvider);
    final spacing = context.appSpacing;

    return SafeArea(
      child: SizedBox(
        height: 420,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
                  EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.sm),
              child: Text(
                context.l10n.selectFavFolder,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.appPalette.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: foldersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _FolderPickerMessage(
                  message: error.toString().contains('pleaseLoginFirst')
                      ? context.l10n.pleaseLoginFirst
                      : context.l10n.videoFavoriteFolderLoadFailed,
                  onRetry: () => ref.invalidate(videoFavoriteFoldersProvider),
                ),
                data: (folders) {
                  if (folders.isEmpty) {
                    return _FolderPickerMessage(
                      message: context.l10n.favFolderEmpty,
                      onRetry: () =>
                          ref.invalidate(videoFavoriteFoldersProvider),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      spacing.sm,
                      0,
                      spacing.sm,
                      spacing.md,
                    ),
                    itemCount: folders.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final folder = folders[index];
                      return ListTile(
                        leading: const Icon(Icons.folder_outlined),
                        title: Text(
                          folder.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          context.l10n.biliFavSongCount(folder.mediaCount),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.appPalette.textSecondary,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pop(folder),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FolderPickerMessage extends StatelessWidget {
  const _FolderPickerMessage({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.appSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.appPalette.textSecondary,
              ),
            ),
            SizedBox(height: context.appSpacing.sm),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractionActionButton extends StatelessWidget {
  const _InteractionActionButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.selected,
    required this.isBusy,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String count;
  final bool selected;
  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final color = selected ? palette.accentStrong : palette.textSecondary;

    return Tooltip(
      message: label,
      child: SizedBox(
        width: 82,
        height: 72,
        child: Material(
          color: selected
              ? palette.accentSoft.withValues(alpha: 0.58)
              : palette.surfaceSecondary.withValues(alpha: 0.5),
          borderRadius: context.appRadii.largeRadius,
          child: InkWell(
            borderRadius: context.appRadii.largeRadius,
            onTap: isBusy ? null : onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: context.appRadii.largeRadius,
                border: Border.all(
                  color: selected
                      ? palette.accentStrong.withValues(alpha: 0.36)
                      : palette.borderSubtle,
                  width: context.appDepth.outline,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appSpacing.xs,
                  vertical: context.appSpacing.xs,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: 22),
                    SizedBox(height: context.appSpacing.xxs),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      count,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton({
    required this.tooltip,
    required this.onPressed,
  });

  static const double dimension = 44;

  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Material(
      color: palette.surfacePrimary.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: palette.borderSubtle,
            width: context.appDepth.outline,
          ),
          boxShadow: context.appDepth.floatingShadow,
        ),
        child: SizedBox.square(
          dimension: dimension,
          child: IconButton(
            tooltip: tooltip,
            padding: EdgeInsets.zero,
            onPressed: onPressed,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: palette.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayBadge extends StatelessWidget {
  const _OverlayBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.appSpacing.sm,
        vertical: context.appSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: context.appPalette.overlayStrong.withValues(alpha: 0.62),
        borderRadius: context.appRadii.pillRadius,
      ),
      child: Text(
        label,
        style: context.textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TinyLabel extends StatelessWidget {
  const _TinyLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.appSpacing.xs,
        vertical: context.appSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: palette.accentSoft.withValues(alpha: 0.58),
        borderRadius: context.appRadii.pillRadius,
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: palette.accentStrong,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _VideoBadge extends StatelessWidget {
  const _VideoBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final color = palette.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.appSpacing.sm,
        vertical: context.appSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceSecondary.withValues(alpha: 0.72),
        borderRadius: context.appRadii.pillRadius,
        border: Border.all(
          color: color.withValues(alpha: 0.22),
          width: context.appDepth.outline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          SizedBox(width: context.appSpacing.xxs),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _PageSelectionRow extends StatelessWidget {
  const _PageSelectionRow({
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  final PageInfo page;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final palette = context.appPalette;

    return Material(
      color: isSelected
          ? palette.accentSoft.withValues(alpha: 0.5)
          : palette.surfacePrimary.withValues(alpha: 0.42),
      borderRadius: context.appRadii.largeRadius,
      child: InkWell(
        borderRadius: context.appRadii.largeRadius,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: context.appRadii.largeRadius,
            border: Border.all(
              color: isSelected
                  ? palette.accentStrong.withValues(alpha: 0.42)
                  : palette.borderSubtle.withValues(alpha: 0.72),
              width: context.appDepth.outline,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs,
            ),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                ),
                SizedBox(width: spacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'P${page.page} ${page.partTitle}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      Text(
                        Formatters.formatDuration(
                          Duration(seconds: page.duration),
                        ),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
