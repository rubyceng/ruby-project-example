import 'package:flutter/material.dart';

import '../docs/用户输入/buttons_example.dart';
import '../docs/用户输入/date_select_example.dart';
import '../docs/用户输入/selection_example.dart';
import '../docs/用户输入/swipe_example.dart';
import '../docs/用户输入/text_example.dart';
import '../docs/用户输入/toggle_between_example.dart';

class UserInputPage extends StatelessWidget {
  const UserInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('用户输入'),
          bottom: TabBar(
            tabs: const [
              Tab(text: '按钮'),
              Tab(text: '文本'),
              Tab(text: '选择框'),
              Tab(text: '值切换'),
              Tab(text: '日期选择'),
              Tab(text: '滑动'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ButtonsExample(),
            TextExample(),
            SelectionExample(),
            ToggleBetweenExample(),
            DateSelectExample(),
            SwipeExample(),
          ],
        ),
      ),
    );
  }
}
