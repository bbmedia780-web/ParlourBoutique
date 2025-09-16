import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../constants/app_strings.dart';
import '../../model/payment_history_model.dart';
import '../../constants/app_assets.dart';


class PaymentHistoryController extends GetxController {
  RxList<PaymentHistoryModel> allPayments = <PaymentHistoryModel>[].obs;
  RxList<PaymentHistoryModel> filteredPayments = <PaymentHistoryModel>[].obs;
  RxString searchQuery = ''.obs;
  late TextEditingController searchController;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    _loadPaymentHistory();
  }

  void _loadPaymentHistory() {
    // Mock data based on the screenshot
    allPayments.value = [
      // Today's transactions
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
      
      // Friday, 13 Jun, 2025 transactions
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
      
      // Monday, 9 Jun, 2025 transactions
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
    
    filteredPayments.value = allPayments;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredPayments.value = allPayments;
    } else {
      filteredPayments.value = allPayments
          .where((payment) => payment.businessName
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }

  List<String> getGroupDates() {
    return filteredPayments
        .map((payment) => payment.groupDate)
        .toSet()
        .toList();
  }

  List<PaymentHistoryModel> getPaymentsByGroup(String groupDate) {
    return filteredPayments
        .where((payment) => payment.groupDate == groupDate)
        .toList();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
