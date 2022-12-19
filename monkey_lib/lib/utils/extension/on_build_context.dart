part of 'in_app_extension.dart';

extension ExBuildContent on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  CustomThemeColors? get customColors =>
      Theme.of(this).extension<CustomThemeColors>();
  CustomThemeText? get customTextTheme =>
      Theme.of(this).extension<CustomThemeText>();
  Brightness get brightness => Theme.of(this).brightness;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;
  double get pixelRatio => mediaQuery.devicePixelRatio;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  TextDirection get textDirection => Directionality.of(this);
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;
  bool get isRTL => textDirection == TextDirection.rtl;
  bool get isLTR => textDirection == TextDirection.ltr;
  bool get isPortrait => size.width < size.height;
  bool get isLandscape => size.width > size.height;
  bool get isPhone => size.width < 600;
  bool get isTablet => size.width >= 600;
  bool get isPhonePortrait => isPhone && isPortrait;
  bool get isPhoneLandscape => isPhone && isLandscape;
  bool get isTabletPortrait => isTablet && isPortrait;
  bool get isTabletLandscape => isTablet && isLandscape;
}
