import 'package:hive/hive.dart';

part 'task_tracker_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
   String title;

  @HiveField(2)
   String description;

  @HiveField(3)
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}