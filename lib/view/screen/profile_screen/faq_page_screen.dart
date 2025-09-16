import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common_text_form_field.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/profile_controller/faq_controller.dart';
import '../../../model/faq_model.dart';
import '../../../utility/global.dart';

class FAQPageView extends StatelessWidget {
  FAQPageView({super.key});

  final FAQController controller = Get.put(FAQController());

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
        title: Text(AppStrings.faqs, style: AppTextStyles.appBarText),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: AppSizes.spacing20),
              Expanded(child: Obx(() => _buildFAQList())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return CommonTextField(
      controller: controller.searchController,
      hintText: AppStrings.searchHere,
      keyboardType: TextInputType.text,
      cursorColor: AppColors.grey,
      onChanged: controller.searchFAQs,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.search,
                fit: BoxFit.cover,
                scale: AppSizes.scaleSize,
                color: AppColors.mediumGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQList() {
    if (controller.filteredFAQs.isEmpty) {
      return Center(
        child: Text(AppStrings.noFaqsFound, style: AppTextStyles.inputText),
      );
    }

    return ListView.builder(
      itemCount: controller.filteredFAQs.length,
      itemBuilder: (context, index) {
        final faq = controller.filteredFAQs[index];
        return _buildFAQItem(faq, index);
      },
    );
  }

  Widget _buildFAQItem(FAQModel faq, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
      decoration: BoxDecoration(
        color: faq.isExpanded
            ? AppColors.rosePink.withValues(alpha: 0.1)
            : AppColors.lightGrey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(faq.question, style: AppTextStyles.faqsPageText),
          iconColor: AppColors.mediumGrey,
          collapsedIconColor: AppColors.mediumGrey,
          onExpansionChanged: (expanded) {
            controller.toggleFAQ(index);
          },
          children: [
            AppGlobal.commonDivider(
              color: AppColors.lightGrey,
            ).paddingSymmetric(horizontal: AppSizes.spacing8),
            Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.spacing16,
                right: AppSizes.spacing16,
                bottom: AppSizes.spacing16,
                top: AppSizes.spacing6,
              ),
              child: Text(faq.answer, style: AppTextStyles.faqsDescriptionText),
            ),
          ],
        ),
      ),
    );
  }
}
