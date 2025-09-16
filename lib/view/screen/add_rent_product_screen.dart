import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';
import '../../constants/app_strings.dart';
import '../../common/common_text_form_field.dart';
import '../../common/common_button.dart';
import '../../controller/add_rent_product_controller.dart';

class AddRentProductScreen extends StatelessWidget {
  AddRentProductScreen({super.key});

  final AddRentProductController controller =
      Get.find<AddRentProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(AppStrings.addProduct, style: AppTextStyles.appBarText),
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.uploadProductImages,
              style: AppTextStyles.captionTitle,
            ),
            const SizedBox(height: AppSizes.spacing10),
            _imagesRow(),
            const SizedBox(height: AppSizes.spacing16),
            Text(AppStrings.productName, style: AppTextStyles.captionTitle),
            const SizedBox(height: AppSizes.spacing6),
            CommonTextField(
              controller: controller.nameController,
              hintText: AppStrings.enterProductName,
              onChanged: (v) => controller.productName.value = v,
            ),
            const SizedBox(height: AppSizes.spacing16),
            Text(
              AppStrings.chooseCategories,
              style: AppTextStyles.captionTitle,
            ),
            const SizedBox(height: AppSizes.spacing6),
            _categoryDropdown(),
            const SizedBox(height: AppSizes.spacing16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.rentPerDay,
                        style: AppTextStyles.captionTitle,
                      ),
                      const SizedBox(height: AppSizes.spacing6),
                      CommonTextField(
                        controller: controller.rentController,
                        hintText: AppStrings.hintRentAmount,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => controller.rentPerDay.value =
                            double.tryParse(v.replaceAll(',', '')) ?? 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.discount,
                        style: AppTextStyles.captionTitle,
                      ),
                      const SizedBox(height: AppSizes.spacing6),
                      CommonTextField(
                        controller: controller.discountController,
                        hintText: AppStrings.hintDiscountPercent,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => controller.discountPercent.value =
                            double.tryParse(v) ?? 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing16),
            Text(AppStrings.productDetails, style: AppTextStyles.captionTitle),
            const SizedBox(height: AppSizes.spacing6),
            CommonTextField(
              controller: controller.detailsController,
              hintText: AppStrings.productDetailsHint,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              onChanged: (v) => controller.details.value = v,
              maxLength: null,
            ),
            const SizedBox(height: AppSizes.size100),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: AppSizes.spacing20,
          right: AppSizes.spacing20,
          bottom: AppSizes.spacing40,
        ),
        child: SizedBox(
          height: AppSizes.spacing48,
          child: AppButton(
            width: double.infinity,
            height: AppSizes.spacing48,
            text: AppStrings.save,
            textStyle: AppTextStyles.buttonText,
            onPressed: controller.save,
          ),
        ),
      ),
    );
  }

  Widget _imagesRow() {
    return Obx(() {
      final imgs = controller.selectedImages.toList();
      return SizedBox(
        height: AppSizes.spacing72,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (c, i) {
            if (i == imgs.length && imgs.length < 5) {
              return _addTile();
            }
            File file = imgs[i];
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.spacing8),
                  child: Image.file(
                    file,
                    width: AppSizes.size70,
                    height: AppSizes.size70,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => controller.removeImageAt(i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppSizes.spacing10),
          itemCount: imgs.length + (imgs.length < 5 ? 1 : 0),
        ),
      );
    });
  }

  Widget _addTile() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Container(
        width: AppSizes.size70,
        height: AppSizes.size70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.spacing8),
          color: AppColors.extraLightGrey,
        ),
        child: const Icon(Icons.add_a_photo_outlined, color: AppColors.grey),
      ),
    );
  }

  Widget _categoryDropdown() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
        decoration: BoxDecoration(
          color: AppColors.extraLightGrey,
          borderRadius: BorderRadius.circular(AppSizes.spacing8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.category.value.isEmpty
                ? null
                : controller.category.value,
            hint: Text(
              AppStrings.rentCategoryHint,
              style: AppTextStyles.hintText,
            ),
            items: controller.rentCategories
                .map(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, style: AppTextStyles.inputText),
                  ),
                )
                .toList(),
            onChanged: controller.selectCategory,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}
