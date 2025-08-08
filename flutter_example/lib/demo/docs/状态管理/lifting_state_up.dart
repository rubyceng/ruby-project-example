import 'package:flutter/material.dart';

/// 状态提升 -- 回调函数法
/// 将“状态共享”和“组件间通信”耦合在一起的模式。

/// 组件间通信：
/// 将共享状态提升到需要共享该状态的组件们的最近共同父组件中进行管理。
/// 父 -> 子: 父组件通过子组件的构造函数将状态数据传递下去。
/// 子 -> 父: 父组件通过子组件的构造函数传递一个回调函数下去。子组件在需要改变状态时，调用这个回调函数，由父组件来执行真正的 setState() 操作。
/// 状态共享: 主要用于父子组件。兄弟组件间的共享可以通过共同的父组件作为中介来实现。

// 父组件，持有并管理状态
class LiftingStateUpExample extends StatefulWidget {
  const LiftingStateUpExample({super.key});
  @override
  State<LiftingStateUpExample> createState() => _LiftingStateUpExampleState();
}

class _LiftingStateUpExampleState extends State<LiftingStateUpExample> {
  bool _isActive = false;

  // 回调函数，用于接收子组件的事件
  void _handleSwitchChanged(bool newValue) {
    setState(() {
      _isActive = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 子组件 A 和 B 是兄弟组件，通过父组件共享 _isActive 状态
    return Column(
      children: [
        // 状态向下传递给子组件 A
        StatusDisplay(isActive: _isActive),
        const SizedBox(height: 10),
        // 状态和回调函数都向下传递给子组件 B
        ControlSwitch(
          isActive: _isActive,
          onChanged: _handleSwitchChanged, // 关键：传递回调
        ),
      ],
    );
  }
}

// 子组件 A：只负责显示状态
class StatusDisplay extends StatelessWidget {
  final bool isActive;
  const StatusDisplay({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Text(
      isActive ? 'Active' : 'Inactive',
      style: TextStyle(
        color: isActive ? Colors.green : Colors.red,
        fontSize: 18,
      ),
    );
  }
}

// 子组件 B：负责触发状态变更
class ControlSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged; // 接收一个回调函数

  const ControlSwitch({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isActive,
      onChanged: onChanged, // 关键：调用父组件传来的回调
    );
  }
}
