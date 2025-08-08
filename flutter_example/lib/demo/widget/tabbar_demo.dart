import 'package:flutter/material.dart';

/// 特性	顶部标签页 (Top Tabs)	 | 底部导航栏 (Bottom Nav)
/// 核心组件	TabBar + TabBarView	  |  BottomNavigationBar + PageView
/// 控制器	TabController (通常由 DefaultTabController 自动管理)	 |  PageController (需要手动创建和管理)
/// 同步方式	自动同步 (只要 TabBar 和 TabBarView 共享一个 TabController)	 |  手动同步 (通过 onTap 和 onPageChanged 回调互相驱动)
/// 滑动性	TabBarView 天生支持滑动	 |  PageView 天生支持滑动 (前提是没有手势冲突)
///
///
///
///
/// 顶部结构实现： scfflod 结构 appbar：tabbar + body： tabbarview
/// 使用tabcontroller控制
class TopTabbarDemo extends StatelessWidget {
  const TopTabbarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tab 1', icon: Icon(Icons.access_alarm)),
              Tab(text: 'Tab 2', icon: Icon(Icons.android)),
              Tab(text: 'Tab 3', icon: Icon(Icons.ac_unit)),
            ],
          ),
          title: Text('TabbarDemo'),
        ),
        body: TabBarView(
          children: [
            Container(color: Colors.blue),
            Container(color: Colors.red),
            Container(color: Colors.green),
          ],
        ),
      ),
    );
  }
}

/// 底部结构实现： scfflod 结构 pageview + bottomNavigationBar
/// 使用pagecontroller控制
class BottomTabbarDemo extends StatefulWidget {
  const BottomTabbarDemo({super.key});

  @override
  State<BottomTabbarDemo> createState() => _BottomTabbarDemoState();
}

class _BottomTabbarDemoState extends State<BottomTabbarDemo> {
  int _currentIndex = 0;
  // 对PageView进行更新需要使用PageController
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'Tab 1',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.android), label: 'Tab 2'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'Tab 3'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
          assert(index >= 0 && index < 3);
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          Container(color: Colors.blue),
          Container(color: Colors.red),
          Container(color: Colors.green),
        ],
      ),
    );
  }
}

/// 顶部tabbar 底部tabbar
enum TabType { top, bottom }

/// 自定义tabbar
class CustomerTabbarWidget extends StatefulWidget {
  // tabbar类型
  final TabType type;

  // 是否需要自适应底部padding
  final bool resizeToAvoidBottomPadding;

  // tabbar项
  final List<Widget>? tabItems;

  // tabbar页面
  final List<Widget>? tabViews;

  // 背景颜色
  final Color? backgroundColor;

  // 指示器颜色
  final Color? indicatorColor;

  // 标题
  final Widget? title;

  // 抽屉
  final Widget? drawer;

  // 浮动按钮
  final Widget? floatingActionButton;

  // 浮动按钮位置
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  // 底部bar
  final Widget? bottomBar;

  // 底部按钮
  final List<Widget>? footerButtons;

  // page控制器 封装后在外面进行配置
  final PageController? pageController;

  // 页面改变
  final ValueChanged<int>? onPageChanged;

  // 双击
  final ValueChanged<int>? onDoublePress;

  // 单击
  final ValueChanged<int>? onSinglePress;

  // tabbar高度
  final double? height;

  // appbar高度 默认48
  final double? appBarHeight;

  const CustomerTabbarWidget({
    super.key,
    required this.type,
    this.resizeToAvoidBottomPadding = true,
    required this.tabItems,
    required this.tabViews,
    required this.backgroundColor,
    required this.indicatorColor,
    this.title,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomBar,
    this.footerButtons,
    this.onPageChanged,
    this.onDoublePress,
    this.onSinglePress,
    this.pageController,
    this.height,
    this.appBarHeight,
  });

  @override
  State<CustomerTabbarWidget> createState() => _CustomerTabbarWidgetState();
}

/// TickerProviderStateMixin 动画实现类
class _CustomerTabbarWidgetState extends State<CustomerTabbarWidget>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: widget.tabItems?.length ?? 0,
    );

    _pageController = widget.pageController;
    _pageController ??= PageController();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == TabType.top) {
      // 顶部tabbar
      return Scaffold(
        drawer: widget.drawer,
        floatingActionButton: widget.floatingActionButton,
        appBar: AppBar(
          title: widget.title,
          centerTitle: false,
          toolbarHeight: widget.appBarHeight ?? 48,
          bottom: TabBar(
            controller: _tabController,
            tabs: widget.tabItems ?? [],
            indicatorColor: widget.indicatorColor,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            dividerColor: Colors.transparent,
            labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: widget.tabViews ?? [],
        ),
      );
    } else {
      // 底部tabbar
      // 底部要使用Controller进行统一的控制
      return Scaffold(
        drawer: widget.drawer,
        floatingActionButton: widget.floatingActionButton,
        appBar: AppBar(
          title: widget.title,
          backgroundColor: widget.backgroundColor,
          toolbarHeight: widget.appBarHeight ?? 48,
        ),
        body: PageView.builder(
          itemCount: widget.tabViews?.length ?? 0,
          controller: _pageController,
          itemBuilder: (context, index) =>
              widget.tabViews?[index] ?? SizedBox.shrink(),
          onPageChanged: (index) => _tabController?.animateTo(index),
        ),
        // 底部导航栏 使用TabBar控制(动画控制)
        // 用Material包裹
        bottomNavigationBar: Material(
          color: widget.backgroundColor,
          child: TabBar(
            tabs: widget.tabItems ?? [],
            controller: _tabController,
            indicatorColor: widget.indicatorColor,
            onTap: (index) => _pageController?.jumpToPage(index),
          ),
        ),
      );
    }
  }
}
