import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

/// A comprehensive validation helper class for form field validation
/// Provides reusable validation methods for various input types
class ValidationHelper {
  
  // ==================== Validation Methods ====================
  
  /// Validates if a name field is not empty and has proper format
  /// @param value - The name value to validate
  /// @returns null if valid, error message if invalid
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseEnterName;
    }
    
    if (value.trim().length < 2) {
      return AppStrings.nameMinLength;
    }
    
    if (value.trim().length > 50) {
      return AppStrings.nameMaxLength;
    }
    
    // Check for valid name format (letters, spaces, and common name characters)
    final nameRegex = RegExp(r"^[a-zA-Z\s\.\-']+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return AppStrings.nameInvalidFormat;
    }
    
    return null;
  }
  
  /// Validates email format
  /// @param value - The email value to validate
  /// @returns null if valid, error message if invalid
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseEnterEmailAddress;
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.pleaseEnterValidEmail;
    }
    
    if (value.trim().length > 100) {
      return AppStrings.emailMaxLength;
    }
    
    return null;
  }
  
  /// Validates phone number format (Indian mobile numbers)
  /// @param value - The phone value to validate
  /// @returns null if valid, error message if invalid
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.mobileNumberRequired;
    }
    
    // Remove any non-digit characters
    final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPhone.length != 10) {
      return AppStrings.mobileNumberLength;
    }
    
    // Check if phone number starts with valid digits (6, 7, 8, 9)
    if (!RegExp(r'^[6-9]').hasMatch(cleanPhone)) {
      return AppStrings.mobileNumberFormat;
    }
    
    return null;
  }
  
  /// Validates password strength
  /// @param value - The password value to validate
  /// @returns null if valid, error message if invalid
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterPassword;
    }
    
    if (value.length < 8) {
      return AppStrings.passwordMinLength;
    }
    
    if (value.length > 50) {
      return AppStrings.passwordMaxLength;
    }
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return AppStrings.passwordNeedsUppercase;
    }
    
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return AppStrings.passwordNeedsLowercase;
    }
    
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return AppStrings.passwordNeedsNumber;
    }
    
    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return AppStrings.passwordNeedsSpecialChar;
    }
    
    return null;
  }
  
  /// Validates confirm password matches the original password
  /// @param password - The original password
  /// @param confirmPassword - The confirm password value
  /// @returns null if valid, error message if invalid
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppStrings.pleaseConfirmPassword;
    }
    
    if (password != confirmPassword) {
      return AppStrings.passwordsDoNotMatch;
    }
    
    return null;
  }
  
  /// Validates if a field is not empty
  /// @param value - The value to validate
  /// @param fieldName - The name of the field for error message
  /// @returns null if valid, error message if invalid
  static String? validateNotEmpty(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? 'Please enter $fieldName' : AppStrings.fieldRequired;
    }
    return null;
  }
  
  /// Validates date format and age
  /// @param value - The date value to validate
  /// @param minAge - Minimum age required (default: 12)
  /// @param maxAge - Maximum age allowed (default: 100)
  /// @returns null if valid, error message if invalid
  static String? validateDate(String? value, {int minAge = 12, int maxAge = 100}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseSelectDate;
    }
    
    try {
      // Parse date in DD-MM-YYYY format
      final parts = value.trim().split('-');
      if (parts.length != 3) {
        return AppStrings.dateFormatInvalid;
      }
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final date = DateTime(year, month, day);
      final now = DateTime.now();
      
      // Check if date is valid
      if (date.day != day || date.month != month || date.year != year) {
        return AppStrings.pleaseEnterValidDate;
      }
      
      // Check if date is not in the future
      if (date.isAfter(now)) {
        return AppStrings.dateFutureNotAllowed;
      }
      
      // Check age constraints
      final age = now.year - date.year;
      if (age < minAge) {
        return AppStrings.minAgeRequired(minAge);
      }
      
      if (age > maxAge) {
        return AppStrings.maxAgeExceeded(maxAge);
      }
      
      return null;
    } catch (e) {
      return AppStrings.pleaseEnterValidDateFormat;
    }
  }
  
  /// Validates dropdown selection
  /// @param value - The selected value
  /// @param fieldName - The name of the field for error message
  /// @returns null if valid, error message if invalid
  static String? validateDropdown(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? 'Please select $fieldName' : AppStrings.pleaseMakeSelection;
    }
    return null;
  }
  
  /// Validates OTP format
  /// @param value - The OTP value to validate
  /// @param length - Expected OTP length (default: 6)
  /// @returns null if valid, error message if invalid
  static String? validateOTP(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseEnterOTP;
    }
    
    final cleanOTP = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanOTP.length != length) {
      return AppStrings.otpMustBeDigits(length);
    }
    
    return null;
  }
  
  /// Validates amount/price format
  /// @param value - The amount value to validate
  /// @param minAmount - Minimum amount allowed (default: 0)
  /// @param maxAmount - Maximum amount allowed (default: 999999)
  /// @returns null if valid, error message if invalid
  static String? validateAmount(String? value, {double minAmount = 0, double maxAmount = 999999}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseEnterAmount;
    }
    
    try {
      final amount = double.parse(value.trim());
      
      if (amount < minAmount) {
        return AppStrings.amountMinRequired(minAmount);
      }
      
      if (amount > maxAmount) {
        return AppStrings.amountMaxExceeded(maxAmount);
      }
      
      return null;
    } catch (e) {
      return AppStrings.pleaseEnterValidAmount;
    }
  }
  
  /// Validates address format
  /// @param value - The address value to validate
  /// @returns null if valid, error message if invalid
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseEnterAddress;
    }
    
    if (value.trim().length < 10) {
      return AppStrings.addressMinLength;
    }
    
    if (value.trim().length > 200) {
      return AppStrings.addressMaxLength;
    }
    
    return null;
  }
  
  /// Validates pincode format (Indian pincode)
  /// @param value - The pincode value to validate
  /// @returns null if valid, error message if invalid
  static String? validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseEnterPincode;
    }
    
    final cleanPincode = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanPincode.length != 6) {
      return AppStrings.pincodeLength;
    }
    
    return null;
  }
  
  /// Validates review text
  /// @param value - The review text to validate
  /// @returns null if valid, error message if invalid
  static String? validateReview(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseWriteReview;
    }
    
    if (value.trim().length < 10) {
      return AppStrings.reviewMinLength;
    }
    
    if (value.trim().length > 500) {
      return AppStrings.reviewMaxLength;
    }
    
    return null;
  }
  
  /// Validates search query
  /// @param value - The search query to validate
  /// @returns null if valid, error message if invalid
  static String? validateSearch(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.pleaseEnterSearchTerm;
    }
    
    if (value.trim().length < 2) {
      return AppStrings.searchMinLength;
    }
    
    if (value.trim().length > 50) {
      return AppStrings.searchMaxLength;
    }
    
    return null;
  }
  
  // ==================== Helper Methods ====================
  
  /// Checks if all validation results are null (all valid)
  /// @param validations - List of validation results
  /// @returns true if all validations pass, false otherwise
  static bool areAllValid(List<String?> validations) {
    return validations.every((validation) => validation == null);
  }
  
  /// Gets the first validation error from a list
  /// @param validations - List of validation results
  /// @returns first error message or null if all valid
  static String? getFirstError(List<String?> validations) {
    for (final validation in validations) {
      if (validation != null) {
        return validation;
      }
    }
    return null;
  }
  
  /// Formats phone number for display
  /// @param phone - Raw phone number
  /// @returns Formatted phone number
  static String formatPhoneNumber(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length == 10) {
      return '+91 $cleanPhone';
    }
    return phone;
  }
  
  /// Formats amount for display
  /// @param amount - Raw amount string
  /// @returns Formatted amount with currency symbol
  static String formatAmount(String amount) {
    try {
      final parsedAmount = double.parse(amount);
      return '₹${parsedAmount.toStringAsFixed(2)}';
    } catch (e) {
      return amount;
    }
  }
}
