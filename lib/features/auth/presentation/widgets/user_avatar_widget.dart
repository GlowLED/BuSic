import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget displaying the current user's avatar or a login button.
///
/// - Logged in: shows circular avatar with user's profile picture
/// - Logged out: shows a person icon button that navigates to login
class UserAvatarWidget extends ConsumerWidget {
  const UserAvatarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement avatar / login button
    // - Watch authNotifierProvider
    // - If logged in: CircleAvatar with cached_network_image
    // - If logged out: IconButton(Icons.person) → go to /login
    return const SizedBox.shrink();
  }
}
