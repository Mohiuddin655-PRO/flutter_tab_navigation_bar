library flutter_widget_depender;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WidgetDepender extends StatefulWidget {
  final Size? defaultSize;
  final Widget depender;
  final Widget Function(BuildContext context, Size size) builder;

  const WidgetDepender({
    super.key,
    this.defaultSize,
    required this.depender,
    required this.builder,
  });

  @override
  State<WidgetDepender> createState() => _WidgetDependerState();
}

class _WidgetDependerState extends State<WidgetDepender> {
  final GlobalKey _key = GlobalKey();

  Size? size;

  @override
  Widget build(BuildContext context) {
    if (size != null) {
      return widget.builder(context, size!);
    }
    return WidgetRender(
      key: _key,
      wrapper: (value) => setState(() => size = value),
      child: widget.depender,
    );
  }
}

class WidgetRender extends SingleChildRenderObjectWidget {
  final Function(Size size) wrapper;

  const WidgetRender({
    super.key,
    required this.wrapper,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ObjectRender(wrapper);
  }
}

class ObjectRender extends RenderProxyBox {
  final Function(Size size) wrapper;

  Size? ox;

  ObjectRender(this.wrapper);

  @override
  void performLayout() {
    super.performLayout();
    try {
      Size? nx = child?.size;
      if (nx != null && ox != nx) {
        ox = nx;
        WidgetsBinding.instance.addPostFrameCallback((_) => wrapper(nx));
      }
    } catch (_) {}
  }
}
