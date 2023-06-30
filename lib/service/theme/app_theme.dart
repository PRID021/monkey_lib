import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:monkey_lib/service/theme/colors/custom_theme_colors.dart';
import 'package:monkey_lib/service/theme/custom_text_form_field_theme.dart';
import 'package:monkey_lib/service/theme/fonts/custom_theme_text.dart';

import '../../main.dart';

/// This class is used to access the system's brightness mode and other functions.
///
/// [instance] is the instance of [SchedulerBinding].
/// [window] is the instance of [SingletonFlutterWindow].
/// [brightness] is the instance of [Brightness].
/// [isDarkMode] is the current brightness mode.

abstract class SystemUtils {
  static SchedulerBinding get instance => SchedulerBinding.instance;
  static SingletonFlutterWindow get window => instance.window;
  static Brightness get brightness => window.platformBrightness;
  static bool get isDarkMode => brightness == Brightness.dark;
}

/// This instance is used to mock the app's theme.
///
/// [appThemes] is the list of [AppTheme].
/// This mock data used [CustomThemeColors] and [CustomThemeText]
/// The [CustomThemeColors] and [CustomThemeText] are defined in [lib\service\theme\colors\custom_theme_colors.dart]
/// which are instances of [ThemeExtension] used to extend the [ThemeData].
///

List<AppTheme> appThemes = [
  AppTheme(themeSetTitle: "monkey", lightModeSet: {
    "monkey-first": ThemeData(primarySwatch: Colors.grey).copyWith(
      canvasColor: Color.fromARGB(255, 59, 33, 33),
      primaryColor: Color.fromARGB(255, 59, 33, 33),
      scaffoldBackgroundColor: Color(0xFFFFFFFF),
      dividerColor: Color(0xFFACACAC),
      iconTheme: IconThemeData().copyWith(
        color: Color(0xFF0088FF),
      ),
      extensions: <ThemeExtension>[
        CustomThemeColors.light,
        CustomThemeText.getLightCustomThemeText,
        CustomTextFormFieldTheme.light,
      ],
      useMaterial3: true,
    ),
  }, darkModeSet: {
    "monkey-first": ThemeData(primarySwatch: Colors.pink).copyWith(
      extensions: <ThemeExtension>[
        CustomThemeColors.dark,
        CustomThemeText.getDarkCustomThemeText,
        CustomTextFormFieldTheme.dark,
      ],
      scaffoldBackgroundColor: Color(0xFF2C2C2C),
      dividerColor: Color(0xFFACACAC),
      iconTheme: IconThemeData().copyWith(
        color: Color(0xFFFCFCFC),
      ),
      useMaterial3: true,
    ),
  }),
];

/// This class is used to define the theme of the app.
///
/// [themeSetTitle] is the title of the theme.
/// [lightModeSet] is is set of the [Map] with the key type of [String] which is the name of the theme,
/// and the value is the [ThemeData] define set of light theme data of app.
/// [darkModeSet] is is set of the [Map] with the key type of [String] which is the name of the theme,
/// and the value is the [ThemeData] define set if dart theme data of app.

class AppTheme {
  final String themeSetTitle;
  final Map<String, ThemeData>? lightModeSet;
  final Map<String, ThemeData>? darkModeSet;

  AppTheme({required this.themeSetTitle, this.lightModeSet, this.darkModeSet});
}

/// This class is used to define the theme's of the app.
///
/// This used singleton pattern. [instance] is the instance of [AppStyle].
/// [appThemes] is the list of [AppTheme].
/// [currentTheme] is the current theme of the app which type of [AppTheme].
/// Used [changeThemeData] to change the theme of the app.
/// [adaptThemeWithSystemChanged] is the boolean value to adapt the theme with system changed.
class AppStyle {
  static final AppStyle _instance = AppStyle._internal();
  factory AppStyle() {
    return _instance;
  }
  AppStyle._internal();
  //
  List<AppTheme>? _appThemes;
  static void setAppThemes(List<AppTheme>? appThemes) {
    _instance._appThemes = appThemes;
  }

  AppTheme? _currentAppTheme;
  static AppTheme? get currentTheme => _instance._currentAppTheme;
  static void changeThemeData(AppTheme? appTheme) {
    _instance._currentAppTheme = appTheme;
  }

  bool? _adaptThemeWithSystemChanged;
  bool? get adaptThemeWithSystemChanged => _adaptThemeWithSystemChanged;

  // public method

  static void initAppTheme({
    AppTheme? defaultAppTheme,
    List<AppTheme>? appThemes,
    bool adaptThemeWithSystemChanged = true,
  }) {
    _instance._appThemes = appThemes;
    _instance._currentAppTheme = defaultAppTheme;
    if (defaultAppThemeData == null) {
      _instance._currentAppTheme = _instance._appThemes?.first;
    }
    _instance._adaptThemeWithSystemChanged = adaptThemeWithSystemChanged;
  }

  static ThemeData? get defaultAppThemeData {
    if (_instance._currentAppTheme == null) {
      return _instance._getThemeDataBySystemWhenCurrentThemeIsNull;
    }
    return _instance._getCurrentThemeDataBySystem;
  }

  static ThemeData? onPlatformBrightnessChanged() {
    if (_instance._adaptThemeWithSystemChanged != true) return null;
    _instance._currentAppTheme ??= _instance._appThemes?.first;
    return _instance._getCurrentThemeDataBySystem;
  }

  // private method
  ThemeData? get _getCurrentThemeDataBySystem {
    bool isDarkMode = SystemUtils.isDarkMode;
    if (isDarkMode) {
      return _instance._currentAppTheme?.darkModeSet?.values.first;
    }
    return _instance._currentAppTheme?.lightModeSet?.values.first;
  }

  ThemeData? get _getThemeDataBySystemWhenCurrentThemeIsNull {
    bool isDarkMode = SystemUtils.isDarkMode;
    if (isDarkMode) {
      return _instance._appThemes?.first.darkModeSet?.values.first;
    }
    return _instance._appThemes?.first.lightModeSet?.values.first;
  }
}
