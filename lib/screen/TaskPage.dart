import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../actions/action.dart';
import '../style/style.dart';


class TaskPage extends StatefulWidget {
  @override
  State<TaskPage> createState() => MyHomePageState();
}

class MyHomePageState extends State<TaskPage> {

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Task Manager", style: AppStyles.appBarTitle)),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: AppSpacing.screenPadding,
            child: TextField(
              controller: searchController,
              decoration: AppDecorations.searchFieldDecoration.copyWith(
                suffixIcon: searchController.text.isNotEmpty ? IconButton(icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {searchQuery = '';});
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() {searchQuery = value.toLowerCase();});
              },
            ),
          ),
          // Task List

          Expanded(

            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: TaskActions.fetchTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
              //No task page animation
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: AppSizes.emptyStateIconSize, color: AppStyles.greyColor),
                        SizedBox(height: AppSpacing.largeSpacing),
                        Text('No tasks yet!', style: AppStyles.emptyStateTitle),
                        SizedBox(height: AppSpacing.mediumSpacing),
                        Text('Tap the + button to add your first task', style: AppStyles.emptyStateSubtitle,),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                // Filter tasks based on search query
                final filteredDocs = docs.where((doc) {
                  final data = doc.data();
                  final name = data['name']?.toString().toLowerCase() ?? '';
                  final description = data['description']?.toString().toLowerCase() ?? '';
                  return name.contains(searchQuery) || description.contains(searchQuery);
                }).toList();

                if (filteredDocs.isEmpty && searchQuery.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: AppSizes.emptyStateIconSize, color: AppStyles.greyColor),
                        SizedBox(height: AppSpacing.largeSpacing),
                        Text('No tasks found', style: AppStyles.emptyStateTitle,),
                        SizedBox(height: AppSpacing.mediumSpacing),
                        Text('Try a different search term', style: AppStyles.emptyStateSubtitle,),
                      ],
                    ),
                  );
                }
               // finally data thake
                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data();
                    final taskId = doc.id;
                    final name = data['name'] ?? 'Untitled Task';
                    final description = data['description'] ?? '';
                    final isCompleted = data['isCompleted'] ?? false;
                    final createdAt = data['createdAt'] as Timestamp?;
                    final priority = data['priority'] ?? 'Medium';
                    return Card(
                      margin: AppSpacing.cardMargin,
                      child: ListTile(
                        leading: Checkbox(
                          value: isCompleted,
                          onChanged: (bool? value) {
                            TaskActions.toggleTaskCompletion(
                              taskId: taskId,
                              isCompleted: value ?? false,
                            );
                          },
                        ),
                        title: Text(name, style: isCompleted ? AppStyles.taskTitleCompleted : AppStyles.taskTitle,),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (description.isNotEmpty)
                              Text(description, style: isCompleted ? AppStyles.taskDescriptionCompleted : AppStyles.taskDescription,),

                            SizedBox(height: AppSpacing.mediumSpacing),

                            Row(
                              children: [
                                Container(
                                  padding: AppSpacing.priorityChipPadding,
                                  decoration: AppDecorations.priorityChipDecoration(
                                      TaskActions.getPriorityColor(priority)
                                  ),
                                  child: Text(
                                    priority,
                                    style: AppStyles.priorityChip,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.mediumSpacing),
                                if (createdAt != null)
                                  Text(
                                    TaskActions.formatDate(createdAt.toDate()),
                                    style: AppStyles.dateText,
                                  ),
                              ],
                            ),
                          ],
                        ),
                        //trailling last ":" wala
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: AppSizes.menuIconSize),
                                  SizedBox(width: AppSpacing.mediumSpacing),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      size: AppSizes.menuIconSize,
                                      color: AppStyles.errorColor),
                                  SizedBox(width: AppSpacing.mediumSpacing),
                                  Text('Delete',
                                      style: TextStyle(color: AppStyles.errorColor)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              showTaskDialog(context, taskId: taskId, currentData: data);
                            } else if (value == 'delete') {
                              showDeleteConfirmation(context, taskId, name);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTaskDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }



  // Show task dialog for create/edit
  void showTaskDialog(BuildContext context, {String? taskId, Map<String, dynamic>? currentData}) {
    final isEditing = taskId != null;
    final nameController = TextEditingController(text: currentData?['name'] ?? '');
    final descriptionController = TextEditingController(text: currentData?['description'] ?? '');
    String selectedPriority = currentData?['priority'] ?? 'Medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            isEditing ? 'Edit Task' : 'Add New Task',
            style: AppStyles.dialogTitle,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: AppDecorations.taskNameDecoration,
                  autofocus: true,
                ),
                SizedBox(height: AppSpacing.largeSpacing),
                TextField(
                  controller: descriptionController,
                  decoration: AppDecorations.taskDescriptionDecoration,
                  maxLines: AppSizes.descriptionMaxLines,
                ),
                SizedBox(height: AppSpacing.largeSpacing),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: AppDecorations.priorityDropdownDecoration,
                  items: ['High', 'Medium', 'Low'].map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  if (isEditing) {
                    await TaskActions.updateTask(
                      taskId: taskId!,
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                      priority: selectedPriority,
                      context: context,
                    );
                  } else {
                    await TaskActions.saveTask(
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                      priority: selectedPriority,
                      context: context,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              style: AppThemes.primaryButtonStyle,
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  // Show delete confirmation dialog
  void showDeleteConfirmation(BuildContext context, String taskId, String taskName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task', style: AppStyles.dialogTitle),
        content: Text('Are you sure you want to delete "$taskName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await TaskActions.deleteTask(
                taskId: taskId,
                context: context,
              );
              Navigator.pop(context);
            },
            style: AppThemes.deleteButtonStyle,
            child: Text('Delete', style: AppStyles.deleteButtonText),
          ),
        ],
      ),
    );
  }

}
