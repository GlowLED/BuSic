import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/application/auth_notifier.dart';
import 'settings_panel.dart';

/// Account section: login/logout.
class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final l10n = context.l10n;

    return SettingsSectionPanel(
      title: l10n.accountSettings,
      icon: Icons.person_rounded,
      children: [
        authState.when(
          loading: () => SettingsTile(
            icon: Icons.sync_rounded,
            title: l10n.loadingAccount,
            trailing: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => SettingsTile(
            icon: Icons.error_outline_rounded,
            title: l10n.loginFailed,
            subtitle: l10n.pleaseLoginFirst,
          ),
          data: (user) {
            if (user != null) {
              return SettingsTile(
                icon: Icons.person_rounded,
                title: user.nickname,
                subtitle: 'UID: ${user.userId}',
                trailing: TextButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.logout),
                        content: Text(l10n.logoutConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: Text(l10n.confirm),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      ref.read(authNotifierProvider.notifier).logout();
                    }
                  },
                  child: Text(l10n.logout),
                ),
              );
            }
            return SettingsTile(
              icon: Icons.person_outline_rounded,
              title: l10n.login,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.go('/login'),
            );
          },
        ),
      ],
    );
  }
}
