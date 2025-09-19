import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_assets.dart';
import '../../model/payment_history_model.dart';

class PaymentHistoryController extends GetxController {
  // ---------------- State ----------------
  /// All payment history records
  final RxList<PaymentHistoryModel> allPayments = <PaymentHistoryModel>[].obs;

  /// Filtered payments based on search
  final RxList<PaymentHistoryModel> filteredPayments = <PaymentHistoryModel>[].obs;

  /// Current search query
  final RxString searchQuery = ''.obs;

  /// Controller for search input field
  late TextEditingController searchController;

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    _loadPaymentHistory();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ---------------- Load Data ----------------
  /// Load mock payment history (replace with API call if needed)
  void _loadPaymentHistory() {
    allPayments.value = [
      // Today
      PaymentHistoryModel(
        id: '1',
        businessName: AppStrings.velvaBeautyBar,
        businessImage: AppAssets.beauty1,
        date: AppStrings.paymentDate28Jun2025,
        amount: 12.00,
        isCredit: false,
        groupDate: AppStrings.today,
      ),
      PaymentHistoryModel(
        id: '2',
        businessName: AppStrings.theVanityRoom,
        businessImage: AppAssets.beauty2,
        date: AppStrings.paymentDate28Jun2025,
        amount: 12.00,
        isCredit: false,
        groupDate: AppStrings.today,
      ),
      PaymentHistoryModel(
        id: '3',
        businessName: AppStrings.polishPoisePayment,
        businessImage: AppAssets.beauty1,
        date: AppStrings.paymentDate28Jun2025,
        amount: 12.00,
        isCredit: false,
        groupDate: AppStrings.today,
      ),
      // Friday, 13 Jun, 2025
      PaymentHistoryModel(
        id: '4',
        businessName: AppStrings.vivahVibes,
        businessImage: AppAssets.beauty2,
        date: AppStrings.paymentDate28Jun2025,
        amount: 12.00,
        isCredit: true,
        groupDate: AppStrings.friday13Jun2025,
      ),
      PaymentHistoryModel(
        id: '5',
        businessName: AppStrings.theStyleNest,
        businessImage: AppAssets.beauty1,
        date: AppStrings.paymentDate28Jun2025,
        amount: 12.00,
        isCredit: false,
        groupDate: AppStrings.friday13Jun2025,
      ),
      PaymentHistoryModel(
        id: '6',
        businessName: AppStrings.fabFlick,
        businessImage: AppAssets.beauty2,
        date: AppStrings.paymentDate28Jun2025,
        amount: 12.00,
        isCredit: true,
        groupDate: AppStrings.friday13Jun2025,
      ),
      // Monday, 9 Jun, 2025
      PaymentHistoryModel(
        id: '7',
        businessName: AppStrings.roopSaaj,
        businessImage: AppAssets.beauty1,
        date: AppStrings.paymentDate26Jun2025,
        amount: 12.00,
        isCredit: false,
        groupDate: AppStrings.monday9Jun2025,
      ),
      PaymentHistoryModel(
        id: '8',
        businessName: AppStrings.blushBeyond,
        businessImage: AppAssets.beauty2,
        date: AppStrings.paymentDate26Jun2025,
        amount: 12.00,
        isCredit: false,
        groupDate: AppStrings.monday9Jun2025,
      ),
      PaymentHistoryModel(
        id: '9',
        businessName: AppStrings.styleMuse,
        businessImage: AppAssets.beauty1,
        date: AppStrings.paymentDate26Jun2025,
        amount: 12.00,
        isCredit: true,
        groupDate: AppStrings.monday9Jun2025,
      ),
    ];

    // Initialize filtered list
    filteredPayments.value = allPayments;
  }

  // ---------------- Search ----------------
  /// Filter payments based on search query
  void onSearchChanged(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredPayments.value = allPayments;
    } else {
      filteredPayments.value = allPayments
          .where((payment) => payment.businessName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // ---------------- Grouping ----------------
  /// Get all unique group dates from filtered payments
  List<String> getGroupDates() {
    return filteredPayments.map((payment) => payment.groupDate).toSet().toList();
  }

  /// Get all payments for a specific group date
  List<PaymentHistoryModel> getPaymentsByGroup(String groupDate) {
    return filteredPayments.where((payment) => payment.groupDate == groupDate).toList();
  }
}

