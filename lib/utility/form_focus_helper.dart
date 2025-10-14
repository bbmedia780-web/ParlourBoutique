import 'package:flutter/material.dart';

class FormFocusHelper {

  static bool scrollToFirstInvalidField({
    required BuildContext context,
    required ScrollController scrollController,
    required List<FocusNode> focusNodes,
    required List<String?> validationErrors,
  }) {
    // Find the first invalid field
    int firstInvalidIndex = -1;
    for (int i = 0; i < validationErrors.length; i++) {
      if (validationErrors[i] != null && validationErrors[i]!.isNotEmpty) {
        firstInvalidIndex = i;
        break;
      }
    }
    
    if (firstInvalidIndex == -1) {
      return false; // All fields are valid
    }
    
    // Focus on the first invalid field
    if (firstInvalidIndex < focusNodes.length) {
      FocusScope.of(context).requestFocus(focusNodes[firstInvalidIndex]);
    }
    
    // Calculate scroll position (approximate)
    final double fieldHeight = 80.0; // Approximate height of each field
    final double scrollPosition = firstInvalidIndex * fieldHeight;
    
    // Scroll to the invalid field
    scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    
    return true;
  }
  
  /// Scrolls to a specific field by index
  /// @param context - BuildContext
  /// @param scrollController - ScrollController for the form
  /// @param focusNode - FocusNode for the specific field
  /// @param fieldIndex - Index of the field to scroll to
  static void scrollToField({
    required BuildContext context,
    required ScrollController scrollController,
    required FocusNode focusNode,
    required int fieldIndex,
  }) {
    // Focus on the field
    FocusScope.of(context).requestFocus(focusNode);
    
    // Calculate scroll position
    final double fieldHeight = 80.0; // Approximate height of each field
    final double scrollPosition = fieldIndex * fieldHeight;
    
    // Scroll to the field
    scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  /// Clears focus from all fields
  /// @param context - BuildContext
  static void clearAllFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
  
  /// Moves focus to the next field
  /// @param context - BuildContext
  /// @param currentFocusNode - Current field's FocusNode
  /// @param nextFocusNode - Next field's FocusNode
  static void moveToNextField({
    required BuildContext context,
    required FocusNode currentFocusNode,
    required FocusNode nextFocusNode,
  }) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }
  
  /// Validates and scrolls to first invalid field if validation fails
  /// @param context - BuildContext
  /// @param scrollController - ScrollController for the form
  /// @param focusNodes - List of FocusNodes for form fields
  /// @param validationErrors - List of validation error messages
  /// @returns true if form is valid, false if invalid (and scrolled to first error)
  static bool validateAndScrollToError({
    required BuildContext context,
    required ScrollController scrollController,
    required List<FocusNode> focusNodes,
    required List<String?> validationErrors,
  }) {
    // Check if any field has validation error
    bool hasError = validationErrors.any((error) => error != null && error.isNotEmpty);
    
    if (hasError) {
      scrollToFirstInvalidField(
        context: context,
        scrollController: scrollController,
        focusNodes: focusNodes,
        validationErrors: validationErrors,
      );
      return false;
    }
    
    return true;
  }
}
