import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../constance/constance_and_key.dart';
import '../model/task_tracker_model.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());


class TaskRepository {
  static const String _boxName = HiveKeys.TASK_BOX_KEY;

  Future<void> addTask(TaskModel task) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    await box.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    await box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    await box.delete(id);
  }

  Future<List<TaskModel>> getAllTasks() async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    return box.values.toList();
  }

  Future<TaskModel?> getTaskById(String id) async {
    final box = await Hive.openBox<TaskModel>(_boxName);
    return box.get(id);
  }
}