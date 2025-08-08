import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 自定义滚动行为，让应用在所有设备上都能通过拖动来滚动
class CustomScrollBehavior extends MaterialScrollBehavior {
  // 重写 asembledDirectDragDevices 方法
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    // 对于一些触控板或外接设备
    PointerDeviceKind.trackpad,
  };
}
