import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parlour_app/utility/global.dart';
import '../constants/app_colors.dart';
import '../model/booking_service_model.dart';
import '../model/payment_method_model.dart';
import '../model/details_model.dart';
import '../constants/app_strings.dart';
import '../constants/app_assets.dart';
import '../controller/auth_controller/auth_controller.dart';
import '../routes/app_routes.dart';

class UnifiedBookingController extends GetxController {
  late BookingServiceModel service;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  // Step management
  final RxInt currentStep = 0.obs;
  final RxInt totalSteps = 3.obs;
  
  // Step 1: Appointment details
  final RxString selectedDate = "12 aug, 2025".obs;
  final RxString selectedTime = "12:00 Pm".obs;
  final RxString selectedLocation = AppStrings.homeService.obs;

  final RxBool isHomeServiceSelected = true.obs;
  final RxBool isParlourServiceSelected = false.obs;
  
  // Step 2: Payment
  final RxList<PaymentMethodModel> paymentMethods = <PaymentMethodModel>[].obs;
  final RxString selectedPaymentId = "".obs;
  
  // Step 3: Confirmation
  final RxString bookingId = "123456781".obs;
  
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    
    // Check if this is a return from login with stored booking data
    if (args is Map && args['returnFromLogin'] == true) {
      _restoreBookingStateFromArgs(Map<String, dynamic>.from(args));
    } else if (args is BookingServiceModel) {
      service = args;
    } else if (args is ServiceCategoryModel) {
      // Convert ServiceCategoryModel to BookingServiceModel
      final price = double.tryParse(args.price) ?? 0.0;
      service = BookingServiceModel(
        image: args.image,
        title: args.name,
        subtitle: args.description ?? AppStrings.getProfessionalServiceDescription(args.name.toLowerCase()),
        address: null,
        price: price,
        // ServiceCategoryModel doesn't contain category type; default to parlour
        type: AppStrings.parlourType,
      );

    } else if (args is Map && args['service'] is BookingServiceModel) {
      service = args['service'] as BookingServiceModel;
    } else {
      // Fallback to a default service if no valid arguments
      service = BookingServiceModel(
        image: AppAssets.beauty1,
        title: AppStrings.hairCutting,
        subtitle: AppStrings.hairCuttingHomeService,
        address: null,
        price: 12.00,
        type: AppStrings.parlourType,
      );
    }
    
