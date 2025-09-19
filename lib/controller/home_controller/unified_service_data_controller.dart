import 'package:get/get.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';
import '../../model/unified_data_model.dart';
import '../../model/service_model.dart';
import '../favourite_controller.dart';

/// Controller to manage unified data for Parlour, Boutique, and Rent tabs
class UnifiedServiceDataController extends GetxController {
  // -------------------- STATE --------------------
  final RxList<UnifiedDataModel> dataList = <UnifiedDataModel>[].obs; // All data
  final RxList<UnifiedDataModel> filteredDataList = <UnifiedDataModel>[].obs; // Filtered based on service
  final RxList<ServiceModel> serviceList = <ServiceModel>[].obs; // List of services per tab
  final RxInt selectedTabIndex = 0.obs;
  final RxInt selectedServiceIndex = 0.obs;
  final RxBool isLoading = false.obs;

  // Track favorites locally within this controller
  final RxSet<String> favoriteIds = <String>{}.obs;

  // -------------------- LIFECYCLE --------------------
  @override
  void onInit() {
    super.onInit();
    loadDataByTab(0);
  }

  // ==================== DATA LOADING ====================

  /// Load data for the selected tab (0: Parlour, 1: Boutique, 2: Rent)
  void loadDataByTab(int tabIndex) {
    selectedTabIndex.value = tabIndex;

    if (tabIndex == 0) {
      _loadParlourData();
    } else if (tabIndex == 1) {
      _loadBoutiqueData();
    } else {
      _loadRentData();
    }

    loadServicesByTab(tabIndex);

    // Reset service filter when tab changes
    _clearServiceSelection();
    _applyServiceFilter();
  }

  // -------------------- PARLOUR DATA --------------------
  void _loadParlourData() {
    dataList.value = [
      UnifiedDataModel(
        id: 'parlour_1',
        title: AppStrings.meeraBeautyParlour,
        subtitle: AppStrings.trendyCuts,
        location: AppStrings.oneKmSarthanaSurat,
        rating: AppStrings.rating38120Reviews,
        image: AppAssets.beauty1,
        discount: AppStrings.discount20Off,
        isOpen: true,
        type: AppStrings.parlourType,
        isFavorite: favoriteIds.contains('parlour_1'),
      ),
      UnifiedDataModel(
        id: 'parlour_2',
        title: AppStrings.rasmiBeauty,
        subtitle: AppStrings.bridalMakeup,
        location: AppStrings.twoKmMottaVarachhaSurat,
        rating: AppStrings.rating38120Reviews,
        image: AppAssets.beauty2,
        discount: AppStrings.discount15Off,
        isOpen: false,
        type: AppStrings.parlourType,
        isFavorite: favoriteIds.contains('parlour_2'),
      ),
      UnifiedDataModel(
        id: 'parlour_3',
        title: AppStrings.glowShineSalon,
        subtitle: AppStrings.facialHairCuts,
        location: AppStrings.location15kmAdajan,
        rating: AppStrings.rating47_210,
        image: AppAssets.beauty1,
        discount: AppStrings.discount10OffFull,
        isOpen: true,
        type: AppStrings.parlourType,
        isFavorite: favoriteIds.contains('parlour_3'),
      ),
      UnifiedDataModel(
        id: 'parlour_4',
        title: AppStrings.blushBeautyHub,
        subtitle: AppStrings.makeupStudio,
        location: AppStrings.location21kmVesu,
        rating: AppStrings.rating46_180,
        image: AppAssets.beauty2,
        discount: AppStrings.discount15OffFull,
        isOpen: true,
        type: AppStrings.parlourType,
        isFavorite: favoriteIds.contains('parlour_4'),
      ),
      UnifiedDataModel(
        id: 'parlour_5',
        title: AppStrings.urbanCuts,
        subtitle: AppStrings.trendyHairCutSpa,
        location: AppStrings.location30kmVarachha,
        rating: AppStrings.rating45_95,
        image: AppAssets.beauty1,
        discount: AppStrings.discount20OffFull,
        isOpen: true,
        type: AppStrings.parlourType,
        isFavorite: favoriteIds.contains('parlour_5'),
      ),
      UnifiedDataModel(
        id: 'parlour_6',
        title: AppStrings.eliteMakeover,
        subtitle: AppStrings.bridalMakeupFacial,
        location: AppStrings.location08kmKatargam,
        rating: AppStrings.rating48_320,
        image: AppAssets.beauty2,
        discount: AppStrings.discount25OffFull,
        isOpen: true,
        type: AppStrings.parlourType,
        isFavorite: favoriteIds.contains('parlour_6'),
      ),
      UnifiedDataModel(
        id: 'parlour_7',
        title: AppStrings.silkGlow,
        subtitle: AppStrings.waxingSpa,
        location: AppStrings.location24kmPal,
        rating: AppStrings.rating43_60,
        image: AppAssets.beauty1,
        discount: AppStrings.discount5OffFull,
        isOpen: false,
        type: AppStrings.parlourType,
        isFavorite: favoriteIds.contains('parlour_7'),
      ),
    ];
  }

