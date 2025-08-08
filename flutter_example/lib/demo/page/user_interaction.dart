import 'package:flutter/material.dart';

import '../docs/用户交互/用户手势/app_drag_example.dart';
import '../docs/用户交互/用户手势/inkwell_example.dart';
import '../docs/用户交互/用户手势/list_clean.example.dart';

class UserInteractionPage extends StatelessWidget {
  const UserInteractionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('用户交互'),
          bottom: TabBar(
            tabs: const [
              Tab(text: '拖拽'),
              Tab(text: '水波纹'),
              Tab(text: '列表清理'),
            ],
          ),
        ),
        body: TabBarView(
          children: [AppDragExample(), InkWellExample(), ListCleanExample()],
        ),
      ),
    );
  }
}
