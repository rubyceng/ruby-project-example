import 'package:flutter/material.dart';

/// 列表清理示例
class ListCleanExample extends StatefulWidget {
  const ListCleanExample({super.key});

  @override
  State<ListCleanExample> createState() => _ListCleanExampleState();
}

class _ListCleanExampleState extends State<ListCleanExample> {
  List<ListTile> _tiles = [];

  List<ListTile> _genneratorTitles() {
    return List.generate(100, (index) => ListTile(title: Text('title $index')));
  }

  @override
  void initState() {
    super.initState();
    _tiles = _genneratorTitles();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _tiles.length,
      itemBuilder: (context, index) {
        final item = _tiles[index];
        return Dismissible(
          key: Key(item.title.toString()),
          child: item,
          onDismissed: (direction) {
            setState(() {
              _tiles.removeAt(index);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.title} 已删除'),
                  backgroundColor: Colors.red,
                  duration: Duration(milliseconds: 1000),
                ),
              );
            });
          },
        );
      },
    );
  }
}
