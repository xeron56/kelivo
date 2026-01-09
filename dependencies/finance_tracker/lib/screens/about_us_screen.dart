import 'package:flutter/material.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/app/global/values.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void showErrorSnackbar() {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Cannot open link")));
    }

    Future<void> launchWebsite(link) async {
      final Uri url = Uri.parse(link);

      if (!await launchUrl(url)) {
        showErrorSnackbar();
      }
    }

    Widget buildAttribution(
        String packageName, String description, String url, String license) {
      return ListTile(
        onTap: () {
          launchWebsite(url);
        },
        title: Text(packageName),
        subtitle: Text(description),
        trailing: Text(
          'License: $license',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('About us'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: smallWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    child: CircleAvatar(
                      minRadius: 50,
                      child: Center(
                        child: Image.asset(
                          "assets/icons/app_logo.png",
                          width: 128,
                          height: 128,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                  child: Text(
                    appName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    appVersion,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    "Pursenal is a free and open-source (FOSS) cash register app designed for personal and business finance management. Built with Flutter, it runs seamlessly on multiple platforms. Users can create multiple profiles, track income and expenses across cash, bank, credit cards, and loans, and manage finances in a wide variety of currencies. The app features insightful charts, budget tracking, and continues to evolve with new features, making financial management simple and efficient.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.8,
                        ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Text(
                      'License:',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Text(
                    'Pursenal is licensed under the GNU General Public License v3 (GPL v3).  ',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      child: Text(
                        "Contact us:",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.8,
                            ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          launchWebsite("mailto:kaashier@gmail.com");
                        },
                        child: const Text("kaashier@gmail.com"))
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Third-Party Libraries Attributions:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 10),
                buildAttribution(
                    'flutter',
                    'Flutter framework for building cross-platform apps.',
                    'https://flutter.dev/',
                    'BSD-3'),
                buildAttribution(
                    'flutter_localizations',
                    'Provides localizations for Flutter applications.',
                    'https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html',
                    'BSD-3'),
                buildAttribution(
                    'provider',
                    'A wrapper around InheritedWidget to manage state in Flutter apps.',
                    'https://pub.dev/packages/provider',
                    'MIT'),
                buildAttribution(
                    'drift',
                    'Reactive persistence library for Dart and Flutter, built on SQLite.',
                    'https://pub.dev/packages/drift',
                    'Apache-2.0'),
                buildAttribution(
                    'drift_flutter',
                    'Flutter bindings for Drift, a reactive persistence library.',
                    'https://pub.dev/packages/drift_flutter',
                    'Apache-2.0'),
                buildAttribution(
                    'ffi',
                    'Foreign Function Interface for calling C libraries in Dart.',
                    'https://pub.dev/packages/ffi',
                    'BSD-3'),
                buildAttribution(
                    'sqlite3_flutter_libs',
                    'Flutter-native sqlite3 implementation.',
                    'https://pub.dev/packages/sqlite3_flutter_libs',
                    'MIT'),
                buildAttribution(
                    'path_provider',
                    'Flutter plugin for accessing file system paths.',
                    'https://pub.dev/packages/path_provider',
                    'BSD-3'),
                buildAttribution(
                    'path',
                    'A string-based path manipulation library for Dart.',
                    'https://pub.dev/packages/path',
                    'BSD-3'),
                buildAttribution(
                    'intl',
                    'Provides internationalization and localization support.',
                    'https://pub.dev/packages/intl',
                    'BSD-3'),
                buildAttribution(
                    'cupertino_icons',
                    'Icon pack for Cupertino (iOS) themed apps.',
                    'https://pub.dev/packages/cupertino_icons',
                    'MIT'),
                buildAttribution(
                    'logger',
                    'A simple, extensible logging package for Dart apps.',
                    'https://pub.dev/packages/logger',
                    'MIT'),
                buildAttribution(
                    'image_picker',
                    'Flutter plugin for selecting images and videos from the gallery.',
                    'https://pub.dev/packages/image_picker',
                    'BSD-3'),
                buildAttribution(
                    'collection',
                    'A collection of useful utilities for working with Dart collections.',
                    'https://pub.dev/packages/collection',
                    'MIT'),
                buildAttribution(
                    'shared_preferences',
                    'Flutter plugin for storing key-value pairs on the device.',
                    'https://pub.dev/packages/shared_preferences',
                    'BSD-3'),
                buildAttribution(
                    'adaptive_theme',
                    'A lightweight theme management package for Flutter apps.',
                    'https://pub.dev/packages/adaptive_theme',
                    'MIT'),
                buildAttribution(
                    'permission_handler',
                    'A Flutter plugin for managing permissions on iOS and Android.',
                    'https://pub.dev/packages/permission_handler',
                    'MIT'),
                buildAttribution(
                    'device_info_plus',
                    'Provides device and OS information in Flutter apps.',
                    'https://pub.dev/packages/device_info_plus',
                    'MIT'),
                buildAttribution(
                    'fl_chart',
                    'A highly customizable Flutter chart library.',
                    'https://pub.dev/packages/fl_chart',
                    'MIT'),
                buildAttribution(
                    'file_picker',
                    'Flutter plugin for picking files from the device.',
                    'https://pub.dev/packages/file_picker',
                    'MIT'),
                buildAttribution(
                    'archive',
                    'Provides ZIP and TAR archive support for Dart.',
                    'https://pub.dev/packages/archive',
                    'MIT'),
                buildAttribution(
                    'pdf',
                    'Flutter plugin for generating and working with PDF files.',
                    'https://pub.dev/packages/pdf',
                    'Apache-2.0'),
                buildAttribution(
                    'open_filex',
                    'Plugin to open files using platform-native applications.',
                    'https://pub.dev/packages/open_filex',
                    'MIT'),
                buildAttribution(
                    'excel',
                    'Flutter package for reading and writing Excel files.',
                    'https://pub.dev/packages/excel',
                    'MIT'),
                buildAttribution(
                    'flutter_local_notifications',
                    'A plugin for displaying local notifications in Flutter.',
                    'https://pub.dev/packages/flutter_local_notifications',
                    'BSD-3'),
                buildAttribution(
                    'timezone',
                    'Provides timezone support for Dart applications.',
                    'https://pub.dev/packages/timezone',
                    'MIT'),
                buildAttribution(
                    'url_launcher',
                    'A Flutter plugin for launching a URL.',
                    'https://pub.dev/packages/url_launcher',
                    'BSD-3'),
                buildAttribution(
                    'flutter_test',
                    'Testing library for Flutter applications.',
                    'https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html',
                    'BSD-3'),
                buildAttribution(
                    'drift_dev',
                    'Code generation package for Drift (reactive persistence library).',
                    'https://pub.dev/packages/drift_dev',
                    'Apache-2.0'),
                buildAttribution(
                    'build_runner',
                    'A build system for Dart applications.',
                    'https://pub.dev/packages/build_runner',
                    'MIT'),
                buildAttribution(
                    'flutter_lints',
                    'Recommended lints for Flutter projects.',
                    'https://pub.dev/packages/flutter_lints',
                    'MIT'),
                buildAttribution(
                    'flutter_launcher_icons',
                    'Flutter package for generating app launcher icons.',
                    'https://pub.dev/packages/flutter_launcher_icons',
                    'MIT'),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

