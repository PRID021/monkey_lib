import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/pretty_json.dart';

abstract class RouteNavigator<T> {
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  RouteNavigator({
    this.routes = const {},
  });

  @protected
  Route buildPageRoute(WidgetBuilder builder, RouteSettings setting);
  Map<String, WidgetBuilder> routes;

  Route onGenerateRoute(RouteSettings settings) {
    String? name = settings.name;
    Object? arguments = settings.arguments;
    Logger.i('onGenerateRoute: $name, $arguments');
    if (routes.containsKey(name)) {
      return buildPageRoute(routes[name]!, settings);
    }
    throw Exception('Unknown route: $name');
  }

  @nonVirtual
  T get currentArguments {
    BuildContext? context = navigatorKey?.currentContext;
    if (context != null) {
      return ModalRoute.of(context)?.settings.arguments as T;
    }
    throw Exception('Navigator is not initialized');
  }

  static BuildContext? get currentContext {
    return navigatorKey?.currentContext;
  }

  static bool get canPop {
    if (currentContext != null) {
      return ModalRoute.of(currentContext!)?.canPop ?? false;
    }
    return false;
  }

  /// Pop the top-most route off the navigator that most tightly encloses the
  /// given context.
  /// {@tool snippet}
  ///
  /// Typical usage for closing a route is as follows:
  ///
  /// ```dart
  /// void _close() {
  ///   RouteNavigator.pop();
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// A dialog box might be closed with a result:
  ///
  /// ```dart
  /// void _accept() {
  ///   RouteNavigator.pop( true); // dialog returns true
  /// }
  /// ```

  @optionalTypeArgs
  static void pop<T extends Object?>([T? result]) {
    if (canPop && currentContext != null) {
      String? routeName = ModalRoute.of(currentContext!)?.settings.name;
      Logger.i('pop: $routeName, with result: $result');
      return Navigator.of(currentContext!).pop<T>(result);
    }
  }

  /// Calls [pop] repeatedly on the navigator that most tightly encloses the
  /// given context until the predicate returns true.
  ///
  /// {@template RouteNavigator.popUntil}
  ///
  /// To pop until a route with a certain name, use the [RoutePredicate]
  /// returned from [ModalRoute.withName].
  ///
  /// The routes are closed with null as their `return` value.
  ///
  /// See [pop] for more details of the semantics of popping a route.
  /// {@endtemplate}
  ///
  /// {@tool snippet}
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _logout() {
  ///   RouteNavigator.popUntil(ModalRoute.withName('/login'));
  /// }
  /// ```
  /// {@end-tool}

  static void popUntil(RoutePredicate predicate) {
    if (canPop && currentContext != null) {
      return Navigator.of(currentContext!).popUntil(predicate);
    }
  }

  /// Push the given route onto the navigator.
  ///
  /// {@template RouteNavigator.push}
  /// The new route and the previous route (if any) are notified (see
  ///
  /// Returns a [Future] that completes to the `result` value passed to [pop]
  /// when the pushed route is popped off the navigator.
  ///
  /// The `T` type argument is the type of the return value of the route.
  /// {@endtemplate}
  ///
  /// {@tool snippet}
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// void _openMyPage() {
  ///   RouteNavigator.push<void>(
  ///     MaterialPageRoute<void>(
  ///       builder: (BuildContext context) => const MyPage(),
  ///     ),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [restorablePush], which pushes a route that can be restored during
  ///    state restoration.
  @optionalTypeArgs
  static Future<T?> push<T extends Object?>(Route<T> route) {
    if (canPop && currentContext != null) {
      String? routeName = ModalRoute.of(currentContext!)?.settings.name;
      Logger.i('push: $routeName, with result: $route');
      return Navigator.of(currentContext!).push<T>(route);
    }
    throw Exception('Navigator is not initialized');
  }

  @optionalTypeArgs
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Route<T> newRoute, {TO? result}) {
    if (canPop && currentContext != null) {
      String? fromRouteName = ModalRoute.of(currentContext!)?.settings.name;
      Logger.i('PushReplacement from: $fromRouteName, with setting: $newRoute, $result');
      return Navigator.of(currentContext!).pushReplacement<T, TO>(newRoute, result: result);
    }
    throw Exception('Navigator is not initialized');
  }

  @optionalTypeArgs
  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    if (canPop && currentContext != null) {
      String? fromRouteName = ModalRoute.of(currentContext!)?.settings.name;
      Logger.i('PushNamed from: $fromRouteName, with args: $arguments, to $routeName');
      return Navigator.of(currentContext!).pushNamed<T>(routeName, arguments: arguments);
    }
    throw Exception('Navigator is not initialized');
  }
}
