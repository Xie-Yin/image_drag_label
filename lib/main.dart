import 'package:flutter/material.dart';
import 'package:image_drag_label/src/image_drag_label.dart';
import 'package:image_drag_label/src/label_info_bean.dart';
import 'package:image_drag_label/test_show_page.dart';

const double CIRCLE_SIZE = 12;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '一个可随意在图片上标记的标签',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ImageDragLabelState> key = GlobalKey();
  Color deleteColor = Colors.grey;

  double get deleteTopRectHeight {
    return 37;
  }

  double get deleteRectHeight {
    return 116;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              color: Color(0xFFEEEEEE),
              child: ImageDragLabel(
                key: key,
                circleSize: CIRCLE_SIZE,
                labelChange: (LabelInfoBean label, bool willDelete) {
                  setState(() {
                    deleteColor = willDelete ? Colors.red : Colors.grey;
                  });
                },
                deleteRect: Rect.fromLTWH(0, size.height - deleteRectHeight,
                    size.width, deleteRectHeight),
              ),
            ),
          ),
          Container(
            height: deleteRectHeight,
            color: deleteColor,
            margin: EdgeInsets.only(top: deleteTopRectHeight),
            child: Center(
              child: Text(
                '拖动标签到此区域可删除',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        '一个可随意在图片上标记的标签',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                key.currentState!.addLabel();
              },
              child: Center(child: Text('添加', style: TextStyle(fontSize: 14))),
            ),
            SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TestShowPage(labels: key.currentState!.labels);
                }));
              },
              child: Center(child: Text('展示', style: TextStyle(fontSize: 14))),
            ),
            SizedBox(width: 16),
          ],
        )
      ],
    );
  }
}
