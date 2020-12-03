import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:taskapplication/models/tasks.dart';


class DatabaseHelper {
	static DatabaseHelper _databaseHelper;    
	static Database _database;               
	String taskTable = 'task_table';
	String colId = 'id';
	String colTitle = 'title';
	String colDescp = 'description';
	String colDate = 'date';

	DatabaseHelper._createInstance(); 

	factory DatabaseHelper() {

		if (_databaseHelper == null) {
			_databaseHelper = DatabaseHelper._createInstance(); 
		}
		return _databaseHelper;
	}

	Future<Database> get database async {

		if (_database == null) {
			_database = await initializeDatabase();
		}
		return _database;
	}

	Future<Database> initializeDatabase() async {
		// Get the directory path for both Android and iOS to store database.
		Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'todotasks.db';

		// Open and  create the database at a given path
		var tasksDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
		return tasksDatabase;
	}

	void _createDb(Database db, int newVersion) async {
		await db.execute('CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
				'$colDescp TEXT,  $colDate TEXT)');
	}

	// Get all tasks  from database
	Future<List<Map<String, dynamic>>> getTaskMapList() async {
		Database db = await this.database;
		var result = await db.query(taskTable, orderBy: '$colDate  DESC'); //$colId ASC');
		return result;
	}

	// Insert : Insert a Tasks  to database
	Future<int> insertTask(Task task) async {
		Database db = await this.database;
		var result = await db.insert(taskTable, task.toMap());
 		return result;
	}

	// Update : Update a Task  and save into database
	Future<int> updateTask(Task task) async {
		var db = await this.database;
		var result = await db.update(taskTable, task.toMap(), where: '$colId = ?', whereArgs: [task.id]);
		return result;
	}

	// Delete : Delete a Task  from database
	Future<int> deleteTask(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $taskTable WHERE $colId = $id');
   	return result;
	}
Future<int> deleteAllTask(int id) async {
		var db = await this.database;
		int result = await db.delete('$taskTable ');
   	return result;
	}

	// Get the 'Map List' [ List<Map> ] and convert it to 'Task List' [ List<task> ]
	Future<List<Task>> getTaskList() async {

		var taskMapList = await getTaskMapList(); // Get 'Map List' from database
		int count = taskMapList.length;         // Count the number of map entries in db table
		List<Task> taskList = List<Task>();
		// For loop to create a 'task List' from a 'Map List'
		for (int i = 0; i < count; i++) {
		taskList.add(Task.fromMapObject(taskMapList[i]));
		}
		return taskList;
	}

}







