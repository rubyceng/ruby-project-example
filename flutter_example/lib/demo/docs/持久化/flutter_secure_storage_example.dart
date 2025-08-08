import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// dependencies:
///   flutter_secure_storage: ^9.0.0 # 推荐使用最新版本

/// 核心解答
/// 适用于存储敏感数据，如用户密码、API密钥等。
/// 使用场景
/// 用户登录信息: 存储用户名、密码、令牌等。
/// 应用配置: 存储API密钥、数据库密码等。

class FlutterSecureStorageExample extends StatelessWidget {
  const FlutterSecureStorageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const SecureStoragePage());
  }
}

class SecureStoragePage extends StatefulWidget {
  const SecureStoragePage({super.key});

  @override
  State<SecureStoragePage> createState() => _SecureStoragePageState();
}

class _SecureStoragePageState extends State<SecureStoragePage> {
  // 1. 创建 storage 实例
  final _storage = const FlutterSecureStorage();
  final _keyController = TextEditingController();
  String _savedValue = '未知';

  // 写入数据
  Future<void> _writeValue() async {
    if (_keyController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入要保存的值!')));
      return;
    }
    // 2. 使用 write 方法保存键值对
    await _storage.write(key: 'api_secret_key', value: _keyController.text);
    _keyController.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已安全保存!')));
    _readValue(); // 保存后立即读取以更新UI
  }

  // 读取数据
  Future<void> _readValue() async {
    // 3. 使用 read 方法读取值
    final value = await _storage.read(key: 'api_secret_key');
    setState(() {
      _savedValue = value ?? '未找到值';
    });
  }

  // 删除数据
  Future<void> _deleteValue() async {
    // 4. 使用 delete 方法删除值
    await _storage.delete(key: 'api_secret_key');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已删除!')));
    _readValue();
  }

  @override
  void initState() {
    super.initState();
    _readValue(); // 页面加载时尝试读取已保存的值
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Secure Storage')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '当前保存的API Key: $_savedValue',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(labelText: '输入敏感信息'),
              obscureText: true, // 隐藏输入内容
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _writeValue, child: const Text('保存')),
            ElevatedButton(onPressed: _readValue, child: const Text('读取')),
            ElevatedButton(
              onPressed: _deleteValue,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('删除'),
            ),
          ],
        ),
      ),
    );
  }
}
