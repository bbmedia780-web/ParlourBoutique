import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../common/common_button.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/write_review_controller.dart';

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
              left: AppSizes.spacing16,
              right: AppSizes.spacing16,
              bottom: bottomInset + AppSizes.spacing12,
            ),
            child: Obx(() => AppButton(
              width: double.infinity,
              height: AppSizes.size50,
              textStyle: AppTextStyles.buttonText,
              text: AppStrings.submitReview,
              onPressed: controller.isFormValid.value ? controller.submitReview : null,
            )),
          );
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width < 600 
                ? AppSizes.spacing16 
                : MediaQuery.of(context).size.width < 900 
                    ? AppSizes.spacing32 
                    : AppSizes.spacing48,
            vertical: MediaQuery.of(context).size.width < 600 
                ? AppSizes.spacing8 
                : MediaQuery.of(context).size.width < 900 
                    ? AppSizes.spacing16 
                    : AppSizes.spacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.addPhoto, style: AppTextStyles.titleSmall),
              SizedBox(height: AppSizes.spacing8),

              Obx(() {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: AppSizes.size120,
                    decoration: BoxDecoration(
                      color: AppColors.extraLightGrey,
                      borderRadius: BorderRadius.circular(AppSizes.spacing12),
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

            SizedBox(height: AppSizes.spacing16),
            Text(AppStrings.writeYourReview, style: AppTextStyles.titleSmall),
            SizedBox(height: AppSizes.spacing8),

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
                      borderRadius: BorderRadius.circular(AppSizes.spacing12),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: controller.reviewError.value.isNotEmpty ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.spacing12),
                      borderSide: BorderSide(
                        color: AppColors.red,
                        width: AppSizes.borderWidth1_5,
                      ),
                    ) : null,
                    focusedErrorBorder: controller.reviewError.value.isNotEmpty ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.spacing12),
                      borderSide: BorderSide(
                        color: AppColors.red,
                        width: AppSizes.borderWidth1_5,
                      ),
                    ) : null,
                  ),
                  onChanged: controller.updateReview,
                ),
                if (controller.reviewError.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSizes.spacing8),
                    child: Text(
                      controller.reviewError.value,
                      style: AppTextStyles.hintText.copyWith(
                        color: AppColors.red,
                        fontSize: AppSizes.small,
                      ),
                    ),
                  ),
              ],
            )),

          ],
        ),
      ),
    ));
  }
}