  // -------------------- BOUTIQUE DATA --------------------
  void _loadBoutiqueData() {
    dataList.value = [
      UnifiedDataModel(
        id: 'boutique_1',
        title: AppStrings.vrutiBoutique,
        subtitle: AppStrings.bridalCollection,
        location: AppStrings.oneKmMottaVarachhaSurat,
        rating: AppStrings.rating4890Reviews,
        image: AppAssets.boutique1,
        discount: AppStrings.discount20Off,
        isOpen: true,
        type: AppStrings.boutiqueType,
        isFavorite: favoriteIds.contains('boutique_1'),
      ),
      UnifiedDataModel(
        id: 'boutique_2',
        title: AppStrings.rasmiBoutique,
        subtitle: AppStrings.formalWear,
        location: AppStrings.twoKmSarthanaSurat,
        rating: AppStrings.rating38120Reviews,
        image: AppAssets.boutique2,
        discount: AppStrings.discount10Off,
        isOpen: false,
        type: AppStrings.boutiqueType,
        isFavorite: favoriteIds.contains('boutique_2'),
      ),
      UnifiedDataModel(
        id: 'boutique_3',
        title: AppStrings.threadNeedle,
        subtitle: AppStrings.customizableDesigns,
        location: AppStrings.location12kmAdajan,
        rating: AppStrings.rating46_150,
        image: AppAssets.boutique3,
        discount: AppStrings.discount10OffFull,
        isOpen: true,
        type: AppStrings.boutiqueType,
        isFavorite: favoriteIds.contains('boutique_3'),
      ),
      UnifiedDataModel(
        id: 'boutique_4',
        title: AppStrings.royalStitches,
        subtitle: AppStrings.embroideryBridal,
        location: AppStrings.location23kmVesu,
        rating: AppStrings.rating45_115,
        image: AppAssets.boutique4,
        discount: AppStrings.discount12OffFull,
        isOpen: true,
        type: AppStrings.boutiqueType,
        isFavorite: favoriteIds.contains('boutique_4'),
      ),
      UnifiedDataModel(
        id: 'boutique_5',
        title: AppStrings.indoWearStudio,
        subtitle: AppStrings.indoWesternSubtitle,
        location: AppStrings.location27kmPal,
        rating: AppStrings.rating47_210Boutique,
        image: AppAssets.boutique1,
        discount: AppStrings.discount18OffFull,
        isOpen: true,
        type: AppStrings.boutiqueType,
        isFavorite: favoriteIds.contains('boutique_5'),
      ),
      UnifiedDataModel(
        id: 'boutique_6',
        title: AppStrings.fashionLoom,
        subtitle: AppStrings.formalWear,
        location: AppStrings.location35kmCityLight,
        rating: AppStrings.rating42_75,
        image: AppAssets.boutique2,
        discount: AppStrings.discount8OffFull,
        isOpen: false,
        type: AppStrings.boutiqueType,
        isFavorite: favoriteIds.contains('boutique_6'),
      ),
    ];
  }

