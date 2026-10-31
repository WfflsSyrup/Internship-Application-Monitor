import 'package:flutter/material.dart';
import '../../core/constants/ui_constants.dart';
import '../../widgets/ui/clean_card.dart';
import '../../widgets/ui/workflow_step_indicator.dart';

class WorkflowOverviewScreen extends StatelessWidget {
  const WorkflowOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      const WorkflowStep(title: 'Application', subtitle: 'Submit application'),
      const WorkflowStep(title: 'Verification', subtitle: 'Coordinator review'),
      const WorkflowStep(title: 'Endorsement', subtitle: 'Adviser approval'),
      const WorkflowStep(title: 'Submission', subtitle: 'Partner review'),
      const WorkflowStep(title: 'Status', subtitle: 'Interview/update'),
      const WorkflowStep(title: 'Confirmation', subtitle: 'Placement final'),
    ];

    return Scaffold(
      backgroundColor: UIConstants.background,
      appBar: AppBar(
        title: const Text('Internship Workflow'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(UIConstants.spacingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bounded Workflow',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: UIConstants.spacingSM),
            Text(
              'Application ? Verification ? Endorsement ? Submission ? Status ? Confirmation',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: UIConstants.textSecondary,
                  ),
            ),
            const SizedBox(height: UIConstants.spacingXL),
            WorkflowStepIndicator(
              steps: steps,
              currentStep: 0,
            ),
            const SizedBox(height: UIConstants.spacingXL),
            Text(
              'Workflow Stages',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: UIConstants.spacingMD),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 3 : 1,
              crossAxisSpacing: UIConstants.spacingMD,
              mainAxisSpacing: UIConstants.spacingMD,
              childAspectRatio: 2.5,
              children: [
                _buildStageCard(
                  context,
                  title: '1. Application',
                  description: 'Student submits application with required details',
                  icon: Icons.description_outlined,
                  role: 'Student',
                ),
                _buildStageCard(
                  context,
                  title: '2. Verification',
                  description: 'Coordinator verifies requirements and documents',
                  icon: Icons.fact_check_outlined,
                  role: 'Coordinator',
                ),
                _buildStageCard(
                  context,
                  title: '3. Endorsement',
                  description: 'Adviser reviews and endorses application',
                  icon: Icons.verified_outlined,
                  role: 'Adviser',
                ),
                _buildStageCard(
                  context,
                  title: '4. Submission',
                  description: 'Application submitted to partner organization',
                  icon: Icons.send_outlined,
                  role: 'Coordinator',
                ),
                _buildStageCard(
                  context,
                  title: '5. Status',
                  description: 'Track interview status and partner updates',
                  icon: Icons.update_outlined,
                  role: 'Partner Reviewer',
                ),
                _buildStageCard(
                  context,
                  title: '6. Confirmation',
                  description: 'Final placement confirmation',
                  icon: Icons.check_circle_outline,
                  role: 'All Stakeholders',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String role,
  }) {
    return CleanCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(UIConstants.spacingMD),
            decoration: BoxDecoration(
              color: UIConstants.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(UIConstants.radiusMD),
            ),
            child: Icon(icon, color: UIConstants.primary, size: 24),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: UIConstants.spacingXS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UIConstants.spacingSM,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: UIConstants.surfaceVariant,
                    borderRadius: BorderRadius.circular(UIConstants.radiusSM),
                  ),
                  child: Text(
                    role,
                    style: const TextStyle(
                      fontSize: 11,
                      color: UIConstants.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
