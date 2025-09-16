import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';
import '../../model/language_model.dart';

class LanguageCardWidget extends StatelessWidget {
  final LanguageModel language;
  final VoidCallback onTap;
  final bool showNativeName;
  final String groupValue;
  final String value;
  final ValueChanged<String?>? onChanged;

  const LanguageCardWidget({
    super.key,
    required this.language,
    required this.onTap,
    this.showNativeName = true,
    required this.groupValue,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell
(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.spacing6,
          horizontal: AppSizes.spacing12,
        ),
        child: Row(
          children: [
            // Language info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.name,
                    style: AppTextStyles.profilePageText,
                  ),
                ],
              ),
            ),
            // Radio button
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
