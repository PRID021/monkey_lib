// ignore_for_file: invalid_sealed_annotation

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:monkey_lib/widgets/custom_load_more/custom_load_more.dart';
import 'types.dart';

abstract class CustomLoadMoreContent<T> extends StatelessWidget {
  final LoadMoreState state;
  final Axis mainAxisDirection;
  final List<T>? items;
  final CustomLoadMore<T> widget;
  final ScrollController scrollController;
  final bool shrinkWrap;
  final PageStorageKey<String> storageKey;
  final StreamController<LoadMoreEvent> streamController;

  const CustomLoadMoreContent(
    Key? key, {
    required this.state,
    this.mainAxisDirection = Axis.vertical,
    required this.items,
    required this.scrollController,
    required this.widget,
    required this.storageKey,
    required this.streamController,
    this.shrinkWrap = false,
  }) : super(key: key);
}
