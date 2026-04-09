// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get signInTitle => 'Iniciar sesión';

  @override
  String get signUpTitle => 'Crea una cuenta nueva';

  @override
  String get emailFormDescription => 'Tu e-mail';

  @override
  String get passwordFormDescription => 'Contraseña';

  @override
  String get accountQuestion => '¿Ya tienes una cuenta?';

  @override
  String get accountSuggestion => 'Inicia sesión';

  @override
  String get noAccountQuestion => '¿No tienes una cuenta?';

  @override
  String get noAccountSuggestion => 'Regístrate';
}
