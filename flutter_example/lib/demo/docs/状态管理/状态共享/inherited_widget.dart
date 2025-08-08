import 'package:flutter/material.dart';

/// InheritedWidget 传递共享状态

/// Flutter 官方提供的、用于在 Widget 树中高效地将数据从祖先传递给后代的机制。
/// 实现方式: 创建一个继承自 InheritedWidget 的类来承载共享数据。子孙组件通过 context.dependOnInheritedWidgetOfExactType`<`T`>() 来获取这个祖先 InheritedWidget 的实例并注册依赖。
/// 当 InheritedWidget 更新时，所有依赖它的后代都会自动重建。
/// 状态共享: 非常适合跨越多层的父子组件和兄弟组件共享。兄弟组件可以访问同一个 InheritedWidget 祖先来获取和同步状态。

// 1. 创建一个继承自 InheritedWidget 的类 -- 共享的状态
class SharedColorWidget extends InheritedWidget {
  final Color color;
  final Function(Color) onColorChange;

  const SharedColorWidget({
    super.key,
    required this.color,
    required this.onColorChange,
    required super.child,
  });

  // 静态 of 方法，方便后代获取实例
  static SharedColorWidget of(BuildContext context) {
    final SharedColorWidget? result = context
        .dependOnInheritedWidgetOfExactType<SharedColorWidget>();
    assert(result != null, 'No SharedColorWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(SharedColorWidget oldWidget) {
    // 当 color 变化时，通知依赖它的后代重建
    return color != oldWidget.color;
  }
}

// 2. 在顶层管理状态，并使用 InheritedWidget 提供数据
class InheritedWidgetExample extends StatefulWidget {
  const InheritedWidgetExample({super.key});
  @override
  State<InheritedWidgetExample> createState() => _InheritedWidgetExampleState();
}

class _InheritedWidgetExampleState extends State<InheritedWidgetExample> {
  Color _color = Colors.blue;

  void _changeColor(Color newColor) {
    setState(() {
      _color = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SharedColorWidget(
      color: _color,
      onColorChange: _changeColor,
      child: Column(
        children: [
          // 这两个兄弟组件都可以访问到 SharedColorWidget
          const ColorDisplay(),
          const SizedBox(height: 10),
          const ColorChangeButton(),
        ],
      ),
    );
  }
}

// 3. 后代组件 A：显示颜色
class ColorDisplay extends StatelessWidget {
  const ColorDisplay({super.key});
  @override
  Widget build(BuildContext context) {
    final sharedColor = SharedColorWidget.of(context).color;
    return Container(width: 50, height: 50, color: sharedColor);
  }
}

// 4. 后代组件 B：改变颜色
class ColorChangeButton extends StatelessWidget {
  const ColorChangeButton({super.key});
  @override
  Widget build(BuildContext context) {
    final sharedColorData = SharedColorWidget.of(context);
    return ElevatedButton(
      child: const Text('Change Color'),
      onPressed: () {
        final newColor = sharedColorData.color == Colors.blue
            ? Colors.red
            : Colors.blue;
        sharedColorData.onColorChange(newColor);
      },
    );
  }
}
