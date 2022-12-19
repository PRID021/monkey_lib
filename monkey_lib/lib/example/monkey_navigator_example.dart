import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import '../navigation/src/route_navigator.dart';

class MonkeyNavigator extends RouteNavigator {
  @override
  Route buildPageRoute(WidgetBuilder builder, RouteSettings setting) {
    if (Platform.isAndroid) {
      return MaterialPageRoute(
        builder: builder,
        settings: setting,
      );
    }
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        builder: builder,
        settings: setting,
      );
    }
    throw Exception('Unknown platform');
  }
}
