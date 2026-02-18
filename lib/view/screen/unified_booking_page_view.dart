import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/constants/app_colors.dart';
import '../../common/common_container_text_field.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/unified_booking_controller.dart';
import '../../common/common_button.dart';
import '../../utility/global.dart';
import '../widget/payment_method_tile.dart';

class UnifiedBookingPageView extends StatelessWidget {
  UnifiedBookingPageView({super.key});

  final UnifiedBookingController controller = Get.put(UnifiedBookingController());

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
          onPressed: () {
            if (controller.currentStep.value > 0) {
              controller.onBackTap();
            } else {
              Get.back();
            }
          },
        ),
        title: Text(AppStrings.booking, style: AppTextStyles.appBarText),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.veryExtraLightGrey,
                      borderRadius: BorderRadius.circular(AppSizes.spacing12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.spacing16),
                      child: _buildStepper(),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing18),
                  Obx(() => _buildStepContent()),
                  const SizedBox(height: AppSizes.spacing40),
                ],
              ),
            ),
          ),
          Obx(
            () => _buildBottomButton().paddingSymmetric(
              horizontal: AppSizes.spacing20,
              vertical:  AppSizes.spacing20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const SizedBox(width: AppSizes.spacing12),
            _circle(step: 0),
            _divider(step: 0),
            _circle(step: 1),
            _divider(step: 1),
            _circle(step: 2),
            const SizedBox(width: AppSizes.spacing12),
          ],
        ),
        const SizedBox(height: AppSizes.spacing8),
        Row(
          children: [
            _label(step: 0, label: AppStrings.bookAppointment),
            const SizedBox(width: AppSizes.spacing18),
            _label(step: 1, label: AppStrings.payment),
            const SizedBox(width: AppSizes.spacing6),
            _label(step: 2, label: AppStrings.finished),
          ],
        ),
      ],
    );
  }

  Widget _circle({required int step}) {
    return Obx(() {
      final isActive = controller.currentStep.value >= step;
      return SizedBox(
        width: AppSizes.size60,
        child: Center(
          child: Container(
            width: isActive ? AppSizes.spacing24 : AppSizes.spacing12,
            height: isActive ? AppSizes.spacing24 : AppSizes.spacing12,
            decoration: BoxDecoration(
              color: isActive ? AppColors.kellyGreen : AppColors.lightGrey,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: isActive
                ? const Icon(
                    Icons.check,
                    size: AppSizes.spacing16,
                    color: AppColors.white,
                  )
                : null,
          ),
        ),
      );
    });
  }

  Widget _divider({required int step}) {
    return Obx(() {
      final isActive = controller.currentStep.value > step;
      return Expanded(
        child: Container(
          height: 2,
          color: isActive ? AppColors.kellyGreen : AppColors.lightGrey,
        ),
      );
    });
  }

  Widget _label({required int step, required String label}) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.captionMediumTitle,
      ),
    );
  }

  Widget _buildStepContent() {

    switch (controller.currentStep.value) {
      case 0:
        return _buildAppointmentStep();
      case 1:
        return _buildPaymentStep();
      case 2:
        return _buildFinishedStep();
      default:
        return _buildAppointmentStep();
    }
  }

  Widget _buildAppointmentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceCard(),
        const SizedBox(height: AppSizes.spacing20),
        _buildDatePicker(),
        _buildTimePicker(),
        _buildLocationOptions(),
      ],
    );
  }

  Widget _buildServiceCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing12),
      decoration: BoxDecoration(
        color: AppColors.veryExtraLightGrey,
        borderRadius: BorderRadius.circular(AppSizes.spacing12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            child: Image.asset(
              controller.service.image,
              width: AppSizes.size60,
              height: AppSizes.spacing64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.service.title, style: AppTextStyles.bodyTitle),
                Text(
                  controller.service.subtitle,
                  style: AppTextStyles.cardSubTitle,
                ),
                Text(
                  '₹ ${controller.service.price.toStringAsFixed(2)}',
                  style: AppTextStyles.priceText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.selectDate, style: AppTextStyles.profilePageText),
        const SizedBox(height: AppSizes.spacing4),
        CommonContainerTextField(
          controller: controller.dateController,
          hintText: controller.selectedDate.value,
          textStyle: AppTextStyles.hintText,
          keyboardType: TextInputType.none,
          readOnly: true,
          onTap: () => controller.selectDate(Get.context!),
          suffixIcon: GestureDetector(
            onTap: () => controller.selectDate(Get.context!),
            child: Container(
              height: AppSizes.size100,
              width: AppSizes.size50,
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppSizes.buttonRadius),
                  bottomRight: Radius.circular(AppSizes.buttonRadius),
                ),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                AppAssets.calender,
                color: AppColors.primary,
                height: AppSizes.spacing26,
              ),
            ),
          ),
        ).paddingOnly(bottom: AppSizes.spacing16),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.selectTime, style: AppTextStyles.profilePageText),
        const SizedBox(height: AppSizes.spacing4),
        CommonContainerTextField(
          controller: controller.timeController,
          hintText: controller.selectedTime.value,
          textStyle: AppTextStyles.hintText,
          keyboardType: TextInputType.none,
          readOnly: true,
          onTap: () => controller.selectTime(Get.context!),
          suffixIcon: GestureDetector(
            onTap: () => controller.selectTime(Get.context!),
            child: Container(
              height: AppSizes.size100,
              width: AppSizes.size50,
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(AppSizes.buttonRadius),
                  bottomRight: Radius.circular(AppSizes.buttonRadius),
                ),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                AppAssets.watch,
                color: AppColors.primary,
                height: AppSizes.spacing26,
              ),
            ),
          ),
        ).paddingOnly(bottom: AppSizes.spacing16),
      ],
    );
  }

  Widget _buildLocationOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.serviceLocation, style: AppTextStyles.inputText),
        const SizedBox(height: AppSizes.spacing8),
        Row(
          children: [
            Expanded(child: _locationTile(AppStrings.homeService)),
            Expanded(child: _locationTile(AppStrings.parlourService)),
          ],
        ),
      ],
    );
  }

  Widget _locationTile(String label) {
    return Obx(
      () => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.chooseLocation(label),
        child: Row(
          children: [
            Radio<String>(
              value: label,
              groupValue: controller.selectedLocation.value,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              onChanged: (value) {
                if (value != null) {
                  controller.chooseLocation(value);
                }
              },
            ),
            Text(
              label,
              style: AppTextStyles.captionMediumTitle,
            ).paddingSymmetric(horizontal: AppSizes.spacing6),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStep() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.services, style: AppTextStyles.bodyTitle),
        const SizedBox(height: AppSizes.spacing12),
        _buildServiceSummaryCard(),
        const SizedBox(height: AppSizes.spacing16),
        _buildPaymentMethodHeader(),
        const SizedBox(height: AppSizes.spacing12),
        _buildPaymentMethodsList(),
      ],
    );
  }

  Widget _buildPaymentMethodHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.paymentMethod, style: AppTextStyles.bodyTitle),
        GestureDetector(
          onTap: () {},
          child: Text(AppStrings.addNewMethod, style: AppTextStyles.priceText),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsList() {
    return Obx(
      () {
        return Column(
          children: controller.paymentMethods.asMap().entries.map((entry) {
            final index = entry.key;
            final paymentMethod = entry.value;
            final isSelected =
                paymentMethod.id == controller.selectedPaymentId.value;

            return Column(
              children: [
                PaymentMethodTile(
                  paymentMethod: paymentMethod,
                  isSelected: isSelected,
                  onTap: () => controller.selectPayment(paymentMethod.id),
                ),
                if (index < controller.paymentMethods.length - 1)
                  const SizedBox(height: AppSizes.spacing12),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildServiceSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: AppColors.veryExtraLightGrey,
        borderRadius: BorderRadius.circular(AppSizes.spacing12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceHeader(),
          const SizedBox(height: AppSizes.spacing12),
          AppGlobal.commonDivider(color: AppColors.lightGrey),
          const SizedBox(height: AppSizes.spacing12),
          _buildServiceDetails(),
          const SizedBox(height: AppSizes.spacing12),
          const DottedLine(
            dashLength: AppSizes.spacing4,
            dashGapLength: AppSizes.spacing4,
            dashColor: AppColors.darkMediumGrey,
          ),
          const SizedBox(height: AppSizes.spacing12),
          _buildTotalPayRow(),
        ],
      ),
    );
  }

  Widget _buildServiceHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          child: Image.asset(
            controller.service.image,
            width: AppSizes.size90,
            height: AppSizes.size80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: AppSizes.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.service.title, style: AppTextStyles.bodyTitle),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                controller.service.subtitle,
                style: AppTextStyles.captionMediumTitle,
              ),
              if (controller.service.address != null &&
                  controller.service.address!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppSizes.spacing4),
                  child: Text(
                    controller.service.address!,
                    style: AppTextStyles.greyVerySmall,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDetails() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  controller.selectedTime.value.isNotEmpty
                      ? controller.selectedTime.value
                      : AppStrings.selectTime,
                  style: AppTextStyles.captionTitle,
                ),
                const SizedBox(width: AppSizes.spacing12),
                Container(
                  width: AppSizes.spacing6,
                  height: AppSizes.spacing6,
                  decoration: const BoxDecoration(
                    color: AppColors.slightGrey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing12),
                Text(
                  controller.selectedDate.value.isNotEmpty
                      ? controller.selectedDate.value
                      : AppStrings.selectDate,
                  style: AppTextStyles.captionTitle,
                ),
              ],
            ),
          ),
          Text(
            '₹${controller.service.price.toStringAsFixed(2)}',
            style: AppTextStyles.captionTitle,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPayRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.totalPay,
            style: AppTextStyles.welcomePageDes
          ),
        ),
        Text(
          '₹${controller.service.price.toStringAsFixed(2)}',
          style: AppTextStyles.primaryButtonText
        ),
      ],
    );
  }

  Widget _buildFinishedStep() {
    return _buildSummaryCard();
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: AppColors.veryExtraLightGrey,
        borderRadius: BorderRadius.circular(AppSizes.spacing12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryHeader(),
          const SizedBox(height: AppSizes.spacing4),
          _buildSummaryLocation(),
          const SizedBox(height: AppSizes.spacing4),
          AppGlobal.commonDivider(color: AppColors.extraLightGrey),
          _buildSummaryDetails(),
          const SizedBox(height: AppSizes.spacing12),
          const DottedLine(
            dashLength: AppSizes.spacing4,
            dashGapLength: AppSizes.spacing4,
            dashColor: AppColors.darkMediumGrey,
          ),
          const SizedBox(height: AppSizes.spacing12),
          _buildSummaryTotal(),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            controller.service.title,
            style: AppTextStyles.bodyTitle,
          ),
        ),
        Obx(
          () => Text(
            'ID : ${controller.bookingId.value}',
            style: AppTextStyles.smallTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryLocation() {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: AppSizes.spacing16,
          color: AppColors.mediumGrey,
        ),
        const SizedBox(width: AppSizes.spacing6),
        Expanded(
          child: Text(
            controller.service.address ?? '',
            style: AppTextStyles.addressText,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryDetails() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.service.subtitle,
                style: AppTextStyles.bodySmallText,
              ),
              const SizedBox(height: AppSizes.spacing8),
              Obx(
                () => Text(
                  controller.selectedLocation.value,
                  style: AppTextStyles.bodySmallText,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(
              () => Text(
                controller.selectedDate.value.isNotEmpty
                    ? controller.selectedDate.value
                    : AppStrings.selectDate,
                style: AppTextStyles.priceText,
              ),
            ),
            const SizedBox(height: AppSizes.spacing8),
            Obx(
              () => Text(
                controller.selectedTime.value.isNotEmpty
                    ? controller.selectedTime.value
                    : AppStrings.selectTime,
                style: AppTextStyles.priceText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryTotal() {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.totalPay,
            style: AppTextStyles.captionTitle,
          ),
        ),
        Text(
          '₹${controller.service.price.toStringAsFixed(0)}',
          style: AppTextStyles.primaryButtonText,
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    switch (controller.currentStep.value) {
      case 0:
        return AppButton(
          height: AppSizes.spacing45,
          width: double.infinity,
          text: AppStrings.next,
          onPressed: controller.onNextStep,
          isPrimary: true,
          borderRadius: AppSizes.spacing8,
          textStyle: AppTextStyles.buttonText,
        );
      case 1:
        return AppButton(
          height: AppSizes.spacing45,
          width: double.infinity,
          text: AppStrings.confirmPayment,
          onPressed: controller.onConfirmPayment,
          isPrimary: true,
          borderRadius: AppSizes.spacing8,
          textStyle: AppTextStyles.buttonText,
        );
      case 2:
        return Column(
          children: [
            AppButton(
              height: AppSizes.spacing45,
              width: double.infinity,
              text: AppStrings.done,
              onPressed: controller.onDone,
              isPrimary: true,
              borderRadius: AppSizes.spacing8,
              textStyle: AppTextStyles.buttonText,
            ),
            const SizedBox(height: AppSizes.spacing12),
            SizedBox(
              height: AppSizes.spacing45,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: controller.onBookMore,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.spacing8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.spacing14,
                  ),
                ),
                child: Text(
                  AppStrings.bookMore,
                  style: AppTextStyles.primaryButtonText,
                ),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
