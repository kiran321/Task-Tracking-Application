import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskapplication/models/tasks.dart';
import 'package:taskapplication/screens/taskdetail.dart';
import 'package:taskapplication/utils/database_helper.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Task> taskList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      taskList = List<Task>();
      updateTaskListView();
    }
    return Scaffold(

        appBar: AppBar(
          title: Text('Todo Tasks'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                iconSize: 35,
                icon: Icon(Icons.add),
                onPressed: () {
                  navigateToTask(Task('', ''), 'Add task');
                },
                tooltip: 'Add new Todo',
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _taskListView()),
          ],
        ));
  }

  Widget _taskListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.deepPurple[100],
          elevation: 2.0,
          child: ListTile(
            title: Text(
              this.taskList[index].title,
            ),
            subtitle: Text(this.taskList[index].description),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, taskList[index]);
              },
            ),
            onTap: () {
              navigateToTask(this.taskList[index], "Edit task");
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, Task task) async {
    int result = await databaseHelper.deleteTask(task.id);
    if (result != 0) {
      _showSnackBar(context, 'Task Deleted Successfully!!');
      updateTaskListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToTask(Task task, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TaskDetail(task, title);
    }));

    if (result == true) {
      updateTaskListView();
    }
  }

  void updateTaskListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  }
}
