import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_style.dart';

/// A reusable tool button component for the upload creation screen
class ToolButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;
  final Color? iconColor;
  final Color? backgroundColor;

  const ToolButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? 
        (isSelected ? AppColors.primary : AppColors.grey);
    final effectiveBackgroundColor = backgroundColor ?? 
        (isSelected ? AppColors.lightPink : AppColors.white);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.size50,
          height: AppSizes.size50,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(AppSizes.spacing8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.mediumGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: effectiveIconColor),
          ),
        ),
        const SizedBox(height: AppSizes.spacing6),
        Text(
          label,
          style: AppTextStyles.grayTiny.copyWith(
            color: isSelected ? AppColors.primary : AppColors.grey,
          ),
        ),
      ],
    );
  }
}

/// A row of tool buttons for the upload creation screen
class ToolButtonRow extends StatelessWidget {
  final List<ToolButtonData> tools;
  final String? selectedTool;

  const ToolButtonRow({
    super.key,
    required this.tools,
    this.selectedTool,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.size80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tools.map((tool) {
          return ToolButton(
            label: tool.label,
            icon: tool.icon,
            onTap: tool.onTap,
            isSelected: selectedTool == tool.label,
          );
        }).toList(),
      ),
    );
  }
}

/// Data class for tool button configuration
class ToolButtonData {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const ToolButtonData({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
