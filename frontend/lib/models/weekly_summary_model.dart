class WeeklySummaryModel {
  final String id;
  final String weekLabel;
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalApplications;
  final int applicationsSubmitted;
  final int applicationsReviewed;
  final int interviewsScheduled;
  final int offersReceived;
  final int placementsConfirmed;
  final int rejected;
  final int pendingReview;
  final double placementRate;

  WeeklySummaryModel({
    required this.id,
    required this.weekLabel,
    required this.weekStart,
    required this.weekEnd,
    required this.totalApplications,
    required this.applicationsSubmitted,
    required this.applicationsReviewed,
    required this.interviewsScheduled,
    required this.offersReceived,
    required this.placementsConfirmed,
    required this.rejected,
    required this.pendingReview,
    required this.placementRate,
  });

  factory WeeklySummaryModel.fromJson(Map<String, dynamic> json) {
    return WeeklySummaryModel(
      id: json['id']?.toString() ?? '',
      weekLabel: json['week_label'] ?? '',
      weekStart: DateTime.parse(json['week_start'] ?? DateTime.now().toIso8601String()),
      weekEnd: DateTime.parse(json['week_end'] ?? DateTime.now().toIso8601String()),
      totalApplications: json['total_applications'] ?? 0,
      applicationsSubmitted: json['applications_submitted'] ?? 0,
      applicationsReviewed: json['applications_reviewed'] ?? 0,
      interviewsScheduled: json['interviews_scheduled'] ?? 0,
      offersReceived: json['offers_received'] ?? 0,
      placementsConfirmed: json['placements_confirmed'] ?? 0,
      rejected: json['rejected'] ?? 0,
      pendingReview: json['pending_review'] ?? 0,
      placementRate: (json['placement_rate'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'week_label': weekLabel,
      'week_start': weekStart.toIso8601String(),
      'week_end': weekEnd.toIso8601String(),
      'total_applications': totalApplications,
      'applications_submitted': applicationsSubmitted,
      'applications_reviewed': applicationsReviewed,
      'interviews_scheduled': interviewsScheduled,
      'offers_received': offersReceived,
      'placements_confirmed': placementsConfirmed,
      'rejected': rejected,
      'pending_review': pendingReview,
      'placement_rate': placementRate,
    };
  }
}
