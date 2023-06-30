import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:monkey_lib/widgets/custom_layout_widgets/custom_column.dart';

class CustomBox extends LeafRenderObjectWidget {
  final int flex;
  final Color color;

  const CustomBox(this.flex, this.color, {super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomBox(flex: flex, color: color);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomBox renderObject) {
    renderObject
      ..flex = flex
      ..color = color;
  }
}

class RenderCustomBox extends RenderBox {
  RenderCustomBox({
    required int flex,
    required Color color,
  })  : _flex = flex,
        _color = color;
  int get flex => _flex;
  set flex(int value) {
    assert(value >= 0);
    if (_flex == value) return;
    _flex = value;
    parentData!.flex = value;
    markParentNeedsLayout();
  }

  int _flex;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  Color _color;

  @override
  CustomColumnParentData? get parentData {
    if (super.parentData == null) return null;
    assert(super.parentData is CustomColumnParentData,
        'parentData is not CustomColumnParentData');
    return super.parentData as CustomColumnParentData;
  }

  // it seem like init state

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    parentData!.flex = flex;
  }

  // Alway set that when the size depends on the parent
  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }
}
