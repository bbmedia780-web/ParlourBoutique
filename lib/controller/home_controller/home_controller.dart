import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

/// HomeController - Manages home screen state and business logic
///
/// This controller handles the home screen functionality including:
/// - Tab switching between Parlour, Boutique, and Rent categories
/// - Search functionality
/// - Scroll behavior (floating search bar)
/// - Navigation to other screens
/// - Popular services data management
///
/// The controller follows MVVM pattern where all business logic
/// is separated from the UI layer.
class HomeController extends GetxController {
  // ==================== Controllers ====================
  
  /// Search input controller
  final TextEditingController searchController = TextEditingController();
  
  /// Scroll controller for list view
  late ScrollController scrollController;

  // ==================== State ====================
  
  /// Currently selected tab index
  /// 0: Parlour, 1: Boutique, 2: Rent
  final RxInt selectedTopTabIndex = 0.obs;
  
  /// Controls visibility of floating search bar
  /// Shows when user scrolls down more than 200px
  final RxBool showFloatingSearchBar = false.obs;

  // ==================== Lifecycle Methods ====================
  
  /// Initializes controller and sets up listeners
  @override
  void onInit() {
    super.onInit();
    
    // Fetch initial data
    fetchPopularServices();

    // Setup scroll controller and listener
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  /// Cleanup resources when controller is disposed
  @override
  void onClose() {
    searchController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  // ==================== Private Methods ====================
  
  /// Handles scroll events to show/hide floating search bar
  ///
  /// Shows the floating search bar when user scrolls more than 200px down
  void _onScroll() {
    final shouldShow = scrollController.offset > 200;
    if (shouldShow != showFloatingSearchBar.value) {
      showFloatingSearchBar.value = shouldShow;
    }
  }

  /// Returns current category key for API/logic use
  ///
  /// Returns: 'parlour', 'boutique', or 'rent'
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

  // ==================== Public Methods ====================
  
  /// Handles microphone button tap for voice search
  ///
  /// TODO: Implement voice search functionality
  void onMicrophoneTap() {
    // Implement voice search
  }

  /// Fetches popular services from API
  ///
  /// TODO: Implement API call to fetch services based on category
  void fetchPopularServices() {
    // API call will be implemented here
  }

  /// Navigates to "See All" screen for popular items
  ///
  /// Passes the current category as argument
  void onSeeAllPopularTap() {
    Get.toNamed(AppRoutes.popularSeeAll, arguments: _currentCategoryKey);
  }

  /// Navigates to notifications screen
  void onNotificationTap() {
    Get.toNamed(AppRoutes.notification);
  }

  /// Handles chat button tap
  ///
  /// TODO: Implement chat screen navigation
  void onChatTap() {
    // Navigate to chat screen
  }

  /// Handles add product button tap
  ///
  /// Only available when Rent tab is selected (index 2)
  void onAddButtonTapped() {
    if (selectedTopTabIndex.value == 2) {
      Get.toNamed(AppRoutes.addRentProduct);
    }
  }

  /// Updates the selected tab index
  ///
  /// Parameters:
  /// - [index]: Tab index (0: Parlour, 1: Boutique, 2: Rent)
  void onTopTabSelected(int index) {
    selectedTopTabIndex.value = index;
  }

  // ==================== Helper Methods ====================
  
  /// Filters popular items based on selected category
  ///
  /// Parameters:
  /// - [popularList]: Complete list of popular items
  ///
  /// Returns: Filtered list containing only items matching current category
  List<dynamic> getFilteredPopularItems(List<dynamic> popularList) {
    return popularList
        .where((item) => item.category == _currentCategoryKey)
        .toList();
  }

  /// Returns human-readable name for current category
  ///
  /// Returns: 'Parlour', 'Boutique', or 'Rent'
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
}

