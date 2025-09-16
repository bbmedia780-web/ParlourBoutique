import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/profile_controller/support_ticket_form_controller.dart';

class SupportTicketFormPageView extends StatelessWidget {
  SupportTicketFormPageView({super.key});

  final SupportTicketFormController controller = Get.find<SupportTicketFormController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SafeArea(child: _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.black,
          size: AppSizes.spacing20,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(AppStrings.helpSupport.tr, style: AppTextStyles.appBarText),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSizes.spacing20),
                    _buildCategorySection(),
                    const SizedBox(height: AppSizes.spacing20),
                    _buildSubjectSection(),
                    const SizedBox(height: AppSizes.spacing20),
                    _buildDescriptionSection(),
                    const SizedBox(height: AppSizes.spacing20),
                  ],
                ),
              ),
            ),
            Builder(
              builder: (context) {
                final bottomInset = MediaQuery.of(context).viewPadding.bottom;
                return Padding(
                  padding: EdgeInsets.only(
                    left: AppSizes.spacing20,
                    right: AppSizes.spacing20,
                    bottom: bottomInset + AppSizes.spacing20,
                    top: AppSizes.spacing20,
                  ),
                  child: AppButton(
                    width: double.infinity,
                    height: AppSizes.spacing45,
                    textStyle: AppTextStyles.buttonText,
                    text: AppStrings.submit.tr,
                    onPressed: controller.submitTicket,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.category.tr, style: AppTextStyles.cardTitle),
        const SizedBox(height: AppSizes.spacing12),
        Obx(() => _buildCategoryDropdown()),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      children: [
        // Dropdown Button
        InkWell(
          onTap: controller.toggleCategoryDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing16,
              vertical: AppSizes.spacing14,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
              border: Border.all(color: AppColors.lightGrey, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.formData.value.category,
                    style: AppTextStyles.reviewTextTitle,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                  size: AppSizes.spacing26,
                ),
              ],
            ),
          ),
        ),

        // Dropdown Options
        if (controller.isCategoryDropdownOpen.value)
          Container(
            margin: const EdgeInsets.only(top: AppSizes.spacing4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
              border: Border.all(color: AppColors.lightGrey, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: controller.categories.map((category) {
                final isSelected =
                    controller.selectedCategory.value == category;
                return InkWell(
                  onTap: () => controller.selectCategory(category),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacing16,
                      vertical: AppSizes.spacing12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.softPink
                          : Colors.transparent,
                    ),
                    child: Text(
                      category.tr,
                      style: AppTextStyles.profilePageText,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSubjectSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.subject.tr, style: AppTextStyles.cardTitle),
        const SizedBox(height: AppSizes.spacing12),
        TextFormField(
          controller: controller.subjectController,
          onChanged: controller.updateSubject,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: 'Enter subject'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
              borderSide: BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
              borderSide: BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing16,
              vertical: AppSizes.spacing14,
            ),
          ),
          style: AppTextStyles.reviewTextTitle,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.description.tr, style: AppTextStyles.cardTitle),
        const SizedBox(height: AppSizes.spacing12),
        TextFormField(
          controller: controller.descriptionController,
          onChanged: controller.updateDescription,
          cursorColor: AppColors.primary,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Enter Description'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.spacing12),
              borderSide: BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.spacing12),
              borderSide: BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.spacing12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing16,
              vertical: AppSizes.spacing14,
            ),
          ),
          style: AppTextStyles.reviewTextTitle,
        ),
      ],
    );
  }

}
