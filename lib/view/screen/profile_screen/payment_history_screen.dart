import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common_text_form_field.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/profile_controller/payment_history_controller.dart';
import '../../../model/payment_history_model.dart';
import '../../../utility/global.dart';


class PaymentHistoryPageView extends StatelessWidget {
  PaymentHistoryPageView({super.key});

  final PaymentHistoryController controller = Get.find<PaymentHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: AppSizes.spacing20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.paymentHistory,
          style: AppTextStyles.appBarText,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _buildPaymentList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing20,
        vertical: AppSizes.spacing16,
      ),
      child: CommonTextField(
        controller: controller.searchController,
        hintText: AppStrings.searchPaymentHistory,
        prefixIcon: Image.asset(
          AppAssets.search,
          color: AppColors.mediumGrey,
          scale: AppSizes.scaleSize,
        ),
        onChanged: controller.onSearchChanged,
      ),
    );
  }

  Widget _buildPaymentList() {
    return Obx(() {
      final groupDates = controller.getGroupDates();

      if (groupDates.isEmpty) {
        return Center(
          child: Text(
            AppStrings.noPaymentHistoryFound,
            style: AppTextStyles.bodySmallText,
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
        itemCount: groupDates.length,
        itemBuilder: (context, index) {
          final groupDate = groupDates[index];
          final payments = controller.getPaymentsByGroup(groupDate);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGroupHeader(groupDate),
              const SizedBox(height: AppSizes.spacing12),
              ...payments.map((payment) => _buildPaymentItem(payment)),
              const SizedBox(height: AppSizes.spacing16),
            ],
          );
        },
      );
    });
  }

  Widget _buildGroupHeader(String groupDate) {
    return Text(
      groupDate,
      style: AppTextStyles.cardTitle,
    );
  }

  Widget _buildPaymentItem(PaymentHistoryModel payment) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing6),
          child: Row(
            children: [
              // Business Image
              Container(
                width: AppSizes.spacing40,
                height: AppSizes.spacing40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(payment.businessImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: AppSizes.spacing12),

              // Business Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.businessName,
                      style: AppTextStyles.profilePageText,
                    ),
                    const SizedBox(height: AppSizes.spacing2),
                    Text(
                      payment.date,
                      style: AppTextStyles.paymentHistoryDate,
                    ),
                  ],
                ),
              ),

              // Amount
              Text(
                '₹${payment.amount.toStringAsFixed(2)}',
                style: AppTextStyles.paymentHistoryAmount.copyWith(
                  color: payment.isCredit ? AppColors.kellyGreen : AppColors.red,
                ),
              ),
            ],
          ),
        ),
        AppGlobal.commonDivider(
          color: AppColors.lightGrey,
          thickness: 1,
        ),
      ],
    );
  }
}
