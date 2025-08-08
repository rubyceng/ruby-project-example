import 'package:flutter/material.dart';

import '../docs/导航路由/data_translate.dart';
import '../docs/导航路由/drawer_example.dart';
import '../docs/导航路由/router_example.dart';

class RouterDemoPage extends StatelessWidget {
  const RouterDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('导航路由'),
          bottom: TabBar(
            tabs: const [
              Tab(text: '路由跳转'),
              Tab(text: '数据传递'),
              Tab(text: '抽屉示例'),
            ],
          ),
        ),
        body: TabBarView(
          children: [FirstRoute(), HomeScreen(), DrawerExamplePage()],
        ),
      ),
    );
  }
}
