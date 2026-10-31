import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StatusIndicator extends StatelessWidget {
  final String status;
  final String? label;

  const StatusIndicator({
    super.key,
    required this.status,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String displayLabel = label ?? status;

    switch (status.toLowerCase()) {
      case 'high':
      case 'critical':
      case 'danger':
      case 'open':
        color = AppColors.danger;
        break;
      case 'warning':
      case 'medium':
      case 'pending':
      case 'in_progress':
        color = AppColors.warning;
        break;
      case 'success':
      case 'low':
      case 'completed':
      case 'closed':
      case 'resolved':
        color = AppColors.success;
        break;
      case 'info':
      default:
        color = AppColors.info;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        displayLabel.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
