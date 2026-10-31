class EscalationModel {
  final String id;
  final String studentName;
  final String studentId;
  final String applicationId;
  final String escalationReason;
  final String escalationLevel;
  final DateTime escalatedAt;
  final String status;
  final String assignedTo;
  final int daysStalled;

  EscalationModel({
    required this.id,
    required this.studentName,
    required this.studentId,
    required this.applicationId,
    required this.escalationReason,
    required this.escalationLevel,
    required this.escalatedAt,
    required this.status,
    required this.assignedTo,
    required this.daysStalled,
  });

  factory EscalationModel.fromJson(Map<String, dynamic> json) {
    return EscalationModel(
      id: json['id']?.toString() ?? '',
      studentName: json['student_name'] ?? '',
      studentId: json['student_id']?.toString() ?? '',
      applicationId: json['application_id']?.toString() ?? '',
      escalationReason: json['escalation_reason'] ?? '',
      escalationLevel: json['escalation_level'] ?? 'medium',
      escalatedAt: DateTime.parse(json['escalated_at'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'open',
      assignedTo: json['assigned_to'] ?? '',
      daysStalled: json['days_stalled'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'student_id': studentId,
      'application_id': applicationId,
      'escalation_reason': escalationReason,
      'escalation_level': escalationLevel,
      'escalated_at': escalatedAt.toIso8601String(),
      'status': status,
      'assigned_to': assignedTo,
      'days_stalled': daysStalled,
    };
  }
}
