import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testpaginator/src/config/themes/theme_light.dart';
import 'config/themes/theme_dark.dart';
import 'localization/locale_keys.g.dart';
import 'routes/router.dart';

class TestPaginator extends ConsumerWidget {
  const TestPaginator({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: LocaleKeys.title.tr(),
      theme: themeLight,
      darkTheme: themeDark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
