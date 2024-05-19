/// <----- task.dart ----->
library;

import '../models/task_type.dart';

/// tablomuzun adı
const String tableName = "tasks";

/// veri tabanındaki sütun adları
const String idField = "_id";
const String titleField = "title";
const String descriptionField = "description";
const String dueDateField = "due_date";
const String taskTypeField = "task_type";
const String isDoneField = "is_done";

/// sütun adlarını bir listede tutalım
const List<String> taskColumns = [
  idField,
  titleField,
  descriptionField,
  dueDateField,
  taskTypeField,
  isDoneField,
];

/// bilinmeyen tür
const String boolType = "BOOLEAN NOT NULL";

/// otomatik artan id için
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";

/// null olabilen Text type için gerekli
const String textTypeNullable = "TEXT";

/// null olmayan Text Type için gerekli
const String textType = "TEXT NOT NULL";

class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final TaskType taskType;
  final bool isDone;

  /// constructor
  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.taskType,
    required this.isDone,
  });

  /// JSON metodlarımız
  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json[idField] as int?,
        title: json[titleField] as String,
        description: json[descriptionField] as String,
        dueDate: DateTime.parse(json[dueDateField] as String),
        taskType: TaskTypeExtension.fromString(json[taskTypeField] as String),
        isDone: json[isDoneField] == 1,
      );

  Map<String, dynamic> toJson() => {
        idField: id,
        titleField: title,
        descriptionField: description,
        dueDateField: dueDate.toIso8601String(),
        taskTypeField: taskType.name,
        isDoneField: isDone ? 1 : 0,
      };

  /// deserialization işlemini kolaylaştıracak metot
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskType? taskType,
    bool? isDone,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        taskType: taskType ?? this.taskType,
        isDone: isDone ?? this.isDone,
      );
}
