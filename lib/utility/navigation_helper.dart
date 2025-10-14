import 'package:get/get.dart';
import '../controller/auth_controller/auth_controller.dart';
import '../controller/guest_mode_controller.dart';
import '../view/bottomsheet/login_bottom_sheet.dart';
import '../constants/app_strings.dart';
import '../utility/global.dart';

/// NavigationHelper - Handles navigation with authentication checks
///
/// This utility class provides methods to navigate to different screens
/// while checking if the user is authenticated or needs to login first.
class NavigationHelper {
  // ------------------ Private Constructor ------------------
  NavigationHelper._();

  // ------------------ Navigation Methods ------------------
  
  /// Navigate to a route with authentication check
  /// If user is guest, shows login bottom sheet
  static void navigateWithAuthCheck(String routeName, {dynamic arguments}) {
    final authController = Get.find<AuthController>();
    
    if (!authController.isLoggedIn.value) {
      // User is guest, show login bottom sheet
      final guestController = Get.find<GuestModeController>();
      guestController.showLoginBottomSheet();
    } else {
      // User is logged in, allow navigation
      if (arguments != null) {
        Get.toNamed(routeName, arguments: arguments);
      } else {
        Get.toNamed(routeName);
      }
    }
  }

  /// Navigate to details screen with authentication check
  static void navigateToDetails(dynamic data) {
    navigateWithAuthCheck('/details', arguments: data);
  }

  /// Navigate to booking screen with authentication check
  static void navigateToBooking(dynamic data) {
    navigateWithAuthCheck('/booking', arguments: data);
  }

  /// Navigate to unified booking screen with authentication check
  static void navigateToUnifiedBooking(dynamic data) {
    navigateWithAuthCheck('/unified-booking', arguments: data);
  }

  /// Navigate to write review screen with authentication check
  static void navigateToWriteReview(dynamic data) {
    navigateWithAuthCheck('/write-review', arguments: data);
  }

  /// Navigate to add rent product screen with authentication check
  static void navigateToAddRentProduct() {
    navigateWithAuthCheck('/add-rent-product');
  }

  /// Navigate to upload creation screen with authentication check
  static void navigateToUploadCreation() {
    navigateWithAuthCheck('/upload-creation');
  }

  /// Navigate to favourite screen with authentication check
  static void navigateToFavourite() {
    navigateWithAuthCheck('/favourite');
  }

  /// Navigate to payment history screen with authentication check
  static void navigateToPaymentHistory() {
    navigateWithAuthCheck('/payment-history');
  }

  /// Navigate to account information screen with authentication check
  static void navigateToAccountInformation() {
    navigateWithAuthCheck('/account-information');
  }

  /// Navigate to settings screen with authentication check
  static void navigateToSettings() {
    navigateWithAuthCheck('/settings');
  }

  /// Navigate to language selection screen with authentication check
  static void navigateToLanguageSelection() {
    navigateWithAuthCheck('/language-selection');
  }

  /// Navigate to help support screen with authentication check
  static void navigateToHelpSupport() {
    navigateWithAuthCheck('/help-support');
  }

  /// Navigate to support ticket form screen with authentication check
  static void navigateToSupportTicketForm() {
    navigateWithAuthCheck('/support-ticket-form');
  }

  /// Navigate to help chat screen with authentication check
  static void navigateToHelpChat() {
    navigateWithAuthCheck('/help-chat');
  }

  /// Navigate to FAQ screen with authentication check
  static void navigateToFAQ() {
    navigateWithAuthCheck('/faqs');
  }

  // ------------------ Helper Methods ------------------
  
  /// Check if user can access a feature
  static bool canAccessFeature() {
    final authController = Get.find<AuthController>();
    return authController.isLoggedIn.value;
  }

  /// Show login bottom sheet with custom message
  static void showLoginBottomSheetWithMessage(String featureName) {
    final guestController = Get.find<GuestModeController>();
    ShowToast.warning('${AppStrings.loginToContinue.tr} to access $featureName');
    guestController.showLoginBottomSheet();
  }
}
