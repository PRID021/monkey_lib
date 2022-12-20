import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkey_lib/service/theme/custom_text_form_field_theme.dart';
import 'package:monkey_lib/utils/constraints/app_constraints.dart';
import 'package:monkey_lib/utils/pretty_json.dart';
import '../utils/extension/in_app_extension.dart' as app_extension;
import '../utils/constraints/app_constraints.dart' as app_constraints;

class CustomTextFormField<String> extends FormField<String> {
  final Function()? onTap;
  final String? titleText;
  final String? hintText;
  final BuildContext context;
  final EdgeInsets? paddingContent;
  final EdgeInsets? marginContent;
  final FocusNode? focusNode;
  final Widget? trailing;
  final Widget? leading;
  final BoxDecoration? focusBorderDecoration;
  final BoxDecoration? borderDecoration;
  final BoxDecoration? errorBorderDecoration;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? contextStyle;
  final TextEditingController? controller;
  final String? initialValue;

  /// Called when user started typing in the field.
  ///
  /// The [newValue] is the new value of the field.
  /// The [oldValue] is the previous value of the field.
  final Function({required String newValue, String? oldValue})? onChanged;
  CustomTextFormField(
    this.context, {
    super.key,
    this.initialValue,
    this.controller,
    this.onTap,
    this.labelStyle,
    this.hintStyle,
    this.contextStyle,
    required this.titleText,
    this.paddingContent,
    this.marginContent,
    this.trailing,
    this.hintText,
    this.focusNode,
    this.leading,
    this.focusBorderDecoration,
    this.borderDecoration,
    this.errorBorderDecoration,
    this.onChanged,
  }) : super(builder: (field) {
          field = field as _CustomTextFomFieldState<String>;
          CustomTextFormFieldFocusState focusState = field._focusState;
          bool isFocused = focusState == CustomTextFormFieldFocusState.Focused;
          final CustomTextFormFieldTheme? customTextFormFieldTheme =
              Theme.of(context).extension<CustomTextFormFieldTheme>();

          final BoxDecoration? _focusBorderDecoration = focusBorderDecoration ??
              customTextFormFieldTheme?.focusBoxDecoration;

          final _borderDecoration =
              borderDecoration ?? customTextFormFieldTheme?.boxDecoration;

          final BoxDecoration? _errorBorderDecoration = errorBorderDecoration ??
              customTextFormFieldTheme?.errorBoxDecoration;
          final TextStyle? _labelStyle =
              labelStyle ?? context.customTextTheme?.textFormFieldLabelStyle;

          final TextStyle? _hintStyle =
              hintStyle ?? context.customTextTheme?.textFormFiledHintStyle;
          final TextStyle? _contextStyle = contextStyle ??
              context.customTextTheme?.textFormFiledContentStyle;
          BoxDecoration? getBorderDecoration({
            required bool isFirstBuild,
            required bool isValid,
            required bool isFocused,
          }) {
            if (isFirstBuild) {
              return _borderDecoration;
            }
            if (!isValid) {
              return _errorBorderDecoration;
            }
            if (isFocused) {
              return _focusBorderDecoration;
            }
            return _borderDecoration;
          }

          final StrutStyle? _strutStyle = customTextFormFieldTheme?.strutStyle;
          final Color? _cursorColor = customTextFormFieldTheme?.cursorColor;
          final List<Color> _iconColors =
              customTextFormFieldTheme?.iconColors ??
                  [
                    Colors.white,
                    Colors.blue,
                  ];

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal:
                  MarginPaddingRadiusConstraints.innerPaddingHorizontalMedium,
              vertical:
                  MarginPaddingRadiusConstraints.innerPaddingVerticalMedium,
            ),
            decoration: getBorderDecoration(
              isFirstBuild: field._isFresh,
              isValid: field.isValid,
              isFocused: isFocused,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leading != null
                    ? Container(
                        width: AppSize.mIconButtonSize,
                        height: AppSize.mIconButtonSize,
                        margin: const EdgeInsets.only(
                            right: MarginPaddingRadiusConstraints.marginSmall),
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: TextField(
                    focusNode: field._focusNode,
                    controller: field._controller,
                    textAlign: TextAlign.start,
                    style: _contextStyle,
                    textAlignVertical: TextAlignVertical.top,
                    cursorRadius: const Radius.elliptical(10, 10),
                    maxLines: 1,
                    strutStyle: _strutStyle,
                    cursorColor: _cursorColor,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintStyle: _hintStyle,
                      labelStyle: _labelStyle,
                      contentPadding: const EdgeInsets.only(
                        top: MarginPaddingRadiusConstraints.paddingSmall,
                        bottom: MarginPaddingRadiusConstraints.paddingSmall,
                      ),
                      isCollapsed: false,
                      isDense: true,
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      labelText: titleText?.toString(),
                      hintText:
                          hintText?.toString() ?? titleText?.toString() ?? "",
                    ),
                  ),
                ),
                trailing != null
                    ? Container(
                        margin: const EdgeInsets.only(
                          left: MarginPaddingRadiusConstraints.marginSmall,
                        ),
                        width: AppSize.mIconButtonSize,
                        height: AppSize.mIconButtonSize,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return RadialGradient(
                              center: Alignment.topLeft,
                              radius: 1.0,
                              colors: _iconColors,
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          child: trailing,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
        });

  @override
  FormFieldState<String> createState() => _CustomTextFomFieldState();
}

enum CustomTextFormFieldFocusState {
  Focused,
  Unfocused,
}

class _CustomTextFomFieldState<String> extends FormFieldState<String> {
  late FocusNode _focusNode;
  late bool _isFresh;
  late CustomTextFormFieldFocusState _focusState;
  late TextEditingController _controller;
  late final String? _initialValue;
  late String? _oldValue;

  @override
  void initState() {
    super.initState();
    _oldValue = null;
    _initialValue = widget.initialValue;
    _controller = widget.controller ?? TextEditingController();
    _controller.value = TextEditingValue(text: "${_initialValue ?? ""}");
    _isFresh = true;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusState = CustomTextFormFieldFocusState.Unfocused;
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          _focusState = CustomTextFormFieldFocusState.Focused;
        } else {
          _focusState = CustomTextFormFieldFocusState.Unfocused;
        }
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isFresh = false;
    });
    _controller.addListener(() {
      if (_oldValue == _controller.text || _oldValue == null) {
        _oldValue = _controller.text as String?;
        return;
      }
      widget.onChanged
          ?.call(newValue: _controller.text as String, oldValue: _oldValue);
      _oldValue = _controller.text as String?;
      didChange(_controller.text as String?);
    });
  }

  @override
  bool validate() {
    if (_isFresh) _isFresh = false;
    return super.validate();
  }

  @override
  CustomTextFormField<String> get widget =>
      super.widget as CustomTextFormField<String>;

  @override
  void didChange(String? value) {
    super.didChange(value);
  }

  @override
  void didUpdateWidget(CustomTextFormField<String> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}
