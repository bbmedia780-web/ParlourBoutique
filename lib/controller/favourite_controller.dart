import 'package:get/get.dart';
import 'package:parlour_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:parlour_app/controller/unified_service_data_controller.dart';
import '../model/popular_model.dart';
import '../model/unified_data_model.dart';
import 'popular_controller.dart';

class FavouriteController extends GetxController with GetSingleTickerProviderStateMixin {
  final RxInt selectedTabIndex = 0.obs;
  final RxList<dynamic> allFavourites = <dynamic>[].obs;
  final RxList<dynamic> parlourFavourites = <dynamic>[].obs;
  final RxList<dynamic> boutiqueFavourites = <dynamic>[].obs;
  final RxList<dynamic> rentFavourites = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  late TabController tabController;
  late PopularController popularController;
  late UnifiedServiceDataController unifiedServiceController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });
    popularController = Get.find<PopularController>();
    unifiedServiceController = Get.find<UnifiedServiceDataController>();
    
    // Load favourites after a short delay to ensure other controllers are initialized
    Future.delayed(const Duration(milliseconds: 100), () {
      loadFavourites();
    });
    
    // Refresh favourites when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshFavourites();
    });
  }

  void loadFavourites() {
    isLoading.value = true;
    
    final allItems = <dynamic>[];
    final parlourItems = <dynamic>[];
    final boutiqueItems = <dynamic>[];
    final rentItems = <dynamic>[];
    
    // Add popular items that are favourited
    for (var item in popularController.popularList) {
      if (item.isFavorite) {
        allItems.add(item);
        if (item.category == 'parlour') {
          parlourItems.add(item);
        } else if (item.category == 'boutique') {
          boutiqueItems.add(item);
        } else if (item.category == 'rent') {
          rentItems.add(item);
        }
      }
    }
    
    // Add unified items that are favourited
    for (var item in unifiedServiceController.dataList) {
      if (item.isFavorite) {
        allItems.add(item);
        if (item.type == 'parlour') {
          parlourItems.add(item);
        } else if (item.type == 'boutique') {
          boutiqueItems.add(item);
        } else if (item.type == 'rent') {
          rentItems.add(item);
        }
      }
    }
    
    allFavourites.value = allItems;
    parlourFavourites.value = parlourItems;
    boutiqueFavourites.value = boutiqueItems;
    rentFavourites.value = rentItems;
    isLoading.value = false;
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;
    tabController.animateTo(index);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    // filterFavouritesBySearch(); // This will be handled by the TabBarView
  }

  void filterFavouritesBySearch() {
    if (searchQuery.value.isEmpty) {
      loadFavourites(); // Reload all data if search is empty
      return;
    }

    final query = searchQuery.value.toLowerCase();
    final currentItems = getCurrentFavourites(); // Get items for the current tab
    final filteredItems = <dynamic>[];

    for (var item in currentItems) {
      if (item.title.toLowerCase().contains(query) ||
          item.location.toLowerCase().contains(query) ||
          (item is PopularModel && item.bestFamousService.toLowerCase().contains(query)) ||
          (item is UnifiedDataModel && item.subtitle.toLowerCase().contains(query))) {
        filteredItems.add(item);
      }
    }

    // Update the appropriate list based on current tab
    switch (selectedTabIndex.value) {
      case 0:
        allFavourites.value = filteredItems;
        break;
      case 1:
        parlourFavourites.value = filteredItems;
        break;
      case 2:
        boutiqueFavourites.value = filteredItems;
        break;
    }
  }

  void removeFromFavourites(dynamic item) {
    final itemId = item.id ?? '';
    
    // Remove from popular controller
    if (item is PopularModel) {
      final index = popularController.popularList.indexWhere((element) => element.id == itemId);
      if (index != -1) {
        popularController.toggleFavorite(index);
      }
    }
    
    // Remove from unified controller
    if (item is UnifiedDataModel) {
      final index = unifiedServiceController.dataList.indexWhere((element) => element.id == itemId);
      if (index != -1) {
        unifiedServiceController.toggleFavorite(index);
      }
    }
    
    // Reload favourites
    loadFavourites();
  }

  void onItemTap(dynamic item) {
    Get.toNamed(AppRoutes.details, arguments: item);
  }

  void onBackPressed() {
    Get.back();
  }

  void onSearchPressed() {
    // TODO: Implement search functionality
  }

  List<dynamic> getCurrentFavourites() {
    switch (selectedTabIndex.value) {
      case 0:
        return allFavourites;
      case 1:
        return parlourFavourites;
      case 2:
        return boutiqueFavourites;
      default:
        return allFavourites;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Refresh favourites when screen is focused
  void refreshFavourites() {
    loadFavourites();
  }
}
