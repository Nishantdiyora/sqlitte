import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlitte/todo_model.dart';

import 'constant.dart';

class HomePageController extends GetxController {
  var todoList = <TodoModel>[].obs;

  @override
  void onInit() {
    database();
    super.onInit();
  }

  Future<void> database() async {
    String path = join(await getDatabasesPath(), databaseName);
    await openDatabase(path, version: version,
        onCreate: (Database db, int version) async {
      printInfo(info: "db:" + db.toString());
      await db.execute("CREATE TABLE $tblName ("
          "$columnId TEXT PRIMARY KEY,"
          "$columnavtar TEXT NOT NULL,"
          "$columnTitle TEXT NOT NULL,"
          "$columnDescription TEXT NOT NULL,"
          "$columnDate TEXT NOT NULL"
          ")");
    });
    getTodo();
  }

  void addData({
    required String avatar,
    required String name,
    required String desc,
    required String date,
  }) {
    var list = TodoModel(
      id: (todoList.length + 1).toString(),
      avatar: avatar,
      name: name,
      desc: desc,
      date: date,
    );
    insertData(list);
  }

  Future<void> insertData(TodoModel todo) async {
    String path = join(await getDatabasesPath(), databaseName);
    final db = await openDatabase(path);

    // print("Hello" + todo.toJson().toString());
    await db.insert(tblName, todo.toJson());
    getTodo();
  }

  Future<void> getTodo() async {
    todoList.clear();
    String path = join(await getDatabasesPath(), databaseName);
    final db = await openDatabase(path, version: version);

    final List<Map<String, dynamic>> maps = await db.query(tblName);
    todoList.addAll(maps.map((value) => TodoModel.fromJson(value)).toList());
    print("LENGTH::::::${todoList.length}");
  }

  updateTodo(TodoModel todo) async {
    print(todo.id);
    String path = join(await getDatabasesPath(), databaseName);
    final db = await openDatabase(path);
    await db.update(
      tblName,
      todo.toJson(),
      where: '$columnId = ?',
      whereArgs: [todo.id],
    );
    getTodo();
    return todo;
  }

  deleteTodo({String? id}) async {
    String path = join(await getDatabasesPath(), databaseName);
    final db = await openDatabase(path);
    getTodo();
    return await db.delete(tblName, where: '$columnId = ?', whereArgs: [id]);
  }
}
