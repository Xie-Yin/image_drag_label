/*
 * 项目名:    image_drag_label
 * 包名
 * 文件名:    label_widget
 * 创建时间:  2021/8/22 on 17:57
 * 描述:     TODO
 *
 * @author   阿钟
 */
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LabelOrientation {
  static const int LEFT = 1;
  static const int RIGHT = 2;
}

class LabelWidget extends StatefulWidget {
  ///标签名字
  final String name;

  ///标签方向
  ///在点的右边[LabelOrientation.RIGHT]
  ///在点的左边[LabelOrientation.LEFT]
  final int orientation;

  ///获取标签的实际大小
  final ValueChanged<Size>? sizeCallback;

  ///是否可拖动
  final bool canMove;

  ///圆圈大小
  final double circleSize;

  ///标签高度
  final double labelHeight;

  LabelWidget(
      {Key? key,
      required this.name,
      this.circleSize = 12.0,
      this.labelHeight = 28.0,
      this.canMove = true,
      this.sizeCallback,
      this.orientation = LabelOrientation.RIGHT})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LabelWidgetState();
  }
}

class LabelWidgetState extends State<LabelWidget> {
  late int orientation;

  @override
  void initState() {
    super.initState();
    orientation = widget.orientation;
  }

  @override
  Widget build(BuildContext context) {
    Widget label = orientation == LabelOrientation.RIGHT
        ? _rightTagLabel(widget.name)
        : _leftTagLabel(widget.name);
    if (widget.canMove) {
      return ShopGoodsLabelRenderObjectWidget(
        label,
        Size(widget.circleSize, widget.labelHeight),
        orientation,
        sizeCallback: widget.sizeCallback,
      );
    } else {
      return label;
    }
  }

  void changeToLeft() {
    if (orientation == LabelOrientation.LEFT) return;
    orientation = LabelOrientation.LEFT;
    setState(() {});
  }

  void changeToRight() {
    if (orientation == LabelOrientation.RIGHT) return;
    orientation = LabelOrientation.RIGHT;
    setState(() {});
  }

  Widget _rightTagLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.circleSize,
              height: widget.circleSize,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Container(
              width: widget.circleSize / 2,
              height: widget.circleSize / 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
        SizedBox(width: 4),
        Container(
          height: widget.labelHeight,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(56),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _leftTagLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: widget.labelHeight,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(56),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        SizedBox(width: 4),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.circleSize,
              height: widget.circleSize,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Container(
              width: widget.circleSize / 2,
              height: widget.circleSize / 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ShopGoodsLabelRenderObjectWidget extends SingleChildRenderObjectWidget {
  final Size circleSize;
  final ValueChanged<Size>? sizeCallback;
  final int orientation;

  ShopGoodsLabelRenderObjectWidget(
      Widget child, this.circleSize, this.orientation,
      {this.sizeCallback})
      : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ShopGoodsLabelBox(circleSize, orientation,
        sizeCallback: sizeCallback);
  }

  @override
  void updateRenderObject(
      BuildContext context, ShopGoodsLabelBox renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.orientation = orientation;
    renderObject.markNeedsLayout();
  }
}

class ShopGoodsLabelBox extends RenderProxyBox with RenderProxyBoxMixin {
  final Size circleSize;
  late Size realSize;
  final ValueChanged<Size>? sizeCallback;
  int orientation;

  ShopGoodsLabelBox(this.circleSize, this.orientation, {this.sizeCallback});

  @override
  void performLayout() {
    super.performLayout();
    realSize = size;
    sizeCallback?.call(realSize);
    size = circleSize;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (orientation == LabelOrientation.LEFT) {
      offset = Offset(offset.dx - realSize.width + circleSize.width, offset.dy);
    }
    if (child != null) context.paintChild(child!, offset);
  }
}
