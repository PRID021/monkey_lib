import 'package:flutter/material.dart';

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but callback have index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    int i = 0;
    return map((E e) => f(e, i++));
  }
}

/// A widget that displays a horizontal row of tabs with some kind of shifting animation.
///
/// Typically created instead of [AppBar] and in conjunction with a [TabBarView].
///
/// If a [TabController] is not provided, then a [DefaultTabController] ancestor
/// must be provided instead. The tab controller's [TabController.length] must
/// equal the length of the [tabs] list.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// See also:
///
///  * [TabBarView], which displays page views that correspond to each tab.
class ShiftingTabBar extends StatefulWidget implements PreferredSizeWidget {
  const ShiftingTabBar({
    Key? key,
    required this.tabs,
    this.controller,
    this.color,
    this.brightness,
    this.labelFlex,
    this.labelStyle,
    this.forceUpperCase = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
  })  : assert(tabs != null),
        super(key: key);

  /// Typically a list of two or more [ShiftingTab] widgets.
  ///
  /// The length of this list must match the [controller]'s [TabController.length].
  final List<ShiftingTab> tabs;

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController? controller;

  /// The color of widget background.
  ///
  /// If a [color] is not provided then it will use ancestor [ThemeData.primaryColor]
  /// property as default background color.
  final Color? color;

  /// Describes the contrast of background color.
  ///
  /// If [Brightness] is not provided, then it will use [Color.computeLuminance] function and
  /// background color as arguments to determine this property.
  final Brightness? brightness;

  /// The amount of space that [Text] widget can take.
  ///
  /// The flex value for [Icon] widgets and also the default value of this property is 1.0
  final double? labelFlex;

  /// The text style of the tab labels.
  final TextStyle? labelStyle;

  /// The option to disable upper-case style in labels
  final bool forceUpperCase;

  ///
  final MainAxisAlignment mainAxisAlignment;

  @override
  _ShiftingTabBarState createState() => _ShiftingTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ShiftingTabBarState extends State<ShiftingTabBar> {
  TabController? _controller;
  Color? _color;
  Brightness? _brightness;
  late MainAxisAlignment _mainAxisAlignment;

  @override
  void initState() {
    super.initState();
    _mainAxisAlignment = widget.mainAxisAlignment;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = widget.controller ?? DefaultTabController.of(context);
    _color = widget.color ?? Theme.of(context).primaryColor;
    _brightness = widget.brightness ?? Brightness.light;

    _controller!.animation!.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      child: SafeArea(
        top: true,
        child: Row(
          mainAxisAlignment: _mainAxisAlignment,
          children: _buildTabWidgets(),
        ),
      ),
    );
  }

  double _computeTabMargin(int tabsLength) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double labelFlex = widget.labelFlex ?? 1.0;
    final double sizeFactor = tabsLength + labelFlex;
    return (deviceWidth / sizeFactor) / 2;
  }

  List<_ShiftingTabWidget> _buildTabWidgets() {
    final double marginRange = _computeTabMargin(widget.tabs.length);
    final List<_ShiftingTabWidget> tabWidgets = List<_ShiftingTabWidget>.from(
      widget.tabs.mapIndexed<_ShiftingTabWidget>((ShiftingTab tab, int index) {
        double left = 0.0;
        double top = 0.0;
        double right = 0.0;
        double bottom = 0.0;
        EdgeInsets margin = EdgeInsets.fromLTRB(left, top, right, bottom);

        return _ShiftingTabWidget(
          key: tab.key,
          animation: _ShiftingAnimation(_controller, index),
          margin: margin,
          icon: tab.icon,
          onTap: () => _controller!.animateTo(index),
          text: widget.forceUpperCase ? tab.text!.toUpperCase() : tab.text,
          brightness: _brightness ??
              (_color!.computeLuminance() > 0.5
                  ? Brightness.dark
                  : Brightness.light),
          labelFlex: widget.labelFlex ?? 1.0,
          labelStyle: widget.labelStyle,
        );
      }),
    );

    return tabWidgets;
  }
}

