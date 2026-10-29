class ApplicationStatus {
  final String studentId;
  final String stage; // e.g., requirements, pending_review, adviser_endorsement, partner_submission, partner_interview, placement
  final String status; // pending/accepted/rejected/invalid/placed/canceled
  final DateTime updatedAt;
  
  ApplicationStatus({
    required this.studentId,
    required this.stage,
    required this.status,
    required this.updatedAt,
  });
  
  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'stage': stage,
    'status': status,
    'updated_at': updatedAt.toUtc().toIso8601String(),
  };
  
  factory ApplicationStatus.fromJson(Map<String, dynamic> json) => ApplicationStatus(
    studentId: json['student_id'],
    stage: json['stage'],
    status: json['status'],
    updatedAt: DateTime.parse(json['updated_at']),
  );
}
