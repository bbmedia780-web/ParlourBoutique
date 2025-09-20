import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_assets.dart';
import '../../controller/auth_controller/welcome_controller.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../widget/welcome_buttons_widget.dart';
import '../widget/welcome_page_widget.dart';

class WelcomeScreen extends StatelessWidget {
  final WelcomeController welcomeController = Get.find<WelcomeController>();
  final PageController pageController = PageController();

  final List<Map<String, String>> pages = [
    {
      "image":AppAssets.welcome1,
      "title":AppStrings.welcomeTitle1.tr,
      "desc": AppStrings.welcomeDesc1.tr,
    },
    {
      "image":AppAssets.welcome2,
      "title":AppStrings.welcomeTitle2.tr,
      "desc": AppStrings.welcomeDesc2.tr,
    },
    {
      "image":AppAssets.welcome3,
      "title":AppStrings.welcomeTitle3.tr,
      "desc": AppStrings.welcomeDesc3.tr,
    },
  ];

  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int pageCount = pages.length;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: welcomeController.setPage,
              itemCount: pageCount,
              itemBuilder: (_, index) {
                return WelcomePageWidget(
                  imagePath: pages[index]['image']!,
                  title: pages[index]['title']!,
                  description: pages[index]['desc']!,
                  pageCount: pages.length,
                );
              },
            ),
          ),
          WelcomeButtonsWidget(pageController: pageController, pageCount: pageCount).paddingOnly(bottom: AppSizes.spacing20)
        ],
      ),
    );
  }
}
