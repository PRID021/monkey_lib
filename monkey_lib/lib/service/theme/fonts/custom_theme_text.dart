import 'package:flutter/material.dart';
import 'package:monkey_lib/service/theme/colors/custom_theme_colors.dart';
import 'package:monkey_lib/utils/extension/in_app_extension.dart';

/// The 2018 spec has thirteen text styles:
/// ```
/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
/// ```

class CustomThemeText extends ThemeExtension<CustomThemeText> {
  final TextStyle? textFormFieldLabelStyle;
  final TextStyle? textFormFiledHintStyle;
  final TextStyle? textFormFiledErrorStyle;
  final TextStyle? textFormFiledContentStyle;
  final BuildContext? context;

  CustomThemeText({
    this.context,
    this.textFormFieldLabelStyle,
    this.textFormFiledHintStyle,
    this.textFormFiledContentStyle,
    this.textFormFiledErrorStyle,
  });

  @override
  ThemeExtension<CustomThemeText> copyWith() {
    return CustomThemeText(
      context: context,
      textFormFieldLabelStyle: textFormFieldLabelStyle,
      textFormFiledHintStyle: textFormFiledHintStyle,
      textFormFiledErrorStyle: textFormFiledErrorStyle,
      textFormFiledContentStyle: textFormFiledContentStyle,
    );
  }

  @override
  ThemeExtension<CustomThemeText> lerp(
      ThemeExtension<CustomThemeText>? other, double t) {
    if (other is! CustomThemeText) {
      return this;
    }
    return CustomThemeText(
      context: context,
      textFormFieldLabelStyle: TextStyle.lerp(
          textFormFieldLabelStyle, other.textFormFieldLabelStyle, t),
      textFormFiledHintStyle: TextStyle.lerp(
          textFormFiledHintStyle, other.textFormFiledHintStyle, t),
      textFormFiledErrorStyle: TextStyle.lerp(
          textFormFiledErrorStyle, other.textFormFiledErrorStyle, t),
      textFormFiledContentStyle: TextStyle.lerp(
          textFormFiledContentStyle, other.textFormFiledContentStyle, t),
    );
  }

  static CustomThemeText get getDarkCustomThemeText => CustomThemeText(
        textFormFieldLabelStyle: TextStyle(
          fontSize: 16,
          height: 16 / 20,
          fontWeight: FontWeight.w400,
          color: CustomThemeColors.dark.textFormFieldLabelColor,
        ),
        textFormFiledHintStyle: TextStyle(
          fontSize: 16,
          height: 20 / 16,
          fontWeight: FontWeight.w400,
          color: CustomThemeColors.dark.textFormFieldHintColor,
        ),
        textFormFiledErrorStyle: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: CustomThemeColors.dark.textFormFieldErrorColor,
        ),
        textFormFiledContentStyle: TextStyle(
          fontSize: 16,
          height: 16 / 20,
          fontWeight: FontWeight.w400,
          color: CustomThemeColors.dark.textFormFieldContentColor,
        ),
      );

  static CustomThemeText get getLightCustomThemeText => CustomThemeText(
        textFormFieldLabelStyle: TextStyle(
          fontSize: 16,
          height: 16 / 20,
          fontWeight: FontWeight.w400,
          color: CustomThemeColors.light.textFormFieldLabelColor,
        ),
        textFormFiledHintStyle: TextStyle(
          fontSize: 16,
          height: 20 / 16,
          fontWeight: FontWeight.w400,
          color: CustomThemeColors.light.textFormFieldHintColor,
        ),
        textFormFiledErrorStyle: TextStyle(
          fontSize: 14,
          height: 16 / 14,
          color: CustomThemeColors.light.textFormFieldErrorColor,
          fontWeight: FontWeight.w400,
        ),
        textFormFiledContentStyle: TextStyle(
          fontSize: 16,
          height: 16 / 20,
          fontWeight: FontWeight.w400,
          color: CustomThemeColors.light.textFormFieldContentColor,
        ),
      );
}
