import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../localization/locale_keys.g.dart';
import 'login_screen_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(title: AutoSizeText(LocaleKeys.title.tr())),
      body: Center(
        child: state.isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                child: AutoSizeText(LocaleKeys.buttons_titles_login.tr()),
                onPressed: () async {
                  await ref
                      .read(loginScreenControllerProvider.notifier)
                      .didTapLogin();
                },
              ),
      ),
    );
  }
}
