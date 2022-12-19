import 'package:flutter/material.dart';

enum PageRoutedAnimatedType {
  scaleFadeIO,
  rotation,
  slideBottomToScreen,
  slideBottomToScreenIO,
  slideTopToScreen,
  slideTopToScreenIO,
  slideLeftToScreen,
  slideLeftToScreenIO,
  slideRightToScreen,
  slideRightToScreenIO,
}

typedef RouteAnimatedSettingsBuilder = Route<Object?> Function(Widget page, {RouteSettings? settings, bool? opaque, bool? barrierDismissible});

class AnimatedPageRouteBuilder {
  static final Map<PageRoutedAnimatedType, RouteTransitionsBuilder> _routeTransition = {
    PageRoutedAnimatedType.scaleFadeIO: (context, animation, secondaryAnimation, child) {
      const begin = 0.0;
      const end = 1.0;
      const curve = Curves.elasticInOut;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );
      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: tween.animate(curvedAnimation),
          child: child,
        ),
      );
    },
    PageRoutedAnimatedType.rotation: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child,
        ),
      );
    },
    PageRoutedAnimatedType.slideBottomToScreen: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
    PageRoutedAnimatedType.slideBottomToScreenIO: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.elasticInOut;

      final tween = Tween(begin: begin / 2, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
    PageRoutedAnimatedType.slideTopToScreen: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, -1.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
    PageRoutedAnimatedType.slideTopToScreenIO: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, -1.0);
      const end = Offset.zero;
      const curve = Curves.elasticInOut;

      final tween = Tween(begin: begin / 2, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
    PageRoutedAnimatedType.slideRightToScreen: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
    PageRoutedAnimatedType.slideRightToScreenIO: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.elasticInOut;

      final tween = Tween(begin: begin / 2, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
    PageRoutedAnimatedType.slideLeftToScreen: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
    PageRoutedAnimatedType.slideLeftToScreenIO: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.elasticInOut;

      final tween = Tween(begin: begin / 2, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  };

  static RouteAnimatedSettingsBuilder? _getRouteAnimatedSettingsBuilder(PageRoutedAnimatedType type, {bool? isDialog = false}) {
    bool _isDialog = isDialog ?? false;
    if (!_isDialog) {
      return (page, {settings, opaque, barrierDismissible}) {
        return PageRouteBuilder(
          settings: settings,
          opaque: opaque ?? false,
          barrierDismissible: barrierDismissible ?? false,
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: _getRouteTransitions(type),
        );
      };
    }
    return (page, {settings, opaque, barrierDismissible}) {
      return RawDialogRoute(
        pageBuilder: (_, __, ___) => page,
        barrierDismissible: barrierDismissible ?? true,
        transitionDuration: const Duration(milliseconds: 600),
        transitionBuilder: _getRouteTransitions(type),
        settings: settings,
      );
    };
  }

  static RouteTransitionsBuilder _getRouteTransitions(PageRoutedAnimatedType pageRoutedAnimatedType) {
    RouteTransitionsBuilder? transitionsBuilder = _routeTransition[pageRoutedAnimatedType];
    if (transitionsBuilder != null) {
      return transitionsBuilder;
    }
    throw Exception("Not found RouteTransitionsBuilder match for $pageRoutedAnimatedType ");
  }

  static Route<Object?> buildRoute(PageRoutedAnimatedType type, Widget widget,
      {RouteSettings? settings, bool? opaque, bool? barrierDismissible, bool? isDialog}) {
    RouteAnimatedSettingsBuilder? builder = _getRouteAnimatedSettingsBuilder(type, isDialog: isDialog);
    if (builder != null) {
      return builder(
        widget,
        settings: settings,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
      );
    }
    throw Exception('Unknown route: $type');
  }
}
