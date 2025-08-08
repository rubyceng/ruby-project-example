import 'package:flutter/material.dart';

import 'demo/page/persistence_page.dart';
import 'utils/custom_scroll_behavior.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: StateManagementDemoApp(),
      // home: UserInputPage(),
      // home: NetworkExample(),
      // home: UserInteractionPage(),
      // home: UserInputPage(),
      // home: RouterDemoPage(),
      home: PersistencePage(),
      scrollBehavior: CustomScrollBehavior(),
      theme: ThemeData(
        // 开启Material3
        useMaterial3: true,

        // 配置主题色
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black54),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: Colors.white, // 选中标签文字颜色
          unselectedLabelColor: Colors.white38, // 未选中标签文字颜色
          indicatorColor: Colors.white, // 指示器颜色
          indicatorSize: TabBarIndicatorSize.tab, // 指示器大小
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ), // 选中标签样式
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ), // 未选中标签样式
          dividerColor: Colors.transparent, // 分割线颜色
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
    );
  }
}
