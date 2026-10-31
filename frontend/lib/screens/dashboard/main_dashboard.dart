import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/cyber_card.dart';
import '../reminders/reminders_screen.dart';
import '../alerts/incomplete_records_screen.dart';
import '../escalations/escalations_screen.dart';
import '../summaries/weekly_summary_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'INTERNSHIP APPLICATION MONITOR',
          style: TextStyle(
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: provider.isConnected 
                      ? AppColors.neonGreen.withOpacity(0.1)
                      : AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: provider.isConnected ? AppColors.neonGreen : AppColors.danger,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      provider.isConnected ? Icons.wifi : Icons.wifi_off,
                      size: 16,
                      color: provider.isConnected ? AppColors.neonGreen : AppColors.danger,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      provider.isConnected ? 'ONLINE' : 'OFFLINE',
                      style: TextStyle(
                        color: provider.isConnected ? AppColors.neonGreen : AppColors.danger,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DashboardProvider>().retryAll(),
            tooltip: 'Refresh All',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Status Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.neonCyan.withOpacity(0.2),
                    AppColors.neonMagenta.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neonCyan),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.dashboard,
                    color: AppColors.neonCyan,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SYSTEM MONITORING ACTIVE',
                        style: TextStyle(
                          color: AppColors.neonCyan,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: AppColors.neonCyan.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Week 13 - Cyber-Industrial Interface',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Navigation Cards
            Text(
              'MONITORING MODULES',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 2 : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: MediaQuery.of(context).size.width > 1000 ? 2.5 : 3,
              children: [
                _buildNavigationCard(
                  context,
                  title: 'MILESTONE REMINDERS',
                  subtitle: 'Track upcoming deadlines and alerts',
                  icon: Icons.notifications_active,
                  color: AppColors.neonOrange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RemindersScreen()),
                  ),
                ),
                _buildNavigationCard(
                  context,
                  title: 'INCOMPLETE RECORDS',
                  subtitle: 'Identify missing documentation',
                  icon: Icons.report_gmailerrorred,
                  color: AppColors.neonYellow,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const IncompleteRecordsScreen()),
                  ),
                ),
                _buildNavigationCard(
                  context,
                  title: 'STALLED APPLICATIONS',
                  subtitle: 'Escalate overdue applications',
                  icon: Icons.speed,
                  color: AppColors.neonPink,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EscalationsScreen()),
                  ),
                ),
                _buildNavigationCard(
                  context,
                  title: 'WEEKLY SUMMARIES',
                  subtitle: 'Placement statistics and analytics',
                  icon: Icons.analytics,
                  color: AppColors.neonGreen,
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

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CyberCard(
      onTap: onTap,
      borderColor: color,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: color,
            size: 16,
          ),
        ],
      ),
    );
  }
}
