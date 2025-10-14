import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../model/popular_model.dart';
import 'favourite_controller.dart';

/// PopularController - Manages popular items across all categories
///
/// Handles:
/// - Loading popular parlours, boutiques, and rent items
/// - Managing favorite state
/// - Category filtering
/// - API data fetching (when ready)
class PopularController extends GetxController {
  // ==================== Dependencies ====================
  /// Dio instance for API calls
  final Dio _dio = Dio();

  // ==================== State ====================
  /// Complete list of all popular items
  final RxList<PopularModel> popularList = <PopularModel>[].obs;
  
  /// Loading state for API calls
  final RxBool isLoading = false.obs;
  
  /// Set of favorited item IDs for quick lookup
  final RxSet<String> favoriteIds = <String>{}.obs;

  // ==================== Lifecycle Methods ====================
  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  // ==================== Private Methods ====================
  
  /// Loads mock data for development/testing
  ///
  /// TODO: Replace with API call when backend is ready
  void _loadMockData() {
    popularList.value = _getMockPopularItems();
    _logDataStats();
  }

  /// Returns mock popular items for all categories
  ///
  /// This includes parlour, boutique, and rent items
  /// Favorites are synced with the favoriteIds set
/*
  List<PopularModel> _getMockPopularItems() {
    return [
      // ==================== Parlour Items ====================
      PopularModel(
        id: 'popular_parlour_1',
        title: AppStrings.bhavinsBeautySalon,
        rating: 3.8,
        location: AppStrings.bhavinsBeautySalonAddress,
        image: AppAssets.parlour1,
        discount: AppStrings.discount20Off,
        bestFamousService: AppStrings.trendyCuts,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_1'),
      ),
      PopularModel(
        id: 'popular_parlour_2',
        title: AppStrings.ashaBeautyStudio,
        rating: 4.5,
        location: AppStrings.ashaBeautyStudioAddress,
        image: AppAssets.parlour2,
        discount: AppStrings.discount50Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: false,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_2'),
      ),
      PopularModel(
        id: 'popular_parlour_3',
        title: AppStrings.cherHairAndBeautyLounge,
        rating: 3.8,
        location: AppStrings.cherHairAndBeautyLoungeAddress,
        image: AppAssets.parlour3,
        discount: "",
        bestFamousService: AppStrings.facial,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_3'),
      ),
      PopularModel(
        id: 'popular_parlour_4',
        title: AppStrings.affinitiSalon,
        rating: 4.0,
        location: AppStrings.affinitiSalonAddress,
        image: AppAssets.parlour4,
        discount: AppStrings.discount10Off,
        bestFamousService: AppStrings.makeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_4'),
      ),
      PopularModel(
        id: 'popular_parlour_5',
        title: AppStrings.looksSalon,
        rating: 4.8,
        location: AppStrings.looksSalonAddress,
        image: AppAssets.parlour1,
        discount: AppStrings.discount25Off,
        bestFamousService: AppStrings.makeupHairStyle,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_5'),
      ),
      PopularModel(
        id: 'popular_parlour_6',
        title: AppStrings.enrichBeauty,
        rating: 4.8,
        location: AppStrings.enrichSalonAddress1,
        image: AppAssets.parlour2,
        discount: "",
        bestFamousService: AppStrings.makeupHairStyle,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_6'),
      ),
      PopularModel(
        id: 'popular_parlour_7',
        title: AppStrings.aOneHairAndBeautyStudio,
        rating: 4.5,
        location: AppStrings.aOneHairAndBeautyStudioAddress1,
        image: AppAssets.parlour3,
        discount: AppStrings.discount15Off,
        bestFamousService: AppStrings.homeService,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_7'),
      ),
      PopularModel(
        id: 'popular_parlour_8',
        title: AppStrings.nailedIttLuxurySalonAndAcademy,
        rating: 4.0,
        location: AppStrings.nailedIttLuxurySalonAndAcademyAddress,
        image: AppAssets.parlour4,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_8'),
      ),
      PopularModel(
        id: 'popular_parlour_9',
        title: AppStrings.ambellishSalon,
        rating: 4.0,
        location: AppStrings.ambellishSalonAddress,
        image: AppAssets.parlour4,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_8'),
      ),
      PopularModel(
        id: 'popular_parlour_10',
        title: AppStrings.wasimsSalonHairBeauty,
        rating: 4.0,
        location: AppStrings.wasimsSalonHairBeautyAddress1,
        image: AppAssets.parlour4,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_8'),
      ),
      PopularModel(
        id: 'popular_parlour_11',
        title: AppStrings.theRedScissorsHairAndBeautySalon,
        rating: 4.0,
        location: AppStrings.theRedScissorsHairAndBeautySalonAddress1,
        image: AppAssets.parlour4,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_8'),
      ),
      PopularModel(
        id: 'popular_parlour_12',
        title: AppStrings.missGlamourBeautyParlour,
        rating: 4.0,
        location: AppStrings.missGlamourBeautyParlourAddress,
        image: AppAssets.parlour4,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_8'),
      ),

      // ==================== Boutique Items ====================
      PopularModel(
        id: 'popular_boutique_1',
        title: AppStrings.zivaBridal,
        rating: 3.8,
        location: AppStrings.sarthanaSurat,
        image: AppAssets.boutique1,
        discount: AppStrings.discount20Off,
        bestFamousService: AppStrings.bridalCollection,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_1'),
      ),
      PopularModel(
        id: 'popular_boutique_2',
        title: AppStrings.vrutiBoutique,
        rating: 4.8,
        location: AppStrings.motaVarachhaSurat,
        image: AppAssets.boutique2,
        discount: AppStrings.discount10Off,
        bestFamousService: AppStrings.formalWear,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_2'),
      ),
      PopularModel(
        id: 'popular_boutique_3',
        title: AppStrings.threadNeedle,
        rating: 4.6,
        location: AppStrings.location12kmAdajan,
        image: AppAssets.boutique3,
        discount: AppStrings.discount10OffFull,
        bestFamousService: AppStrings.customizableDesigns,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_3'),
      ),
      PopularModel(
        id: 'popular_boutique_4',
        title: AppStrings.royalStitches,
        rating: 4.5,
        location: AppStrings.location23kmVesu,
        image: AppAssets.boutique4,
        discount: AppStrings.discount12OffFull,
        bestFamousService: AppStrings.embroideryBridal,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_4'),
      ),
      PopularModel(
        id: 'popular_boutique_5',
        title: AppStrings.indoWearStudio,
        rating: 4.7,
        location: AppStrings.location27kmPal,
        image: AppAssets.boutique1,
        discount: AppStrings.discount18OffFull,
        bestFamousService: AppStrings.indoWesternSubtitle,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_5'),
      ),
      PopularModel(
        id: 'popular_boutique_6',
        title: AppStrings.fashionLoom,
        rating: 4.2,
        location: AppStrings.location35kmCityLight,
        image: AppAssets.boutique2,
        discount: AppStrings.discount8OffFull,
        bestFamousService: AppStrings.formalWear,
        service: AppStrings.homeService,
        isOpen: false,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_6'),
      ),
      
      // ==================== Rent Items ====================
      PopularModel(
        id: 'popular_rent_1',
        title: AppStrings.rentFashion,
        rating: 4.9,
        location: AppStrings.location18kmAdajan,
        image: AppAssets.rent1,
        discount: AppStrings.discount30OffFull,
        bestFamousService: AppStrings.lehengaRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_1'),
        price: 70000,
        view: 3.4,
      ),
      PopularModel(
        id: 'popular_rent_2',
        title: AppStrings.bridalRentalsStudio,
        rating: 4.8,
        location: AppStrings.location25kmVesu,
        image: AppAssets.rent2,
        discount: AppStrings.discount22OffFull,
        bestFamousService: AppStrings.sareeRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_2'),
        price: 6000,
        view: 4.4,
      ),
      PopularModel(
        id: 'popular_rent_3',
        title: AppStrings.designerRentalsHub,
        rating: 4.7,
        location: AppStrings.location32kmVarachha,
        image: AppAssets.rent3,
        discount: AppStrings.discount28OffFull,
        bestFamousService: AppStrings.gownRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_3'),
        price: 70088,
        view: 5.4,
      ),
      PopularModel(
        id: 'popular_rent_4',
        title: AppStrings.partyWearRentals,
        rating: 4.6,
        location: AppStrings.location12kmKatargam,
        image: AppAssets.rent4,
        discount: AppStrings.discount35OffFull,
        bestFamousService: AppStrings.suitRental,
        service: AppStrings.homeService,
        isOpen: false,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_4'),
        price: 50000,
        view: 4.1,
      ),
      PopularModel(
        id: 'popular_rent_5',
        title: AppStrings.fashionRentals,
        rating: 4.5,
        location: AppStrings.location15kmAdajan,
        image: AppAssets.rent1,
        discount: AppStrings.discount20OffFull,
        bestFamousService: AppStrings.partyWearRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_5'),
        price: 89000,
        view: 3.8,
      ),
      PopularModel(
        id: 'popular_rent_6',
        title: AppStrings.weddingRentals,
        rating: 4.8,
        location: AppStrings.location21kmVesu,
        image: AppAssets.rent2,
        discount: AppStrings.discount25OffFull,
        bestFamousService: AppStrings.bridalWearRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_6'),
        price: 58900,
        view: 4.3,
      ),
    ];
  }
*/

