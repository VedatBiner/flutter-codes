/// <----- task_type.dart ----->
library;

enum TaskType { today, planned, urgent }

/// her bir vergi öğesinin adını almak  için
/// bir extension oluşturalım
extension TaskTypeExtension on TaskType {
  String get name {
    switch (this) {
      case TaskType.planned:
        return "Planned";
      case TaskType.today:
        return "Today";
      case TaskType.urgent:
        return "Urgent";
      default:
        return "";
    }
  }

  /// vergi türünü sqflite veri tabanına kaydederken
  /// serileştirecek form ögesi
  static TaskType fromString(String value) {
    switch (value) {
      case "Planned":
        return TaskType.planned;
      case "Today":
        return TaskType.today;
      case "Urgent":
        return TaskType.urgent;
      default:
        throw ArgumentError("Invalid TaskType string : $value");
    }
  }
}
