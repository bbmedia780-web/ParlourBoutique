import 'package:get/get.dart';
import 'package:parlour_app/view/screen/profile_screen/account_information_screen.dart';
import '../view/screen/profile_screen/booking_page_view.dart';
import '../view/screen/details_screen.dart';
import '../controller/popular_details_controller.dart';
import '../view/screen/main_navigation_screen.dart';
import '../view/screen/profile_screen/faq_page_screen.dart';
import '../view/screen/profile_screen/help_chat_page_screen.dart';
import '../view/screen/profile_screen/help_support_page_screen.dart';
import '../view/screen/profile_screen/language_selection_page_screen.dart';
import '../view/screen/profile_screen/payment_history_screen.dart';
import '../view/screen/profile_screen/settings_page_screen.dart';
import '../view/screen/profile_screen/support_ticket_form_page_screen.dart';
import '../view/screen/profile_screen/favourite_screen.dart';
import '../view/screen/sign_in_page_screen.dart';
import '../view/screen/unified_booking_page_view.dart';
import '../view/screen/welcome_screen.dart';
import '../view/screen/popular_see_all_screen.dart';
import '../view/screen/notification_screen.dart';
import '../view/screen/write_review_page_view.dart';
import '../view/screen/add_rent_product_screen.dart';
import '../controller/add_rent_product_controller.dart';
import '../view/screen/upload_creation_screen.dart';
import '../controller/upload_creation_controller.dart';
import '../view/screen/information_page_screen.dart';
import '../view/screen/splash_screen.dart';
import '../controller/splash_controller.dart';



class AppRoutes {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const home = '/home';
  static const popularSeeAll = '/popular-see-all';
  static const details = '/details';
  static const accountInformation = '/account-information';
  static const favourite = '/favourite';
  static const paymentHistory = '/payment-history';
  static const faqs = '/faqs';
  static const helpSupport = '/help-support';
  static const supportTicketForm = '/support-ticket-form';
  static const helpChat = '/help-chat';
  static const settings = '/settings';
  static const languageSelection = '/language-selection';
  static const notification = '/notification';
  static const writeReview = '/write-review';
  static const booking = '/booking';
  static const unifiedBooking = '/unified-booking';
  static const addRentProduct = '/add-rent-product';
  static const uploadCreation = '/upload-creation';
  static const information = '/information';





  static final routes = [
    GetPage(
      name: splash, 
      page: () => const SplashScreen(), 
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
      transition: Transition.cupertino,
    ),
    GetPage(name: welcome, page: () => WelcomeScreen(), transition: Transition.cupertino),
    GetPage(name: signIn, page: () => SignInScreen(), transition: Transition.cupertino),
    GetPage(name: home, page: () => MainNavigationScreen(), transition: Transition.cupertino),
    GetPage(name: popularSeeAll, page: () => PopularSeeAllScreen(), transition: Transition.cupertino),
    GetPage(name: details, page: () => DetailsScreen(), binding: BindingsBuilder(() {Get.put(DetailsController());}),
      transition: Transition.cupertino,
    ),
    GetPage(name: accountInformation, page: () => AccountInformationPageView(), transition: Transition.cupertino),
    GetPage(name: favourite, page: () => FavouriteScreen(), transition: Transition.cupertino),
    GetPage(name: paymentHistory, page: () => PaymentHistoryPageView(), transition: Transition.cupertino),
    GetPage(name: faqs, page: () => FAQPageView(), transition: Transition.cupertino),
    GetPage(name: helpSupport, page: () => HelpSupportPageView(), transition: Transition.cupertino),
    GetPage(name: supportTicketForm, page: () => SupportTicketFormPageView(), transition: Transition.cupertino),
    GetPage(name: helpChat, page: () => HelpChatPageView(), transition: Transition.cupertino),
    GetPage(name: settings, page: () => SettingsPageView(), transition: Transition.cupertino),
    GetPage(name: languageSelection, page: () => LanguageSelectionPageView(), transition: Transition.cupertino),
    GetPage(name: notification, page: () => NotificationScreen(), transition: Transition.cupertino),
    GetPage(name: writeReview, page: () => WriteReviewScreen(), transition: Transition.cupertino),
    GetPage(name: booking, page: () => BookingPageView(), transition: Transition.cupertino),
    GetPage(name: unifiedBooking, page: () => UnifiedBookingPageView(), transition: Transition.cupertino),

    GetPage(
      name: addRentProduct,
      page: () => AddRentProductScreen(),
      binding: BindingsBuilder(() {
        Get.put(AddRentProductController());
      }),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: uploadCreation,
      page: () => UploadCreationScreen(),
      binding: BindingsBuilder(() {
        Get.put(UploadCreationController());
      }),
      transition: Transition.cupertino,
    ),
    GetPage(name: information, page: () => InformationScreen(), transition: Transition.cupertino),


  ];
}