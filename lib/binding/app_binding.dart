import 'package:get/get.dart';

// Auth Controllers
import '../controller/auth_controller/auth_controller.dart';
import '../controller/auth_controller/information_controller.dart';
import '../controller/auth_controller/otp_verification_controller.dart';
import '../controller/auth_controller/sign_in_controller.dart';
import '../controller/auth_controller/welcome_controller.dart';

// Home Controllers
import '../controller/booking_controller.dart';
import '../controller/favourite_controller.dart';
import '../controller/home_controller/filter_controller.dart';
import '../controller/home_controller/home_controller.dart';
import '../controller/home_controller/main_navigation_controller.dart';
import '../controller/home_controller/notification_controller.dart';
import '../controller/home_controller/reels_controller.dart';
import '../controller/home_controller/unified_service_data_controller.dart';
import '../controller/popular_controller.dart';

// Profile Controllers
import '../controller/profile_controller/account_information_controller.dart';
import '../controller/profile_controller/help_chat_controller.dart';
import '../controller/profile_controller/help_support_controller.dart';
import '../controller/profile_controller/language_controller.dart';
import '../controller/profile_controller/payment_history_controller.dart';
import '../controller/profile_controller/profile_controller.dart';
import '../controller/profile_controller/settings_controller.dart';
import '../controller/profile_controller/support_ticket_form_controller.dart';

// Review Controllers
import '../controller/review_controller.dart';
import '../controller/write_review_controller.dart';

// Content Creation Controllers
import '../controller/effect_controller.dart';
import '../controller/media_selection_controller.dart';
import '../controller/overlay_controller.dart';
import '../controller/upload_creation_controller.dart';
import '../controller/video_editor_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== Core Controllers ====================
    // Must be initialized first as other controllers depend on them
    Get.put(AuthController(), permanent: true);
    Get.put(UnifiedServiceDataController(), permanent: true);

    // ==================== Auth Flow Controllers ====================
    Get.put(WelcomeController(), permanent: true);
    Get.put(SignInController(), permanent: true);
    Get.put(OtpVerificationController(), permanent: true);
    Get.put(InformationController(), permanent: true);

    // ==================== Main Navigation ====================
    Get.put(MainNavigationController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(PopularController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(FilterController(), permanent: true);

    // ==================== Profile Controllers ====================
    Get.put(ProfileController(), permanent: true);
    Get.put(AccountInformationController(), permanent: true);
    Get.put(PaymentHistoryController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    Get.put(LanguageController(), permanent: true);

    // ==================== Support Controllers ====================
    Get.put(HelpSupportController(), permanent: true);
    Get.put(SupportTicketFormController(), permanent: true);
    Get.put(HelpChatController(), permanent: true);

    // ==================== Booking & Reviews ====================
    Get.put(FavouriteController(), permanent: true);
    Get.put(BookingController(), permanent: true);
    Get.put(ReviewController(), permanent: true);
    Get.put(WriteReviewController(), permanent: true);

    // ==================== Content Creation ====================
    // Reels functionality
    Get.put(ReelsController(), permanent: true);
    
    // Video editing and upload (initialized in order of dependency)
    Get.put(VideoEditorController(), permanent: true);
    Get.put(OverlayController(), permanent: true);
    Get.put(EffectController(), permanent: true);
    Get.put(MediaSelectionController(), permanent: true);
    Get.put(UploadCreationController(), permanent: true);
  }
}
