

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:parlour_app/constants/app_colors.dart';

import '../../constants/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final bool? isBack;
  final List<Widget>? children;
  const CustomAppBar({
    super.key,
    required this.title,
    this.isBack,
    this.subtitle = "",
    this.onBack,
    this.children
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(preferredSize: preferredSize, child: Container(
        width: (MediaQuery.of(context).size.width),
        height: 2.5,
        color: AppColors.grey,
      )),
      automaticallyImplyLeading: false,
      backgroundColor:AppColors.primary,

      leading: isBack==true ? null : GestureDetector(
        onTap: onBack ?? () => Get.back(),
        child:  Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.white,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style:  AppTextStyles.subHeading.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
      actions: children,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
