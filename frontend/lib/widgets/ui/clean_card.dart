import 'package:flutter/material.dart';
import '../../core/constants/ui_constants.dart';

class CleanCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CleanCard({
    super.key,
    required this.child,
    this.padding,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UIConstants.radiusLG),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(UIConstants.spacingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null || subtitle != null || trailing != null)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          if (subtitle != null) ...[
                            const SizedBox(height: UIConstants.spacingXS),
                            Text(
                              subtitle!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
              if (title != null || subtitle != null || trailing != null)
                const SizedBox(height: UIConstants.spacingMD),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
