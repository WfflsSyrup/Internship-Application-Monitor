import 'package:flutter/foundation.dart';
import '../models/reminder_model.dart';
import '../models/incomplete_record_model.dart';
import '../models/escalation_model.dart';
import '../models/weekly_summary_model.dart';
import '../services/api_service.dart';

enum DataLoadingState { loading, success, empty, error, idle }

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Data
  List<ReminderModel> _reminders = [];
  List<IncompleteRecordModel> _incompleteRecords = [];
  List<EscalationModel> _escalations = [];
  List<WeeklySummaryModel> _weeklySummaries = [];

  // States
  DataLoadingState _remindersState = DataLoadingState.idle;
  DataLoadingState _incompleteRecordsState = DataLoadingState.idle;
  DataLoadingState _escalationsState = DataLoadingState.idle;
  DataLoadingState _weeklySummariesState = DataLoadingState.idle;

  // Errors
  String _remindersError = '';
  String _incompleteRecordsError = '';
  String _escalationsError = '';
  String _weeklySummariesError = '';

  // Getters
  List<ReminderModel> get reminders => _reminders;
  List<IncompleteRecordModel> get incompleteRecords => _incompleteRecords;
  List<EscalationModel> get escalations => _escalations;
  List<WeeklySummaryModel> get weeklySummaries => _weeklySummaries;

  DataLoadingState get remindersState => _remindersState;
  DataLoadingState get incompleteRecordsState => _incompleteRecordsState;
  DataLoadingState get escalationsState => _escalationsState;
  DataLoadingState get weeklySummariesState => _weeklySummariesState;

  String get remindersError => _remindersError;
  String get incompleteRecordsError => _incompleteRecordsError;
  String get escalationsError => _escalationsError;
  String get weeklySummariesError => _weeklySummariesError;

  bool get isConnected => _apiService.isConnected;

  // Fetch all data
  Future<void> fetchAllData() async {
    await Future.wait([
      fetchReminders(),
      fetchIncompleteRecords(),
      fetchEscalations(),
      fetchWeeklySummaries(),
    ]);
  }

  // Fetch Reminders
  Future<void> fetchReminders() async {
    _remindersState = DataLoadingState.loading;
    _remindersError = '';
    notifyListeners();

    try {
      final data = await _apiService.getReminders();
      _reminders = data;
      _remindersState = data.isEmpty ? DataLoadingState.empty : DataLoadingState.success;
    } catch (e) {
      _remindersState = DataLoadingState.error;
      _remindersError = e.toString();
    }
    notifyListeners();
  }

  // Fetch Incomplete Records
  Future<void> fetchIncompleteRecords() async {
    _incompleteRecordsState = DataLoadingState.loading;
    _incompleteRecordsError = '';
    notifyListeners();

    try {
      final data = await _apiService.getIncompleteRecords();
      _incompleteRecords = data;
      _incompleteRecordsState = data.isEmpty ? DataLoadingState.empty : DataLoadingState.success;
    } catch (e) {
      _incompleteRecordsState = DataLoadingState.error;
      _incompleteRecordsError = e.toString();
    }
    notifyListeners();
  }

  // Fetch Escalations
  Future<void> fetchEscalations() async {
    _escalationsState = DataLoadingState.loading;
    _escalationsError = '';
    notifyListeners();

    try {
      final data = await _apiService.getEscalations();
      _escalations = data;
      _escalationsState = data.isEmpty ? DataLoadingState.empty : DataLoadingState.success;
    } catch (e) {
      _escalationsState = DataLoadingState.error;
      _escalationsError = e.toString();
    }
    notifyListeners();
  }

  // Fetch Weekly Summaries
  Future<void> fetchWeeklySummaries() async {
    _weeklySummariesState = DataLoadingState.loading;
    _weeklySummariesError = '';
    notifyListeners();

    try {
      final data = await _apiService.getWeeklySummaries();
      _weeklySummaries = data;
      _weeklySummariesState = data.isEmpty ? DataLoadingState.empty : DataLoadingState.success;
    } catch (e) {
      _weeklySummariesState = DataLoadingState.error;
      _weeklySummariesError = e.toString();
    }
    notifyListeners();
  }

  // Retry all failed requests
  Future<void> retryAll() async {
    await fetchAllData();
  }

  // Test connection
  Future<bool> testConnection() async {
    final connected = await _apiService.testConnection();
    notifyListeners();
    return connected;
  }
}
