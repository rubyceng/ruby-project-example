import 'package:flutter/material.dart';

import '../docs/持久化/flutter_secure_storage_example.dart';
import '../docs/持久化/local_file_example.dart';
import '../docs/持久化/shared_preferences_example.dart';
import '../docs/持久化/sql_lite_example.dart';

class PersistencePage extends StatelessWidget {
  const PersistencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('持久化'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'SharedPreferences'),
              Tab(text: 'LocalFile'),
              Tab(text: 'SQLite'),
              Tab(text: 'FlutterSecureStorage'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SharedPreferencesExample(),
            LocalFileExample(),
            SqlLiteExample(),
            FlutterSecureStorageExample(),
          ],
        ),
      ),
    );
  }
}
