import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/booking_controller.dart';
import '../../widget/booking_service_card.dart';

class BookingPageView extends StatelessWidget {
  BookingPageView({super.key});

  final BookingController controller = Get.find<BookingController>();

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
        title: Text(AppStrings.booking, style: AppTextStyles.appBarText),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildServicesGrid(controller.allServices),
                _buildServicesGrid(controller.parlourServices),
                // Disabled for Phase 1: Boutique services tab
                // _buildServicesGrid(controller.boutiqueServices),
                _buildServicesGrid(controller.rentServices),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
      child: TabBar(
        controller: controller.tabController,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.grey,
        labelStyle: AppTextStyles.captionTitle,
        unselectedLabelStyle: AppTextStyles.captionTitle,
        tabs: [
          Tab(text: AppStrings.all),
          Tab(text: AppStrings.parlourTab),
          // Disabled for Phase 1: Boutique tab
          // Tab(text: AppStrings.boutiqueTab),
          Tab(text: AppStrings.rentTab),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(List services) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.spacing12,
        right: AppSizes.spacing12,
        top: AppSizes.spacing16,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: AppSizes.size250,
          childAspectRatio: 0.85,
          mainAxisSpacing: AppSizes.spacing8,
          crossAxisSpacing: AppSizes.spacing8,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Obx(() {
            final isBooked = controller.bookedServiceIds.contains(service.id);
            return BookingServiceCard(
              service: service,
              onTap: () => controller.onServiceTap(service),
              onBookNow: () => controller.onBookNowTap(service),
              isBooked: isBooked,
            );
          });
        },
      ),
    );
  }

}
