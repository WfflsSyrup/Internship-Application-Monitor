import 'dart:convert';
import 'dart:async';
import 'dart:io';

class RetryPolicy {
  static Future<T> withRetry<T>(Future<T> Function() action) async {
    Duration wait = const Duration(seconds: 2);
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        return await action();
      } catch (e) {
        if (attempt == 3) rethrow;
        await Future.delayed(wait);
        wait *= 2;
      }
    }
    throw Exception('Retry failed');
  }
  
  static bool isTransientError(Object error) {
    if (error is TimeoutException || error is SocketException || error is HttpException) {
      return true;
    }
    return false;
  }
}

class Logger {
  static void log({
    required String level,
    required String event,
    String? studentId,
    int? daysWaiting,
    String? actionTaken,
    Map<String, dynamic>? extra,
  }) {
    final logEntry = <String, dynamic>{
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'level': level,
      'event': event,
    };
    if (studentId != null) logEntry['student_id'] = studentId;
    if (daysWaiting != null) logEntry['days_waiting'] = daysWaiting;
    if (actionTaken != null) logEntry['action_taken'] = actionTaken;
    if (extra != null) logEntry.addAll(extra);
    // Structured logs in JSON format
    // ignore: avoid_print
    print(jsonEncode(logEntry));
  }
}
