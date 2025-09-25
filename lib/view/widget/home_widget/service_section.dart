import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/home_controller/home_controller.dart';
import '../../../controller/home_controller/unified_service_data_controller.dart';
import '../home_page_service_card_widget.dart';

class ServicesSection extends StatelessWidget {
  final HomeController controller;
  final UnifiedServiceDataController unifiedServiceController;

  const ServicesSection({
    super.key,
    required this.controller,
    required this.unifiedServiceController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.services.tr, style: AppTextStyles.bodyTitle),
        const SizedBox(height: AppSizes.spacing8),
        Obx(() {
          final selectedTab = controller.selectedTopTabIndex.value;
          if (unifiedServiceController.selectedTabIndex.value != selectedTab) {
            unifiedServiceController.loadDataByTab(selectedTab);
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                unifiedServiceController.serviceList.length,
                    (index) {
                  final service = unifiedServiceController.serviceList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.spacing20),
                    child: ServiceCard(
                      title: service.title,
                      icon: service.icon,
                      isSelected: service.isSelected,
                      onTap: () => unifiedServiceController.selectService(index),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
