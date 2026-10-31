import 'package:flutter/material.dart';
import '../../core/constants/ui_constants.dart';
import '../../widgets/ui/clean_card.dart';
import '../workflow/workflow_overview_screen.dart';
import '../reminders/reminders_screen.dart';
import '../alerts/incomplete_records_screen.dart';
import '../escalations/escalations_screen.dart';
import '../summaries/weekly_summary_screen.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.background,
      appBar: AppBar(
        title: const Text('Internship Application Monitor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.spacingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: UIConstants.spacingSM),
            Text(
              'Monitor and automate your internship application workflow',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: UIConstants.textSecondary,
                  ),
            ),
            const SizedBox(height: UIConstants.spacingXL),
            Text(
              'Quick Access',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: UIConstants.spacingMD),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 3 : 1,
              crossAxisSpacing: UIConstants.spacingMD,
              mainAxisSpacing: UIConstants.spacingMD,
              childAspectRatio: 2.2,
              children: [
                _buildNavCard(
                  context,
                  title: 'Workflow Overview',
                  description: 'View the 6-stage process',
                  icon: Icons.timeline,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WorkflowOverviewScreen()),
                  ),
                ),
                _buildNavCard(
                  context,
                  title: 'Milestone Reminders',
                  description: 'Track deadlines',
                  icon: Icons.notifications_active,
                  color: UIConstants.warning,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RemindersScreen()),
                  ),
                ),
                _buildNavCard(
                  context,
                  title: 'Incomplete Records',
                  description: 'Missing documentation alerts',
                  icon: Icons.error_outline,
                  color: UIConstants.error,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const IncompleteRecordsScreen()),
                  ),
                ),
                _buildNavCard(
                  context,
                  title: 'Stalled Escalations',
                  description: 'Applications needing attention',
                  icon: Icons.report_problem,
                  color: UIConstants.error,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EscalationsScreen()),
                  ),
                ),
                _buildNavCard(
                  context,
                  title: 'Weekly Summaries',
                  description: 'Placement statistics',
                  icon: Icons.bar_chart,
                  color: UIConstants.success,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WeeklySummaryScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    Color? color,
    required VoidCallback onTap,
  }) {
    final cardColor = color ?? UIConstants.primary;
    return CleanCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(UIConstants.spacingMD),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(UIConstants.radiusMD),
            ),
            child: Icon(icon, color: cardColor, size: 24),
          ),
          const SizedBox(width: UIConstants.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: UIConstants.spacingXS),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: UIConstants.textTertiary),
        ],
      ),
    );
  }
}
