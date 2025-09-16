import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/routes/app_routes.dart';


class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxInt selectedTopTabIndex = 0.obs; // 0: Parlour, 1: Boutique, 2: Rent
  
  // Scroll controller and floating search bar state
  late ScrollController scrollController;
  final RxBool showFloatingSearchBar = false.obs;


  @override
  void onInit() {
    super.onInit();
    fetchPopularServices();
    selectedTopTabIndex.value = 0;
    
    // Initialize scroll controller
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }
  
  void _onScroll() {
    // Show floating search bar when scrolled past the header
    final shouldShow = scrollController.offset > 200;
    if (shouldShow != showFloatingSearchBar.value) {
      showFloatingSearchBar.value = shouldShow;
    }
  }


  void onMicrophoneTap() {
    // Handle microphone tap
  }

  void fetchPopularServices() {
    // Fetch popular services
  }
  
  void onSeeAllPopularTap() {
    String selectedCategory;
    switch (selectedTopTabIndex.value) {
      case 0:
        selectedCategory = 'parlour';
        break;
      case 1:
        selectedCategory = 'boutique';
        break;
      case 2:
        selectedCategory = 'rent';
        break;
      default:
        selectedCategory = 'parlour';
    }
    Get.toNamed( AppRoutes.popularSeeAll, arguments: selectedCategory);
  }

  
  void onNotificationTap() {
    Get.toNamed(AppRoutes.notification);
  }
  
  void onChatTap() {
    // Handle chat tap
  }

  void onAddButtonTapped() {
    if (selectedTopTabIndex.value == 2) {
      Get.toNamed(AppRoutes.addRentProduct);
    }
  }

  void onTopTabSelected(int index) {
    selectedTopTabIndex.value = index;
  }

  // Get filtered popular items based on selected category
  List<dynamic> getFilteredPopularItems(List<dynamic> popularList) {
    String selectedCategory;
    switch (selectedTopTabIndex.value) {
      case 0:
        selectedCategory = 'parlour';
        break;
      case 1:
        selectedCategory = 'boutique';
        break;
      case 2:
        selectedCategory = 'rent';
        break;
      default:
        selectedCategory = 'parlour';
    }
    
    return popularList
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  // Get category name for display
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
  
  @override
  void onClose() {
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
} 
