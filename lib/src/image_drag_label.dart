/*
 * 项目名:    image_drag_label
 * 包名       
 * 文件名:    image_drag_label
 * 创建时间:  2021/8/22 on 17:57
 * 描述:     TODO
 *
 * @author   阿钟
 */
import 'dart:ui' as ui;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_drag_label/src/label_widget.dart';
import 'package:image_drag_label/src/label_info_bean.dart';

typedef LabelChange = void Function(LabelInfoBean label, bool willDelete);

class ImageDragLabel extends StatefulWidget {
  ///标签圆圈的大小
  final double circleSize;

  ///标签的高度
  final double labelHeight;

  ///删除矩形在屏幕上的位置
  final Rect deleteRect;
  final LabelChange? labelChange;

  ImageDragLabel(
      {Key? key,
      this.deleteRect = Rect.zero,
      this.labelChange,
      this.circleSize = 12,
      this.labelHeight = 28})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ImageDragLabelState();
  }
}

class ImageDragLabelState extends State<ImageDragLabel> {
  List<LabelInfoBean> _labels = [];
  GlobalKey _stackKey = GlobalKey();

  ///Stack相对于屏幕的起点
  Offset containerOffset = Offset.zero;

  ///图片相对于Stack的起点
  Offset imgStartOffset = Offset.zero;

  ///Stack大小
  Size? containerSize;
  Rect? imgRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((callback) {
      containerSize = _getWidgetSize(_stackKey);
      containerOffset = _location(_stackKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _stackKey,
      children: <Widget>[
            Center(
              child: ExtendedImage.network(
                'https://oss-fg.feng-go.com/assets/pic/image2021081629705239222830547.jpg',
                fit: BoxFit.contain,
                loadStateChanged: (ExtendedImageState state) {
                  if (state.extendedImageLoadState == LoadState.completed) {
                    imgRect = _calcImgRect(state.extendedImageInfo?.image);
                  }
                },
              ),
            ),
          ] +
          _labels
              .map((e) {
                var label = LabelWidget(
                    key: e.key,
                    name: e.name,
                    labelHeight: widget.labelHeight,
                    sizeCallback: (size) => e.labelSize = size);
                return Positioned(
                    left: e.offset.dx,
                    top: e.offset.dy,
                    child: Draggable(
                      child: label,
                      feedback: Material(
                          color: Colors.transparent, child: _feedbackWidget()),

                      ///为了在拖动的时候通过key还能拿到标签对象
                      childWhenDragging: Offstage(child: label),
                      onDragUpdate: (detail) {
                        _dragUpdate(e, detail.globalPosition);
                      },
                      onDragEnd: (detail) {
                        _dragEnd(e, detail.offset);
                      },
                    ));
              })
              .toList()
              .cast<Widget>(),
    );
  }

  void _dragUpdate(LabelInfoBean label, Offset offset) {
    if (widget.deleteRect.contains(offset)) {
      widget.labelChange?.call(label, true);
    } else {
      widget.labelChange?.call(label, false);
    }
  }

  ///判断拖动的点是否在图片矩形内和删除矩形
  void _dragEnd(LabelInfoBean label, Offset offset) {
    ///因为标签占据大小，所以图片矩形需要缩小一些
    Rect tempRect = Rect.fromLTWH(
        imgRect!.left,
        imgRect!.top,
        imgRect!.width - widget.circleSize,
        imgRect!.height - widget.labelHeight);
    if (tempRect.contains(offset)) {
      label.offset = offset - containerOffset;

      ///判断是否需要改变标签布局方向
      LabelWidgetState labelState = label.state;
      if (label.offset.dx + label.labelSize.width >
          tempRect.right - containerOffset.dx) {
        labelState.changeToLeft();
      } else {
        labelState.changeToRight();
      }
      label.orientation = labelState.orientation;
      setState(() {});
      return;
    }
    if (widget.deleteRect.contains(offset)) {
      _labels.remove(label);
      widget.labelChange?.call(label, false);
      setState(() {});
      return;
    }
  }

  ///初始化标签初始位置
  Rect? _calcImgRect(ui.Image? image) {
    if (imgRect != null) return imgRect;
    if (containerSize == null) return imgRect;
    Size realImgSize = _calcImgSize(image);
    print('计算图片的真实大小：$realImgSize');
    double imgOffsetX = (containerSize!.width - realImgSize.width) / 2;
    double imgOffsetY = (containerSize!.height - realImgSize.height) / 2;
    imgStartOffset = Offset(imgOffsetX, imgOffsetY);

    ///计算图片左上角在屏幕上的位置
    Offset imgOffset = containerOffset + Offset(imgOffsetX, imgOffsetY);
    Rect rect = imgOffset & realImgSize;
    print('图片矩形在屏幕的位置：$rect');
    return rect;
  }

  ///计算图片的真实大小
  ///[image] 图片模式
  ///[BoxFit.contain] 计算模式
  Size _calcImgSize(ui.Image? image) {
    if (image == null || containerSize == null) return Size.zero;
    Size result = Size.zero;
    double imageAspectRatio = image.width.toDouble() / image.height.toDouble();
    double containerRatio = containerSize!.width / containerSize!.height;
    if (containerRatio > imageAspectRatio) {
      result =
          Size(imageAspectRatio * containerSize!.height, containerSize!.height);
    } else {
      result = Size(
          containerSize!.width,
          image.height.toDouble() *
              containerSize!.width /
              image.width.toDouble());
    }
    return result;
  }

  ///获取组件在屏幕上的位置
  Offset _location(GlobalKey key) {
    RenderBox? renderBox = key.currentContext!.findRenderObject() as RenderBox?;
    return renderBox!.localToGlobal(Offset.zero);
  }

  ///获取组件的大小
  Size _getWidgetSize(GlobalKey key) {
    return key.currentContext!.size!;
  }

  Widget _feedbackWidget() {
    return Container(
      height: widget.labelHeight,
      child: Stack(
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
    );
  }

  void addLabel() {
    _labels.add(
      LabelInfoBean(
        '我是第个${_labels.length}标签呀',
        startOffset: imgStartOffset,
        imgSize: Size(imgRect?.width ?? 0, imgRect?.height ?? 0),
      ),
    );
    setState(() {});
  }

  List<LabelInfoBean> get labels => _labels;
}
