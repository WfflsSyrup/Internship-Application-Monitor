import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/ui_constants.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/ui/clean_card.dart';
import '../../widgets/ui/state_widgets.dart' as ui;

class IncompleteRecordsScreen extends StatefulWidget {
  const IncompleteRecordsScreen({super.key});

  @override
  State<IncompleteRecordsScreen> createState() => _IncompleteRecordsScreenState();
}

class _IncompleteRecordsScreenState extends State<IncompleteRecordsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchIncompleteRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.background,
      appBar: AppBar(
        title: const Text('Incomplete Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<DashboardProvider>().fetchIncompleteRecords(),
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.incompleteRecordsState == DataLoadingState.loading) {
            return const ui.LoadingState(message: 'Loading records...');
          }
          if (provider.incompleteRecordsState == DataLoadingState.error) {
            return ui.TransientErrorState(
              message: provider.incompleteRecordsError,
              onRetry: () => provider.fetchIncompleteRecords(),
            );
          }
          if (provider.incompleteRecordsState == DataLoadingState.empty || provider.incompleteRecords.isEmpty) {
            return ui.EmptyState(
              icon: Icons.check_circle_outline,
              title: 'All records complete',
              description: 'No missing documentation found',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(UIConstants.spacingLG),
            itemCount: provider.incompleteRecords.length,
            itemBuilder: (context, index) {
              final record = provider.incompleteRecords[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: UIConstants.spacingMD),
                child: CleanCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              record.studentName,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: UIConstants.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(UIConstants.radiusSM),
                            ),
                            child: Text(
                              record.severity.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                color: UIConstants.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: UIConstants.spacingSM),
                      Text(
                        'Missing: ${record.missingField}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: UIConstants.spacingSM),
                      Text(
                        '${record.daysIncomplete} days incomplete',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
