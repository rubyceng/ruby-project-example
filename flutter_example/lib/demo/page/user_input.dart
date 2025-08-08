import 'package:flutter/material.dart';

import '../docs/用户交互/snackbar/snack_bar_example.dart';
import '../docs/用户交互/输入表单/form_input.dart';
import '../docs/用户交互/输入表单/text_input.dart';

class UserInputPage extends StatelessWidget {
  const UserInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('输入表单'),
          bottom: TabBar(
            tabs: const [
              Tab(text: '输入控制'),
              Tab(text: '表单控制'),
              Tab(text: 'SnackBar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [TextInputExample(), FormInputExample(), SnackBarPage()],
        ),
      ),
    );
  }
}
