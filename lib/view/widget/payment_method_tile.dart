import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';
import '../../model/payment_method_model.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethodModel paymentMethod;
  final VoidCallback onTap;
  final bool isSelected;

  const PaymentMethodTile({
    super.key,
    required this.paymentMethod,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing14,
        ),
        decoration: BoxDecoration(
          color: AppColors.extraLightGrey,
          borderRadius: BorderRadius.circular(AppSizes.spacing12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.extraLightGrey,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            _buildPaymentIcon(),
            const SizedBox(width: AppSizes.spacing12),
            Expanded(
              child: Text(
                paymentMethod.type == "cash" 
                    ? paymentMethod.name 
                    : paymentMethod.maskedNumber,
                style: AppTextStyles.inputText,
              ),
            ),
            if (isSelected) _buildSelectionIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentIcon() {
    if (paymentMethod.type == "cash") {
      // No icon for cash
      return const SizedBox.shrink();
    }

    // Card payment icons
    switch (paymentMethod.logo?.toLowerCase()) {
      case "visa":
        return Container(
          width: AppSizes.spacing40,
          height: AppSizes.spacing24,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F71), // VISA blue
            borderRadius: BorderRadius.circular(AppSizes.spacing4),
          ),
          child: Center(
            child: Text(
              "VISA",
              style: AppTextStyles.whiteCaptionText,
            ),
          ),
        );
      case "mastercard":
        return Container(
          width: AppSizes.spacing40,
          height: AppSizes.spacing24,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEB001B), Color(0xFFF79E1B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(AppSizes.spacing4),
          ),
          child: Center(
            child: Text(
              "MC",
              style: AppTextStyles.whiteCaptionText,
            ),
          ),
        );
      default:
        return Container(
          width: AppSizes.spacing24,
          height: AppSizes.spacing24,
          decoration: BoxDecoration(
            color: AppColors.veryExtraLightGrey,
            borderRadius: BorderRadius.circular(AppSizes.spacing6),
          ),
          child: const Icon(
            Icons.credit_card,
            size: AppSizes.spacing16,
            color: AppColors.grey,
          ),
        );
    }
  }

  Widget _buildSelectionIndicator() {
    return Container(
      width: AppSizes.spacing20,
      height: AppSizes.spacing20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.check,
        size: AppSizes.spacing12,
        color: AppColors.white,
      ),
    );
  }
}


