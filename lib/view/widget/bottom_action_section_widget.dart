import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

class BottomActionSectionWidget extends StatelessWidget {
  final Widget? child;
  final Widget actionButton;
  final EdgeInsets? padding;
  final bool showShadow;

  const BottomActionSectionWidget({
    super.key,
    this.child,
    required this.actionButton,
    this.padding,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.only(
        top: AppSizes.spacing20,
        bottom: AppSizes.spacing20,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: showShadow ? [
          BoxShadow(
            color: AppColors.lightGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ] : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (child != null) ...[
            child!,
            const SizedBox(height: AppSizes.spacing16),
          ],
          actionButton,
        ],
      ),
    );
  }
}
