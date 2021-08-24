/*
 * 项目名:    image_drag_label
 * 包名       
 * 文件名:    test_show_page
 * 创建时间:  2021/8/24 on 14:41
 * 描述:     TODO
 *
 * @author   阿钟
 */
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_drag_label/main.dart';
import 'package:image_drag_label/src/label_info_bean.dart';
import 'package:image_drag_label/src/label_widget.dart';

class TestShowPage extends StatefulWidget {
  final List<LabelInfoBean> labels;

  const TestShowPage({Key? key, required this.labels}) : super(key: key);

  @override
  _TestShowPageState createState() => _TestShowPageState();
}

class _TestShowPageState extends State<TestShowPage> {
  final String img =
      'https://oss-fg.feng-go.com/assets/pic/image2021081629705239222830547.jpg';
  late Size containerSize;

  @override
  Widget build(BuildContext context) {
    containerSize = Size(MediaQuery.of(context).size.width, 500);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('标签显示', style: TextStyle(fontSize: 16)),
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        width: containerSize.width,
        height: containerSize.height,
        child: Stack(
          children: <Widget>[
                Center(
                  child: ExtendedImage.network(
                    img,
                    fit: BoxFit.contain,
                  ),
                ),
              ] +
              _showLabel(),
        ),
      ),
    );
  }

  ///展示标签
  List<Widget> _showLabel() {
    if (widget.labels.length == 0) return [];

    ///图片的宽高比和高宽比
    LabelInfoBean label = widget.labels.first;
    double imgWHRatio = label.imgSize.width / label.imgSize.height;
    double imgHWRatio = label.imgSize.height / label.imgSize.width;
    return widget.labels
        .map((element) {
          ///计算图片的大小
          Size realImgSize = _calcImgSize(imgWHRatio, imgHWRatio);

          ///点在原来图片上的x、y比例
          Offset percent = _calcPercent(element.relativeOffset, label.imgSize);

          double offsetX = (containerSize.width - realImgSize.width) / 2;
          double offsetY = (containerSize.height - realImgSize.height) / 2;
          double x = percent.dx * realImgSize.width;
          double y = percent.dy * realImgSize.height;

          ///左边显示
          if (element.orientation == LabelOrientation.LEFT) {
            double x = (1 - percent.dx) * realImgSize.width;
            Offset end = Offset(offsetX + x - CIRCLE_SIZE, offsetY + y);
            return Positioned(
              right: end.dx,
              top: end.dy,
              child: LabelWidget(
                name: element.name,
                canMove: false,
                orientation: LabelOrientation.LEFT,
              ),
            );
          } else {
            Offset end = Offset(offsetX + x, offsetY + y);
            return Positioned(
              left: end.dx,
              top: end.dy,
              child: LabelWidget(
                name: element.name,
                canMove: false,
                orientation: LabelOrientation.RIGHT,
              ),
            );
          }
        })
        .toList()
        .cast<Widget>();
  }

  ///计算图片高度
  ///[whRation] 宽高比
  ///[hwRation] 高宽比
  Size _calcImgSize(double whRation, double hwRation) {
    Size result = Size.zero;
    double containerRatio = containerSize.width / containerSize.height;
    if (containerRatio > whRation) {
      result = Size(whRation * containerSize.height, containerSize.height);
    } else {
      result = Size(containerSize.width, hwRation * containerSize.width);
    }
    return result;
  }

  ///计算x，y比例
  Offset _calcPercent(Offset offset, Size imgSize) {
    double x = offset.dx / imgSize.width;
    double y = offset.dy / imgSize.height;
    return Offset(x, y);
  }
}
