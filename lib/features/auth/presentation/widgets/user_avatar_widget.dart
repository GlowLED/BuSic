import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../application/auth_notifier.dart';

/// Widget displaying the current user's avatar or a login button.
class UserAvatarWidget extends ConsumerWidget {
  const UserAvatarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return authState.when(
      data: (user) {
        if (user != null && user.isLoggedIn) {
          return GestureDetector(
            onTap: () => context.go('/settings'),
            child: Tooltip(
              message: user.nickname,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: user.avatarUrl != null
                    ? CachedNetworkImageProvider(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(user.nickname.isNotEmpty ? user.nickname[0] : '?',
                        style: TextStyle(color: colorScheme.onPrimaryContainer))
                    : null,
              ),
            ),
          );
        }
        return IconButton(
          icon: Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
          tooltip: 'Login',
          onPressed: () => context.go('/login'),
        );
      },
      loading: () => const SizedBox(
        width: 36, height: 36,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => IconButton(
        icon: Icon(Icons.person_outline, color: colorScheme.onSurfaceVariant),
        onPressed: () => context.go('/login'),
      ),
    );
  }
}
