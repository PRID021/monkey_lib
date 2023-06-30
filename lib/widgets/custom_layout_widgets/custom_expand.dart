import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monkey_lib/widgets/custom_layout_widgets/custom_column.dart';

class CustomExpand extends ParentDataWidget<CustomColumnParentData> {
  final int flex;

  const CustomExpand({Key? key, required super.child, this.flex = 1})
      : assert(flex >= 0),
        super(key: key);
  @override
  void applyParentData(RenderObject renderObject) {
    final CustomColumnParentData parentData =
        renderObject.parentData as CustomColumnParentData;

    if (parentData.flex != flex) {
      parentData.flex = flex;
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CustomColumn;
}
