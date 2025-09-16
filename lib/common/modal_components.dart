import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_style.dart';

/// Reusable modal components for the app
class ModalComponents {
  
  /// Shows a bottom sheet with a list of selectable items
  static void showListPicker({
    required BuildContext context,
    required String title,
    required List<String> items,
    required Function(String) onItemSelected,
    String? selectedItem,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.spacing20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModalHeader(title),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedItem == item;
                return ListTile(
                  title: Text(
                    item,
                    style: AppTextStyles.bodyTitle.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.black,
                    ),
                  ),
                  trailing: isSelected 
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                  onTap: () {
                    onItemSelected(item);
                    Get.back();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a bottom sheet with chips for multi-selection
  static void showChipPicker({
    required BuildContext context,
    required String title,
    required List<String> items,
    required Function(String) onItemToggled,
    required List<String> selectedItems,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.spacing20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModalHeader(title),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacing16),
              child: Wrap(
                spacing: AppSizes.spacing8,
                runSpacing: AppSizes.spacing8,
                children: items.map((item) {
                  final isSelected = selectedItems.contains(item);
                  return ChoiceChip(
                    label: Text(item),
                    selected: isSelected,
                    onSelected: (_) => onItemToggled(item),
                    selectedColor: AppColors.lightPink,
                    labelStyle: AppTextStyles.captionTitle.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.grey,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a text input dialog
  static void showTextInputDialog({
    required BuildContext context,
    required String title,
    required String hintText,
    required Function(String) onConfirm,
    String? initialText,
  }) {
    final textController = TextEditingController(text: initialText);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.bottomSheetHeading),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            ),
          ),
          style: AppTextStyles.inputText,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTextStyles.primaryButtonText),
          ),
          TextButton(
            onPressed: () {
              onConfirm(textController.text.trim());
              Get.back();
            },
            child: Text('Add', style: AppTextStyles.primaryButtonText),
          ),
        ],
      ),
    );
  }

  /// Shows a radio selection dialog
  static void showRadioPicker({
    required BuildContext context,
    required String title,
    required List<String> items,
    required Function(String) onItemSelected,
    String? selectedItem,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.spacing20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModalHeader(title),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return RadioListTile<String>(
                  title: Text(item, style: AppTextStyles.bodyTitle),
                  value: item,
                  groupValue: selectedItem,
                  onChanged: (value) {
                    if (value != null) {
                      onItemSelected(value);
                      Get.back();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a consistent modal header
  static Widget _buildModalHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.bottomSheetHeading),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