  List<PopularModel> _getMockPopularItems() {
    return [
      // ==================== Parlour Items ====================
      PopularModel(
        id: 'popular_parlour_1',
        title: AppStrings.bhavinsBeautySalon,
        rating: 3.8,
        location: AppStrings.bhavinsBeautySalonAddress,
        image: AppAssets.bhavinsBeautySalon,
        discount: AppStrings.discount20Off,
        bestFamousService: AppStrings.trendyCuts,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_1'),
      ),
      PopularModel(
        id: 'popular_parlour_2',
        title: AppStrings.ashaBeautyStudio,
        rating: 4.5,
        location: AppStrings.ashaBeautyStudioAddress,
        image: AppAssets.ashaBeautyStudio,
        discount: AppStrings.discount50Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: false,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_2'),
      ),
      PopularModel(
        id: 'popular_parlour_3',
        title: AppStrings.cherHairAndBeautyLounge,
        rating: 3.8,
        location: AppStrings.cherHairAndBeautyLoungeAddress,
        image: AppAssets.cherHairAndBeautyLounge,
        discount: "",
        bestFamousService: AppStrings.facial,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_3'),
      ),
      PopularModel(
        id: 'popular_parlour_4',
        title: AppStrings.affinitiSalon,
        rating: 4.0,
        location: AppStrings.affinitiSalonAddress,
        image: AppAssets.affinitiSalon,
        discount: AppStrings.discount10Off,
        bestFamousService: AppStrings.makeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_4'),
      ),
      PopularModel(
        id: 'popular_parlour_5',
        title: AppStrings.looksSalon,
        rating: 4.8,
        location: AppStrings.looksSalonAddress,
        image: AppAssets.looksSalon,
        discount: AppStrings.discount25Off,
        bestFamousService: AppStrings.makeupHairStyle,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_5'),
      ),
      PopularModel(
        id: 'popular_parlour_6',
        title: AppStrings.enrichBeauty,
        rating: 4.8,
        location: AppStrings.enrichSalonAddress1,
        image: AppAssets.enrichSalon,
        discount: "",
        bestFamousService: AppStrings.makeupHairStyle,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_6'),
      ),
      PopularModel(
        id: 'popular_parlour_7',
        title: AppStrings.aOneHairAndBeautyStudio,
        rating: 4.5,
        location: AppStrings.aOneHairAndBeautyStudioAddress1,
        image: AppAssets.aOneHairAndBeautyStudio,
        discount: AppStrings.discount15Off,
        bestFamousService: AppStrings.homeService,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_7'),
      ),
      PopularModel(
        id: 'popular_parlour_8',
        title: AppStrings.nailedIttLuxurySalonAndAcademy,
        rating: 4.0,
        location: AppStrings.nailedIttLuxurySalonAndAcademyAddress,
        image: AppAssets.nailedIttLuxurySalonAndAcademy,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_8'),
      ),
      PopularModel(
        id: 'popular_parlour_9',
        title: AppStrings.ambellishSalon,
        rating: 4.0,
        location: AppStrings.ambellishSalonAddress,
        image: AppAssets.ambellishSalon,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_9'),
      ),
      PopularModel(
        id: 'popular_parlour_10',
        title: AppStrings.wasimsSalonHairBeauty,
        rating: 4.0,
        location: AppStrings.wasimsSalonHairBeautyAddress1,
        image: AppAssets.wasimsSalonHairBeauty,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_10'),
      ),
      PopularModel(
        id: 'popular_parlour_12',
        title: AppStrings.missGlamourBeautyParlour,
        rating: 4.0,
        location: AppStrings.missGlamourBeautyParlourAddress,
        image: AppAssets.missGlamourBeautyParlour,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_12'),
      ),

      // ==================== Boutique Items ====================
      PopularModel(
        id: 'popular_boutique_1',
        title: AppStrings.zivaBridal,
        rating: 3.8,
        location: AppStrings.sarthanaSurat,
        image: AppAssets.boutique1,
        discount: AppStrings.discount20Off,
        bestFamousService: AppStrings.bridalCollection,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_1'),
      ),
      PopularModel(
        id: 'popular_boutique_2',
        title: AppStrings.vrutiBoutique,
        rating: 4.8,
        location: AppStrings.motaVarachhaSurat,
        image: AppAssets.boutique2,
        discount: AppStrings.discount10Off,
        bestFamousService: AppStrings.formalWear,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_2'),
      ),
      PopularModel(
        id: 'popular_boutique_3',
        title: AppStrings.threadNeedle,
        rating: 4.6,
        location: AppStrings.location12kmAdajan,
        image: AppAssets.boutique3,
        discount: AppStrings.discount10OffFull,
        bestFamousService: AppStrings.customizableDesigns,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_3'),
      ),
      PopularModel(
        id: 'popular_boutique_4',
        title: AppStrings.royalStitches,
        rating: 4.5,
        location: AppStrings.location23kmVesu,
        image: AppAssets.boutique4,
        discount: AppStrings.discount12OffFull,
        bestFamousService: AppStrings.embroideryBridal,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_4'),
      ),
      PopularModel(
        id: 'popular_boutique_5',
        title: AppStrings.indoWearStudio,
        rating: 4.7,
        location: AppStrings.location27kmPal,
        image: AppAssets.boutique1,
        discount: AppStrings.discount18OffFull,
        bestFamousService: AppStrings.indoWesternSubtitle,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_5'),
      ),
      PopularModel(
        id: 'popular_boutique_6',
        title: AppStrings.fashionLoom,
        rating: 4.2,
        location: AppStrings.location35kmCityLight,
        image: AppAssets.boutique2,
        discount: AppStrings.discount8OffFull,
        bestFamousService: AppStrings.formalWear,
        service: AppStrings.homeService,
        isOpen: false,
        category: 'boutique',
        isFavorite: favoriteIds.contains('popular_boutique_6'),
      ),
      
      // ==================== Rent Items ====================
      PopularModel(
        id: 'popular_rent_1',
        title: AppStrings.rentFashion,
        rating: 4.9,
        location: AppStrings.location18kmAdajan,
        image: AppAssets.rent1,
        discount: AppStrings.discount30OffFull,
        bestFamousService: AppStrings.lehengaRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_1'),
        price: 70000,
        view: 3.4,
      ),
      PopularModel(
        id: 'popular_rent_2',
        title: AppStrings.bridalRentalsStudio,
        rating: 4.8,
        location: AppStrings.location25kmVesu,
        image: AppAssets.rent2,
        discount: AppStrings.discount22OffFull,
        bestFamousService: AppStrings.sareeRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_2'),
        price: 6000,
        view: 4.4,
      ),
      PopularModel(
        id: 'popular_rent_3',
        title: AppStrings.designerRentalsHub,
        rating: 4.7,
        location: AppStrings.location32kmVarachha,
        image: AppAssets.rent3,
        discount: AppStrings.discount28OffFull,
        bestFamousService: AppStrings.gownRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_3'),
        price: 70088,
        view: 5.4,
      ),
      PopularModel(
        id: 'popular_rent_4',
        title: AppStrings.partyWearRentals,
        rating: 4.6,
        location: AppStrings.location12kmKatargam,
        image: AppAssets.rent4,
        discount: AppStrings.discount35OffFull,
        bestFamousService: AppStrings.suitRental,
        service: AppStrings.homeService,
        isOpen: false,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_4'),
        price: 50000,
        view: 4.1,
      ),
      PopularModel(
        id: 'popular_rent_5',
        title: AppStrings.fashionRentals,
        rating: 4.5,
        location: AppStrings.location15kmAdajan,
        image: AppAssets.rent1,
        discount: AppStrings.discount20OffFull,
        bestFamousService: AppStrings.partyWearRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_5'),
        price: 89000,
        view: 3.8,
      ),
      PopularModel(
        id: 'popular_rent_6',
        title: AppStrings.weddingRentals,
        rating: 4.8,
        location: AppStrings.location21kmVesu,
        image: AppAssets.rent2,
        discount: AppStrings.discount25OffFull,
        bestFamousService: AppStrings.bridalWearRental,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'rent',
        isFavorite: favoriteIds.contains('popular_rent_6'),
        price: 58900,
        view: 4.3,
      ),
    ];
  }


