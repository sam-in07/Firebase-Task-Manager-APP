import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskActions {

  static final tasksRef = FirebaseFirestore.instance.collection('task');

  // Fetch tasks stream
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchTasks() {
    return tasksRef.orderBy('createdAt', descending: true).snapshots();
  }

  // Save new task
  static Future<void> saveTask(
  {
    required String name,
    required String description,
    required String priority,
    required BuildContext context
  })
  async {

    try {

      final taskData = {
        'name': name,
        'description': description,
        'priority': priority,
        'isCompleted': false,
        'createdAt': Timestamp.now(),
      };

      await tasksRef.add(taskData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully!')),
        );
      }

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding task: $e')),
        );
      }
    }
  }



  // Update existing task
  static Future<void> updateTask(
      {required String taskId,
        required String name,
        required String description,
        required String priority,
        required BuildContext context,}
      )
  async {
    try {

      final taskData = {
        'name': name,
        'description': description,
        'priority': priority,
      };

      await tasksRef.doc(taskId).update(taskData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task updated successfully!')),
        );
      }

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating task: $e')),
        );
      }
    }
  }

  // Delete task
  static Future<void> deleteTask(
      {
        required String taskId,
        required BuildContext context,
      }
      )
  async {

    try {
      await tasksRef.doc(taskId).delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task deleted successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting task: $e')),
        );
      }
    }
  }

  // Toggle task completion status
  static Future<void> toggleTaskCompletion({required String taskId, required bool isCompleted,}) async {
    try {
      await tasksRef.doc(taskId).update({'isCompleted': isCompleted});
    } catch (e) {
      print('Error toggling task completion: $e');
    }
  }

  // Get priority color
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  // Format date
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
