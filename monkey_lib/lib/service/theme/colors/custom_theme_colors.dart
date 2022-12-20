import 'package:flutter/material.dart';

class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  final Color dividerColor;
  final Color scaffoldBackgroundColor;

  // textFormField
  final Color textFormFieldCursorColor;
  final Color textFormFieldBorderColor;
  final Color textFormFieldFocusBorderColor;
  final Color textFormFieldHoverBorderColor;
  final Color textFormFieldDisabledBorderColor;
  final Color textFormFieldErrorBorderColor;
  final Color textFormFieldLabelColor;
  final Color textFormFieldHintColor;
  final Color textFormFieldContentColor;
  final Color textFormFieldErrorColor;
  final Color textFormFieldBackgroundColor;
  final List<Color> textFormFieldTrailingIconColor;

  CustomThemeColors({
    this.textFormFieldLabelColor = const Color(0xFFFCFCFC),
    this.textFormFieldErrorColor = const Color(0xFFFCFCFC),
    this.textFormFieldHintColor = const Color(0xFFFCFCFC),
    this.textFormFieldContentColor = const Color(0xFFFCFCFC),
    this.textFormFieldFocusBorderColor = const Color(0xFFFCFCFC),
    this.textFormFieldHoverBorderColor = const Color(0xFFFCFCFC),
    this.textFormFieldDisabledBorderColor = const Color(0xFFFCFCFC),
    this.textFormFieldErrorBorderColor = const Color(0xFFFCFCFC),
    this.dividerColor = const Color(0xFFE2E9FC),
    this.textFormFieldBorderColor = const Color(0xFFFCFCFC),
    this.textFormFieldBackgroundColor = const Color(0xFFFCFCFC),
    this.textFormFieldTrailingIconColor = const [
      Color(0xFFFCFCFC),
      Color(0xFFFCFCFC)
    ],
    this.scaffoldBackgroundColor = const Color(0xFFFCFCFC),
    this.textFormFieldCursorColor = const Color(0xFFF7941E),
  });

  @override
  ThemeExtension<CustomThemeColors> copyWith() {
    return CustomThemeColors(
        dividerColor: dividerColor,
        textFormFieldBorderColor: textFormFieldBorderColor,
        textFormFieldFocusBorderColor: textFormFieldFocusBorderColor,
        textFormFieldHoverBorderColor: textFormFieldHoverBorderColor,
        textFormFieldDisabledBorderColor: textFormFieldDisabledBorderColor,
        textFormFieldErrorBorderColor: textFormFieldErrorBorderColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textFormFieldLabelColor: textFormFieldLabelColor,
        textFormFieldHintColor: textFormFieldHintColor,
        textFormFieldErrorColor: textFormFieldErrorColor,
        textFormFieldBackgroundColor: textFormFieldBackgroundColor,
        textFormFieldTrailingIconColor: textFormFieldTrailingIconColor,
        textFormFieldCursorColor: textFormFieldCursorColor,
        textFormFieldContentColor: textFormFieldContentColor);
  }

  @override
  ThemeExtension<CustomThemeColors> lerp(
      ThemeExtension<CustomThemeColors>? other, double t) {
    if (other is! CustomThemeColors) {
      return this;
    }
    return CustomThemeColors(
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t) ??
          const Color(0xFF0E2E9FC),
      textFormFieldBorderColor: Color.lerp(
              textFormFieldBorderColor, other.textFormFieldBorderColor, t) ??
          const Color(0xFFFCFCFC),
      textFormFieldFocusBorderColor: Color.lerp(textFormFieldFocusBorderColor,
              other.textFormFieldFocusBorderColor, t) ??
          const Color(0xFFFCFCFC),
      textFormFieldHoverBorderColor: Color.lerp(textFormFieldHoverBorderColor,
              other.textFormFieldHoverBorderColor, t) ??
          const Color(0xFFFCFCFC),
      textFormFieldDisabledBorderColor: Color.lerp(
              textFormFieldDisabledBorderColor,
              other.textFormFieldDisabledBorderColor,
              t) ??
          const Color(0xFFFCFCFC),
      textFormFieldErrorBorderColor: Color.lerp(textFormFieldErrorBorderColor,
              other.textFormFieldErrorBorderColor, t) ??
          const Color(0xFFFCFCFC),
      scaffoldBackgroundColor: Color.lerp(
              scaffoldBackgroundColor, other.scaffoldBackgroundColor, t) ??
          const Color(0xFFFCFCFC),
      textFormFieldLabelColor: Color.lerp(
              textFormFieldLabelColor, other.textFormFieldLabelColor, t) ??
          const Color(0xFFFCFCFC),
      textFormFieldHintColor:
          Color.lerp(textFormFieldHintColor, other.textFormFieldHintColor, t) ??
              const Color(0xFFFCFCFC),
      textFormFieldContentColor: Color.lerp(
              textFormFieldContentColor, other.textFormFieldContentColor, t) ??
          const Color(0xFFFCFCFC),
      textFormFieldErrorColor: Color.lerp(
              textFormFieldErrorColor, other.textFormFieldErrorColor, t) ??
          const Color(0xFFFCFCFC),
      textFormFieldBackgroundColor: Color.lerp(textFormFieldBackgroundColor,
              other.textFormFieldBackgroundColor, t) ??
          const Color(0xFFFCFCFC),
      textFormFieldTrailingIconColor: textFormFieldTrailingIconColor,
      textFormFieldCursorColor: Color.lerp(
              textFormFieldCursorColor, other.textFormFieldCursorColor, t) ??
          const Color(0xFFF7941E),
    );
  }

  // the dark theme
  static CustomThemeColors get dark => CustomThemeColors(
        dividerColor: Colors.white.withOpacity(0.1),
        textFormFieldBorderColor: Colors.white,
        textFormFieldFocusBorderColor: Color.fromARGB(255, 57, 127, 255),
        textFormFieldHoverBorderColor: Color.fromARGB(255, 151, 79, 79),
        textFormFieldDisabledBorderColor: Colors.white.withOpacity(0.1),
        textFormFieldErrorBorderColor: Colors.red.withOpacity(0.5),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        textFormFieldContentColor: Color.fromARGB(255, 255, 255, 255),
        textFormFieldLabelColor: Color.fromARGB(255, 202, 202, 202),
        textFormFieldTrailingIconColor: [
          Colors.yellow,
          Colors.deepOrange,
        ],
        textFormFieldCursorColor: const Color(0xFFFFFFFF),
        textFormFieldHintColor: Color.fromARGB(255, 255, 128, 128),
      );
  // the light theme
  static CustomThemeColors get light => CustomThemeColors(
        dividerColor: const Color(0xFF454C60),
        textFormFieldBorderColor: const Color(0xFFE2E9FC),
        textFormFieldFocusBorderColor: const Color(0xFF4250D0),
        textFormFieldHoverBorderColor: const Color(0xFFF3F6FF),
        textFormFieldDisabledBorderColor: const Color(0xFFF1F1F1),
        textFormFieldErrorBorderColor: const Color(0xFFFD3549),
        textFormFieldContentColor: const Color(0xFF212633),
        textFormFieldLabelColor: const Color(0xFFB8C3E1),
        textFormFieldHintColor: const Color(0xFFB8C3E1),
        textFormFieldErrorColor: const Color(0xFFFD3549),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        textFormFieldBackgroundColor: const Color(0xFFE2E9FC),
        textFormFieldTrailingIconColor: const [
          Color(0xFF4250D0),
          Color(0xFF4250D0)
        ],
        textFormFieldCursorColor: const Color(0xFFF7941E),
      );
}
