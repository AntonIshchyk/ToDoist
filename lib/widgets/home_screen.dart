import 'package:flutter/material.dart';
import '../Models/Task.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({super.key, required this.userId });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _editTask(int index, Task updatedTask) {
    setState(() {
      _tasks[index] = updatedTask;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showTaskDialog({Task? task, int? index}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(task == null ? "Add Task" : "Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final newTask = Task(
                  userId: widget.userId,
                  title: titleController.text,
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : null,
                );
                if (task == null) {
                  _addTask(newTask);
                } else {
                  _editTask(index!, newTask);
                }
                Navigator.pop(context);
              },
              child: Text(task == null ? "Add" : "Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text("No tasks available."))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (ctx, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description ?? "No description"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showTaskDialog(task: task, index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTask(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
