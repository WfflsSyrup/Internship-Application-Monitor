import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

/// Enhanced API Service with strict retry and recovery policy
class ApiServiceEnhanced {
  static final ApiServiceEnhanced _instance = ApiServiceEnhanced._internal();
  factory ApiServiceEnhanced() => _instance;
  ApiServiceEnhanced._internal();

  final http.Client _client = http.Client();
  final Random _random = Random();

  // Connection state tracking
  bool _isConnected = true;
  DateTime? _lastFailureTime;
  int _consecutiveFailures = 0;

  bool get isConnected => _isConnected;
  int get consecutiveFailures => _consecutiveFailures;

  /// Execute request with bounded retries and exponential backoff
  Future<T> _executeWithRetry<T>(
    Future<T> Function() request, {
    int maxRetries = 5,
    Duration initialDelay = const Duration(seconds: 1),
    Duration maxDelay = const Duration(seconds: 32),
    double multiplier = 2.0,
  }) async {
    int attempt = 0;
    Duration currentDelay = initialDelay;

    while (attempt < maxRetries) {
      try {
        final result = await request().timeout(
          ApiConstants.connectionTimeout,
          onTimeout: () => throw TimeoutException('Request timeout'),
        );
        
        // Success - reset failure tracking
        _isConnected = true;
        _consecutiveFailures = 0;
        _lastFailureTime = null;
        
        return result;
      } on TimeoutException catch (e) {
        attempt++;
        _recordFailure();
        
        if (attempt >= maxRetries) {
          throw TransientNetworkException(
            'Request timed out after $maxRetries attempts',
            canAutoRetry: true,
          );
        }
        
        await _waitWithBackoff(currentDelay);
        currentDelay = _calculateNextDelay(currentDelay, maxDelay, multiplier);
      } on http.ClientException catch (e) {
        attempt++;
        _recordFailure();
        
        if (attempt >= maxRetries) {
          throw TransientNetworkException(
            'Network connection failed: ${e.message}',
            canAutoRetry: true,
          );
        }
        
        await _waitWithBackoff(currentDelay);
        currentDelay = _calculateNextDelay(currentDelay, maxDelay, multiplier);
      } catch (e) {
        attempt++;
        _recordFailure();
        
        // Check if it's a server error (5xx) - retryable
        if (_isRetryableError(e) && attempt < maxRetries) {
          await _waitWithBackoff(currentDelay);
          currentDelay = _calculateNextDelay(currentDelay, maxDelay, multiplier);
          continue;
        }
        
        if (attempt >= maxRetries) {
          throw TransientNetworkException(
            'Request failed after $maxRetries attempts: $e',
            canAutoRetry: _isRetryableError(e),
          );
        }
        
        throw _classifyException(e);
      }
    }
    
    throw TransientNetworkException(
      'Maximum retry limit exceeded',
      canAutoRetry: true,
    );
  }

  void _recordFailure() {
    _isConnected = false;
    _consecutiveFailures++;
    _lastFailureTime = DateTime.now();
  }

  Future<void> _waitWithBackoff(Duration delay) async {
    // Add jitter (±25%)
    final jitterRange = (delay.inMilliseconds * 0.25).round();
    final jitter = _random.nextInt(jitterRange * 2) - jitterRange;
    final actualDelay = Duration(milliseconds: max(100, delay.inMilliseconds + jitter));
    await Future.delayed(actualDelay);
  }

  Duration _calculateNextDelay(Duration current, Duration maxDelay, double multiplier) {
    final nextMs = (current.inMilliseconds * multiplier).round();
    return Duration(milliseconds: min(nextMs, maxDelay.inMilliseconds));
  }

  bool _isRetryableError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('500') ||
        errorStr.contains('502') ||
        errorStr.contains('503') ||
        errorStr.contains('504') ||
        errorStr.contains('timeout') ||
        errorStr.contains('connection');
  }

  Exception _classifyException(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('400') || errorStr.contains('bad request')) {
      return BusinessRuleException(
        'Invalid request data',
        details: error.toString(),
        interventionSteps: [
          'Verify all required fields are filled correctly',
          'Check data format and validation rules',
          'Contact the student/coordinator for corrections',
        ],
      );
    } else if (errorStr.contains('403') || errorStr.contains('forbidden')) {
      return BusinessRuleException(
        'Access denied - insufficient permissions',
        details: error.toString(),
        interventionSteps: [
          'Verify user role and permissions',
          'Check if action is allowed for current workflow state',
          'Escalate to system administrator if permissions need adjustment',
        ],
      );
    } else if (errorStr.contains('404') || errorStr.contains('not found')) {
      return BusinessRuleException(
        'Resource not found',
        details: error.toString(),
        interventionSteps: [
          'Verify the application/record exists',
          'Check if it was moved or deleted',
          'Contact coordinator to locate the correct record',
        ],
      );
    } else if (errorStr.contains('422') || errorStr.contains('validation')) {
      return BusinessRuleException(
        'Business validation failed',
        details: error.toString(),
        interventionSteps: [
          'Review validation errors and correct the data',
          'Ensure all workflow prerequisites are met',
          'Contact the appropriate party for required information',
        ],
      );
    }
    
    return TransientNetworkException(error.toString(), canAutoRetry: true);
  }

  // API Methods
  Future<Map<String, dynamic>> getWorkflowStatus(String applicationId) async {
    return _executeWithRetry(() async {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/workflow/$applicationId/status'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to fetch workflow status: ${response.statusCode}');
    });
  }

  Future<List<Map<String, dynamic>>> getMilestoneReminders() async {
    return _executeWithRetry(() async {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/automation/reminders'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      throw Exception('Failed to fetch reminders: ${response.statusCode}');
    });
  }

  Future<List<Map<String, dynamic>>> getIncompleteRecords() async {
    return _executeWithRetry(() async {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/automation/incomplete-records'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      throw Exception('Failed to fetch incomplete records: ${response.statusCode}');
    });
  }

  Future<List<Map<String, dynamic>>> getStalledEscalations() async {
    return _executeWithRetry(() async {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/automation/escalations'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      throw Exception('Failed to fetch escalations: ${response.statusCode}');
    });
  }

  Future<Map<String, dynamic>> getWeeklyPlacementSummary() async {
    return _executeWithRetry(() async {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/automation/weekly-summary'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to fetch weekly summary: ${response.statusCode}');
    });
  }

  void dispose() {
    _client.close();
  }
}

/// Transient network error - can be retried
class TransientNetworkException implements Exception {
  final String message;
  final bool canAutoRetry;

  TransientNetworkException(this.message, {required this.canAutoRetry});

  @override
  String toString() => message;
}

/// Permanent business rule failure - requires human intervention
class BusinessRuleException implements Exception {
  final String message;
  final String details;
  final List<String> interventionSteps;

  BusinessRuleException(
    this.message, {
    required this.details,
    required this.interventionSteps,
  });

  @override
  String toString() => message;
}
