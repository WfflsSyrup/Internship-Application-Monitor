class IncompleteRecordModel {
  final String id;
  final String studentName;
  final String studentId;
  final String missingField;
  final String recordType;
  final DateTime lastUpdated;
  final int daysIncomplete;
  final String severity;

  IncompleteRecordModel({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.missingField,
    required this.recordType,
    required this.lastUpdated,
    required this.daysIncomplete,
    required this.severity,
  });

  factory IncompleteRecordModel.fromJson(Map<String, dynamic> json) {
    return IncompleteRecordModel(
      id: json['id']?.toString() ?? '',
      studentName: json['student_name'] ?? '',
      studentId: json['student_id']?.toString() ?? '',
      missingField: json['missing_field'] ?? '',
      recordType: json['record_type'] ?? '',
      lastUpdated: DateTime.parse(json['last_updated'] ?? DateTime.now().toIso8601String()),
      daysIncomplete: json['days_incomplete'] ?? 0,
      severity: json['severity'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'student_id': studentId,
      'missing_field': missingField,
      'record_type': recordType,
      'last_updated': lastUpdated.toIso8601String(),
      'days_incomplete': daysIncomplete,
      'severity': severity,
    };
  }
}
