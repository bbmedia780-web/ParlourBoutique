import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/routes/app_routes.dart';

class HomeController extends GetxController {
  // -------------------- Controllers --------------------
  final TextEditingController searchController = TextEditingController();
  late ScrollController scrollController;

  // -------------------- State --------------------
  final RxInt selectedTopTabIndex = 0.obs; // 0: Parlour, 1: Boutique, 2: Rent
  final RxBool showFloatingSearchBar = false.obs;

  // -------------------- Lifecycle --------------------
  @override
  void onInit() {
    super.onInit();
    fetchPopularServices();

    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  // -------------------- Scroll Handling --------------------
  void _onScroll() {
    // Show floating search bar if user scrolls more than 200px
    final shouldShow = scrollController.offset > 200;
    if (shouldShow != showFloatingSearchBar.value) {
      showFloatingSearchBar.value = shouldShow;
    }
  }

  // -------------------- Actions --------------------
  void onMicrophoneTap() {
    // TODO: Implement voice search
  }

  void fetchPopularServices() {
    // TODO: API call for fetching services
  }

  void onSeeAllPopularTap() {
    // Navigate to Popular See All page with current category
    Get.toNamed(AppRoutes.popularSeeAll, arguments: _currentCategoryKey);
  }

  void onNotificationTap() {
    Get.toNamed(AppRoutes.notification);
  }

  void onChatTap() {
    // TODO: Open chat screen
  }

  void onAddButtonTapped() {
    // Add product button is only available in Rent tab
    if (selectedTopTabIndex.value == 2) {
      Get.toNamed(AppRoutes.addRentProduct);
    }
  }

  void onTopTabSelected(int index) {
    selectedTopTabIndex.value = index;
  }

  // -------------------- Helpers --------------------
  /// Returns filtered popular items based on selected category
  List<dynamic> getFilteredPopularItems(List<dynamic> popularList) {
    return popularList
        .where((item) => item.category == _currentCategoryKey)
        .toList();
  }

  /// Returns current category display name
  String getCategoryName() {
    switch (selectedTopTabIndex.value) {
      case 0:
        return 'Parlour';
      case 1:
        return 'Boutique';
      case 2:
        return 'Rent';
      default:
        return 'Parlour';
    }
  }

  /// Returns current category key for API/logic use
  String get _currentCategoryKey {
    switch (selectedTopTabIndex.value) {
      case 0:
        return 'parlour';
      case 1:
        return 'boutique';
      case 2:
        return 'rent';
      default:
        return 'parlour';
    }
  }
}
