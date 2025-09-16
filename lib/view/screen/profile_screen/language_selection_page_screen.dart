import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/profile_controller/language_controller.dart';
import '../../../utility/global.dart';
import '../../widget/bottom_action_section_widget.dart';
import '../../widget/language_card_widget.dart';

class LanguageSelectionPageView extends StatelessWidget {
  LanguageSelectionPageView({super.key});

  final LanguageController controller = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _buildBody(constraints);
          },
        ),
      ),
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
      title: Text(
        AppStrings.language.tr,
        style: AppTextStyles.appBarText,
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
      child: Column(
        children: [
          Expanded(
            child: _buildLanguageList(),
          ),
          _buildBottomSection(constraints),
        ],
      ),
    );
  }

  Widget _buildLanguageList() {
    return Obx(() => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
          itemCount: controller.languages.length,
          separatorBuilder: (context, index) => AppGlobal.commonDivider(
            color: AppColors.lightGrey,
            thickness: 1,
          ),
          itemBuilder: (context, index) {
            final language = controller.languages[index];
            return LanguageCardWidget(
              language: language,
              onTap: () => controller.selectLanguage(language.id),
              groupValue: controller.selectedLanguageId.value,
              value: language.id,
              onChanged: (val) {
                if (val != null) controller.selectLanguage(val);
              },
            );
          },
        ));
  }

  Widget _buildBottomSection(BoxConstraints constraints) {
    return BottomActionSectionWidget(
      actionButton: _buildSaveButton(constraints),
    );
  }

  Widget _buildSaveButton(BoxConstraints constraints) {
    return AppButton(
      text: AppStrings.save.tr,
      onPressed: controller.saveLanguage,
      width: constraints.maxWidth,
      height: AppSizes.size50,
      isPrimary: true,
      textStyle: AppTextStyles.buttonText.copyWith(
        fontSize: AppSizes.body,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
