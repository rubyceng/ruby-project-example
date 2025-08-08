import 'package:flutter/material.dart';

/// setState 适合组件内部状态更新
/// 适合独立管理自身状态
/// 状态被完全限制在这个 Widget 内部

class SelfStateCounter extends StatefulWidget {
  const SelfStateCounter({super.key});

  @override
  State<SelfStateCounter> createState() => _SelfStateCounterState();
}

class _SelfStateCounterState extends State<SelfStateCounter> {
  // 1. 状态（数据）作为 State 类的属性
  int _counter = 0;

  void _increment() {
    // 2. 调用 setState() 来更新状态并触发 UI 重建
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Local State Counter: $_counter',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 16),
        ElevatedButton(onPressed: _increment, child: const Icon(Icons.add)),
      ],
    );
  }
}
