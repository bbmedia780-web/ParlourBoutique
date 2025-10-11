import 'package:get/get.dart';

// Controllers
import '../controller/add_rent_product_controller.dart';
import '../controller/auth_controller/splash_controller.dart';
import '../controller/popular_details_controller.dart'; // DetailsController
import '../controller/upload_creation_controller.dart';

// Screens - Auth
import '../view/screen/information_page_screen.dart';
import '../view/screen/sign_in_page_screen.dart';
import '../view/screen/splash_screen.dart';
import '../view/screen/welcome_screen.dart';

// Screens - Main
import '../view/screen/add_rent_product_screen.dart';
import '../view/screen/details_screen.dart';
import '../view/screen/main_navigation_screen.dart';
import '../view/screen/notification_screen.dart';
import '../view/screen/popular_see_all_screen.dart';
import '../view/screen/unified_booking_page_view.dart';
import '../view/screen/upload_creation_screen.dart';
import '../view/screen/write_review_page_view.dart';

// Screens - Profile
import '../view/screen/profile_screen/account_information_screen.dart';
import '../view/screen/profile_screen/booking_page_view.dart';
import '../view/screen/profile_screen/faq_page_screen.dart';
import '../view/screen/profile_screen/favourite_screen.dart';
import '../view/screen/profile_screen/help_chat_page_screen.dart';
import '../view/screen/profile_screen/help_support_page_screen.dart';
import '../view/screen/profile_screen/language_selection_page_screen.dart';
import '../view/screen/profile_screen/payment_history_screen.dart';
import '../view/screen/profile_screen/settings_page_screen.dart';
import '../view/screen/profile_screen/support_ticket_form_page_screen.dart';

/// AppRoutes - Centralized routing configuration
///
/// This class manages all app routes and their configurations using GetX navigation.
/// Controllers are lazily initialized via bindings for better memory management.
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // ==================== Route Names ====================
  // Auth Routes
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String signIn = '/sign-in';
  static const String information = '/information';

  // Main Routes
  static const String home = '/home';
  static const String details = '/details';
  static const String notification = '/notification';
  static const String popularSeeAll = '/popular-see-all';

  // Booking & Review Routes
  static const String booking = '/booking';
  static const String unifiedBooking = '/unified-booking';
  static const String writeReview = '/write-review';

  // Content Creation Routes
  static const String addRentProduct = '/add-rent-product';
  static const String uploadCreation = '/upload-creation';

  // Profile Routes
  static const String accountInformation = '/account-information';
  static const String favourite = '/favourite';
  static const String paymentHistory = '/payment-history';
  static const String settings = '/settings';
  static const String languageSelection = '/language-selection';

  // Support Routes
  static const String faqs = '/faqs';
  static const String helpSupport = '/help-support';
  static const String supportTicketForm = '/support-ticket-form';
  static const String helpChat = '/help-chat';

  // ==================== Route Pages ====================
  static final List<GetPage> routes = [
    // Auth Flow
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(() => SplashController());
      }),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: welcome,
      page: () => WelcomeScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: signIn,
      page: () => SignInScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: information,
      page: () => InformationScreen(),
      transition: Transition.cupertino,
    ),

    // Main Navigation
    GetPage(
      name: home,
      page: () => MainNavigationScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: details,
      page: () => DetailsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DetailsController>(() => DetailsController());
      }),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: notification,
      page: () => NotificationScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: popularSeeAll,
      page: () => PopularSeeAllScreen(),
      transition: Transition.cupertino,
    ),

    // Booking & Reviews
    GetPage(
      name: booking,
      page: () => BookingPageView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: unifiedBooking,
      page: () => UnifiedBookingPageView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: writeReview,
      page: () => WriteReviewScreen(),
      transition: Transition.cupertino,
    ),

    // Content Creation
    GetPage(
      name: addRentProduct,
      page: () => AddRentProductScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddRentProductController>(() => AddRentProductController());
      }),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: uploadCreation,
      page: () => UploadCreationScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UploadCreationController>(() => UploadCreationController());
      }),
      transition: Transition.cupertino,
    ),

    // Profile
    GetPage(
      name: accountInformation,
      page: () => AccountInformationPageView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: favourite,
      page: () => FavouriteScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: paymentHistory,
      page: () => PaymentHistoryPageView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: settings,
      page: () => SettingsPageView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: languageSelection,
      page: () => LanguageSelectionPageView(),
      transition: Transition.cupertino,
    ),

    // Help & Support
    GetPage(
      name: faqs,
      page: () => FAQPageView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: helpSupport,
      page: () => HelpSupportPageView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: supportTicketForm,
      page: () => SupportTicketFormPageView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: helpChat,
      page: () => HelpChatPageView(),
      transition: Transition.cupertino,
    ),
  ];
}
