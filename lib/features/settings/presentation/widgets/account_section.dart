import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/application/auth_notifier.dart';

/// Account section: login/logout.
class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final l10n = context.l10n;

    return authState.when(
      loading: () => const ListTile(
        leading: CircularProgressIndicator(),
        title: Text('...'),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (user) {
        if (user != null) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.nickname),
            subtitle: Text('UID: ${user.userId}'),
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
        return ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(l10n.login),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/login'),
        );
      },
    );
  }
}
