import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Addtask extends StatefulWidget {
  const Addtask({Key? key}) : super(key: key);

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = titleController.text;
    final description = descriptionController.text;

    final CollectionReference tasks =
        FirebaseFirestore.instance.collection('tasks');

    tasks.add({
      'title': title,
      'description': description,
    }).then((value) {
      Get.defaultDialog(
        title: 'Task added',
        middleText: 'Task Added successfully',
        textConfirm: 'OK',
        onConfirm: () {
          Get.back();
          titleController.clear();
          descriptionController.clear();
        },
      );
      print('Task added to Firestore');
    }).catchError((error) {
      print('Error adding task to Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Task",
          style: TextStyle(color: Colors.orange, fontSize: 30),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Enter Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Enter Description",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addTask,
                child: Text("Add Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Addtask(),
    theme: ThemeData(primaryColor: Colors.deepPurple),
  ));
}
