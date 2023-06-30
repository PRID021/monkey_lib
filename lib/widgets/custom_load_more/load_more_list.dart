import 'package:flutter/material.dart';
import 'package:monkey_lib/utils/pretty_json.dart';
import 'package:monkey_lib/widgets/custom_load_more/load_more_content.dart';
import 'package:monkey_lib/widgets/custom_load_more/types.dart';

class LoadMoreList<T> extends CustomLoadMoreContent<T> {
  const LoadMoreList(super.key,
      {required super.state,
      required super.mainAxisDirection,
      required super.items,
      required super.scrollController,
      required super.storageKey,
      required super.streamController,
      required super.widget});

  List<Widget> buildListItems(List<T>? items, BuildContext context) {
    if (items == null) {
      return [];
    }
    return items.asMap().entries.map((e) {
      int idx = e.key;
      T item = e.value;
      return widget.listItemBuilder(context, idx, item);
    }).toList();
  }

  Widget? buildStateContent(BuildContext context) {
    switch (state) {
      case LoadMoreState.INIT:
        return null;
      case LoadMoreState.INIT_FAILED:
        return null;
      case LoadMoreState.STABLE:
        return null;
      case LoadMoreState.LOAD_MORE:
        return widget.loadMoreBuilder(context);
      case LoadMoreState.LOAD_MORE_FAILED:
        return widget.loadMoreFailedBuilder(context, () {
          streamController.add(LoadMoreEvent.RETRY_WHEN_LOAD_MORE_FAILED);
        });
      case LoadMoreState.NO_MORE:
        return widget.noMoreBuilder(context);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((p0, constrains) {
        double height = constrains.maxHeight;
        double width = constrains.maxWidth;
        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  Logger.w("add PULL_TO_REFRESH");
                  streamController.add(LoadMoreEvent.PULL_TO_REFRESH);
                },
                child: SingleChildScrollView(
                  key: storageKey,
                  controller: scrollController,
                  scrollDirection: mainAxisDirection,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ListBody(
                    mainAxis: mainAxisDirection,
                    children: [
                      ...buildBody(context),
                    ],
                  ),
                ),
              ),
              AnimatedScale(
                duration: const Duration(milliseconds: 600),
                scale: (state == LoadMoreState.INIT ||
                        state == LoadMoreState.INIT_FAILED)
                    ? 1
                    : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: (state == LoadMoreState.INIT ||
                          state == LoadMoreState.INIT_FAILED)
                      ? 1
                      : 0,
                  child: _buildInitState(context, state),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInitState(BuildContext context, LoadMoreState state) {
    if (state == LoadMoreState.INIT) {
      return Center(
        child: widget.initBuilder(context),
      );
    }
    if (state == LoadMoreState.INIT_FAILED) {
      return Center(
        child: widget.initFailedBuilder(
          context,
          () {
            Logger.w("add RETRY_WHEN_INIT_FAILED");
            streamController.add(LoadMoreEvent.RETRY_WHEN_INIT_FAILED);
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  List<Widget> buildBody(BuildContext context) {
    List<Widget> body = [];
    Widget? statusWidget = buildStateContent(context);
    List<Widget> bodyContent = buildListItems(items, context);
    if (statusWidget == null) {
      body = bodyContent;
      return body;
    }
    body = [...bodyContent, statusWidget];
    return body;
  }
}
