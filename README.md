### 一个可随意在图片上标记的标签，包括标签的展示
### [Flutter使用Draggable与自定义RenderObject实现图片添加标签，随意拖动位置效果](https://azhon.blog.csdn.net/article/details/119899192)
### 效果图展示
<img src="https://github.com/Xie-Yin/image_drag_label/blob/main/img/screen_0.jpg" width="300"/>  <img src="https://github.com/Xie-Yin/image_drag_label/blob/main/img/screen_1.jpg" width="300"/>
<img src="https://github.com/Xie-Yin/image_drag_label/blob/main/img/screen_2.jpg" width="300"/>  <img src="https://github.com/Xie-Yin/image_drag_label/blob/main/img/screen_3.jpg" width="300"/>

### 实现的功能与使用到技术点
- 功能
    - 标签拖动的时候显为一个圆点
    - 标签只能在图片显示的范围内拖动
    - 标签可以拖动到指定位置删除
    - 标签拖动到左边或者右边，根据剩余宽度自动改变标签布局方向
- 技术点
    - Draggable拖动组件
    - 自定义RenderObject、RenderBox 参与组件绘制、摆放流程
    - 图片使用BoxFit后，计算在容器内的实际位置
