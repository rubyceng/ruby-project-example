import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'network_model_example.dart';

/// 相关网络模块封装 https://medium.com/@foxanna/basic-and-advanced-networking-in-dart-and-flutter-the-tide-way-part-0-introduction-33ac040a4a1c

class NetworkExample extends StatefulWidget {
  const NetworkExample({super.key});

  @override
  State<NetworkExample> createState() => _NetworkExampleState();
}

/// 获取数据使用 initState(只会调用一次) 和 didChangeDependencies(每次依赖改变时调用) 方法
/// 放在initState中，因为initState只会调用一次，不放在build中
/// 每当 Flutter 需要更改视图中的任何内容时（并且这种更改出现的频率非常高），就会调用 build() 方法。
/// 因此，如果你将 fetchAlbum() 方法放在 build() 内，该方法会在每次重建应用时重复调用，同时还会拖慢应用程序的速度。
/// 将 fetchAlbum() 的结果存储在状态变量中，可确保 Future 只执行一次，然后缓存(得到的数据)以备后续重新构建应用。
class _NetworkExampleState extends State<NetworkExample> {
  Future<Album>? _album;

  Future<Album> _getAlbum() async {
    var response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
      headers: {
        'User-Agent': 'Mozilla/5.0 (compatible; FlutterApp/1.0)',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  /// 异步数据源组件 使用 Feture 组件
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Network Example')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                if (_album != null) {
                  setState(() {
                    _album = null;
                  });
                  return;
                }
                setState(() {
                  _album = _getAlbum();
                });
              },
              child: Text('Get Data'),
            ),
            FutureBuilder<Album>(
              future: _album,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.title);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
