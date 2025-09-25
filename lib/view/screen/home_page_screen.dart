/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/controller/popular_controller.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_text_style.dart';
import '../../controller/home_controller/home_controller.dart';
import '../../controller/home_controller/unified_service_data_controller.dart';
import '../../controller/auth_controller/auth_controller.dart';
import '../../view/bottomsheet/filter_bottom_sheet.dart';
import '../../controller/home_controller/filter_controller.dart';
import '../widget/home_page_service_card_widget.dart';
import '../widget/popular_card_widget.dart';
import '../widget/unified_service_card_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find<HomeController>();
  final PopularController popularController = Get.find<PopularController>();
  final UnifiedServiceDataController unifiedServiceController = Get.find<UnifiedServiceDataController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
            CustomScrollView(
              controller: controller.scrollController,
              slivers: [
            SliverAppBar(
              backgroundColor: AppColors.white,
              automaticallyImplyLeading: false,
              pinned: true,
              floating: false,
              expandedHeight: AppSizes.size380,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderSection(context),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppSizes.spacing12),
                  _buildPopularNowSection(),
                  const SizedBox(height: AppSizes.spacing12),
                  _buildServicesSection(),
                  const SizedBox(height: AppSizes.spacing30),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
              sliver: _buildUnifiedListSliver(),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: AppSizes.size100),
            ),
              ],
            ),
            // Floating Search Bar
            Obx(() => controller.showFloatingSearchBar.value
              ? Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing20,
                    vertical: AppSizes.spacing8,
                  ),
                  child: _buildFloatingSearchBar(),
                ),
              )
              : const SizedBox.shrink(),
            ),
          ],
        ),
      );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return SizedBox(
      height: AppSizes.size380,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.white, AppColors.lightPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.spacing24),
                bottomRight: Radius.circular(AppSizes.spacing24),
              ),
            ),
          ),
          Positioned(
            bottom: AppSizes.size110,
            left: AppSizes.size120,
            child: Image.asset(AppAssets.spiral, height: AppSizes.spacing12),
          ),
          Positioned(
            bottom: AppSizes.spacing20,
            right: AppSizes.spacing30,
            child: Image.asset(AppAssets.heart, height: AppSizes.spacing12),
          ),
          Positioned(
            bottom: AppSizes.spacing62,
            right: AppSizes.spacing40,
            child: Image.asset(AppAssets.infinity, height: AppSizes.spacing8),
          ),
          Positioned(
            bottom: AppSizes.spacing35,
            left: AppSizes.size150,
            child: Image.asset(AppAssets.plus, height: AppSizes.spacing10),
          ),
          Positioned(
            bottom: AppSizes.size80,
            left: AppSizes.size180,
            child: Image.asset(AppAssets.bubble, height: AppSizes.spacing12),
          ),
          Positioned(
            bottom: AppSizes.size110,
            right: AppSizes.spacing20,
            child: Image.asset(AppAssets.bubble, height: AppSizes.spacing14),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppSizes.spacing20,
              right: AppSizes.spacing20,
              top: MediaQuery.of(context).padding.top + AppSizes.spacing6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        AppAssets.user,
                        height: AppSizes.spacing45,
                        width: AppSizes.spacing45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: AppSizes.spacing8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            authController.userName.value.isNotEmpty ? authController.userName.value : 'Guest',
                            style: AppTextStyles.captionTitle,
                          )),
                          Obx(() => Text(
                            authController.mobile.value.isNotEmpty ? authController.mobile.value : AppStrings.userAddress,
                            style: AppTextStyles.faqsDescriptionText,
                          )),
                        ],
                      ),
                    ),
                    _iconSquare(
                      AppAssets.notification,
                      onTap: controller.onNotificationTap,
                    ),
                    _iconSquare(AppAssets.message, onTap: controller.onChatTap),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing16),
                Obx(() {
                  final selected = controller.selectedTopTabIndex.value;
                  return Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            _segmentWithIcon(
                              AppStrings.parlourTab,
                              AppAssets.parlour,
                              0,
                              selected == 0,
                            ),
                            const SizedBox(width: AppSizes.spacing8),
                            // Disabled for Phase 1: Boutique tab
                            // _segmentWithIcon(
                            //   AppStrings.boutiqueTab,
                            //   AppAssets.boutique,
                            //   1,
                            //   selected == 1,
                            // ),
                            const SizedBox(width: AppSizes.spacing8),
                            _segmentWithIcon(
                              AppStrings.rentTab,
                              AppAssets.rentIcon,
                              2,
                              selected == 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: AppSizes.spacing16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: AppSizes.size50,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            AppSizes.spacing8,
                          ),
                          border: Border.all(color: AppColors.mediumGrey),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spacing16,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppAssets.search,
                              width: AppSizes.spacing20,
                              height: AppSizes.spacing20,
                              color: AppColors.mediumGrey,
                            ),
                            const SizedBox(width: AppSizes.spacing12),
                            Expanded(
                              child: TextField(
                                controller: controller.searchController,
                                decoration: InputDecoration(
                                  hintText: AppStrings.searchBridalMakeup,
                                  border: InputBorder.none,
                                  hintStyle: AppTextStyles.reviewTextTitle,
                                ),
                              ),
                            ),
                            Container(
                              height: AppSizes.spacing24,
                              width: 1,
                              color: AppColors.mediumGrey,
                              margin: const EdgeInsets.symmetric(
                                horizontal: AppSizes.spacing8,
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.onMicrophoneTap,
                              child: Image.asset(
                                AppAssets.mic,
                                width: AppSizes.spacing20,
                                height: AppSizes.spacing20,
                                color: AppColors.mediumGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacing12),
                    Container(
                      width: AppSizes.size50,
                      height: AppSizes.size50,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.spacing8),
                        border: Border.all(color: AppColors.mediumGrey),
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Ensure controller exists then open bottom sheet
                          if (!Get.isRegistered<FilterController>()) {
                            Get.put(FilterController());
                          }
                          Get.bottomSheet(
                            const FilterBottomSheet(),
                            isScrollControlled: true,
                          );
                        },
                        icon: Image.asset(
                          AppAssets.filterBlack,
                          width: AppSizes.spacing20,
                          height: AppSizes.spacing20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing8),
                _buildUnifiedBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconSquare(String asset, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: IconButton(
        onPressed: onTap,
        icon: Image.asset(asset, height: AppSizes.spacing32),
      ),
    );
  }

  Widget _segmentWithIcon(
      String title,
      String iconPath,
      int index,
      bool selected,
      ) {
    return GestureDetector(
      onTap: () {
        controller.onTopTabSelected(index);
        unifiedServiceController.loadDataByTab(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: AppSizes.size100,
        height: AppSizes.size80,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
            colors: [AppColors.rosePink, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          )
              : null,
          color: selected ? null : Colors.white,
          border: selected
              ? null
              : Border.all(color: AppColors.lightGrey, width: 1.2),
          borderRadius: BorderRadius.circular(AppSizes.spacing15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(iconPath, height: AppSizes.spacing45),
              Text(
                title,
                style: selected
                    ? AppTextStyles.whiteNameText
                    : AppTextStyles.captionTitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildUnifiedBanner() {
    return Obx(() {
      final bannerData = unifiedServiceController.getBannerData();

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            bannerData['image']!,
            fit: BoxFit.contain,
            height: AppSizes.size130,
            scale: AppSizes.scaleSize,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(bannerData['title']!, style: AppTextStyles.homeBanner),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      bannerData['discountImage'] ?? AppAssets.off30,
                      height: AppSizes.spacing24,
                      scale: AppSizes.scaleSize,
                    ),
                    Text(
                      bannerData['highlightText'] ?? "",
                      style: AppTextStyles.homeBanner,
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.spacing2),
                GestureDetector(
                  onTap: controller.onAddButtonTapped,
                  child: Container(
                    height: AppSizes.spacing40,
                    width: AppSizes.size140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.spacing30),
                      color: AppColors.primary,
                    ),
                    child: Center(
                      child: Text(
                        bannerData['btnLabel']!,
                        style: AppTextStyles.whiteNameText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPopularNowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.popularNow.tr, style: AppTextStyles.bodyTitle),
            GestureDetector(
              onTap: controller.onSeeAllPopularTap,
              child: Text(AppStrings.seeAll.tr, style: AppTextStyles.hintText),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacing10),
        SizedBox(
          height: AppSizes.size250,
          child: Obx(() {
            final filteredItems = controller.getFilteredPopularItems(popularController.popularList);
            if (filteredItems.isEmpty) {
              final categoryName = controller.getCategoryName();
              return Center(
                child: Text(
                  AppStrings.noItemsFor(categoryName),
                  style: AppTextStyles.bodyText.copyWith(color: AppColors.grey),
                ),
              );
            }

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filteredItems.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: AppSizes.spacing4),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return PopularCard(
                  data: item,
                  onFavoriteTap: () => popularController.toggleFavoriteById(item.id ?? ''),
                );
              },
            );
          }),
        ),
      ],
    );
  }


  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.services.tr, style: AppTextStyles.bodyTitle),
        const SizedBox(height: AppSizes.spacing8),
        Obx(() {
          // Update unified controller tab when home tab changes
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

  Widget _buildUnifiedListSliver() {
    return Obx(() {
      final list = unifiedServiceController.filteredDataList.isNotEmpty
          ? unifiedServiceController.filteredDataList
          : unifiedServiceController.dataList;

      if (list.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSizes.spacing20),
            child: Center(
              child: Text(
                AppStrings.noDataFound,
                style: AppTextStyles.bodyText.copyWith(color: AppColors.grey),
              ),
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final data = list[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacing16),
              child: UnifiedServiceCard(
                data: data,
                index: index,
                onFavoriteTap: () => unifiedServiceController.toggleFavoriteById(data.id ?? ''),
              ),
            );
          },
          childCount: list.length,
        ),
      );
    });
  }

  Widget _buildFloatingSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: AppSizes.size50,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                AppSizes.spacing8,
              ),
              border: Border.all(color: AppColors.mediumGrey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing16,
            ),
            child: Row(
              children: [
                Image.asset(
                  AppAssets.search,
                  width: AppSizes.spacing20,
                  height: AppSizes.spacing20,
                  color: AppColors.mediumGrey,
                ),
                const SizedBox(width: AppSizes.spacing12),
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: AppStrings.searchBridalMakeup,
                      border: InputBorder.none,
                      hintStyle: AppTextStyles.reviewTextTitle,
                    ),
                  ),
                ),
                Container(
                  height: AppSizes.spacing24,
                  width: 1,
                  color: AppColors.mediumGrey,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing8,
                  ),
                ),
                GestureDetector(
                  onTap: controller.onMicrophoneTap,
                  child: Image.asset(
                    AppAssets.mic,
                    width: AppSizes.spacing20,
                    height: AppSizes.spacing20,
                    color: AppColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSizes.spacing12),
        Container(
          width: AppSizes.size50,
          height: AppSizes.size50,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.spacing8),
            border: Border.all(color: AppColors.mediumGrey),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              // Ensure controller exists then open bottom sheet
              if (!Get.isRegistered<FilterController>()) {
                Get.put(FilterController());
              }
              Get.bottomSheet(
                const FilterBottomSheet(),
                isScrollControlled: true,
              );
            },
            icon: Image.asset(
              AppAssets.filterBlack,
              width: AppSizes.spacing20,
              height: AppSizes.spacing20,
            ),
          ),
        ),
      ],
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../controller/auth_controller/auth_controller.dart';
import '../../controller/home_controller/home_controller.dart';
import '../../controller/home_controller/unified_service_data_controller.dart';
import '../../controller/popular_controller.dart';
import '../widget/home_widget/floating_search_bar_widget.dart';
import '../widget/home_widget/home_header.dart';
import '../widget/home_widget/popular_now_section.dart';
import '../widget/home_widget/service_section.dart';
import '../widget/home_widget/unified_list_sliver.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find<HomeController>();
  final PopularController popularController = Get.find<PopularController>();
  final UnifiedServiceDataController unifiedServiceController = Get.find<UnifiedServiceDataController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.white,
                automaticallyImplyLeading: false,
                pinned: true,
                expandedHeight: AppSizes.size380,
                flexibleSpace: FlexibleSpaceBar(
                  background: HomeHeader(
                    controller: controller,
                    authController: authController,
                    unifiedServiceController: unifiedServiceController,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing20,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppSizes.spacing12),
                    PopularNowSection(
                      controller: controller,
                      popularController: popularController,
                    ),
                    const SizedBox(height: AppSizes.spacing12),
                    ServicesSection(
                      controller: controller,
                      unifiedServiceController: unifiedServiceController,
                    ),
                    const SizedBox(height: AppSizes.spacing30),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing20,
                ),
                sliver: UnifiedListSliver(controller: unifiedServiceController),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(height: AppSizes.size100),
              ),
            ],
          ),
          Obx(
            () => controller.showFloatingSearchBar.value
                ? Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 0,
                    right: 0,
                    child: FloatingSearchBarWidget(controller: controller),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
