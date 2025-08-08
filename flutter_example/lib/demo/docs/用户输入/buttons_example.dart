import 'package:flutter/material.dart';

/// 按钮相关

class ButtonsExample extends StatefulWidget {
  const ButtonsExample({super.key});

  @override
  State<ButtonsExample> createState() => _ButtonsExampleState();
}

class _ButtonsExampleState extends State<ButtonsExample> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('$_counter', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          // 修复按钮布局问题
          _buildButtonSection(
            button: ElevatedButton(
              onPressed: _incrementCounter,
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('ElevatedButton'),
            ),
            description: "具有一定深度的按钮。使用抬高的按钮可以为原本扁平的布局增添立体感。",
          ),
          const SizedBox(height: 20),
          _buildButtonSection(
            button: OutlinedButton(
              onPressed: _incrementCounter,
              style: OutlinedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('OutlinedButton'),
            ),
            description: "带有文本和可见边框的按钮。这些按钮包含一些重要操作，但并非应用中的主要操作",
          ),
          const SizedBox(height: 20),
          _buildButtonSection(
            button: FilledButton(
              onPressed: _incrementCounter,
              style: FilledButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('FilledButton'),
            ),
            description: "填充按钮，用于完成流程的重要、最终操作，例如保存、立即加入或确认",
          ),
          const SizedBox(height: 20),
          _buildButtonSection(
            button: IconButton(
              onPressed: _incrementCounter,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                iconSize: 30,
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              tooltip: 'IconButton 图标按钮',
            ),
            description: "图标按钮，用于执行简单操作，例如添加或删除。",
          ),
          const SizedBox(height: 20),
          _buildButtonSection(
            button: FloatingActionButton(
              onPressed: _incrementCounter,
              child: Icon(Icons.add, size: 30, color: Colors.white),
            ),
            description: "浮动操作按钮，用于执行主要或操作频繁的操作，例如添加或删除。",
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSection({
    required Widget button,
    required String description,
  }) {
    return Column(
      children: [
        button,
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}
