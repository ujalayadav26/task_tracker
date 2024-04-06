import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_tracker/provider/task_state.dart';

import '../model/task_tracker_model.dart';
import '../reposetry/task_repository.dart';

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(taskRepository);
});

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _taskRepository;

  TaskNotifier(this._taskRepository) : super(TaskState.initial());

  Future<void> fetchTasks() async {
    try {
      state = state.copyWith(taskStateStatus: TaskStateStatus.loading);
      final tasks = await _taskRepository.getAllTasks();
      state = state.copyWith(
        taskStateStatus: TaskStateStatus.loaded,
        taskList: tasks,
      );
    } catch (e) {
      state = state.copyWith(
        taskStateStatus: TaskStateStatus.error,
        massege: e.toString(),
      );
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _taskRepository.addTask(task);
      state = state.copyWith(
        taskList: [...state.taskList ?? [], task],
      );
    } catch (e) {
      state = state.copyWith(
        taskStateStatus: TaskStateStatus.error,
        massege: e.toString(),
      );
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _taskRepository.updateTask(task);
      state = state.copyWith(
        taskList:
            state.taskList?.map((t) => t.id == task.id ? task : t).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        taskStateStatus: TaskStateStatus.error,
        massege: e.toString(),
      );
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskRepository.deleteTask(id);
      state = state.copyWith(
        taskList: state.taskList?.where((t) => t.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        taskStateStatus: TaskStateStatus.error,
        massege: e.toString(),
      );
    }
  }
}
