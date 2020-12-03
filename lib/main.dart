import 'package:flutter/material.dart';
import 'package:taskapplication/screens/todolist.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
  Widget build(BuildContext context) {
    return MaterialApp(
	    title: 'To Do Tasks ',
	    debugShowCheckedModeBanner: false,
	    theme: ThemeData(
		    primarySwatch: Colors.deepPurple
	    ),
	    home: TodoList(),
    );
  }
}