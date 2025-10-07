/*
import 'package:get/get.dart';
import 'package:parlour_app/controller/add_rent_product_controller.dart';
import 'package:parlour_app/controller/auth_controller/auth_controller.dart';
import 'package:parlour_app/controller/auth_controller/information_controller.dart';
import 'package:parlour_app/controller/auth_controller/otp_verification_controller.dart';
import 'package:parlour_app/controller/auth_controller/sign_in_controller.dart';
import 'package:parlour_app/controller/auth_controller/splash_controller.dart';
import 'package:parlour_app/controller/auth_controller/welcome_controller.dart';
import 'package:parlour_app/controller/booking_controller.dart';
import 'package:parlour_app/controller/effect_controller.dart';
import 'package:parlour_app/controller/favourite_controller.dart';
import 'package:parlour_app/controller/home_controller/filter_controller.dart';
import 'package:parlour_app/controller/home_controller/home_controller.dart';
import 'package:parlour_app/controller/home_controller/main_navigation_controller.dart';
import 'package:parlour_app/controller/home_controller/notification_controller.dart';
import 'package:parlour_app/controller/home_controller/reels_controller.dart';
import 'package:parlour_app/controller/home_controller/unified_service_data_controller.dart';
import 'package:parlour_app/controller/media_selection_controller.dart';
import 'package:parlour_app/controller/overlay_controller.dart';
import 'package:parlour_app/controller/popular_controller.dart';
import 'package:parlour_app/controller/popular_details_controller.dart';
import 'package:parlour_app/controller/profile_controller/account_information_controller.dart';
import 'package:parlour_app/controller/profile_controller/faq_controller.dart';
import 'package:parlour_app/controller/profile_controller/help_chat_controller.dart';
import 'package:parlour_app/controller/profile_controller/help_support_controller.dart';
import 'package:parlour_app/controller/profile_controller/language_controller.dart';
import 'package:parlour_app/controller/profile_controller/payment_history_controller.dart';
import 'package:parlour_app/controller/profile_controller/profile_controller.dart';
import 'package:parlour_app/controller/profile_controller/settings_controller.dart';
import 'package:parlour_app/controller/profile_controller/support_ticket_form_controller.dart';
import 'package:parlour_app/controller/review_controller.dart';
import 'package:parlour_app/controller/unified_booking_controller.dart';
import 'package:parlour_app/controller/upload_creation_controller.dart';
import 'package:parlour_app/controller/video_editor_controller.dart';
import 'package:parlour_app/controller/write_review_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // ========== Core Controllers ==========
    Get.put(AuthController(), permanent: true);
    Get.put(MainNavigationController(), permanent: true);
    Get.put(UnifiedServiceDataController(), permanent: true);

    // ========== Auth Flow ==========
    Get.put(SplashController(), permanent: true);
    Get.put(WelcomeController(), permanent: true);
    Get.put(SignInController(), permanent: true);
    Get.put(OtpVerificationController(), permanent: true);
    Get.put(InformationController(), permanent: true);

    // ========== Home & Navigation ==========
    Get.put(HomeController(), permanent: true);
    Get.put(PopularController(), permanent: true);
    Get.put(DetailsController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(FilterController(), permanent: true);

    // ========== Profile ==========
    Get.put(ProfileController(), permanent: true);
    Get.put(AccountInformationController(), permanent: true);
    Get.put(PaymentHistoryController(), permanent: true);
    Get.put(HelpSupportController(), permanent: true);
    Get.put(SupportTicketFormController(), permanent: true);
    Get.put(HelpChatController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(FAQController(), permanent: true);

    // ========== Booking & Reviews ==========
    Get.put(FavouriteController(), permanent: true);
    Get.put(BookingController(), permanent: true);
    Get.put(UnifiedBookingController(), permanent: true);
    Get.put(ReviewController(), permanent: true);
    Get.put(WriteReviewController(), permanent: true);

    // ========== Reels & Content Creation ==========
    Get.put(ReelsController(), permanent: true);
    Get.put(AddRentProductController(), permanent: true);
    
    // Initialize specialized controllers first (dependencies)
    Get.put(VideoEditorController(), permanent: true);
    Get.put(OverlayController(), permanent: true);
    Get.put(EffectController(), permanent: true);
    Get.put(MediaSelectionController(), permanent: true);
    
    // Initialize main upload controller that depends on above controllers
    Get.put(UploadCreationController(), permanent: true);
  }
}
*/

import 'package:get/get.dart';
import 'package:parlour_app/controller/home_controller/notification_controller.dart';
import 'package:parlour_app/controller/popular_controller.dart';
import 'package:parlour_app/controller/favourite_controller.dart';
import 'package:parlour_app/controller/auth_controller/auth_controller.dart';

import 'package:parlour_app/controller/profile_controller/account_information_controller.dart';
import 'package:parlour_app/controller/profile_controller/language_controller.dart';
import 'package:parlour_app/controller/profile_controller/payment_history_controller.dart';
import 'package:parlour_app/controller/profile_controller/profile_controller.dart';
import 'package:parlour_app/controller/profile_controller/settings_controller.dart';
import 'package:parlour_app/controller/profile_controller/support_ticket_form_controller.dart';
import 'package:parlour_app/controller/auth_controller/sign_in_controller.dart';
import 'package:parlour_app/controller/home_controller/filter_controller.dart';
import '../controller/booking_controller.dart';
import '../controller/auth_controller/information_controller.dart';
import '../controller/auth_controller/otp_verification_controller.dart';
import '../controller/profile_controller/help_chat_controller.dart';
import '../controller/profile_controller/help_support_controller.dart';
import '../controller/review_controller.dart';
import '../controller/home_controller/unified_service_data_controller.dart';
import '../controller/auth_controller/welcome_controller.dart';
import '../controller/home_controller/home_controller.dart';
import '../controller/home_controller/main_navigation_controller.dart';
import '../controller/write_review_controller.dart';
import '../controller/home_controller/reels_controller.dart';
import '../controller/upload_creation_controller.dart';
import '../controller/video_editor_controller.dart';
import '../controller/overlay_controller.dart';
import '../controller/effect_controller.dart';
import '../controller/media_selection_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthController
    Get.put(AuthController(), permanent: true);
    // First register the dependencies
    Get.put(UnifiedServiceDataController(), permanent: true);
    // Now register controllers that depend on them
    Get.put(PopularController(), permanent: true);

    // Other global controllers
    Get.put(FavouriteController(), permanent: true);
    Get.put(MainNavigationController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(WelcomeController(), permanent: true);
    Get.put(SignInController(), permanent: true);
    Get.put(OtpVerificationController(), permanent: true);
    Get.put(InformationController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(AccountInformationController(), permanent: true);
    Get.put(PaymentHistoryController(), permanent: true);
    Get.put(HelpSupportController(), permanent: true);
    Get.put(SupportTicketFormController(), permanent: true);
    Get.put(HelpChatController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(FilterController(), permanent: true);
    Get.put(ReviewController(), permanent: true);
    Get.put(WriteReviewController(), permanent: true);
    Get.put(BookingController(), permanent: true);
    Get.put(ReelsController(), permanent: true);

    // Upload creation controllers
    Get.put(VideoEditorController(), permanent: true);
    Get.put(OverlayController(), permanent: true);
    Get.put(EffectController(), permanent: true);
    Get.put(MediaSelectionController(), permanent: true);
    Get.put(UploadCreationController(), permanent: true);
  }
}
