import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monkey_lib/widgets/custom_load_more/custom_load_more.dart';
import 'package:monkey_lib/widgets/custom_load_more/load_more_content.dart';
import 'package:monkey_lib/widgets/custom_load_more/load_more_list.dart';
import 'package:monkey_lib/widgets/custom_load_more/types.dart';

abstract class CustomScrollableLayoutBuilderInjector<T> {
  late CustomLoadMore<T> widgetParent;

  set setParent(CustomLoadMore<T> widget) {
    widgetParent = widget;
  }

  CustomScrollableLayoutBuilderInjector();
  CustomLoadMoreContent<T> buildMainContent(
    BuildContext context,
    LoadMoreState state,
    List<T>? dataItems,
    ScrollController scrollController,
    PageStorageKey<String> storageKey,
    StreamController<LoadMoreEvent> streamController,
  );
}

class MonkeyScrollableLayoutBuilderInjector<T>
    extends CustomScrollableLayoutBuilderInjector<T> {
  @override
  CustomLoadMoreContent<T> buildMainContent(
    BuildContext context,
    LoadMoreState state,
    List<T>? dataItems,
    ScrollController scrollController,
    PageStorageKey<String> storageKey,
    StreamController<LoadMoreEvent> streamController,
  ) {
    return LoadMoreList<T>(
      widgetParent.key,
      state: state,
      mainAxisDirection: widgetParent.mainAxisDirection,
      items: dataItems,
      widget: widgetParent,
      scrollController: scrollController,
      storageKey: storageKey,
      streamController: streamController,
    );
  }
}
