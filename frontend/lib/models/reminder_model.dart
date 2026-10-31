class ReminderModel {
  final String id;
  final String studentName;
  final String studentId;
  final String reminderType;
  final String message;
  final DateTime dueDate;
  final bool isCompleted;
  final String priority;

  ReminderModel({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.reminderType,
    required this.message,
    required this.dueDate,
    required this.isCompleted,
    required this.priority,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id']?.toString() ?? '',
      studentName: json['student_name'] ?? '',
      studentId: json['student_id']?.toString() ?? '',
      reminderType: json['reminder_type'] ?? '',
      message: json['message'] ?? '',
      dueDate: DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      isCompleted: json['is_completed'] ?? false,
      priority: json['priority'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'student_id': studentId,
      'reminder_type': reminderType,
      'message': message,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
      'priority': priority,
    };
  }
}
