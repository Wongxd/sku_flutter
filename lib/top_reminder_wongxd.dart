import 'dart:async';
import 'package:flutter/material.dart';

///
/// 自定义的顶部提醒组件
///
///Created by Wongxd on 2020/6/17.
///https://github.com/Wongxd
///wxd1@live.com
///
class TopReminder extends StatefulWidget {
  /// 提醒文本。
  final String reminderText;
  final Color bgColor;
  final Color textColor;
  final double height;
  final double textSize;

  ///以秒为单位
  final int duration;

  TopReminder({
    @required this.reminderText,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
    this.duration = 3,
    this.height = 90.0,
    this.textSize = 18.0,
  });

  /// 实现“路由导航”。
  /// 打开顶部提醒页面。
  static void openTopReminder(context, TopReminder topReminder) {
    // 导航器（`Navigator`）组件，用于管理具有堆栈规则的一组子组件。
    // 许多应用程序在其窗口组件层次结构的顶部附近有一个导航器，以便使用叠加显示其逻辑历史记录，
    // 最近访问过的页面可视化地显示在旧页面之上。使用此模式，
    // 导航器可以通过在叠加层中移动组件来直观地从一个页面转换到另一个页面。
    // 类似地，导航器可用于通过将对话框窗口组件放置在当前页面上方来显示对话框。
    // 导航器（`Navigator`）组件的关于（`of`）方法，来自此类的最近实例的状态，它包含给定的上下文。
    // 导航器（`Navigator`）组件的推（`push`）方法，将给定路径推送到最紧密包围给定上下文的导航器。
    Navigator.of(context).push(
      // 页面路由生成器（`PageRouteBuilder`）组件，用于根据回调定义一次性页面路由的实用程序类。
      PageRouteBuilder(
          // 转换完成后路由是否会遮盖以前的路由。
          opaque: false,
          // 页面构建器（`pageBuilder`）属性，用于构建路径的主要内容。
          pageBuilder: (BuildContext context, _, __) {
            return topReminder;
          },

          /// 实现“过渡动画”。
          // 转换生成器（`transitionsBuilder`）属性，用于构建路径的转换。
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            // 淡出过渡（`FadeTransition`）组件，动画组件的不透明度。
            // https://docs.flutter.io/flutter/widgets/FadeTransition-class.html
            return FadeTransition(
              // 不透明度（`opacity`）属性，控制子组件不透明度的动画。
              opacity: animation,
              // 滑动过渡（`SlideTransition`）组件，动画组件相对于其正常位置的位置。
              // https://docs.flutter.io/flutter/widgets/SlideTransition-class.html
              child: SlideTransition(
                // 位置（`position`）属性，控制子组件位置的动画。
                // 两者之间（`Tween`）类，开始值和结束值之间的线性插值。
                // 偏移（`Offset`）类，不可变的2D浮点偏移量。
                position: Tween<Offset>(
                  // 两者之间（`Tween`）类的开始（`begin`）属性，此变量在动画开头的值。
                  begin: Offset(0.0, -0.3),
                  // 两者之间（`Tween`）类的结束（`end`）属性，此变量在动画结束时的值。
                  end: Offset.zero,
                  // 两者之间（`Tween`）类的活跃（`animate`）方法，返回由给定动画驱动但接受由此对象确定的值的新动画。
                ).animate(animation),
                child: child,
              ),
            );
          }),
    );
  }

  static void info(
    BuildContext context,
    String content, {
    int duration = 3,
    double height = 90.0,
    double textSize = 18.0,
    textColor: Colors.white,
  }) {
    openTopReminder(
        context,
        TopReminder(
          reminderText: content,
          bgColor: Colors.blue,
          duration: duration,
          height: height,
          textSize: textSize,
          textColor: textColor,
        ));
  }

  static void success(
    BuildContext context,
    String content, {
    int duration = 3,
    double height = 90.0,
    double textSize = 18.0,
    textColor: Colors.white,
  }) {
    openTopReminder(
        context,
        TopReminder(
          reminderText: content,
          bgColor: Colors.blue,
          duration: duration,
          height: height,
          textSize: textSize,
          textColor: textColor,
        ));
  }

  static void warning(
    BuildContext context,
    String content, {
    int duration = 3,
    double height = 90.0,
    double textSize = 18.0,
    textColor: Colors.black,
  }) {
    openTopReminder(
        context,
        TopReminder(
          reminderText: content,
          bgColor: Colors.yellowAccent,
          duration: duration,
          height: height,
          textSize: textSize,
          textColor: textColor,
        ));
  }

  static void error(
    BuildContext context,
    String content, {
    int duration = 3,
    double height = 90.0,
    double textSize = 18.0,
    textColor: Colors.white,
  }) {
    openTopReminder(
        context,
        TopReminder(
          reminderText: content,
          bgColor: Colors.red,
          duration: duration,
          height: height,
          textSize: textSize,
          textColor: textColor,
        ));
  }

  @override
  _TopReminderState createState() => _TopReminderState();
}

/// 与自定义的顶部提醒组件关联的状态子类。
class _TopReminderState extends State<TopReminder> {
  /// 倒计时的计时器。
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  /// 启动倒计时的计时器。
  _startTimer() {
    _timer = Timer(
      // 持续时间参数。
      Duration(seconds: widget.duration),
      // 回调函数参数。
      () {
        Navigator.of(context).pop(true);
      },
    );
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _cancelTimer();
        Navigator.of(context).pop(true);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            // 双精度（`double`）类的无穷（`infinity`）常量，最大宽度。
            width: double.infinity,
            height: widget.height,
            color: widget.bgColor,
            child: Align(
              alignment: Alignment.center,
              // 使用材料（`Material`）组件来避免文本下方的黄色线条。
              child: Material(
                color: widget.bgColor,
                child: Text(
                  widget.reminderText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: widget.textSize,
                    color: widget.textColor,
                  ),
                ),
              ),
            ),
          ),
          // 不透明度（`Opacity`）组件，使子组件部分透明。
          Opacity(
            // 不透明度（`opacity`）属性，缩放子组件的阿尔法通道（`alpha`）值的分数。
            // 不透明度为1.0是完全不透明的，不透明度为0.0是完全透明的（即不可见）。
            opacity: 0.5,
            child: Container(
              height: 0,
              color: const Color(0xFFCCCCCC),
            ),
          ),
        ],
      ),
    );
  }
}
