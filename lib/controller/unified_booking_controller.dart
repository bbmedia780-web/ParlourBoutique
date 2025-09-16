import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/booking_service_model.dart';
import '../model/payment_method_model.dart';
import '../model/details_model.dart';
import '../constants/app_strings.dart';
import '../constants/app_assets.dart';

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
    if (args is BookingServiceModel) {
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
  
  void onConfirmPayment() {
    currentStep.value = 2; // Move to final step
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

