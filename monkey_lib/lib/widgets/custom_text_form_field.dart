import 'package:flutter/material.dart';
import 'package:monkey_lib/service/theme/custom_text_form_field_theme.dart';
import 'package:monkey_lib/utils/constraints/app_constraints.dart';
import '../utils/extension/in_app_extension.dart' as app_extension;

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
  final bool showClearButton;

  /// Called when user started typing in the field.
  ///
  /// The [newValue] is the new value of the field.
  /// The [oldValue] is the previous value of the field.
  final Function({required String newValue, String? oldValue})? onChanged;
  CustomTextFormField(
    this.context, {
    super.key,
    super.initialValue,
    super.validator,
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
    this.showClearButton = true,
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
            required CustomTextFormFieldStatus status,
            required CustomTextFormFieldFocusState focusState,
          }) {
            if (focusState == CustomTextFormFieldFocusState.Focused) {
              return _focusBorderDecoration;
            }

            if (status == CustomTextFormFieldStatus.Invalid) {
              return _errorBorderDecoration;
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: MarginPaddingRadiusConstraints
                      .innerPaddingHorizontalMedium,
                  vertical:
                      MarginPaddingRadiusConstraints.innerPaddingVerticalMedium,
                ),
                decoration: getBorderDecoration(
                    focusState: field._focusState, status: field._status),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leading != null
                        ? Container(
                            width: AppSize.mIconButtonSize,
                            height: AppSize.mIconButtonSize,
                            margin: const EdgeInsets.only(
                                right:
                                    MarginPaddingRadiusConstraints.marginSmall),
                          )
                        : const SizedBox.shrink(),
                    Expanded(
                      child: TextField(
                        focusNode: field._focusNode,
                        controller: field._controller,
                        textAlign: TextAlign.start,
                        style: _contextStyle,
                        textAlignVertical: TextAlignVertical.top,
                        cursorRadius: const Radius.elliptical(8, 8),
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
                          hintText: hintText?.toString() ??
                              titleText?.toString() ??
                              "",
                        ),
                      ),
                    ),
                    trailing != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: MarginPaddingRadiusConstraints
                                      .paddingSmall,
                                ),
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return RadialGradient(
                                      center: Alignment.center,
                                      radius: 0,
                                      colors: _iconColors,
                                      tileMode: TileMode.decal,
                                    ).createShader(bounds);
                                  },
                                  child: trailing,
                                ),
                              ),
                              if (showClearButton)
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: MarginPaddingRadiusConstraints
                                        .paddingSmall,
                                  ),
                                  width: AppSize.mIconButtonSize / 8,
                                  height: AppSize.mIconButtonSize,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                ),
                              if (showClearButton)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: MarginPaddingRadiusConstraints
                                        .paddingSmall,
                                  ),
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return RadialGradient(
                                        center: Alignment.center,
                                        radius: 0,
                                        colors: _iconColors,
                                        tileMode: TileMode.decal,
                                      ).createShader(bounds);
                                    },
                                    child: InkWell(
                                      onTap: () {
                                        (field as _CustomTextFomFieldState<
                                                String>)
                                            ._controller
                                            .clear();
                                      },
                                      customBorder: const CircleBorder(),
                                      child: const Icon(Icons.cancel_outlined),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              Opacity(
                opacity: field.hasError == true ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: MarginPaddingRadiusConstraints.paddingSmall,
                    left: MarginPaddingRadiusConstraints
                        .innerPaddingHorizontalMedium,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      field.errorText ?? "Smell something fishy \u1F60	",
                      style: context.customTextTheme?.textFormFiledErrorStyle,
                    ),
                  ),
                ),
              ),
            ],
          );
        });

  @override
  FormFieldState<String> createState() => _CustomTextFomFieldState();
}

enum CustomTextFormFieldFocusState {
  Focused,
  Unfocused,
}

enum CustomTextFormFieldStatus {
  Valid,
  Invalid,
  Initial,
}

class _CustomTextFomFieldState<String> extends FormFieldState<String> {
  late FocusNode _focusNode;

  late CustomTextFormFieldFocusState _focusState;
  late TextEditingController _controller;
  late final String? _initialValue;
  late String? _oldValue;
  late CustomTextFormFieldStatus _status;

  @override
  void initState() {
    super.initState();
    _status = CustomTextFormFieldStatus.Initial;
    _oldValue = null;
    _initialValue = widget.initialValue;
    _controller = widget.controller ?? TextEditingController();
    _controller.value = TextEditingValue(text: "${_initialValue ?? ""}");

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
    bool valid = super.validate();
    if (valid) {
      _status = CustomTextFormFieldStatus.Valid;
    } else {
      _status = CustomTextFormFieldStatus.Invalid;
    }
    return valid;
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
