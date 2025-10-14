import 'dart:ui';

import 'package:get/get.dart';
import '../view/bottomsheet/login_bottom_sheet.dart';
import '../constants/app_strings.dart';
import '../utility/global.dart';

/// GuestModeController - Manages guest user functionality
///
/// This controller handles:
/// - Guest mode state
/// - Showing login bottom sheet when guest tries to access restricted features
/// - Managing guest user interactions
class GuestModeController extends GetxController {
  // ------------------ State ------------------
  final isGuestMode = true.obs;

  // ------------------ Methods ------------------
  
  /// Check if user is in guest mode
  bool get isGuest => isGuestMode.value;

  /// Exit guest mode (when user logs in)
  void exitGuestMode() {
    isGuestMode.value = false;
  }

  /// Enter guest mode (when user logs out)
  void enterGuestMode() {
    isGuestMode.value = true;
  }

  /// Show login bottom sheet when guest tries to access restricted features
  void showLoginBottomSheet() {
    if (isGuestMode.value) {
      Get.bottomSheet(
        LoginBottomSheet(),
        isScrollControlled: true,
        backgroundColor: const Color(0x00000000),
      );
    }
  }

  /// Handle guest user trying to access restricted features
  void handleGuestAccess(String featureName) {
    if (isGuestMode.value) {
      ShowToast.warning('${AppStrings.loginToContinue.tr} to access $featureName');
      showLoginBottomSheet();
    }
  }

  /// Check if guest can access a feature
  bool canAccessFeature() {
    return !isGuestMode.value;
  }
}
