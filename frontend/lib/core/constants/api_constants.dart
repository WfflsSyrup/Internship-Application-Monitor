class ApiConstants {
  // Base URL for Laravel backend
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Endpoints
  static const String reminders = '/reminders';
  static const String incompleteRecords = '/incomplete-records';
  static const String escalations = '/escalations';
  static const String weeklySummaries = '/weekly-summaries';
  
  // Retry configuration
  static const int maxRetries = 3;
  static const Duration initialRetryDelay = Duration(seconds: 2);
  static const Duration maxRetryDelay = Duration(seconds: 30);
  static const double retryMultiplier = 2.0;
  
  // Timeout configuration
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
