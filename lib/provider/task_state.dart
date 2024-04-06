import 'package:equatable/equatable.dart';
import '../model/task_tracker_model.dart';

enum TaskStateStatus { loading, loaded, error }

class TaskState extends Equatable {
  final TaskStateStatus taskStateStatus;
  final List<TaskModel>? taskList;
  final String? massege;

  const TaskState({
    required this.taskStateStatus,
    this.taskList,
    this.massege,
  });

  factory TaskState.initial() {
    return const TaskState(
        taskStateStatus: TaskStateStatus.loading,
        taskList: null,
        massege: null);
  }

  TaskState copyWith({
    TaskStateStatus? taskStateStatus,
    List<TaskModel>? taskList,
    String? massege,
  }) {
    return TaskState(
      taskStateStatus: taskStateStatus ?? this.taskStateStatus,
      taskList: taskList ?? this.taskList,
      massege: massege ?? this.massege,
    );
  }

  @override
  List<Object?> get props => [taskStateStatus, taskList, massege];
}