class ShiftingTab {
  ShiftingTab({
    this.key,
    this.text,
    this.icon,
  });

  final Key? key;
  final String? text;
  final Icon? icon;
}

class _ShiftingTabWidget extends AnimatedWidget {
  const _ShiftingTabWidget({
    Key? key,
    required Animation<double> animation,
    this.onTap,
    this.text,
    this.icon,
    this.margin,
    this.brightness,
    this.labelFlex,
    this.labelStyle,
  }) : super(key: key, listenable: animation);

  final Function? onTap;
  final String? text;
  final Icon? icon;
  final EdgeInsets? margin;
  final Brightness? brightness;
  final double? labelFlex;
  final TextStyle? labelStyle;

  int get iconSize => 19;
  int get textSize => 16;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final Tween<double> tween =
        Tween<double>(begin: 1.0, end: 1.0 + labelFlex!);
    final Color? color = brightness == Brightness.dark
        ? Color.lerp(Colors.white54, Colors.white, animation.value)
        : Color.lerp(Colors.black54, Colors.black, animation.value);

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap as void Function()?,
      child: _buildTab(animation, color, margin, context),
    );

    return Expanded(
      flex: (tween.animate(animation).value * 100).round(),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap as void Function()?,
        child: _buildTab(animation, color, margin, context),
      ),
    );
  }

  Widget _buildTab(
    Animation<double> animation,
    Color? color,
    EdgeInsets? margin,
    BuildContext context,
  ) {
    final TextDirection dir = Directionality.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildIcon(color, margin, dir),
        _buildText(
          animation,
          color,
          dir,
          labelStyle ??
              Theme.of(context).textTheme.headline5!.copyWith(
                  fontSize: 14,
                  color: color,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildIcon(Color? color, EdgeInsets? margin, TextDirection dir) {
    return Container(
      margin: margin,
      child: IconTheme.merge(
        data: IconThemeData(
          color: color,
          size: iconSize.toDouble(),
        ),
        child: icon!,
      ),
    );
  }

  Widget _buildText(
    Animation<double> animation,
    Color? color,
    TextDirection dir,
    TextStyle labelStyle,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        axis: Axis.horizontal,
        axisAlignment: -1.0,
        sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
        child: Container(
          margin: dir == TextDirection.ltr
              ? const EdgeInsets.only(left: 12)
              : const EdgeInsets.only(right: 12),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DefaultTextStyle(
                  style: labelStyle,
                  child: Text(text!),
                )
              ]),
        ),
      ),
    );
  }
}

class _ShiftingAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _ShiftingAnimation(this.controller, this.index);

  final TabController? controller;
  final int index;

  @override
  Animation<double> get parent => controller!.animation!;

  @override
  double get value => _indexChangeProgress(controller!, index);
}

/// I'm not exactly sure that what I did here. LOL
/// But the basic idea of this function is converting the value of controller
/// animation (witch is a double between 0.0 and number of tab items minus one)
/// to a double between 0.0 and 1.0 base on [index] of tab.
double _indexChangeProgress(TabController controller, int index) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  /// I created this part base on some experiments and I'm pretty sure this can be
  /// simplified!

  if (index != currentIndex && index != previousIndex) {
    if (controller.indexIsChanging) {
      return 0.0;
    } else if (controller.offset < 0 && index == controller.index - 1) {
      return controller.offset.abs().clamp(0.0, 1.0);
    } else if (controller.offset > 0 && index == controller.index + 1) {
      return controller.offset.abs().clamp(0.0, 1.0);
    } else {
      return 0.0;
    }
  }

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging) {
    if (index == currentIndex) {
      return 1.0 - controller.offset.abs().clamp(0.0, 1.0);
    } else {
      return (controller.index + 1 == previousIndex && controller.offset > 0) ||
              (controller.index - 1 == previousIndex && controller.offset < 0)
          ? controller.offset.abs().clamp(0.0, 1.0)
          : 0.0;
    }
  }

  // The TabController animation's value is changing from previousIndex to currentIndex.
  final double val = (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
  return index == currentIndex ? 1.0 - val : val;
}
