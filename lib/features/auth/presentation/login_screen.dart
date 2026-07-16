import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:window_manager/window_manager.dart';

import '../application/auth_notifier.dart';
import '../application/web_login_providers.dart';
import '../data/bili_web_login_cookie_store.dart';
import '../data/linux_managed_browser_login_service.dart';
import '../domain/models/bili_login_cookies.dart';
import 'widgets/bili_web_login_view.dart';
import 'widgets/linux_managed_web_login_view.dart';
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
  bool _isWebLogging = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      final url = await ref
          .read(authNotifierProvider.notifier)
          .login(
            onScanned: () {
              if (mounted) {
                setState(() {
                  _statusText = context.l10n.qrScannedConfirm;
                });
              }
            },
            onExpired: () {
              if (mounted) {
                setState(() {
                  _isExpired = true;
                  _statusText = context.l10n.qrExpiredRefresh;
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
        context.showSnackBar(context.l10n.cookieRequired);
      }
      return;
    }

    setState(() => _isCookieLogging = true);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .loginWithCookie(
            sessdata: sessdata,
            biliJct: biliJct,
            dedeUserId: dedeUserId,
          );
    } catch (e) {
      if (mounted) {
        context.showSnackBar(context.l10n.cookieLoginFailedWithError('$e'));
      }
    } finally {
      if (mounted) setState(() => _isCookieLogging = false);
    }
  }

  Future<void> _loginWithWebCookies(
    BiliLoginCookies cookies,
    BiliWebLoginCookieStore cookieStore,
  ) async {
    await _loginWithCapturedWebCookies(
      cookies,
      cleanup: cookieStore.clearBiliCookies,
    );
  }

  Future<void> _loginWithManagedBrowserCookies(
    BiliLoginCookies cookies,
    LinuxManagedBrowserLoginSession session,
  ) async {
    await _loginWithCapturedWebCookies(cookies, cleanup: session.close);
  }

  Future<void> _loginWithCapturedWebCookies(
    BiliLoginCookies cookies, {
    required Future<void> Function() cleanup,
  }) async {
    if (_isWebLogging) return;

    setState(() => _isWebLogging = true);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .loginWithWebCookies(
            sessdata: cookies.sessdata,
            biliJct: cookies.biliJct,
            dedeUserId: cookies.dedeUserId,
          );
    } catch (e) {
      if (mounted) {
        context.showSnackBar(context.l10n.webLoginFailedWithError('$e'));
      }
    } finally {
      await cleanup();
      if (mounted) setState(() => _isWebLogging = false);
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
              icon: const Icon(Icons.horizontal_rule_rounded, size: 18),
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
          tabs: [
            Tab(text: context.l10n.qrLoginTab),
            Tab(text: context.l10n.webLoginTab),
            Tab(text: context.l10n.cookieLoginTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQrCodeTab(colorScheme),
          _buildWebLoginTab(colorScheme),
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
                Text(
                  context.l10n.appTitle,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const SizedBox(
                    width: 200,
                    height: 200,
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
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 48,
                            color: colorScheme.error,
                          ),
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

  Widget _buildWebLoginTab(ColorScheme colorScheme) {
    final hostPlatform = ref.watch(webLoginHostPlatformProvider);
    final availability = ref.watch(webLoginAvailabilityProvider);

    return availability.when(
      loading: () => _buildWebLoginStatusCard(
        colorScheme,
        icon: Icons.public_outlined,
        title: context.l10n.webLoginPreparing,
        description: context.l10n.webLoginDesc,
        isLoading: true,
      ),
      error: (error, stackTrace) => _buildWebLoginStatusCard(
        colorScheme,
        icon: Icons.public_off_outlined,
        title: context.l10n.webLoginInitFailedTitle,
        description: _webLoginInitFailedDescription(hostPlatform),
      ),
      data: (availability) {
        if (hostPlatform == WebLoginHostPlatform.linux) {
          return _buildLinuxWebLoginTab(colorScheme, availability);
        }

        switch (availability.status) {
          case WebLoginAvailabilityStatus.unsupportedPlatform:
            return _buildWebLoginStatusCard(
              colorScheme,
              icon: Icons.public_off_outlined,
              title: context.l10n.webLoginUnsupportedTitle,
              description: context.l10n.webLoginUnsupportedDesc,
            );
          case WebLoginAvailabilityStatus.browserMissing:
            return _buildWebLoginStatusCard(
              colorScheme,
              icon: Icons.web_asset_off_outlined,
              title: context.l10n.webLoginBrowserMissingTitle,
              description: context.l10n.webLoginBrowserMissingDesc,
            );
          case WebLoginAvailabilityStatus.webView2Missing:
            return _buildWebLoginStatusCard(
              colorScheme,
              icon: Icons.web_asset_off_outlined,
              title: context.l10n.webLoginWebView2MissingTitle,
              description: context.l10n.webLoginWebView2MissingDesc,
            );
          case WebLoginAvailabilityStatus.initializationFailed:
            return _buildWebLoginStatusCard(
              colorScheme,
              icon: Icons.public_off_outlined,
              title: context.l10n.webLoginInitFailedTitle,
              description: context.l10n.webLoginInitFailedDesc,
            );
          case WebLoginAvailabilityStatus.available:
            if (availability.mode == WebLoginMode.managedBrowser) {
              return _buildLinuxManagedWebLoginCard(colorScheme);
            }
            return _buildWebLoginCard(colorScheme, availability);
        }
      },
    );
  }

  Widget _buildLinuxWebLoginTab(
    ColorScheme colorScheme,
    WebLoginAvailability availability,
  ) {
    switch (availability.status) {
      case WebLoginAvailabilityStatus.browserMissing:
        return _buildWebLoginStatusCard(
          colorScheme,
          icon: Icons.web_asset_off_outlined,
          title: context.l10n.webLoginBrowserMissingTitle,
          description: context.l10n.webLoginBrowserMissingDesc,
        );
      case WebLoginAvailabilityStatus.initializationFailed:
        return _buildWebLoginStatusCard(
          colorScheme,
          icon: Icons.public_off_outlined,
          title: context.l10n.webLoginInitFailedTitle,
          description: context.l10n.webLoginLinuxStartFailed,
        );
      case WebLoginAvailabilityStatus.unsupportedPlatform:
        return _buildWebLoginStatusCard(
          colorScheme,
          icon: Icons.public_off_outlined,
          title: context.l10n.webLoginUnsupportedTitle,
          description: context.l10n.webLoginUnsupportedDesc,
        );
      case WebLoginAvailabilityStatus.webView2Missing:
      case WebLoginAvailabilityStatus.available:
        return _buildLinuxManagedWebLoginCard(colorScheme);
    }
  }

  String _webLoginInitFailedDescription(WebLoginHostPlatform hostPlatform) {
    return switch (hostPlatform) {
      WebLoginHostPlatform.linux => context.l10n.webLoginLinuxStartFailed,
      WebLoginHostPlatform.windows => context.l10n.webLoginInitFailedDesc,
      WebLoginHostPlatform.other => context.l10n.webLoginUnsupportedDesc,
    };
  }

  Widget _buildWebLoginCard(
    ColorScheme colorScheme,
    WebLoginAvailability availability,
  ) {
    final cookieStore = ref.watch(
      biliWebLoginCookieStoreProvider(availability.webViewEnvironment),
    );
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 4,
        child: Stack(
          children: [
            BiliWebLoginView(
              cookieStore: cookieStore,
              webViewEnvironment: availability.webViewEnvironment,
              onCookiesCaptured: (cookies) {
                _loginWithWebCookies(cookies, cookieStore);
              },
              onCookieMissing: () {
                context.showSnackBar(context.l10n.webLoginCookieMissing);
              },
            ),
            if (_isWebLogging)
              Positioned.fill(
                child: ColoredBox(
                  color: colorScheme.surface.withValues(alpha: 0.72),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(context.l10n.webLoginChecking),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinuxManagedWebLoginCard(ColorScheme colorScheme) {
    final loginService = ref.watch(linuxManagedBrowserLoginServiceProvider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 4,
        child: Stack(
          children: [
            LinuxManagedWebLoginView(
              loginService: loginService,
              isVerifying: _isWebLogging,
              onCookiesCaptured: (cookies, session) {
                return _loginWithManagedBrowserCookies(cookies, session);
              },
              onCookieMissing: () {
                context.showSnackBar(context.l10n.webLoginCookieMissing);
              },
            ),
            if (_isWebLogging)
              Positioned.fill(
                child: ColoredBox(
                  color: colorScheme.surface.withValues(alpha: 0.72),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(context.l10n.webLoginChecking),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebLoginStatusCard(
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String description,
    bool isLoading = false,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                title,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (isLoading) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
            ],
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
                context.l10n.cookieLoginTitle,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.cookieLoginDesc,
                style: context.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _sessdataController,
                decoration: InputDecoration(
                  labelText: 'SESSDATA',
                  hintText: context.l10n.cookieSessdataHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.cookie_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _biliJctController,
                decoration: InputDecoration(
                  labelText: 'bili_jct',
                  hintText: context.l10n.cookieBiliJctHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.cookie_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dedeUserIdController,
                decoration: InputDecoration(
                  labelText: 'DedeUserID',
                  hintText: context.l10n.cookieDedeUserIdHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person_outlined),
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
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    _isCookieLogging
                        ? context.l10n.loggingIn
                        : context.l10n.login,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
