import 'package:flutter/material.dart';
import 'package:monkey_lib/service/theme/colors/custom_theme_colors.dart';
import 'package:monkey_lib/service/theme/fonts/custom_theme_text.dart';
import 'package:monkey_lib/utils/constraints/app_constraints.dart';

class CustomTextFormFieldTheme
    extends ThemeExtension<CustomTextFormFieldTheme> {
  final BoxDecoration? focusBoxDecoration;
  final BoxDecoration? errorBoxDecoration;
  final BoxDecoration? boxDecoration;
  final TextStyle? textStyle;
  final TextStyle? errorTextStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Color? cursorColor;
  final List<Color>? iconColors;
  final StrutStyle? strutStyle;

  CustomTextFormFieldTheme(
      {this.focusBoxDecoration,
      this.cursorColor,
      this.errorBoxDecoration,
      this.boxDecoration,
      this.iconColors,
      this.textStyle,
      this.errorTextStyle,
      this.strutStyle,
      this.hintStyle,
      this.labelStyle});

  static CustomTextFormFieldTheme get light => CustomTextFormFieldTheme(
        focusBoxDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(MarginPaddingRadiusConstraints.radiusMedium)),
          border: Border.all(
              width: AppSize.mBorderWidth,
              color: CustomThemeColors.light.textFormFieldFocusBorderColor),
        ),
        errorBoxDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(MarginPaddingRadiusConstraints.radiusMedium)),
          border: Border.all(
              width: AppSize.mBorderWidth,
              color: CustomThemeColors.light.textFormFieldErrorBorderColor),
        ),
        boxDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
              width: AppSize.mBorderWidth,
              color: CustomThemeColors.light.dividerColor),
        ),
        textStyle:
            CustomThemeText.getLightCustomThemeText.textFormFiledContentStyle,
        errorTextStyle:
            CustomThemeText.getLightCustomThemeText.textFormFiledErrorStyle,
        hintStyle:
            CustomThemeText.getLightCustomThemeText.textFormFiledHintStyle,
        labelStyle:
            CustomThemeText.getLightCustomThemeText.textFormFieldLabelStyle,
        cursorColor: CustomThemeColors.light.textFormFieldCursorColor,
        iconColors: CustomThemeColors.light.textFormFieldTrailingIconColor,
        strutStyle: const StrutStyle(
          forceStrutHeight: true,
          height: 1.2,
          leading: 0.2,
        ),
      );

  static CustomTextFormFieldTheme get dark => CustomTextFormFieldTheme(
        focusBoxDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(MarginPaddingRadiusConstraints.radiusMedium)),
          border: Border.all(
              width: AppSize.mBorderWidth,
              color: CustomThemeColors.dark.textFormFieldFocusBorderColor),
        ),
        errorBoxDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(MarginPaddingRadiusConstraints.radiusMedium)),
          border: Border.all(
              width: AppSize.mBorderWidth,
              color: CustomThemeColors.dark.textFormFieldErrorBorderColor),
        ),
        boxDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            width: AppSize.mBorderWidth,
            color: CustomThemeColors.dark.textFormFieldBorderColor,
          ),
        ),
        textStyle:
            CustomThemeText.getDarkCustomThemeText.textFormFiledContentStyle,
        errorTextStyle:
            CustomThemeText.getDarkCustomThemeText.textFormFiledErrorStyle,
        hintStyle:
            CustomThemeText.getDarkCustomThemeText.textFormFiledHintStyle,
        labelStyle:
            CustomThemeText.getDarkCustomThemeText.textFormFieldLabelStyle,
        cursorColor: CustomThemeColors.dark.textFormFieldCursorColor,
        strutStyle: const StrutStyle(
          forceStrutHeight: true,
          height: 1.2,
          leading: 0.2,
        ),
        iconColors: CustomThemeColors.dark.textFormFieldTrailingIconColor,
      );

  @override
  ThemeExtension<CustomTextFormFieldTheme> copyWith() {
    return CustomTextFormFieldTheme(
      focusBoxDecoration: focusBoxDecoration,
      errorBoxDecoration: errorBoxDecoration,
      boxDecoration: boxDecoration,
      textStyle: textStyle,
      errorTextStyle: errorTextStyle,
      hintStyle: hintStyle,
      labelStyle: labelStyle,
      strutStyle: strutStyle,
      cursorColor: cursorColor,
    );
  }

  @override
  ThemeExtension<CustomTextFormFieldTheme> lerp(
      ThemeExtension<CustomTextFormFieldTheme>? other, double t) {
    if (other is! CustomTextFormFieldTheme) {
      return this;
    }
    return CustomTextFormFieldTheme(
      focusBoxDecoration:
          BoxDecoration.lerp(focusBoxDecoration, other.focusBoxDecoration, t),
      errorBoxDecoration:
          BoxDecoration.lerp(errorBoxDecoration, other.errorBoxDecoration, t),
      boxDecoration: BoxDecoration.lerp(boxDecoration, other.boxDecoration, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      errorTextStyle: TextStyle.lerp(errorTextStyle, other.errorTextStyle, t),
      hintStyle: TextStyle.lerp(hintStyle, other.hintStyle, t),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t),
      strutStyle: strutStyle,
    );
  }
}
