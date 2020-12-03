import 'package:flutter/material.dart';
import 'package:taskapplication/models/tasks.dart';
import 'package:taskapplication/utils/database_helper.dart';


class TaskDetail extends StatefulWidget {
  final String appBarTitle;
  final Task task;

  TaskDetail(this.task, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return TaskDetailState(this.task, this.appBarTitle);
  }
}

class TaskDetailState extends State<TaskDetail> {
  String appBarTitle;
  Task task;
  TaskDetailState(this.task, this.appBarTitle);
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    titleController.text = task.title;
    descriptionController.text = task.description;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: titleController,
                  onChanged: (value) {
                    task.title = titleController.text;
                  },
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Title';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  controller: descriptionController,
                  onChanged: (value) {
                    task.description = descriptionController.text;
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Description';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Colors.deepPurple,
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _saveUpdate();
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.deepPurple,
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          setState(() {
                            _deleteTask();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Save data to database
  void _saveUpdate() async {
    Navigator.pop(context, true);
    task.date = DateTime.now().microsecondsSinceEpoch;
    int taskinserted = (task.id != null)
        ? await helper.updateTask(task)
        : await helper.insertTask(task);
    String dialogueboxmessage =
        (taskinserted != 0) ? 'Task Saved Successfully' : 'Task Saving Failed';
    _showAlertDialog('Status of Task', dialogueboxmessage);
  }

  void _deleteTask() async {
    Navigator.pop(context, true);
    int result = await helper.deleteTask(task.id);
    result != 0
        ? _showAlertDialog('Status of Task', 'Task Deleted Successfully')
        : _showAlertDialog(
            'Status of Task', 'Error Occured while Deleting task');
  }

  _showAlertDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(message),
            ));
  }
}
