import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../application/auth_notifier.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../shared/extensions/context_extensions.dart';

/// Login screen with QR code display and cookie login for Bilibili authentication.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  String? _qrUrl;
  String _statusText = '';
  bool _isLoading = false;
  bool _isExpired = false;
  bool _initialized = false;

  late TabController _tabController;

  // Cookie login fields
  final _sessdataController = TextEditingController();
  final _biliJctController = TextEditingController();
  final _dedeUserIdController = TextEditingController();
  bool _isCookieLogging = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sessdataController.dispose();
    _biliJctController.dispose();
    _dedeUserIdController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _generateQrCode();
    }
  }

  Future<void> _generateQrCode() async {
    setState(() {
      _isLoading = true;
      _isExpired = false;
      _statusText = context.l10n.scanToLogin;
    });
    try {
      final url = await ref.read(authNotifierProvider.notifier).login(
        onScanned: () {
          if (mounted) {
            setState(() {
              _statusText = '已扫码，请在手机上确认';
            });
          }
        },
        onExpired: () {
          if (mounted) {
            setState(() {
              _isExpired = true;
              _statusText = '二维码已过期，请刷新';
            });
          }
        },
      );
      setState(() {
        _qrUrl = url;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusText = context.l10n.loginFailed;
      });
    }
  }

  Future<void> _loginWithCookie() async {
    final sessdata = _sessdataController.text.trim();
    final biliJct = _biliJctController.text.trim();
    final dedeUserId = _dedeUserIdController.text.trim();

    if (sessdata.isEmpty || biliJct.isEmpty || dedeUserId.isEmpty) {
      if (mounted) {
        context.showSnackBar('请填写所有Cookie字段');
      }
      return;
    }

    setState(() => _isCookieLogging = true);
    try {
      await ref.read(authNotifierProvider.notifier).loginWithCookie(
            sessdata: sessdata,
            biliJct: biliJct,
            dedeUserId: dedeUserId,
          );
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Cookie登录失败: $e');
      }
    } finally {
      if (mounted) setState(() => _isCookieLogging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(authNotifierProvider);
    final colorScheme = context.colorScheme;

    // If logged in, navigate back
    ref.listen(authNotifierProvider, (prev, next) {
      next.whenData((user) {
        if (user != null) {
          if (context.mounted) {
            context.showSnackBar(context.l10n.loginSuccess);
            context.go('/');
          }
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: GestureDetector(
          onPanStart: PlatformUtils.isDesktop
              ? (_) => windowManager.startDragging()
              : null,
          child: Text(context.l10n.login),
        ),
        titleSpacing: 0,
        flexibleSpace: PlatformUtils.isDesktop
            ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (_) => windowManager.startDragging(),
              )
            : null,
        actions: [
          if (PlatformUtils.isDesktop) ...[
            IconButton(
              icon: const Icon(Icons.minimize, size: 18),
              onPressed: () => windowManager.minimize(),
            ),
            IconButton(
              icon: const Icon(Icons.crop_square, size: 18),
              onPressed: () async {
                if (await windowManager.isMaximized()) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => windowManager.hide(),
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '扫码登录'),
            Tab(text: 'Cookie登录'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── QR Code Tab ──
          _buildQrCodeTab(colorScheme),
          // ── Cookie Tab ──
          _buildCookieTab(colorScheme),
        ],
      ),
    );
  }

  Widget _buildQrCodeTab(ColorScheme colorScheme) {
    return SingleChildScrollView(
      child: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.music_note, size: 48, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text('BuSic', style: context.textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary, fontWeight: FontWeight.bold,
              )),
              const SizedBox(height: 32),
              if (_isLoading)
                const SizedBox(
                  width: 200, height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_qrUrl != null && !_isExpired)
                QrImageView(
                  data: _qrUrl!,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                )
              else
                SizedBox(
                  width: 200, height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 48, color: colorScheme.error),
                        const SizedBox(height: 8),
                        Text(context.l10n.loginFailed),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Text(_statusText, style: context.textTheme.bodyLarge),
              const SizedBox(height: 16),
              if (_isExpired || (!_isLoading && _qrUrl == null))
                FilledButton.icon(
                  onPressed: _generateQrCode,
                  icon: const Icon(Icons.refresh),
                  label: Text(context.l10n.reset),
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildCookieTab(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cookie登录',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '从浏览器中获取B站Cookie后填入以下字段。\n'
                '在 bilibili.com 按 F12 → 应用 → Cookie → 找到对应值。',
                style: context.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _sessdataController,
                decoration: const InputDecoration(
                  labelText: 'SESSDATA',
                  hintText: '粘贴 SESSDATA 值',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cookie_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _biliJctController,
                decoration: const InputDecoration(
                  labelText: 'bili_jct',
                  hintText: '粘贴 bili_jct 值',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cookie_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dedeUserIdController,
                decoration: const InputDecoration(
                  labelText: 'DedeUserID',
                  hintText: '粘贴 DedeUserID 值',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outlined),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isCookieLogging ? null : _loginWithCookie,
                  icon: _isCookieLogging
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.login),
                  label: Text(_isCookieLogging ? '登录中...' : '登录'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
