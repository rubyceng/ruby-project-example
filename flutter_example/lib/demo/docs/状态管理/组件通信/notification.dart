import 'package:flutter/material.dart';

/// Notification 是一个事件通信机制。它的核心思想是**“我（一个子组件）发生了一件事，我把这个事件向上传递，希望我的某个祖先能听到并处理它
/// 事件冒泡 数据是单向的，并且是冒泡式的。

/// 实现方式
/// 定义事件: 创建一个继承自 Notification 的类，它可以携带事件相关的数据。
/// 监听事件: 在一个祖先组件外层包裹 NotificationListener`<`T`>`，并提供 onNotification 回调函数。
/// 派发事件: 在任何需要发送信号的子孙组件中，创建 Notification 实例并调用其 .dispatch(context) 方法。

// 1. 定义一个通知类
class ColorChangeNotification extends Notification {
  final Color color;
  ColorChangeNotification(this.color);
}

// 2. 在顶层监听通知
class NotificationExample extends StatefulWidget {
  const NotificationExample({super.key});
  @override
  State<NotificationExample> createState() => _NotificationExampleState();
}

class _NotificationExampleState extends State<NotificationExample> {
  Color _containerColor = Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    // 使用 NotificationListener 包裹子树
    return NotificationListener<ColorChangeNotification>(
      // 收到通知时的回调
      onNotification: (notification) {
        setState(() {
          _containerColor = notification.color;
        });
        // 返回 true 表示事件已经被处理，不再向上冒泡
        return true;
      },
      child: Container(
        color: _containerColor,
        padding: const EdgeInsets.all(20),
        child: const DeeplyNestedButton(), // 嵌套很深的子组件
      ),
    );
  }
}

// 3. 在深层子组件中派发通知
class DeeplyNestedButton extends StatelessWidget {
  const DeeplyNestedButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Change Parent Color'),
        onPressed: () {
          // 派发一个通知，任何上层的 NotificationListener<ColorChangeNotification> 都可以接收到
          ColorChangeNotification(Colors.teal.shade100).dispatch(context);
        },
      ),
    );
  }
}
