// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signInTitle => 'Sign In';

  @override
  String get signUpTitle => 'Create a new account';

  @override
  String get emailFormDescription => 'Your e-mail';

  @override
  String get passwordFormDescription => 'Password';

  @override
  String get accountQuestion => 'Already have an account?';

  @override
  String get accountSuggestion => 'Sign in';

  @override
  String get noAccountQuestion => 'Don\'t have an account?';

  @override
  String get noAccountSuggestion => 'Register';
}
