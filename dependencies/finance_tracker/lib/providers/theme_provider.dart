import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finance_tracker/app/extensions/color.dart';
import 'package:finance_tracker/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final lightTextColor = Colors.grey.shade700;
  final lightCardColor = Colors.grey.shade100;
  final lightScaffoldBGColor = const Color(0xFFFEFBFF);
  final lightMainTitleColor = Colors.grey.shade900;
  final lightPageTitleColor = Colors.blueGrey.shade700;

  final darkTextColor = Colors.grey.shade100;
  final darkCardColor = Colors.grey.shade800;
  final darkScaffoldBGColor = const Color(0xFF1A1B21);
  final darkMainTitleColor = Colors.blue.shade400;
  final darkPageTitleColor = Colors.blueAccent.shade100;

  MaterialColor _primaryColor = Colors.indigo;
  MaterialColor get primaryColor => _primaryColor;

  // Defaults matching Main App
  Color primary700 = const Color(0xFF4D5C92);
  Color primary50 = const Color(0xFFDCE1FF); // primaryContainer
  Color primary200 = const Color(0xFFB6C4FF); // inversePrimary

  // Keep these for compatibility if needed, but we rely on ColorScheme mostly
  Color primary400 = const Color(0xFF595D72);
  Color primary500 = const Color(0xFF4D5C92);
  Color primary600 = const Color(0xFF4D5C92);
  Color primary800 = const Color(0xFF354479);
  Color primary900 = const Color(0xFF03174B);
  Color primary100 = const Color(0xFFDCE1FF);

  // Grey Colors
  final Color grey100 = Colors.grey.shade100;
  final Color grey200 = Colors.grey.shade200;
  final Color grey300 = Colors.grey.shade300;
  final Color grey500 = Colors.grey;
  final Color grey700 = Colors.grey.shade700;
  final Color grey800 = Colors.grey.shade800;
  final Color grey900 = Colors.grey.shade900;

  // BlueGrey Colors
  final Color blueGrey50 = Colors.blueGrey.shade50;
  final Color blueGrey100 = Colors.blueGrey.shade100;
  final Color blueGrey200 = Colors.blueGrey.shade200;
  final Color blueGrey400 = Colors.blueGrey.shade400;
  final Color blueGrey500 = Colors.blueGrey.shade500;
  final Color blueGrey700 = Colors.blueGrey.shade700;
  final Color blueGrey800 = Colors.blueGrey.shade800;
  final Color blueGrey900 = Colors.blueGrey.shade900;

  // Other common colors
  final Color white = Colors.white;
  final Color transparent = Colors.transparent;

  final elevatedBtnRadius = 8.0;
  final cardRadius = 12.0;

  // Preferences instance
  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      notifyListeners();

      _prefs = await SharedPreferences.getInstance();
      _primaryColor =
          (await getPrimaryColor())?.hexToMaterialColor() ?? Colors.blue;
      await _getFont();
      setColors();
      notifyListeners();
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');

      notifyListeners();
    }
  }

  setColors() {
    primary700 = _primaryColor[700] ?? Colors.blue.shade700;
    primary50 = _primaryColor[50] ?? Colors.blue.shade50;
    primary200 = _primaryColor[200] ?? Colors.blue.shade200;
    primary400 = _primaryColor[400] ?? Colors.blue.shade400;
    primary500 = _primaryColor[500] ?? Colors.blue.shade500;
    primary600 = _primaryColor[600] ?? Colors.blue.shade600;
    primary700 =
        _primaryColor[700] ??
        Colors.blueAccent.shade700; // also used as the primary color
    primary800 = _primaryColor[800] ?? Colors.blue.shade800;
    primary900 = _primaryColor[900] ?? Colors.blue.shade900;
    primary100 = _primaryColor[100] ?? Colors.blueAccent.shade100;
    notifyListeners();
  }

  String _selectedFont = 'Ubuntu'; // Default font

  String get selectedFont => _selectedFont;

  set primaryColor(MaterialColor value) {
    try {
      _primaryColor = value;
      setPrimaryColor(value.toHex());
      setColors();
    } catch (e) {
      AppLogger.instance.error(' ${e.toString()}');
    }
    notifyListeners();
  }

  Future<String?> getPrimaryColor() async {
    try {
      return _prefs?.getString('primaryColor');
    } catch (e) {
      AppLogger.instance.error("Error selecting primary color ${e.toString()}");
      return null;
    }
  }

  Future<void> setPrimaryColor(String color) async {
    try {
      _prefs?.setString('primaryColor', color);
    } catch (e) {
      AppLogger.instance.error("Error setting primary color ${e.toString()}");
    }
  }

  Future<void> _getFont() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedFont = prefs.getString('selectedFont') ?? 'OpenSans';
    notifyListeners();
  }

  Future<void> setFont(String font) async {
    _selectedFont = font;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedFont', font);
    notifyListeners();
  }

  ThemeData getLightTheme() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4D5C92),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFDCE1FF),
      onPrimaryContainer: Color(0xFF03174B),
      secondary: Color(0xFF595D72),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFDEE1F9),
      onSecondaryContainer: Color(0xFF161B2C),
      tertiary: Color(0xFF75546F),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFD7F6),
      onTertiaryContainer: Color(0xFF2C122A),
      error: Color(0xFFBB0947),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFDDADE),
      onErrorContainer: Color(0xFF400013),
      surface: Color(0xFFFEFBFF),
      onSurface: Color(0xFF1A1B21),
      onSurfaceVariant: Color(0xFF45464F),
      outline: Color(0xFF75757F),
      outlineVariant: Color(0xFFC6C6D0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2F3036),
      onInverseSurface: Color(0xFFF1F0F7),
      inversePrimary: Color(0xFFB6C4FF),
      surfaceTint: Color(0xFF4D5C92),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: _selectedFont,
      scaffoldBackgroundColor: scheme.surface,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        elevation: 0,
        indicatorColor: scheme.secondaryContainer,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: scheme.onInverseSurface,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actionTextColor: scheme.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.black, size: 20),
        actionsIconTheme: const IconThemeData(color: Colors.black, size: 20),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 40),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(elevatedBtnRadius),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: scheme.surfaceContainerHighest.withOpacity(0.5),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.primary, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        labelStyle: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
      ),
      // Compact Text TextTheme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: scheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: scheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
        bodyLarge: TextStyle(color: scheme.onSurface, fontSize: 14),
        bodyMedium: TextStyle(color: scheme.onSurface, fontSize: 13),
        bodySmall: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11),
        labelLarge: TextStyle(
          color: scheme.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11),
        labelSmall: TextStyle(color: scheme.onSurfaceVariant, fontSize: 10),
      ),
      iconTheme: IconThemeData(size: 20, color: scheme.onSurface),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        iconSize: 24,
        sizeConstraints: const BoxConstraints(minHeight: 56, minWidth: 56),
      ),
    );
  }

  ThemeData getDarkTheme() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFB6C4FF),
      onPrimary: Color(0xFF1D2D61),
      primaryContainer: Color(0xFF354479),
      onPrimaryContainer: Color(0xFFDCE1FF),
      secondary: Color(0xFFC2C5DD),
      onSecondary: Color(0xFF2B3042),
      secondaryContainer: Color(0xFF424659),
      onSecondaryContainer: Color(0xFFDEE1F9),
      tertiary: Color(0xFFE3BADA),
      onTertiary: Color(0xFF432740),
      tertiaryContainer: Color(0xFF5B3D57),
      onTertiaryContainer: Color(0xFFFFD7F6),
      error: Color(0xFFFCB4BD),
      onError: Color(0xFF670023),
      errorContainer: Color(0xFF910034),
      onErrorContainer: Color(0xFFFCB4BD),
      surface: Color(0xFF1A1B21),
      onSurface: Color(0xFFE3E1E9),
      onSurfaceVariant: Color(0xFFC6C6D0),
      outline: Color(0xFF90909A),
      outlineVariant: Color(0xFF45464F),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE3E1E9),
      onInverseSurface: Color(0xFF2F3036),
      inversePrimary: Color(0xFF4D5C92),
      surfaceTint: Color(0xFFB6C4FF),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: _selectedFont,
      scaffoldBackgroundColor: scheme.surface,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        elevation: 0,
        indicatorColor: scheme.secondaryContainer,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: scheme.onInverseSurface,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actionTextColor: scheme.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 20),
        actionsIconTheme: const IconThemeData(color: Colors.white, size: 20),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 40),
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(elevatedBtnRadius),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: scheme.surfaceContainerHighest.withOpacity(0.5),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.primary, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        labelStyle: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
      ),
      // Compact Text TextTheme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: scheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: scheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
        bodyLarge: TextStyle(color: scheme.onSurface, fontSize: 14),
        bodyMedium: TextStyle(color: scheme.onSurface, fontSize: 13),
        bodySmall: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11),
        labelLarge: TextStyle(
          color: scheme.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11),
        labelSmall: TextStyle(color: scheme.onSurfaceVariant, fontSize: 10),
      ),
      iconTheme: IconThemeData(size: 20, color: scheme.onSurface),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        iconSize: 24,
        sizeConstraints: const BoxConstraints(minHeight: 56, minWidth: 56),
      ),
    );
  }
}