    // Initialize payment methods
    _initializePaymentMethods();
  }
  
  /// Restore booking state from arguments when returning from login
  void _restoreBookingStateFromArgs(Map<String, dynamic> args) {
    service = args['service'] as BookingServiceModel;
    selectedDate.value = args['selectedDate'] as String;
    selectedTime.value = args['selectedTime'] as String;
    selectedLocation.value = args['selectedLocation'] as String;
    selectedPaymentId.value = args['selectedPaymentId'] as String;
    
    // Update text controllers
    dateController.text = selectedDate.value;
    timeController.text = selectedTime.value;
    
    // Update location selection
    isHomeServiceSelected.value = selectedLocation.value == AppStrings.homeService;
    isParlourServiceSelected.value = selectedLocation.value == AppStrings.parlourService;
    
    // Set current step to payment step (step 1) since user was trying to confirm payment
    currentStep.value = 1;
  }
  
  void _initializePaymentMethods() {
    paymentMethods.value = [
      PaymentMethodModel(
        id: AppStrings.visaId,
        type: AppStrings.card,
        name: AppStrings.visa,
        maskedNumber: AppStrings.maskedCardNumber,
        logo: AppStrings.visaLogo,
        isSelected: true,
      ),
      PaymentMethodModel(
        id: AppStrings.mastercardId, 
        type: AppStrings.card,
        name: AppStrings.mastercard,
        maskedNumber: AppStrings.maskedCardNumber,
        logo: AppStrings.mastercardLogo,
        isSelected: false,
      ),
      PaymentMethodModel(
        id: AppStrings.cashId,
        type: AppStrings.cash,
        name: AppStrings.paymentInCash,
        maskedNumber: "",
        logo: null,
        isSelected: false,
      ),
    ];
    
    // Set initial selected payment
    if (paymentMethods.isNotEmpty) {
      selectedPaymentId.value = paymentMethods.first.id;
    }
    

  }
  
  void onBackTap() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }
  
  // Step 1 methods
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final formattedDate = DateFormat(AppStrings.dateFormat).format(picked);
      selectedDate.value = formattedDate;
      dateController.text = formattedDate;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final formattedTime = DateFormat(AppStrings.timeFormat).format(selectedDateTime);
      selectedTime.value = formattedTime;
      timeController.text = formattedTime;
    }
  }

  void chooseLocation(String location) {
    selectedLocation.value = location;
    isHomeServiceSelected.value = location == AppStrings.homeService;
    isParlourServiceSelected.value = location == AppStrings.parlourService;
  }

  void onNextStep() {
    if (currentStep.value < totalSteps.value - 1) {
      currentStep.value++;
    }
  }
  
  // Step 2 methods
  void selectPayment(String paymentId) {
    selectedPaymentId.value = paymentId;
    
    // Update selection state for all payment methods
    for (int i = 0; i < paymentMethods.length; i++) {
      paymentMethods[i] = paymentMethods[i].copyWith(
        isSelected: paymentMethods[i].id == paymentId,
      );
    }
  }
  
  PaymentMethodModel? get selectedPaymentMethod {
    try {
      return paymentMethods.firstWhere((method) => method.id == selectedPaymentId.value);
    } catch (e) {
      return null;
    }
  }
  
  void onConfirmPayment() async {
    // Check if user is logged in
    final authController = Get.find<AuthController>();
    
    if (!authController.isLoggedIn.value) {
      // User is not logged in, redirect to login screen
      // Store current booking state for returning after login
      _storeBookingStateForReturn();
      
      // Navigate to login screen
      Get.toNamed(AppRoutes.signIn);
      ShowSnackBar.show(AppStrings.loginRequired, AppStrings.pleaseLogin,backgroundColor: AppColors.red);
      return;
    }
    
    // User is logged in, proceed with payment confirmation
    currentStep.value = 2; // Move to final step
  }
  
  /// Store current booking state so user can return after login
  void _storeBookingStateForReturn() {
    // Store the current booking data in GetX arguments for returning after login
    final bookingData = {
      'service': service,
      'selectedDate': selectedDate.value,
      'selectedTime': selectedTime.value,
      'selectedLocation': selectedLocation.value,
      'selectedPaymentId': selectedPaymentId.value,
      'returnFromLogin': true, // Flag to indicate this is a return from login
    };
    
    // Store in GetX storage for access after login
    Get.put(bookingData, tag: 'pending_booking');
  }
  
  /// Restore booking state after successful login
  void restoreBookingStateAfterLogin() {
    try {
      final bookingData = Get.find<Map<String, dynamic>>(tag: 'pending_booking');
      if (bookingData['returnFromLogin'] == true) {
        // Restore the booking state
        service = bookingData['service'] as BookingServiceModel;
        selectedDate.value = bookingData['selectedDate'] as String;
        selectedTime.value = bookingData['selectedTime'] as String;
        selectedLocation.value = bookingData['selectedLocation'] as String;
        selectedPaymentId.value = bookingData['selectedPaymentId'] as String;
        
        // Update text controllers
        dateController.text = selectedDate.value;
        timeController.text = selectedTime.value;
        
        // Update location selection
        isHomeServiceSelected.value = selectedLocation.value == AppStrings.homeService;
        isParlourServiceSelected.value = selectedLocation.value == AppStrings.parlourService;
        
        // Navigate back to unified booking page
        Get.toNamed(AppRoutes.unifiedBooking, arguments: bookingData);
        
        // Clean up the stored data
        Get.delete<Map<String, dynamic>>(tag: 'pending_booking');
      }
    } catch (e) {
      // No pending booking data found, this is normal for new users
      print('No pending booking data found: $e');
    }
  }
  
  // Step 3 methods
  void onDone() {
    Get.back();
  }
  
  void onBookMore() {
    currentStep.value = 0; // Reset to first step
  }

  @override
  void onClose() {
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }
}