  // -------------------- RENT DATA --------------------
  void _loadRentData() {
    dataList.value = [
      UnifiedDataModel(
        id: 'rent_1',
        title: AppStrings.rentFashion,
        subtitle: AppStrings.lehengaRentalSubtitle,
        location: AppStrings.location18kmAdajan,
        rating: AppStrings.rating49_180,
        image: AppAssets.rent1,
        discount: AppStrings.discount30OffFull,
        isOpen: true,
        type: AppStrings.rentType,
        isFavorite: favoriteIds.contains('rent_1'),
        price: 799,
        oldPrice: 899,
        offerText: 'Flat 30% Off',
        description: 'Highlighting the benefits of renting designer wear at lower cost.',
      ),
      UnifiedDataModel(
        id: 'rent_2',
        title: AppStrings.bridalRentalsStudio,
        subtitle: AppStrings.sareeRentalSubtitle,
        location: AppStrings.location25kmVesu,
        rating: AppStrings.rating48_150,
        image: AppAssets.rent2,
        discount: AppStrings.discount22OffFull,
        isOpen: true,
        type: AppStrings.rentType,
        isFavorite: favoriteIds.contains('rent_2'),
        price: 1099,
        oldPrice: 1399,
        offerText: 'Flat 22% Off',
        description: 'Highlighting the benefits of renting designer wear at lower cost.',
      ),
      UnifiedDataModel(
        id: 'rent_3',
        title: AppStrings.designerRentalsHub,
        subtitle: AppStrings.gownRentalSubtitle,
        location: AppStrings.location32kmVarachha,
        rating: AppStrings.rating47_120,
        image: AppAssets.rent3,
        discount: AppStrings.discount28OffFull,
        isOpen: true,
        type: AppStrings.rentType,
        isFavorite: favoriteIds.contains('rent_3'),
        price: 999,
        oldPrice: 1299,
        offerText: 'Flat 28% Off',
        description: 'Highlighting the benefits of renting designer wear at lower cost.',
      ),
      UnifiedDataModel(
        id: 'rent_4',
        title: AppStrings.partyWearRentals,
        subtitle: AppStrings.suitRentalSubtitle,
        location: AppStrings.location12kmKatargam,
        rating: AppStrings.rating46_90,
        image: AppAssets.rent4,
        discount: AppStrings.discount35OffFull,
        isOpen: false,
        type: AppStrings.rentType,
        isFavorite: favoriteIds.contains('rent_4'),
        price: 1299,
        oldPrice: 1699,
        offerText: 'Flat 35% Off',
        description: 'Highlighting the benefits of renting designer wear at lower cost.',
      ),
    ];
  }

  // ==================== FAVORITES MANAGEMENT ====================
  void toggleFavorite(int index) {
    final item = dataList[index];
    final itemId = item.id ?? '';

    if (favoriteIds.contains(itemId)) {
      favoriteIds.remove(itemId);
    } else {
      favoriteIds.add(itemId);
    }

    dataList[index] = dataList[index].copyWith(isFavorite: favoriteIds.contains(itemId));

    try {
      final favouriteController = Get.find<FavouriteController>();
      favouriteController.loadFavourites();
    } catch (_) {}
  }

  void toggleFavoriteById(String itemId) {
    final index = dataList.indexWhere((item) => item.id == itemId);
    if (index != -1) toggleFavorite(index);
  }

