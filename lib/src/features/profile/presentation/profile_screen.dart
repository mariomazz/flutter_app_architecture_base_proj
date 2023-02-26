import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testpaginator/src/features/profile/presentation/profile_screen_controller.dart';
import '../../../localization/locale_keys.g.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.screens_titles_profile.tr()),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await ref
                .read(profileScreenControllerProvider.notifier)
                .didTapLogout();
          },
          child: Text(LocaleKeys.buttons_titles_logout.tr()),
        ),
      ),
    );
  }
}
