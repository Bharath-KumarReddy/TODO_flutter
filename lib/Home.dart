import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:usingfirebase/Addtask.dart';
import 'package:usingfirebase/Delete.dart';
import 'package:usingfirebase/Edit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Todo",
          style: TextStyle(
            fontSize: 30,
            color: Colors.orange,
          ),
        ),
      ),
      body: _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Get.to(() => const Addtask());
        },
      ),
    );
  }

  Widget _buildTaskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final taskDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: taskDocs.length,
          itemBuilder: (context, index) {
            final taskData = taskDocs[index].data() as Map<String, dynamic>;
            final title = taskData['title'];
            final description = taskData['description'];

            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  'Title: $title',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Description: $description',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Get.to(() => Edit(
                           taskId: taskDocs[index].id, 
                           initialTitle: title,
                          initialDescription: description,
                        ));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Get.to(() => Delete(taskId: taskDocs[index].id,));
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
