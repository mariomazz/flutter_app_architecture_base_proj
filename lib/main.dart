import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';
import 'src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await runZonedGuarded<Future<void>>(
    () async {
      setPathUrlStrategy();
      await EasyLocalization.ensureInitialized();
      return runApp(EasyLocalization(
          path: 'assets/l10n',
          supportedLocales: const [Locale('it', 'IT'), Locale('en', 'US')],
          fallbackLocale: const Locale('en', 'US'),
          child: const ProviderScope(child: TestPaginator())));
    },
    (err, stacktrace) {
      if (kDebugMode) {
        print("MAIN Exception => ${err.toString()}");
      }
    },
  );
}
