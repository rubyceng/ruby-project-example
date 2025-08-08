import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// shared_preferences 是Flutter官方推荐的、用于在设备上持久化存储简单键值对数据的插件。它非常适合存储用户的轻量级设置或标记位。
/// shared_preferences 是对原生平台存储方案的一个封装。
///
/// dependencies:
///   shared_preferences: ^2.0.15 # 用于获取安全的文件系统路径

/// 在 Android 上，它使用 SharedPreferences API。
/// 在 iOS 上，它使用 NSUserDefaults。
/// 由于它需要通过 Platform Channels 与原生代码通信，所以所有操作都是异步的（返回Future）。它将数据以XML（Android）或plist（iOS）文件的形式存储在应用的沙盒目录中。因为每次读写都可能涉及到文件I/O和序列化/反序列化，所以它不适合存储大量或复杂的数据。

/// 使用场景
/// 用户偏好设置: 保存应用的皮肤主题（如夜间模式）、语言设置、字体大小等。
/// 状态标记: 记录用户是否已经看过了引导页（hasSeenOnboarding: true），或者是否同意了用户协议。
/// 轻量级缓存: 缓存一些不重要但需要快速读取的数据，比如用户上次搜索的关键词。

class SharedPreferencesExample extends StatefulWidget {
  const SharedPreferencesExample({super.key});

  @override
  State<SharedPreferencesExample> createState() =>
      _SharedPreferencesExampleState();
}

class _SharedPreferencesExampleState extends State<SharedPreferencesExample> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _getSharedPreferencesValue();
  }

  Future<void> _getSharedPreferencesValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter++;
      prefs.setInt('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Counter: $_counter'),
          ElevatedButton(
            onPressed: _incrementCounter,
            child: Text('Add Counter'),
          ),
        ],
      ),
    );
  }
}
