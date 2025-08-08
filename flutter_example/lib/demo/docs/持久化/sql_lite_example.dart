import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// dependencies:
///   sqflite: ^2.0.3
///   path: ^1.8.2 # sqflite内部需要path库

/// 核心解答
/// 适用于存储大量结构化数据，并能利用强大的SQL语言进行高效的增、删、改、查操作。
///
/// 数据密集型应用: 如记账本、待办事项列表（TODO List）、日记应用等，需要存储大量结构化记录。
/// 需要复杂查询的应用: 当你需要根据多个条件筛选、排序、聚合数据时，SQL的强大能力就显现出来了。
/// 离线优先的应用: 将网络数据缓存到本地数据库，即使用户设备离线，应用依然可以流畅运行，并在网络恢复时进行同步。

/// Moudle对象
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  String toString() {
    return 'Dog(id: $id, name: $name, age: $age)';
  }
}

/// 数据库工具类
class DataBaseHelper {
  // 单例实现
  // 1. 创建唯一的私有静态实例
  static final DataBaseHelper _instance = DataBaseHelper._internal();

  // 2. 工厂构造函数，始终返回同一个实例
  factory DataBaseHelper() => _instance;

  static Database? _database;

  // 3. 私有构造函数，防止外部实例化
  DataBaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'doggie_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
    );
  }

  Future<void> insertDog(Dog dog) async {
    final db = await database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // 如果id已存在则替换
    );
  }

  Future<List<Dog>> getDogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    print(maps.length);
    return List.generate(maps.length, (i) {
      return Dog(id: maps[i]['id'], name: maps[i]['name'], age: maps[i]['age']);
    });
  }
}

class SqlLiteExample extends StatefulWidget {
  const SqlLiteExample({super.key});

  @override
  State<SqlLiteExample> createState() => _SqlLiteExampleState();
}

class _SqlLiteExampleState extends State<SqlLiteExample> {
  final List<Dog> _dogs = [];
  final DataBaseHelper dbHelper = DataBaseHelper();

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  Future<void> _loadDogs() async {
    final dogs = await dbHelper.getDogs();
    setState(() {
      _dogs.clear();
      _dogs.addAll(dogs);
    });
  }

  void _addDog() async {
    // 随机添加一只狗
    final id = DateTime.now().millisecondsSinceEpoch;
    final dog = Dog(id: id, name: 'Buddy_${id % 100}', age: (id % 10) + 1);
    await dbHelper.insertDog(dog);
    _loadDogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite 数据库示例')),
      body: ListView.builder(
        itemCount: _dogs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_dogs[index].name),
            subtitle: Text('Age: ${_dogs[index].age}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
