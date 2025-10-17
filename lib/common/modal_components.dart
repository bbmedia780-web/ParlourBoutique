import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/common_button.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_style.dart';

class ModalComponents {

  static void showConfirmationDialog({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    String? cancelButtonText,
    RxBool? isLoadingRx,
    Color? iconColor,
    Color? iconBackgroundColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacing20),
        ),
        backgroundColor: AppColors.white,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.size80,
                height: AppSizes.size80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softPink,
                ),
                child: Icon(
                  icon,
                  color:AppColors.primary,
                  size: AppSizes.spacing36,
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing24),
              
              // Title
              Text(
                title,
                style: AppTextStyles.bottomSheetHeading.copyWith(
                  fontSize: AppSizes.largeHeading,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing12),
              
              // Description
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.grey,
                  height: AppSizes.lineHeight1_5,
                ),
              ),
              
              const SizedBox(height: AppSizes.spacing32),
              
              // Action buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: AppButton(
                      text: cancelButtonText ?? AppStrings.cancel,
                      isPrimary: false,
                      onPressed: () => Get.back(),
                      height: AppSizes.spacing45,
                      borderRadius: AppSizes.buttonRadius,
                      textStyle: AppTextStyles.buttonText,
                    ),
                  ),
                  
                  const SizedBox(width: AppSizes.spacing16),
                  
                  // Confirm button with optional reactive loading state
                  Expanded(
                    child: isLoadingRx != null
                        ? Obx(() => AppButton(
                              text: confirmButtonText,
                              isPrimary: true,
                              onPressed: isLoadingRx.value ? null : () {
                                Get.back();
                                onConfirm();
                              },
                              height: AppSizes.spacing45,
                              borderRadius: AppSizes.buttonRadius,
                              textStyle: AppTextStyles.buttonText.copyWith(
                                color: AppColors.white,
                              ),
                              isLoading: isLoadingRx.value,
                            ))
                        : AppButton(
                            text: confirmButtonText,
                            isPrimary: true,
                            onPressed: () {
                              Get.back();
                              onConfirm();
                            },
                            height: AppSizes.spacing45,
                            borderRadius: AppSizes.buttonRadius,
                            textStyle: AppTextStyles.buttonText.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
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
            child: Text(AppStrings.cancel, style: AppTextStyles.primaryButtonText),
          ),
          TextButton(
            onPressed: () {
              onConfirm(textController.text.trim());
              Get.back();
            },
            child: Text(AppStrings.add, style: AppTextStyles.primaryButtonText),
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
          bottom: BorderSide(color: AppColors.lightGrey, width: AppSizes.borderWidth1),
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
