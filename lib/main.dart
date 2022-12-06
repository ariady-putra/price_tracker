import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) => log(
        details.exceptionAsString(),
        stackTrace: details.stack,
      );

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runZonedGuarded(
    () => runApp(
      MyApp(settingsController: settingsController),
    ),
    (error, stack) => log(
      '$error',
      stackTrace: stack,
    ),
  );
}
