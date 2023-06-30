import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:collection';

import 'package:monkey_lib/utils/pretty_json.dart';

enum CustomColumAlign { start, center }

class CustomColumn extends MultiChildRenderObjectWidget {
  CustomColumn({
    Key? key,
    List<Widget> children = const <Widget>[],
    this.align = CustomColumAlign.start,
  }) : super(key: key, children: children);
  final CustomColumAlign align;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomColumn(
      align: align,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomColumn renderObject) {
    renderObject.align = align;
  }
}

class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  int? flex;
}

class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  RenderCustomColumn({required CustomColumAlign align}) : _align = align;
  CustomColumAlign get align => _align;
  set align(CustomColumAlign value) {
    if (_align == value) return;
    _align = value;
    markNeedsLayout();
  }

  CustomColumAlign _align;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! CustomColumnParentData) {
      child.parentData = CustomColumnParentData();
    }
  }

  Size _performSize({required BoxConstraints constraints, required bool dry}) {
    double width = 0, height = 0, totalFlex = 0;
    RenderBox? child = firstChild;
    List<RenderBox> flexibleChildren = [];

    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final int flex = childParentData.flex ?? 0;
      if (flex > 0) {
        totalFlex += flex;
        if (!flexibleChildren.contains(child)) {
          flexibleChildren.add(child);
        }
      }
      if (flex == 0) {
        late final Size childSize;
        if (!dry) {
          child.layout(BoxConstraints(maxWidth: constraints.maxWidth),
              parentUsesSize: true);
          childSize = child.size;
        }
        if (dry) {
          childSize = child
              .computeDryLayout(BoxConstraints(maxWidth: constraints.maxWidth));
        }
        height += childSize.height;
        width = max(width, childSize.width);
      }
      child = childParentData.nextSibling;
    }
    double flexHeight = (constraints.maxHeight - height) / totalFlex;
    for (RenderBox child in flexibleChildren) {
      final childParentData = child.parentData as CustomColumnParentData;
      final double childHeight = flexHeight * childParentData.flex!;
      late final Size childSize;
      if (!dry) {
        child.layout(
            BoxConstraints(
                minHeight: childHeight,
                maxHeight: childHeight,
                maxWidth: constraints.maxWidth),
            parentUsesSize: true);
        childSize = child.size;
      }
      if (dry) {
        childSize = child.computeDryLayout(BoxConstraints(
            minHeight: childHeight,
            maxHeight: childHeight,
            maxWidth: constraints.maxWidth));
      }

      height += childSize.height;
      width = max(width, childSize.width);
    }
    return Size(width, height);
  }

  Size _maxChildSize(BoxConstraints constraints) {
    double width = 0, height = 0;
    RenderBox? child = firstChild;

    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final int flex = childParentData.flex ?? 0;
      if (flex == 0) {
        Size childSize = child.getDryLayout(constraints);
        if (childSize < constraints.biggest) {
          height = max(height, childSize.height);
          width = max(width, childSize.width);
        }
      }

      child = childParentData.nextSibling;
    }
    return Size(width, height);
  }

  Size _layoutChild(BoxConstraints constraints) {
    Size maxSize = _maxChildSize(constraints);
    RenderBox? child = firstChild;
    int totalFlex = 0;
    double totalHeight = 0;
    List<RenderBox> flexibleChildren = [];
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final int flex = childParentData.flex ?? 0;
      if (flex == 0) {
        child.layout(
            BoxConstraints(
              minHeight: maxSize.height,
              maxHeight: maxSize.height,
              maxWidth: constraints.biggest.width,
              minWidth: constraints.biggest.width,
              // maxWidth: constraints.biggest.width,
              // minWidth: constraints.biggest.width,
            ),
            parentUsesSize: true);
        totalHeight += child.size.height;
      }
      if (flex > 0) {
        if (!flexibleChildren.contains(child)) {
          flexibleChildren.add(child);
          totalFlex += flex;
        }
      }
      child = childParentData.nextSibling;
    }

    double flexHeight = ((constraints.maxHeight - totalHeight) / totalFlex);

    for (RenderBox child in flexibleChildren) {
      final childParentData = child.parentData as CustomColumnParentData;
      final int flex = childParentData.flex ?? 0;
      child.layout(
          BoxConstraints(
            minHeight: flexHeight * flex,
            maxHeight: flexHeight * flex,
            maxWidth: constraints.biggest.width,
            minWidth: constraints.biggest.width,
          ),
          parentUsesSize: true);
      totalHeight += child.size.height;
    }
    Logger.w("totalHeight $totalHeight");
    return constraints.biggest;
  }

  @override
  void performLayout() {
    size = _layoutChild(constraints);
    // Position the children
    Offset childOffset = const Offset(0, 0);
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final int flex = childParentData.flex ?? 0;
      childParentData.offset = Offset(
          align == CustomColumAlign.center
              ? (size.width - child.size.width) / 2
              : 0,
          childOffset.dy);
      childOffset += Offset(0, child.size.height);
      child = childParentData.nextSibling;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _performSize(constraints: constraints, dry: true);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    double width = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final int flex = childParentData.flex ?? 0;
      if (flex == 0) {
        if (width == 0) {
          width = child.getMaxIntrinsicWidth(height);
        }
        width = max(width, child.getMaxIntrinsicWidth(height));
      }
      child = childParentData.nextSibling;
    }
    return width;
  }

  // @override
  // double computeMinIntrinsicWidth(double height) {
  //   double width = 0;
  //   RenderBox? child = firstChild;
  //   while (child != null) {
  //     final childParentData = child.parentData as CustomColumnParentData;
  //     final int flex = childParentData.flex ?? 0;
  //     if (flex == 0) {
  //       if (width == 0) {
  //         width = child.getMinIntrinsicWidth(height);
  //       }
  //       width = max(width, child.getMinIntrinsicWidth(height));
  //     }
  //     child = childParentData.nextSibling;
  //   }
  //   return width;
  // }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    double height = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final int flex = childParentData.flex ?? 0;
      if (flex == 0) {
        height += child.getMaxIntrinsicHeight(width);
      }
      child = childParentData.nextSibling;
    }
    return height;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    double height = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final int flex = childParentData.flex ?? 0;
      if (flex == 0) {
        height += child.getMinIntrinsicHeight(width);
      }
      child = childParentData.nextSibling;
    }
    return height;
  }
}
