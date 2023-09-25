import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:usingfirebase/Home.dart';

class Edit extends StatefulWidget {
  final String taskId;
  final String initialTitle;
  final String initialDescription;

  const Edit({
    Key? key,
    required this.taskId,
    required this.initialTitle,
    required this.initialDescription,
  }) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    descriptionController =
        TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTask() async {
    final title = titleController.text;
    final description = descriptionController.text;

    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'title': title,
        'description': description,
      });

      Get.snackbar(
        'Success',
        'Task updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.to(() => Home());
    } catch (error) {
      print('Error updating task: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
