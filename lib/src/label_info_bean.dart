/*
 * 项目名:    image_drag_label
 * 包名       
 * 文件名:    label_info_bean
 * 创建时间:  2021/8/23 on 10:14
 * 描述:     TODO
 *
 * @author   阿钟
 */
import 'package:flutter/material.dart';
import 'package:image_drag_label/src/label_widget.dart';

class LabelInfoBean {
  ///标签大小
  late Size labelSize;

  ///图片大小，用于计算高比
  Size imgSize;

  ///标签名称
  String name;

  ///图片在容器的起点坐标
  Offset startOffset;
  Offset offset = Offset.zero;
  int orientation = LabelOrientation.RIGHT;
  GlobalKey<LabelWidgetState> key = GlobalKey();

  LabelInfoBean(this.name,
      {this.startOffset = Offset.zero, this.imgSize = Size.zero}) {
    offset = startOffset;
  }

  LabelWidgetState get state => key.currentState!;

  ///获取相对于容器左上角的offset
  Offset get relativeOffset => offset - startOffset;
}
