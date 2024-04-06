import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/task_tracker_model.dart';
import '../provider/task_notifyr.dart';
import '../provider/task_state.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskNotifierProvider.notifier).fetchTasks();
    });
  }

  void _showTaskDialog([TaskModel? task]) {
    _titleController.text = task?.title ?? '';
    _descriptionController.text = task?.description ?? '';
    final taskNotifier = ref.read(taskNotifierProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(task == null ? 'Add Task' : 'Update Task Or'),
            if(task != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                taskNotifier.deleteTask(task!.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Task title',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(

                hintText: 'Task description',
              ),
            ),
          ],
        ),
        actions: [

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (task == null) {
                final newTask = TaskModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  isCompleted: false,
                );
                taskNotifier.addTask(newTask);
              } else {
                task.title = _titleController.text;
                task.description = _descriptionController.text;
                taskNotifier.updateTask(task);
              }
              Navigator.of(context).pop();
            },
            child: Text(task == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskNotifier = ref.watch(taskNotifierProvider.notifier);
    final taskState = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            onPressed: () => _showTaskDialog(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: taskState.taskStateStatus == TaskStateStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : taskState.taskStateStatus == TaskStateStatus.error
              ? Center(child: Text(taskState.massege ?? 'Error'))
              : ListView.builder(
                  itemCount: taskState.taskList?.length ?? 0,
                  itemBuilder: (context, index) {
                    final task = taskState.taskList![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.amber),borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) {
                              task.isCompleted = value ?? false;
                              taskNotifier.updateTask(task);
                            },
                          ),
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showTaskDialog(task),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
