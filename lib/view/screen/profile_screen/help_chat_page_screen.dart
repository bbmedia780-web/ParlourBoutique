import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/common_container_text_field.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/profile_controller/help_chat_controller.dart';


class HelpChatPageView extends StatelessWidget {
  HelpChatPageView({super.key});

  final HelpChatController controller = Get.find<HelpChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildChatList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
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
        AppStrings.helpSupport.tr,
        style: AppTextStyles.appBarText
      ),
      centerTitle: true,
    );
  }

  Widget _buildChatList() {
    return Obx(() => ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16, vertical: AppSizes.spacing12),
      itemCount: controller.messages.length,
      itemBuilder: (context, index) {
        final message = controller.messages[index];
        return _buildMessageBubble(message);
      },
    ));
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['type'] == AppStrings.messageTypeUser;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacing16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            _buildAgentAvatar(),
            const SizedBox(width: AppSizes.spacing8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: Get.width * 0.75,
              ),
              padding: const EdgeInsets.all(AppSizes.spacing12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.softPink : AppColors.extraLightGrey,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppSizes.spacing16),
                  topRight: const Radius.circular(AppSizes.spacing16),
                  bottomLeft: Radius.circular(isUser ? AppSizes.spacing16 : AppSizes.spacing4),
                  bottomRight: Radius.circular(isUser ? AppSizes.spacing4 : AppSizes.spacing16),
                ),
              ),
              child: Text(
                message['message'],
                style: AppTextStyles.bodySmallText.copyWith(
                  color: isUser ? AppColors.black : AppColors.black,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: AppSizes.spacing8),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildAgentAvatar() {
    return Container(
      width: AppSizes.spacing32,
      height: AppSizes.spacing32,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.support_agent,
        color: Colors.white,
        size: AppSizes.spacing16,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: AppSizes.spacing32,
      height: AppSizes.spacing32,
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        color: AppColors.primary,
        size: AppSizes.spacing16,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      color: AppColors.white,
      child: CommonContainerTextField(
        controller: controller.messageController,
        keyboardType: TextInputType.text,
        hintText: AppStrings.askQuestion.tr,
        suffixIcon: GestureDetector(
          onTap: controller.sendMessage,
          child: Image.asset(
            AppAssets.send,
            height: AppSizes.size60,
            scale: AppSizes.scaleSize,
          ),
        ),
      ),
    );
  }
}
