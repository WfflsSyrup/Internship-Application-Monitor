import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/reminder_model.dart';
import '../models/incomplete_record_model.dart';
import '../models/escalation_model.dart';
import '../models/weekly_summary_model.dart';

/// API Service with retry and recovery policy
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  final Random _random = Random();

  // Track connection state for recovery
  bool _isConnected = true;
  DateTime? _lastFailureTime;

  bool get isConnected => _isConnected;

  /// Execute request with exponential backoff retry and recovery
  Future<T> _executeWithRetry<T>(
    Future<T> Function() request,
  ) async {
    int attempt = 0;
    Duration delay = ApiConstants.initialRetryDelay;

    while (attempt <= ApiConstants.maxRetries) {
      try {
        final result = await request().timeout(ApiConstants.connectionTimeout);
        _isConnected = true;
        _lastFailureTime = null;
        return result;
      } catch (e) {
        attempt++;
        _isConnected = false;
        _lastFailureTime = DateTime.now();

        if (attempt > ApiConstants.maxRetries) {
          throw ApiException(
            'Request failed after ${ApiConstants.maxRetries} retries: $e',
            isNetworkError: _isNetworkError(e),
            isRecoverable: _isRecoverableError(e),
          );
        }

        // Add jitter to avoid thundering herd
        final jitter = Duration(milliseconds: _random.nextInt(500));
        await Future.delayed(delay + jitter);
        delay = Duration(
          milliseconds: min(
            (delay.inMilliseconds * ApiConstants.retryMultiplier).round(),
            ApiConstants.maxRetryDelay.inMilliseconds,
          ),
        );
      }
    }
    throw ApiException('Unexpected error in retry logic');
  }

  bool _isNetworkError(dynamic error) {
    return error.toString().contains('SocketException') ||
        error.toString().contains('TimeoutException') ||
        error.toString().contains('Connection');
  }

  bool _isRecoverableError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('timeout') ||
        errorStr.contains('connection') ||
        errorStr.contains('503') ||
        errorStr.contains('502') ||
        errorStr.contains('504');
  }

  // Fetch Milestone Reminders
  Future<List<ReminderModel>> getReminders() async {
    return _executeWithRetry(() async {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.reminders}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ReminderModel.fromJson(json)).toList();
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else {
        throw ApiException('Failed to fetch reminders: ${response.statusCode}');
      }
    });
  }

  // Fetch Incomplete Records
  Future<List<IncompleteRecordModel>> getIncompleteRecords() async {
    return _executeWithRetry(() async {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.incompleteRecords}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => IncompleteRecordModel.fromJson(json)).toList();
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else {
        throw ApiException('Failed to fetch incomplete records: ${response.statusCode}');
      }
    });
  }

  // Fetch Stalled Application Escalations
  Future<List<EscalationModel>> getEscalations() async {
    return _executeWithRetry(() async {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.escalations}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => EscalationModel.fromJson(json)).toList();
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else {
        throw ApiException('Failed to fetch escalations: ${response.statusCode}');
      }
    });
  }

  // Fetch Weekly Placement Summaries
  Future<List<WeeklySummaryModel>> getWeeklySummaries() async {
    return _executeWithRetry(() async {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.weeklySummaries}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WeeklySummaryModel.fromJson(json)).toList();
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else {
        throw ApiException('Failed to fetch weekly summaries: ${response.statusCode}');
      }
    });
  }

  // Test connection for recovery
  Future<bool> testConnection() async {
    try {
      await _executeWithRetry(() async {
        final response = await _client.get(
          Uri.parse('${ApiConstants.baseUrl}/health'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(ApiConstants.connectionTimeout);
        return response.statusCode == 200;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}

/// Custom exceptions for API errors
class ApiException implements Exception {
  final String message;
  final bool isNetworkError;
  final bool isRecoverable;

  ApiException(this.message, {this.isNetworkError = false, this.isRecoverable = false});

  @override
  String toString() => message;
}

class ServerException extends ApiException {
  ServerException(String message) : super(message, isNetworkError: false, isRecoverable: true);
}
