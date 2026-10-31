import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/loading_state_widget.dart';
import '../../widgets/cyber_card.dart';

class AutomationDashboard extends StatefulWidget {
  const AutomationDashboard({super.key});

  @override
  State<AutomationDashboard> createState() => _AutomationDashboardState();
}

class _AutomationDashboardState extends State<AutomationDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadAllAutomationData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'AUTOMATION FOUNDATION',
          style: TextStyle(
            color: AppColors.neonCyan,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: AppColors.neonCyan.withOpacity(0.5), blurRadius: 8)],
          ),
        ),
        elevation: 0,
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('MILESTONE REMINDERS'),
                const SizedBox(height: 16),
                LoadingStateWidget(
                  state: provider.remindersState,
                  errorMessage: provider.remindersError,
                  onRetry: () => provider.loadReminders(),
                  emptyMessage: 'No pending reminders',
                  child: _buildRemindersList(provider.reminders),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('INCOMPLETE RECORD ALERTS'),
                const SizedBox(height: 16),
                LoadingStateWidget(
                  state: provider.incompleteRecordsState,
                  errorMessage: provider.incompleteRecordsError,
                  onRetry: () => provider.loadIncompleteRecords(),
                  emptyMessage: 'All records complete',
                  child: _buildIncompleteRecordsList(provider.incompleteRecords),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('STALLED APPLICATION ESCALATIONS'),
                const SizedBox(height: 16),
                LoadingStateWidget(
                  state: provider.escalationsState,
                  errorMessage: provider.escalationsError,
                  onRetry: () => provider.loadEscalations(),
                  emptyMessage: 'No stalled applications',
                  child: _buildEscalationsList(provider.escalations),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader('WEEKLY PLACEMENT SUMMARY'),
                const SizedBox(height: 16),
                LoadingStateWidget(
                  state: provider.weeklySummaryState,
                  errorMessage: provider.weeklySummaryError,
                  onRetry: () => provider.loadWeeklySummary(),
                  emptyMessage: 'No summary data',
                  child: _buildWeeklySummary(provider.weeklySummary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.neonPurple,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
      ),
    );
  }

  Widget _buildRemindersList(List<Map<String, dynamic>> reminders) {
    return Column(
      children: reminders.map((r) => CyberCard(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(Icons.alarm, color: _getPriorityColor(r['priority'])),
          title: Text(r['student_name'], style: const TextStyle(color: AppColors.textPrimary)),
          subtitle: Text(r['message'], style: const TextStyle(color: AppColors.textSecondary)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Due: ', style: TextStyle(color: AppColors.warning, fontSize: 12)),
              Text(r['priority'].toString().toUpperCase(), style: TextStyle(color: _getPriorityColor(r['priority']), fontSize: 10)),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildIncompleteRecordsList(List<Map<String, dynamic>> records) {
    return Column(
      children: records.map((r) => CyberCard(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(Icons.warning_amber, color: _getSeverityColor(r['severity'])),
          title: Text(r['student_name'], style: const TextStyle(color: AppColors.textPrimary)),
          subtitle: Text('Missing: ', style: const TextStyle(color: AppColors.textSecondary)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(' days', style: TextStyle(color: AppColors.danger, fontSize: 12)),
              Text(r['severity'].toString().toUpperCase(), style: TextStyle(color: _getSeverityColor(r['severity']), fontSize: 10)),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildEscalationsList(List<Map<String, dynamic>> escalations) {
    return Column(
      children: escalations.map((e) => CyberCard(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(Icons.trending_up, color: AppColors.danger),
          title: Text(e['student_name'], style: const TextStyle(color: AppColors.textPrimary)),
          subtitle: Text(e['escalation_reason'], style: const TextStyle(color: AppColors.textSecondary)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(' days stalled', style: TextStyle(color: AppColors.danger, fontSize: 12)),
              Text('Level ', style: TextStyle(color: AppColors.warning, fontSize: 10)),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildWeeklySummary(Map<String, dynamic>? summary) {
    if (summary == null) return const SizedBox.shrink();
    return CyberCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(summary['week_label'], style: TextStyle(color: AppColors.neonCyan, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _summaryItem('Total', summary['total_applications'].toString()),
                _summaryItem('Submitted', summary['applications_submitted'].toString()),
                _summaryItem('Interviews', summary['interviews_scheduled'].toString()),
                _summaryItem('Offers', summary['offers_received'].toString()),
                _summaryItem('Placed', summary['placements_confirmed'].toString()),
                _summaryItem('Placement Rate', '%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neonGreen.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: AppColors.neonGreen, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high': return AppColors.danger;
      case 'medium': return AppColors.warning;
      default: return AppColors.info;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical': return AppColors.danger;
      case 'high': return AppColors.warning;
      default: return AppColors.info;
    }
  }
}