  // ==================== SERVICE MANAGEMENT ====================
  void loadServicesByTab(int tabIndex) {
    if (tabIndex == 0) {
      serviceList.value = [
        ServiceModel(title: AppStrings.hairCutting, icon: AppAssets.parlour1, type: AppStrings.parlourType),
        ServiceModel(title: AppStrings.facial, icon: AppAssets.parlour2, type: AppStrings.parlourType),
        ServiceModel(title: AppStrings.makeup, icon: AppAssets.parlour3, type: AppStrings.parlourType),
        ServiceModel(title: AppStrings.waxing, icon: AppAssets.parlour4, type: AppStrings.parlourType),
        ServiceModel(title: AppStrings.spa, icon: AppAssets.parlour1, type: AppStrings.parlourType),
      ];
    } else if (tabIndex == 1) {
      serviceList.value = [
        ServiceModel(title: AppStrings.customizable, icon: AppAssets.boutique1, type: AppStrings.boutiqueType),
        ServiceModel(title: AppStrings.indoWestern, icon: AppAssets.boutique2, type: AppStrings.boutiqueType),
        ServiceModel(title: AppStrings.bridalCholi, icon: AppAssets.boutique3, type: AppStrings.boutiqueType),
        ServiceModel(title: AppStrings.embroidery, icon: AppAssets.boutique4, type: AppStrings.boutiqueType),
      ];
    } else {
      serviceList.value = [
        ServiceModel(title: AppStrings.lehengaRental, icon: AppAssets.rent1, type: AppStrings.rentType),
        ServiceModel(title: AppStrings.sareeRental, icon: AppAssets.rent2, type: AppStrings.rentType),
        ServiceModel(title: AppStrings.gownRental, icon: AppAssets.rent3, type: AppStrings.rentType),
        ServiceModel(title: AppStrings.suitRental, icon: AppAssets.rent4, type: AppStrings.rentType),
      ];
    }
  }

  void selectService(int index) {
    for (int i = 0; i < serviceList.length; i++) {
      serviceList[i] = serviceList[i].copyWith(isSelected: false);
    }
    serviceList[index] = serviceList[index].copyWith(isSelected: true);
    selectedServiceIndex.value = index;
    _applyServiceFilter();
  }

  void _clearServiceSelection() {
    for (int i = 0; i < serviceList.length; i++) {
      serviceList[i] = serviceList[i].copyWith(isSelected: false);
    }
    selectedServiceIndex.value = -1;
  }

  void _applyServiceFilter() {
    if (selectedServiceIndex.value < 0 || selectedServiceIndex.value >= serviceList.length) {
      filteredDataList.value = List.from(dataList);
      return;
    }

    final selectedTitle = serviceList[selectedServiceIndex.value].title.toLowerCase();
    final tab = selectedTabIndex.value;

    bool matches(UnifiedDataModel item) {
      final title = item.title.toLowerCase();
      final subtitle = item.subtitle.toLowerCase();
      return title.contains(selectedTitle) || subtitle.contains(selectedTitle);
    }

    filteredDataList.value = dataList.where(matches).toList();
  }

  // ==================== BANNER DATA ====================
  Map<String, String> getBannerData() {
    if (selectedTabIndex.value == 0) {
      return {
        'title': AppStrings.vivahGlam,
        'highlightText': AppStrings.off,
        'btnLabel': AppStrings.joinOne,
        'image': AppAssets.cosmetic,
        'discountImage': AppAssets.off30,
      };
    } else if (selectedTabIndex.value == 1) {
      return {
        'title': AppStrings.rangrezBoutique,
        'highlightText': AppStrings.off,
        'btnLabel': AppStrings.joinOne,
        'image': AppAssets.couple,
        'discountImage': AppAssets.off30,
      };
    } else {
      return {
        'title': AppStrings.firstRentFlat,
        'highlightText': AppStrings.off,
        'btnLabel': AppStrings.joinOne,
        'image': AppAssets.rent,
        'discountImage': AppAssets.off20,
      };
    }
  }
}
