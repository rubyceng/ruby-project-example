import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ChangeNotifier + Provider: 状态管理模式

// ChangeNotifier 是一个状态管理工具。它的核心思想是“我持有一个可被多方监听的共享状态，当状态变化时，我会通知所有监听者。”

// 可以把它比作一个**“中央公告板”**。
// 公告板 (ChangeNotifier 实例)：负责记录和保管信息（状态）。
// 发布者 (调用 notifyListeners() 的方法)：在公告板上更新信息。
// 订阅者 (context.watch 或 Consumer)：所有关心这个公告板的人。当公告板信息更新时，所有订阅者都会收到通知，并过来查看最新的信息，然后更新自己的行为（UI 重建）。

// 实现方式
// 1. 创建状态模型: 创建一个类并混入 ChangeNotifier，在状态变更后调用 notifyListeners()。
// 2. 提供状态: 在 Widget 树的上层，使用 ChangeNotifierProvider 来提供这个状态模型的实例。
// 3. 消费状态: 在任何需要该状态的子孙组件中，使用 context.watch<T>() 或 Consumer<T> 来监听状态变化并重建 UI。

// 1. 状态模型：购物车
class CartModel extends ChangeNotifier {
  final List<String> _items = [];
  List<String> get items => _items;

  void add(String item) {
    _items.add(item);
    notifyListeners(); // 状态改变，通知所有监听者！
  }
}

// 2. 在顶层提供状态
class ChangeNotifierExample extends StatelessWidget {
  const ChangeNotifierExample({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: const Column(
        children: [
          // 两个兄弟组件共享同一个 CartModel
          CartBadge(), // 显示数量
          SizedBox(height: 20),
          ProductList(), // 添加商品
        ],
      ),
    );
  }
}

// 3. 消费状态的组件 A
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});
  @override
  Widget build(BuildContext context) {
    // 使用 watch 监听 CartModel 的变化
    final cart = context.watch<CartModel>();
    return Chip(
      label: Text('购物车: ${cart.items.length} 件'),
      backgroundColor: Colors.orange,
    );
  }
}

// 4. 改变状态的组件 B
class ProductList extends StatelessWidget {
  const ProductList({super.key});
  @override
  Widget build(BuildContext context) {
    // 使用 read 获取 CartModel，因为这里只是调用方法，不需要监听变化
    final cart = context.read<CartModel>();
    final cartVM = context.watch<CartModel>();
    return ElevatedButton(
      child: Text('添加商品 "手机" ${cartVM.items.length}'),
      onPressed: () => cart.add('手机'),
    );
  }
}
