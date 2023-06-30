// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monkey_lib/utils/pretty_json.dart';
import 'package:monkey_lib/widgets/custom_load_more/constraints.dart';
import 'package:monkey_lib/widgets/custom_load_more/scroll_layout_injector.dart';
import 'types.dart';
import 'package:flutter/rendering.dart';

/// The [CustomLoadMore] widget is a widget that can be used to load more data.
/// It can be used in [ListView], [GridView], [SliverList], [SliverGrid].
/// Currently we only support [ListView].

class CustomLoadMore<T> extends StatefulWidget {
  final Axis mainAxisDirection;
  final InitBuilderDelegate initBuilder;
  final InitFailBuilderDelegate initFailedBuilder;
  final ListItemBuilderDelegate<T> listItemBuilder;
  final LoadMoreBuilderDelegate loadMoreBuilder;
  final LoadMoreFailBuilderDelegate loadMoreFailedBuilder;
  final NoMoreBuilderDelegate noMoreBuilder;
  final FutureCallback<T> loadMoreCallback;
  final FutureCallback<T> initCallBack;
  final double? loadMoreOffset;
  final ScrollController? scrollController;
  final CustomScrollableLayoutBuilderInjector<T>
      customScrollableLayoutBuilderInjector;
  final bool shrinkWrap;
  final VoidCallback? onRefresh;
  final PageStorageBucket bucketGlobal;
  PageStorageKey<String> storageKey;
  CustomLoadMore(
      {super.key,
      required this.mainAxisDirection,
      required this.initBuilder,
      required this.initFailedBuilder,
      required this.loadMoreBuilder,
      required this.loadMoreFailedBuilder,
      required this.noMoreBuilder,
      required this.customScrollableLayoutBuilderInjector,
      required this.listItemBuilder,
      required this.loadMoreCallback,
      required this.bucketGlobal,
      required this.storageKey,
      this.scrollController,
      this.shrinkWrap = false,
      this.loadMoreOffset,
      this.onRefresh,
      required this.initCallBack});

  @override
  State<CustomLoadMore<T>> createState() => _CustomLoadMoreState<T>();
}

class _CustomLoadMoreState<T> extends State<CustomLoadMore<T>> {
  late LoadMoreState state;
  late List<T>? items;
  late CustomScrollableLayoutBuilderInjector<T>
      customScrollableLayoutBuilderInjector;
  late double loadMoreOffset;
  late ScrollController scrollController;
  late final PageStorageKey<String> storageKey;
  late final PageStorageBucket bucketGlobal;

  /// This stream is used to process event come from user.
  final StreamController<LoadMoreEvent> streamController =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    Logger.w("initState in CustomLoadMore");
    storageKey = widget.storageKey;
    bucketGlobal = widget.bucketGlobal;
    state = LoadMoreState.INIT;
    items = null;
    scrollController = widget.scrollController ?? ScrollController();
    loadMoreOffset = widget.loadMoreOffset ?? kLoadMoreExtent;
    customScrollableLayoutBuilderInjector =
        widget.customScrollableLayoutBuilderInjector;
    customScrollableLayoutBuilderInjector.setParent = widget;
    widget.initCallBack.call().then((value) {
      setState(() {
        items = value;
        state = LoadMoreState.STABLE;
      });
    }).catchError((error) {
      Logger.w(error.toString());
      setState(() {
        state = LoadMoreState.INIT_FAILED;
      });
    });
    streamController.stream.listen((event) {
      switch (event) {
        case LoadMoreEvent.RETRY_WHEN_INIT_FAILED:
          retryCallFallback();
          break;
        case LoadMoreEvent.RETRY_WHEN_LOAD_MORE_FAILED:
          retryLoadMoreFailed();
          break;
        case LoadMoreEvent.PULL_TO_REFRESH:
          pullForRefresh();
          break;
        case LoadMoreEvent.SCROLL_TO_LOAD_MORE:
          loadMore();
          break;
      }
    });
  }

  /// This method is used to retry load more when load more failed.
  void retryLoadMoreFailed() {
    if (state != LoadMoreState.LOAD_MORE_FAILED) {
      return;
    }
    setState(() {
      state = LoadMoreState.LOAD_MORE;
    });
    widget.loadMoreCallback().then((value) {
      setState(() {
        items = [...items ?? [], ...value ?? []];
        state = LoadMoreState.STABLE;
        if (value?.isEmpty ?? true) {
          state = LoadMoreState.NO_MORE;
        }
        Logger.w("retryLoadMoreFailed success");
      });
    }).catchError((error) {
      setState(() {
        state = LoadMoreState.LOAD_MORE_FAILED;
        Logger.e(error, "retryLoadMoreFailed failed");
      });
    });
  }

  /// This method is used to load more data.
  void loadMore() {
    if (state != LoadMoreState.STABLE) {
      return;
    }
    Logger.w("loadMore");
    setState(() {
      state = LoadMoreState.LOAD_MORE;
    });
    widget.loadMoreCallback().then((value) {
      setState(() {
        items = [...items ?? [], ...value ?? []];
        state = LoadMoreState.STABLE;
        if (value?.isEmpty ?? true) {
          state = LoadMoreState.NO_MORE;
        }
        Logger.w("loadMore success");
      });
    }).catchError((error) {
      setState(() {
        state = LoadMoreState.LOAD_MORE_FAILED;
        Logger.e(error, "loadMore failed");
      });
    });
  }

  /// Call back when init failed.
  void retryCallFallback() {
    Logger.w("retryCallFallback");
    setState(() {
      state = LoadMoreState.INIT;
    });
    widget.initCallBack.call().then((value) {
      setState(() {
        items = value;
        state = LoadMoreState.STABLE;
      });
    }).catchError((error) {
      Logger.w(error.toString());
      setState(() {
        state = LoadMoreState.INIT_FAILED;
      });
    });
  }

  /// Call back when pull for refresh.
  void pullForRefresh() {
    widget.onRefresh?.call();
    Logger.w("pullForRefresh");
    setState(() {
      items = null;
      state = LoadMoreState.INIT;
    });
    widget.initCallBack.call().then((value) {
      setState(() {
        items = value;
        state = LoadMoreState.STABLE;
      });
    }).catchError((error) {
      Logger.w(error.toString());
      setState(() {
        state = LoadMoreState.INIT_FAILED;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        Logger.i(
            "notification.metrics.pixels: ${notification.metrics.pixels} and maxScrollExtent: ${notification.metrics.maxScrollExtent}");

        /// That code using to detect user scroll behavior (up or down as vertical and left or right with horizontal).
        /// the orientation obey the [mainAxisDirection] property.
        if (scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          //('User is going down');
          if (state == LoadMoreState.NO_MORE) {
            return false;
          }
          if (notification.metrics.pixels >
              notification.metrics.maxScrollExtent - loadMoreOffset) {
            streamController.sink.add(LoadMoreEvent.SCROLL_TO_LOAD_MORE);
          }
          return false;
        }

        if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          return false;
        }
        return false;
      },
      child: PageStorage(
        bucket: bucketGlobal,
        child: customScrollableLayoutBuilderInjector.buildMainContent(context,
            state, items, scrollController, storageKey, streamController),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
