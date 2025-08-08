import 'package:flutter/material.dart';

// 导入已有的状态管理示例
import '../docs/状态管理/lifting_state_up.dart';
import '../docs/状态管理/set_state_demo.dart';
import '../docs/状态管理/状态共享/inherited_widget.dart';
import '../docs/状态管理/状态共享/provider_change_notifier.dart';
import '../docs/状态管理/组件通信/notification.dart';

/// 五种状态管理方式的演示应用

class StateManagementDemoApp extends StatelessWidget {
  const StateManagementDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '状态管理演示',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // 自定义TabBar主题 - 修复版本
        tabBarTheme: TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white, width: 2),
            insets: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const StateManagementTabsPage(),
    );
  }
}

/// 主要的Tab页面
class StateManagementTabsPage extends StatefulWidget {
  const StateManagementTabsPage({super.key});

  @override
  State<StateManagementTabsPage> createState() =>
      _StateManagementTabsPageState();
}

class _StateManagementTabsPageState extends State<StateManagementTabsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 状态管理演示'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'setState'),
            Tab(text: '状态提升'),
            Tab(text: 'InheritedWidget'),
            Tab(text: 'Provider'),
            Tab(text: 'Notification'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. setState 页面
          const SetStateTabPage(),
          // 2. 状态提升页面
          const LiftingStateUpTabPage(),
          // 3. InheritedWidget 页面
          const InheritedWidgetTabPage(),
          // 4. Provider 页面
          const ProviderTabPage(),
          // 5. Notification 页面
          const NotificationTabPage(),
        ],
      ),
    );
  }
}

/// 1. setState 演示页面
class SetStateTabPage extends StatelessWidget {
  const SetStateTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'setState 状态管理',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '适合组件内部状态更新，状态被完全限制在Widget内部',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SelfStateCounter(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '特点：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '• 简单易用，适合单个组件内部状态\n• 状态作为State类的属性\n• 调用setState()触发UI重建',
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. 状态提升演示页面
class LiftingStateUpTabPage extends StatelessWidget {
  const LiftingStateUpTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '状态提升 (Lifting State Up)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '通过回调函数实现父子组件状态共享',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: LiftingStateUpExample(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '特点：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              '• 父组件管理状态，子组件通过回调修改状态\n• 适合父子组件和兄弟组件共享\n• 状态向下传递，事件向上传递',
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. InheritedWidget 演示页面
class InheritedWidgetTabPage extends StatelessWidget {
  const InheritedWidgetTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'InheritedWidget 状态管理',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Flutter官方提供的状态共享机制',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: InheritedWidgetExample(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '特点：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• 高效的数据传递机制\n• 适合跨越多层的组件共享\n• 当数据更新时，依赖它的组件会自动重建'),
          ],
        ),
      ),
    );
  }
}

/// 4. Provider 演示页面
class ProviderTabPage extends StatelessWidget {
  const ProviderTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider + ChangeNotifier',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '基于ChangeNotifier的状态管理模式',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ChangeNotifierExample(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '特点：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• 类似"中央公告板"的概念\n• 状态变化时通知所有监听者\n• 适合复杂的应用状态管理'),
          ],
        ),
      ),
    );
  }
}

/// 5. Notification 演示页面
class NotificationTabPage extends StatelessWidget {
  const NotificationTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification 事件通信',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '基于事件冒泡的组件通信机制',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: NotificationExample(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '特点：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('• 事件冒泡机制，单向数据流\n• 适合深层嵌套的组件通信\n• 解耦子组件与祖先组件'),
          ],
        ),
      ),
    );
  }
}
