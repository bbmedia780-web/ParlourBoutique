/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../common/common_button.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/write_review_controller.dart';
import '../../../utility/responsive_helper.dart';
import '../../../constants/responsive_sizes.dart';
import '../../../common/responsive_layout.dart';

class WriteReviewScreen extends StatelessWidget {
  final WriteReviewController controller = Get.find<WriteReviewController>();

  WriteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(AppStrings.writeReview, style: AppTextStyles.appBarText),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.black,
            size: AppSizes.spacing20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: ResponsiveLayout(
        useSafeArea: true,
        useScrollView: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.addPhoto, style: AppTextStyles.titleSmall),
            SizedBox(height: ResponsiveSizes.getSpacing8(context)),

            Obx(() {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: ResponsiveSizes.getSize120(context),
                  decoration: BoxDecoration(
                    color: AppColors.extraLightGrey,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.getSpacing12(context)),
                  ),
                  child: controller.selectedMedia.value == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Icon(
                              Icons.cloud_upload_sharp,
                              color: AppColors.neutralGrey,
                              size: AppSizes.spacing40,
                            ),
                            SizedBox(height: AppSizes.spacing4),
                            Text(
                              AppStrings.upload,
                              style: AppTextStyles.cardSubTitle,
                            ),
                          ],
                        )
                      : Image.file(
                          controller.selectedMedia.value!,
                          fit: BoxFit.cover,
                        ),
                ),
              );
            }),

            SizedBox(height: ResponsiveSizes.getSpacing16(context)),
            Text(AppStrings.writeYourReview, style: AppTextStyles.titleSmall),
            SizedBox(height: ResponsiveSizes.getSpacing8(context)),

            TextField(
              maxLines: 5,
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: AppStrings.reviewHint,
                hintStyle: AppTextStyles.hintText,
                filled: true,
                fillColor: AppColors.extraLightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveSizes.getSpacing12(context)),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: controller.updateReview,
            ),

            const Spacer(),

            Builder(
              builder: (context) {
                final bottomInset = MediaQuery.of(context).viewPadding.bottom;
                return Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: AppButton(
                    width: double.infinity,
                    height: ResponsiveSizes.getSize50(context),
                    textStyle: AppTextStyles.buttonText,
                    text: AppStrings.submitReview,
                    onPressed: controller.submitReview,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../common/common_button.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/write_review_controller.dart';
import '../../../utility/responsive_helper.dart';
import '../../../constants/responsive_sizes.dart';
import '../../../common/responsive_layout.dart';

class WriteReviewScreen extends StatelessWidget {
  final WriteReviewController controller = Get.find<WriteReviewController>();

  WriteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(AppStrings.writeReview, style: AppTextStyles.appBarText),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.black,
            size: AppSizes.spacing20,
          ),
          onPressed: () => Get.back(),
        ),
      ),

      // ✅ Submit button fixed at bottom
      bottomNavigationBar: Builder(
        builder: (context) {
          final bottomInset = MediaQuery.of(context).viewPadding.bottom;
          return Padding(
            padding: EdgeInsets.only(
              left: ResponsiveSizes.getSpacing16(context),
              right: ResponsiveSizes.getSpacing16(context),
              bottom: bottomInset + ResponsiveSizes.getSpacing12(context),
            ),
            child: Obx(() => AppButton(
              width: double.infinity,
              height: ResponsiveSizes.getSize50(context),
              textStyle: AppTextStyles.buttonText,
              text: AppStrings.submitReview,
              onPressed: controller.isFormValid.value ? controller.submitReview : null,
            )),
          );
        },
      ),

      body: ResponsiveLayout(
        useSafeArea: true,
        useScrollView: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.addPhoto, style: AppTextStyles.titleSmall),
            SizedBox(height: ResponsiveSizes.getSpacing8(context)),

            Obx(() {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: ResponsiveSizes.getSize120(context),
                  decoration: BoxDecoration(
                    color: AppColors.extraLightGrey,
                    borderRadius: BorderRadius.circular(ResponsiveSizes.getSpacing12(context)),
                  ),
                  child: controller.selectedMedia.value == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_sharp,
                        color: AppColors.neutralGrey,
                        size: AppSizes.spacing40,
                      ),
                      SizedBox(height: AppSizes.spacing4),
                      Text(
                        AppStrings.upload,
                        style: AppTextStyles.cardSubTitle,
                      ),
                    ],
                  )
                      : Image.file(
                    controller.selectedMedia.value!,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),

            SizedBox(height: ResponsiveSizes.getSpacing16(context)),
            Text(AppStrings.writeYourReview, style: AppTextStyles.titleSmall),
            SizedBox(height: ResponsiveSizes.getSpacing8(context)),

            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  maxLines: 5,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: AppStrings.reviewHint,
                    hintStyle: AppTextStyles.hintText,
                    filled: true,
                    fillColor: AppColors.extraLightGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSizes.getSpacing12(context)),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: controller.reviewError.value.isNotEmpty ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSizes.getSpacing12(context)),
                      borderSide: BorderSide(
                        color: AppColors.red,
                        width: 1.5,
                      ),
                    ) : null,
                    focusedErrorBorder: controller.reviewError.value.isNotEmpty ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSizes.getSpacing12(context)),
                      borderSide: BorderSide(
                        color: AppColors.red,
                        width: 1.5,
                      ),
                    ) : null,
                  ),
                  onChanged: controller.updateReview,
                ),
                if (controller.reviewError.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      controller.reviewError.value,
                      style: AppTextStyles.hintText.copyWith(
                        color: AppColors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            )),

          ],
        ),
      ),
    );
  }
}
