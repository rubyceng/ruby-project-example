import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// 本地文件 (File Storage)
/// 核心解答
/// 直接在设备的应用专属目录下读写文件，这是最灵活的持久化方式。你可以存储任何格式的数据，例如纯文本、JSON、序列化的对象，甚至是图片或音频等二进制数据。
///
/// 使用方法
/// 1. 获取应用的专属目录
/// 2. 读写文件
/// 定位文件: Android和iOS的文件系统结构不同。path_provider插件解决了这个痛点，它提供了跨平台的API来获取标准的应用目录（如文档目录、缓存目录）。getApplicationDocumentsDirectory是存储用户数据最常用的路径。
/// 读写操作: dart:io库提供了File类，它包含了readAsString(), writeAsString(), readAsBytes(), writeAsBytes()等异步方法来处理文件I/O。

/// 缓存API响应: 将从服务器获取的复杂JSON响应直接写入文件，作为网络缓存。
/// 存储用户生成的内容: 如笔记应用保存的Markdown文本，绘图应用保存的画布数据，或者日志文件。
/// 处理配置文件: 加载和存储复杂的、结构化的应用配置信息。

class LocalFileExample extends StatefulWidget {
  const LocalFileExample({super.key});

  @override
  State<LocalFileExample> createState() => _LocalFileExampleState();
}

class _LocalFileExampleState extends State<LocalFileExample> {
  String _fileContents = "暂无内容";
  final Map<String, dynamic> _jsonData = {
    'name': 'test',
    'id': 123,
    'courses': ['Flutter', 'Dart'],
  };

  // 获取本地文件
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  // 写入文件
  Future<void> _writeFile() async {
    try {
      final file = await _localFile;
      final json = jsonEncode(_jsonData);
      await file.writeAsString(json);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('写入成功')));
      // 写入成功后立即读取并更新界面
      await _readFile();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('写入失败: $e')));
    }
  }

  // 读取文件
  Future<void> _readFile() async {
    try {
      final file = await _localFile;

      // 检查文件是否存在
      if (!await file.exists()) {
        setState(() {
          _fileContents = "文件不存在，请先点击写入按钮创建文件";
        });
        return;
      }

      final contents = await file.readAsString();
      setState(() {
        try {
          const jsonEncoder = JsonEncoder.withIndent('  ');
          final jsonData = jsonDecode(contents);
          _fileContents = jsonEncoder.convert(jsonData);
        } catch (e) {
          _fileContents = '文件内容格式错误: $e';
        }
      });
    } catch (e) {
      setState(() {
        _fileContents = '读取失败: $e';
      });
    }
  }

  // 删除文件
  Future<void> _deleteFile() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        await file.delete();
        setState(() {
          _fileContents = "文件已删除";
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('文件删除成功')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('文件不存在')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
    }
  }

  // 检查文件信息
  Future<void> _checkFileInfo() async {
    try {
      final file = await _localFile;
      final directory = await getApplicationDocumentsDirectory();

      setState(() {
        _fileContents =
            '''
文件路径: ${file.path}
应用目录: ${directory.path}
文件存在: ${file.existsSync()}
        ''';
      });
    } catch (e) {
      setState(() {
        _fileContents = '获取文件信息失败: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 初始化时检查文件信息，而不是直接读取
    _checkFileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('本地文件存储示例')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _writeFile,
                  child: const Text('写入文件'),
                ),
                ElevatedButton(onPressed: _readFile, child: const Text('读取文件')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _deleteFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('删除文件'),
                ),
                ElevatedButton(
                  onPressed: _checkFileInfo,
                  child: const Text('文件信息'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              '文件内容/信息:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _fileContents,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