  /// Logs statistics about loaded data for debugging
  void _logDataStats() {
    if (popularList.isEmpty) return;
    
    final parlourCount = popularList.where((item) => item.category == 'parlour').length;
    final boutiqueCount = popularList.where((item) => item.category == 'boutique').length;
    final rentCount = popularList.where((item) => item.category == 'rent').length;
    
    print('Popular data loaded: Total=${popularList.length}, '
        'Parlour=$parlourCount, Boutique=$boutiqueCount, Rent=$rentCount');
  }

  /// Notifies favorite controller if it's registered
  void _notifyFavoriteController() {
    try {
      if (Get.isRegistered<FavouriteController>()) {
        Get.find<FavouriteController>().loadFavourites();
      }
    } catch (e) {
      // FavouriteController might not be initialized yet
      print('FavouriteController not available: $e');
    }
  }

  // ==================== Public Methods ====================
  
  /// Fetches popular data from API
  ///
  /// TODO: Update endpoint URL when backend is ready
  Future<void> fetchPopularData() async {
    try {
      isLoading.value = true;

      final response = await _dio.get("/popular");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        popularList.value = data.map((e) => PopularModel.fromJson(e)).toList();
        _logDataStats();
      } else {
        print("${AppStrings.apiError}: ${response.statusCode}");
      }
    } catch (e) {
      print("${AppStrings.errorFetchingData}: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggles favorite status for an item at the given index
  ///
  /// Parameters:
  /// - [index]: Index of the item in popularList
  void toggleFavorite(int index) {
    if (index < 0 || index >= popularList.length) {
      print('Invalid index: $index');
      return;
    }

    final item = popularList[index];
    final itemId = item.id ?? '';

    if (itemId.isEmpty) {
      print('Item has no ID, cannot toggle favorite');
      return;
    }

    // Update favorite IDs set
    if (favoriteIds.contains(itemId)) {
      favoriteIds.remove(itemId);
    } else {
      favoriteIds.add(itemId);
    }

    // Update item in list
    popularList[index] = item.copyWith(
      isFavorite: favoriteIds.contains(itemId),
    );

    // Notify favorite controller
    _notifyFavoriteController();
  }

  /// Toggles favorite status for an item by its ID
  ///
  /// Useful when working with filtered lists
  /// Parameters:
  /// - [itemId]: Unique identifier of the item
  void toggleFavoriteById(String itemId) {
    final index = popularList.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      toggleFavorite(index);
    } else {
      print('Item not found with ID: $itemId');
    }
  }

  /// Returns filtered list of items by category
  ///
  /// Parameters:
  /// - [category]: Category to filter by ('parlour', 'boutique', or 'rent')
  ///
  /// Returns: List of PopularModel items matching the category
  List<PopularModel> getFilteredItemsByCategory(String category) {
    return popularList.where((item) => item.category == category).toList();
  }

  /// Returns display-friendly name for a category
  ///
  /// Parameters:
  /// - [category]: Category key ('parlour', 'boutique', or 'rent')
  ///
  /// Returns: Human-readable category name
  String getCategoryDisplayName(String category) {
    switch (category) {
      case 'parlour':
        return 'Parlour';
      case 'boutique':
        return 'Boutique';
      case 'rent':
        return 'Rent';
      default:
        return 'Parlour';
    }
  }

  /// Refreshes the data (reload from API or mock data)
  void refreshData() {
    // In production, this would call fetchPopularData()
    // For now, reload mock data
    _loadMockData();
  }
}