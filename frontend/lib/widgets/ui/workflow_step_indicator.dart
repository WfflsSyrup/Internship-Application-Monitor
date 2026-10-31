import 'package:flutter/material.dart';
import '../../core/constants/ui_constants.dart';

class WorkflowStepIndicator extends StatelessWidget {
  final List<WorkflowStep> steps;
  final int currentStep;

  const WorkflowStepIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.spacingLG),
      decoration: BoxDecoration(
        color: UIConstants.surface,
        border: Border.all(color: UIConstants.border),
        borderRadius: BorderRadius.circular(UIConstants.radiusLG),
      ),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;
          final isLast = index == steps.length - 1;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? UIConstants.success
                              : isCurrent
                                  ? UIConstants.primary
                                  : UIConstants.surfaceVariant,
                          border: Border.all(
                            color: isCompleted
                                ? UIConstants.success
                                : isCurrent
                                    ? UIConstants.primary
                                    : UIConstants.border,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 20)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isCurrent
                                        ? Colors.white
                                        : UIConstants.textTertiary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: UIConstants.spacingSM),
                      Text(
                        steps[index].title,
                        style: TextStyle(
                          color: isCurrent
                              ? UIConstants.textPrimary
                              : UIConstants.textSecondary,
                          fontSize: 13,
                          fontWeight: isCurrent ? FontWeight.w500 : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (steps[index].subtitle != null) ...[
                        const SizedBox(height: UIConstants.spacingXS),
                        Text(
                          steps[index].subtitle!,
                          style: const TextStyle(
                            color: UIConstants.textTertiary,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 40),
                      color: isCompleted ? UIConstants.success : UIConstants.border,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class WorkflowStep {
  final String title;
  final String? subtitle;

  const WorkflowStep({
    required this.title,
    this.subtitle,
  });
}
