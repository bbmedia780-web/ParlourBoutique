import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../model/details_model.dart';
import '../model/popular_model.dart';
import '../model/unified_data_model.dart';
import '../routes/app_routes.dart';
import 'favourite_controller.dart';
import '../view/bottomsheet/branches_bottom_sheet.dart';
import '../view/bottomsheet/service_details_bottom_sheet.dart';
import '../model/booking_service_model.dart';
// GlobalFavoriteController removed

class DetailsController extends GetxController {


  // Observable variables
  final RxBool isFavorite = false.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxInt selectedGenderIndex = 0.obs; // 0 for Male, 1 for Female (for boutiques)
  final RxBool isBoutique = false.obs;
  final Rx<BusinessDetailsModel?> businessDetails = Rx<BusinessDetailsModel?>(
    null,
  );

  String? currentItemId;
  // Local favorite state for details
  final RxSet<String> favoriteIds = <String>{}.obs;
  // Service favorites - store service name + business ID combinations
  final RxSet<String> serviceFavoriteIds = <String>{}.obs;

  // Rent pricing state (UI reads these; logic stays here)
  final RxDouble rentCurrentPrice = 0.0.obs;
  final RxnDouble rentOldPrice = RxnDouble();
  final RxnString rentDiscountText = RxnString();
  final RxnString rentDescription = RxnString();

  // Category lists
  final List<String> parlourCategories = [
    AppStrings.hairCutting,
    AppStrings.facial,
    AppStrings.waxing,
    AppStrings.nailArt,
    AppStrings.makeup,
  ];

  final List<String> boutiqueGenderCategories = [
    AppStrings.male,
    AppStrings.female,
  ];

  final List<String> maleCategories = [
    AppStrings.formalWear,
    AppStrings.casualWear,
    AppStrings.traditional,
    AppStrings.weddingCollection,
  ];

  final List<String> femaleCategories = [
    AppStrings.bridalCollection,
    AppStrings.indoWesternTag,
    AppStrings.traditional,
    AppStrings.partyWear,
  ];

  // Service data maps
  final Map<String, List<ServiceCategoryModel>> parlourServicesByCategory = {
    AppStrings.hairCutting: [
      ServiceCategoryModel(
        name: AppStrings.stepCut,
        image: AppAssets.stepCut,
        price: '₹995',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.invertedBob,
        image: AppAssets.invertedBob,
        price: '₹957',
        discount: AppStrings.discount20Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.faceCut,
        image: AppAssets.faceCut,
        price: '₹6799',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.bluntBob,
        image: AppAssets.bluntBob,
        price: '₹899',
        discount: AppStrings.discount20Off,
      ),
    ],
    AppStrings.facial: [
      ServiceCategoryModel(
        name: AppStrings.classicFacial,
        image: AppAssets.beauty1,
        price: '₹799',
        discount: AppStrings.discount15Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.goldFacial,
        image: AppAssets.beauty2,
        price: '₹1299',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.diamondFacial,
        image: AppAssets.faceCut,
        price: '₹1999',
        discount: AppStrings.discount25Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.antiAgeingFacial,
        image: AppAssets.bluntBob,
        price: '₹1499',
        discount: null,
      ),
    ],
    AppStrings.waxing: [
      ServiceCategoryModel(
        name: AppStrings.fullArmsWaxing,
        image: AppAssets.stepCut,
        price: '₹399',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.fullLegsWaxing,
        image: AppAssets.invertedBob,
        price: '₹599',
        discount: AppStrings.discount10Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.bikiniWaxing,
        image: AppAssets.faceCut,
        price: '₹299',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.fullBodyWaxing,
        image: AppAssets.bluntBob,
        price: '₹1499',
        discount: AppStrings.discount20Off,
      ),
    ],
    AppStrings.nailArt: [
      ServiceCategoryModel(
        name: AppStrings.basicManicure,
        image: AppAssets.beauty1,
        price: '₹299',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.gelManicure,
        image: AppAssets.beauty2,
        price: '₹599',
        discount: AppStrings.discount15Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.nailArtDesign,
        image: AppAssets.faceCut,
        price: '₹799',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.acrylicNails,
        image: AppAssets.bluntBob,
        price: '₹949',
        discount: AppStrings.discount25Off,
      ),
    ],
    AppStrings.makeup: [
      ServiceCategoryModel(
        name: AppStrings.partyMakeup,
        image: AppAssets.stepCut,
        price: '₹1999',
        discount: AppStrings.discount20Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.bridalMakeup,
        image: AppAssets.invertedBob,
        price: '₹4999',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.engagementMakeup2,
        image: AppAssets.faceCut,
        price: '₹2999',
        discount: AppStrings.discount15Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.naturalMakeup,
        image: AppAssets.bluntBob,
        price: '₹1499',
        discount: null,
      ),
    ],
  };

  final Map<String, List<ServiceCategoryModel>> maleClothingByCategory = {
    AppStrings.formalWear: [
      ServiceCategoryModel(
        name: AppStrings.businessSuit,
        image: AppAssets.beauty1,
        price: '₹3999',
        discount: AppStrings.discount20Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.formalShirt,
        image: AppAssets.beauty2,
        price: '₹1499',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.formalTrousers,
        image: AppAssets.faceCut,
        price: '₹1999',
        discount: AppStrings.discount15Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.blazer,
        image: AppAssets.bluntBob,
        price: '₹2999',
        discount: null,
      ),
    ],
    AppStrings.casualWear: [
      ServiceCategoryModel(
        name: AppStrings.casualTShirt,
        image: AppAssets.stepCut,
        price: '₹799',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.denimJeans,
        image: AppAssets.invertedBob,
        price: '₹1499',
        discount: AppStrings.discount10Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.casualShirt,
        image: AppAssets.faceCut,
        price: '₹999',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.hoodie,
        image: AppAssets.bluntBob,
        price: '₹1299',
        discount: AppStrings.discount25Off,
      ),
    ],
    AppStrings.traditional: [
      ServiceCategoryModel(
        name: AppStrings.kurtaPajama,
        image: AppAssets.beauty1,
        price: '₹2499',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.dhotiKurta,
        image: AppAssets.beauty2,
        price: '₹1999',
        discount: AppStrings.discount15Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.pathaniSuit,
        image: AppAssets.faceCut,
        price: '₹2999',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.bandhgala,
        image: AppAssets.bluntBob,
        price: '₹3999',
        discount: AppStrings.discount20Off,
      ),
    ],
    AppStrings.weddingCollection: [
      ServiceCategoryModel(
        name: AppStrings.weddingSherwani,
        image: AppAssets.stepCut,
        price: '₹15999',
        discount: AppStrings.discount30Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.groomKurta,
        image: AppAssets.invertedBob,
        price: '₹8999',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.weddingSuit,
        image: AppAssets.faceCut,
        price: '₹12999',
        discount: AppStrings.discount25Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.royalSherwani,
        image: AppAssets.bluntBob,
        price: '₹19999',
        discount: null,
      ),
    ],
  };

  final Map<String, List<ServiceCategoryModel>> femaleClothingByCategory = {
    AppStrings.bridalCollection: [
      ServiceCategoryModel(
        name: AppStrings.bridalLehenga,
        image: AppAssets.beauty1,
        price: '₹25999',
        discount: AppStrings.discount40Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.bridalSaree,
        image: AppAssets.beauty2,
        price: '₹15999',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.bridalGown,
        image: AppAssets.faceCut,
        price: '₹19999',
        discount: AppStrings.discount30Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.bridalAnarkali,
        image: AppAssets.bluntBob,
        price: '₹12999',
        discount: null,
      ),
    ],
    AppStrings.indoWesternTag: [
      ServiceCategoryModel(
        name: AppStrings.indoWesternDress,
        image: AppAssets.stepCut,
        price: '₹3999',
        discount: AppStrings.discount20Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.fusionKurta,
        image: AppAssets.invertedBob,
        price: '₹2999',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.cropTopSkirt,
        image: AppAssets.faceCut,
        price: '₹2499',
        discount: AppStrings.discount15Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.palazzoSuit,
        image: AppAssets.bluntBob,
        price: '₹3499',
        discount: null,
      ),
    ],
    AppStrings.traditional: [
      ServiceCategoryModel(
        name: AppStrings.silkSaree,
        image: AppAssets.beauty1,
        price: '₹5999',
        discount: AppStrings.discount25Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.cottonSaree,
        image: AppAssets.beauty2,
        price: '₹2999',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.salwarKameez,
        image: AppAssets.faceCut,
        price: '₹3999',
        discount: AppStrings.discount20Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.anarkaliSuit,
        image: AppAssets.bluntBob,
        price: '₹4999',
        discount: null,
      ),
    ],
    AppStrings.partyWear: [
      ServiceCategoryModel(
        name: AppStrings.cocktailDress,
        image: AppAssets.stepCut,
        price: '₹4999',
        discount: AppStrings.discount30Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.eveningGown,
        image: AppAssets.invertedBob,
        price: '₹7999',
        discount: null,
      ),
      ServiceCategoryModel(
        name: AppStrings.partySaree,
        image: AppAssets.faceCut,
        price: '₹3999',
        discount: AppStrings.discount20Off,
      ),
      ServiceCategoryModel(
        name: AppStrings.designerKurta,
        image: AppAssets.bluntBob,
        price: '₹2999',
        discount: null,
      ),
    ],
  };

  // Rent category services data - prices match unified data model
  final Map<String, List<ServiceCategoryModel>> rentServicesByCategory = {
    AppStrings.lehengaRental: [
      ServiceCategoryModel(
        name: AppStrings.designerLehenga,
        image: AppAssets.rent1,
        price: '₹799',
        discount: AppStrings.discount30Off,
        description: AppStrings.designerLehengaDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.bridalLehenga,
        image: AppAssets.rent2,
        price: '₹1099',
        discount: AppStrings.discount25Off,
        description: AppStrings.bridalLehengaDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.partyLehenga,
        image: AppAssets.rent3,
        price: '₹999',
        discount: AppStrings.discount20Off,
        description: AppStrings.partyLehengaDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.festivalLehenga,
        image: AppAssets.rent4,
        price: '₹699',
        discount: null,
        description: AppStrings.festivalLehengaDesc,
      ),
    ],
    AppStrings.sareeRental: [
      ServiceCategoryModel(
        name: AppStrings.silkSaree,
        image: AppAssets.rent1,
        price: '₹799',
        discount: AppStrings.discount15Off,
        description: AppStrings.silkSareeDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.banarasiSaree,
        image: AppAssets.rent2,
        price: '₹1099',
        discount: AppStrings.discount20Off,
        description: AppStrings.banarasiSareeDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.georgetteSaree,
        image: AppAssets.rent3,
        price: '₹999',
        discount: null,
        description: AppStrings.georgetteSareeDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.chiffonSaree,
        image: AppAssets.rent4,
        price: '₹699',
        discount: AppStrings.discount10Off,
        description: AppStrings.chiffonSareeDesc,
      ),
    ],
    AppStrings.gownRental: [
      ServiceCategoryModel(
        name: AppStrings.eveningGown,
        image: AppAssets.rent1,
        price: '₹799',
        discount: AppStrings.discount25Off,
        description: AppStrings.eveningGownDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.cocktailDress,
        image: AppAssets.rent2,
        price: '₹1099',
        discount: AppStrings.discount20Off,
        description: AppStrings.cocktailDressDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.promDress,
        image: AppAssets.rent3,
        price: '₹999',
        discount: null,
        description: AppStrings.promDressDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.weddingGown,
        image: AppAssets.rent4,
        price: '₹699',
        discount: AppStrings.discount30Off,
        description: AppStrings.weddingGownDesc,
      ),
    ],
    AppStrings.suitRental: [
      ServiceCategoryModel(
        name: AppStrings.formalSuit,
        image: AppAssets.rent1,
        price: '₹799',
        discount: AppStrings.discount15Off,
        description: AppStrings.formalSuitDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.tuxedo,
        image: AppAssets.rent2,
        price: '₹1099',
        discount: AppStrings.discount20Off,
        description: AppStrings.tuxedoDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.weddingSuit,
        image: AppAssets.rent3,
        price: '₹999',
        discount: null,
        description: AppStrings.weddingSuitDesc,
      ),
      ServiceCategoryModel(
        name: AppStrings.businessSuit,
        image: AppAssets.rent4,
        price: '₹699',
        discount: AppStrings.discount10Off,
        description: AppStrings.businessSuitDesc,
      ),
    ],
  };

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }


  void initializeData() {
    try {
      final dynamic arguments = Get.arguments;
      print('DEBUG: DetailsController initializeData called with arguments: $arguments');
      
      if (arguments is UnifiedDataModel) {
        print('DEBUG: Processing UnifiedDataModel');
        final salonData = arguments;
        currentItemId = salonData.id;
        isBoutique.value = salonData.type == AppStrings.boutiqueType;
        isFavorite.value = favoriteIds.contains(currentItemId ?? '');

        // Create business details model from UnifiedDataModel
        businessDetails.value = _createBusinessDetailsModelFromUnified(salonData);
        _computeRentPricing(arguments, businessDetails.value);
        print('DEBUG: Business details set successfully for UnifiedDataModel');
      } else if (arguments is PopularModel) {
        print('DEBUG: Processing PopularModel');
        final salonData = arguments;
        currentItemId = salonData.id;
        isBoutique.value = salonData.category == AppStrings.boutiqueType;
        isFavorite.value = favoriteIds.contains(currentItemId ?? '');

        // Create business details model
        businessDetails.value = _createBusinessDetailsModel(salonData);
        _computeRentPricing(arguments, businessDetails.value);
        print('DEBUG: Business details set successfully for PopularModel');
      } else {
        print('DEBUG: Invalid arguments type: ${arguments.runtimeType}');
        // Handle invalid arguments gracefully
        businessDetails.value = null;
      }
    } catch (e) {
      print('DEBUG: Error in initializeData: $e');
      businessDetails.value = null;
    }
  }

  void _computeRentPricing(dynamic args, BusinessDetailsModel? details) {
    // Only applicable for rent category UI; keep logic out of the view
    if (details == null) return;
    if (details.category != AppStrings.rentType) return;

    double currentPrice = 0;
    double? oldPrice;
    String? discountText;
    String? description;

    if (args is UnifiedDataModel) {
      currentPrice = args.price ?? 0;
      oldPrice = args.oldPrice;
      discountText = args.offerText;
      description = args.description;
    } else if (args is Map) {
      final map = args;
      currentPrice = (map['price'] as double?) ?? 0;
      oldPrice = map['oldPrice'] as double?;
      discountText = map['offerText'] as String?;
      description = map['description'] as String?;
    } else if (args is PopularModel) {
      // Use rent-specific fields from PopularModel when available
      if (args.price != null) {
        currentPrice = args.price!.toDouble();
      }
      // Try to derive discount text from PopularModel.discount if present
      if ((discountText == null || discountText.isEmpty) && args.discount.isNotEmpty) {
        discountText = args.discount;
      }
      // No explicit old price in PopularModel; compute from discount if possible
      if (discountText != null && currentPrice > 0) {
        final m = RegExp(r'(\d+)%').firstMatch(discountText);
        if (m != null) {
          final pct = double.tryParse(m.group(1)!) ?? 0;
          if (pct > 0 && pct < 90) {
            oldPrice = currentPrice / (1 - pct / 100.0);
          }
        }
      }
    }

    if (currentPrice == 0 || discountText == null) {
      final promo = details.promotions.isNotEmpty ? details.promotions.first : null;
      if (promo != null) {
        final priceNum = promo.price;
        currentPrice = priceNum.toDouble();
        discountText = discountText ?? promo.discount;
        if (oldPrice == null && currentPrice > 0) {
          final m = RegExp(r'(\d+)%').firstMatch(discountText);
          if (m != null) {
            final pct = double.tryParse(m.group(1)!) ?? 0;
            if (pct > 0 && pct < 90) {
              oldPrice = currentPrice / (1 - pct / 100.0);
            }
          }
        }
      }
    }

    rentCurrentPrice.value = currentPrice;
    rentOldPrice.value = oldPrice;
    rentDiscountText.value = discountText;
    rentDescription.value = description ?? details.description;
  }

  BusinessDetailsModel _createBusinessDetailsModelFromUnified(UnifiedDataModel salonData) {
    final servicesByCategory = isBoutique.value
        ? (selectedGenderIndex.value == 0
              ? maleClothingByCategory
              : femaleClothingByCategory)
        : (salonData.type == AppStrings.rentType
            ? rentServicesByCategory
            : parlourServicesByCategory);

    final promotions = [
      PromotionModel(
        discount: AppStrings.discount10Off,
        title: salonData.title,
        service: isBoutique.value
            ? AppStrings.bridalCollection
            : AppStrings.trendyCuts,
        price: isBoutique.value
            ? AppStrings.boutiquePrice1
            : AppStrings.parlourPrice1,
      ),
      PromotionModel(
        discount: AppStrings.discount10Off,
        title: isBoutique.value
            ? AppStrings.rangrezBoutiqueName
            : AppStrings.rasmiBeauty,
        service: isBoutique.value
            ? AppStrings.formalWear
            : AppStrings.bridalMakeup,
        price: isBoutique.value
            ? AppStrings.boutiquePrice2
            : AppStrings.parlourPrice2,
      ),
    ];

    return BusinessDetailsModel(
      id: salonData.id ?? '',
      title: salonData.title,
      service: salonData.subtitle,
      bestFamousService: salonData.subtitle,
      location: salonData.location,
      image: salonData.image,
      rating: double.tryParse(salonData.rating.replaceAll('★', '').trim()) ?? 0.0,
      isOpen: salonData.isOpen,
      isFavorite: salonData.isFavorite,
      category: salonData.type,
      description: isBoutique.value
          ? AppStrings.boutiqueDescription(salonData.title)
          : AppStrings.parlourDescription(salonData.title),
      promotions: promotions,
      servicesByCategory: servicesByCategory,
    );
  }

  BusinessDetailsModel _createBusinessDetailsModel(PopularModel salonData) {
    final servicesByCategory = isBoutique.value
        ? (selectedGenderIndex.value == 0
              ? maleClothingByCategory
              : femaleClothingByCategory)
        : (salonData.category == AppStrings.rentType
            ? rentServicesByCategory
            : parlourServicesByCategory);

    final promotions = [
      PromotionModel(
        discount: AppStrings.discount10Off,
        title: salonData.title,
        service: isBoutique.value
            ? AppStrings.bridalCollection
            : AppStrings.trendyCuts,
        price:isBoutique.value
            ? AppStrings.boutiquePrice1     // boutique price
            : AppStrings.parlourPrice1,
      ),
      PromotionModel(
        discount: AppStrings.discount10Off,
        title: isBoutique.value
            ? AppStrings.rangrezBoutiqueName
            : AppStrings.rasmiBeauty,
        service: isBoutique.value
            ? AppStrings.formalWear
            : AppStrings.bridalMakeup,
        price: isBoutique.value
            ? AppStrings.boutiquePrice2       // boutique price
            : AppStrings.parlourPrice2,

      ),
    ];

    return BusinessDetailsModel(
      id: salonData.id ?? '',
      title: salonData.title,
      service: salonData.service,
      bestFamousService: salonData.bestFamousService,
      location: salonData.location,
      image: salonData.image,
      rating: salonData.rating,
      isOpen: salonData.isOpen,
      isFavorite: salonData.isFavorite,
      category: salonData.category,
      description: isBoutique.value
          ? AppStrings.boutiqueDescription(salonData.title)
          : AppStrings.parlourDescription(salonData.title),
      promotions: promotions,
      servicesByCategory: servicesByCategory,
    );
  }

  // Helper method to get current items based on selected category
  List<ServiceCategoryModel> getCurrentItems() {
    if (isBoutique.value) {
      final genderCategories = selectedGenderIndex.value == 0
          ? maleCategories
          : femaleCategories;
      final selectedCategory = genderCategories[selectedCategoryIndex.value];

      if (selectedGenderIndex.value == 0) {
        return maleClothingByCategory[selectedCategory] ?? [];
      } else {
        return femaleClothingByCategory[selectedCategory] ?? [];
      }
    } else {
      final selectedCategory = parlourCategories[selectedCategoryIndex.value];
      final services = parlourServicesByCategory[selectedCategory] ?? [];
      print('DEBUG: Selected category: $selectedCategory, Services count: ${services.length}');
      return services;
    }
  }

  // Get current categories based on business type and gender
  List<String> getCurrentCategories() {
    if (isBoutique.value) {
      return selectedGenderIndex.value == 0 ? maleCategories : femaleCategories;
    } else {
      return parlourCategories;
    }
  }

  // Action methods
  void onBackPressed() {
    Get.back();
  }

  void onSharePressed() {
    // TODO: Implement share functionality
  }

  void onRentNowPressed() {
    final details = businessDetails.value;
    if (details == null) return;

    // Only proceed for rent category
    if (details.category != AppStrings.rentType) return;

    // Use computed rent fields if available; otherwise fall back to 0
    final double price = rentCurrentPrice.value;

    final BookingServiceModel bookingService = BookingServiceModel(
      image: details.image,
      title: details.title,
      subtitle: rentDescription.value ?? details.description,
      address: details.location,
      price: price,
      type: AppStrings.rentType,
    );

    Get.toNamed(AppRoutes.unifiedBooking, arguments: {'service': bookingService});
  }

  void onFavoritePressed() {
    if (currentItemId != null) {
      if (favoriteIds.contains(currentItemId!)) {
        favoriteIds.remove(currentItemId!);
      } else {
        favoriteIds.add(currentItemId!);
      }

      isFavorite.value = favoriteIds.contains(currentItemId!);

      if (businessDetails.value != null) {
        businessDetails.value = businessDetails.value!.copyWith(
          isFavorite: isFavorite.value,
        );
      }
      
      // Notify favourite controller to refresh
      try {
        final favouriteController = Get.find<FavouriteController>();
        favouriteController.loadFavourites();
      } catch (e) {
        // FavouriteController might not be initialized yet
      }
    }
  }

  void onGenderCategorySelected(int index) {
    selectedGenderIndex.value = index;
    selectedCategoryIndex.value = 0; // Reset category selection
  }

  void onServiceCategorySelected(int index) {
    selectedCategoryIndex.value = index;
    // Force UI update when category is selected
    update();
  }

  void onServiceItemPressed(ServiceCategoryModel service) {
    final details = businessDetails.value;
    if (details == null) return;

    // Create reactive favorite state for this service
    final serviceFavoriteId = '${service.name}_${details.id}';
    final favoriteState = RxBool(serviceFavoriteIds.contains(serviceFavoriteId));

    Get.bottomSheet(
      ServiceDetailsBottomSheet(
        service: service,
        businessName: details.title,
        businessLocation: details.location,
        businessCategory: details.category,
        businessRating: details.rating,
        reviewsCount: 90,
        onBookNow: () => _handleBookNow(service),
        onFavorite: () => _handleServiceFavoriteAndRefresh(service, favoriteState),
        onShare: () => _handleServiceShare(service),
        isFavorite: _isServiceFavorite(service),
        favoriteState: favoriteState,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _handleBookNow(ServiceCategoryModel service) {
    Get.back();
    final details = businessDetails.value;
    
    // Determine the correct category type based on the business details
    String type = AppStrings.parlourType; // default
    if (details != null) {
      if (details.category == AppStrings.rentType) {
        type = AppStrings.rentType;
      } else if (details.category == AppStrings.boutiqueType) {
        type = AppStrings.boutiqueType;
      } else {
        type = AppStrings.parlourType;
      }
    }
    
    final String priceString = service.price;
    final String sanitized = priceString.replaceAll(RegExp(r'[^0-9\.]'), '');
    final double price = double.tryParse(sanitized) ?? 0.0;

    final BookingServiceModel bookingService = BookingServiceModel(
      image: service.image,
      title: service.name,
      subtitle: details?.description ?? AppStrings.getProfessionalServiceDescription(service.name.toLowerCase()),
      address: details?.location,
      price: price,
      type: type,
    );

    Get.toNamed(AppRoutes.unifiedBooking, arguments: {'service': bookingService});
  }

  void _handleServiceFavorite(ServiceCategoryModel service) {
    final details = businessDetails.value;
    if (details == null) return;

    // Create unique service favorite ID (service name + business ID)
    final serviceFavoriteId = '${service.name}_${details.id}';

    if (serviceFavoriteIds.contains(serviceFavoriteId)) {
      // Remove from favorites
      serviceFavoriteIds.remove(serviceFavoriteId);
    } else {
      // Add to favorites
      serviceFavoriteIds.add(serviceFavoriteId);
    }

    // Notify favourite controller to refresh
    try {
      final favouriteController = Get.find<FavouriteController>();
      favouriteController.loadFavourites();
    } catch (e) {
      // FavouriteController might not be initialized yet
    }
  }

  void _handleServiceFavoriteAndRefresh(ServiceCategoryModel service, RxBool favoriteState) {
    // Toggle favorite state
    _handleServiceFavorite(service);
    
    // Update the reactive favorite state to trigger UI rebuild
    final details = businessDetails.value;
    if (details != null) {
      final serviceFavoriteId = '${service.name}_${details.id}';
      favoriteState.value = serviceFavoriteIds.contains(serviceFavoriteId);
    }
  }

  void _handleServiceShare(ServiceCategoryModel service) {
    // TODO: Handle service share logic
  }

  bool _isServiceFavorite(ServiceCategoryModel service) {
    final details = businessDetails.value;
    if (details == null) return false;

    // Check if service is in favorites using service name + business ID
    final serviceFavoriteId = '${service.name}_${details.id}';
    return serviceFavoriteIds.contains(serviceFavoriteId);
  }

  void onPromotionPressed(PromotionModel promotion) {
    // TODO: Navigate to promotion details
  }

  // Check if current business is rent category
  bool get isRentCategory {
    final details = businessDetails.value;
    return details?.category == AppStrings.rentType;
  }

  void onTitleTapped() {
    final details = businessDetails.value;
    if (details == null) return;

    final List<BranchModel> branches = details.branches ?? [
      BranchModel(
        id: '${details.id}-1',
        name: '${details.title} - ${AppStrings.mainBranch}',
        address: details.location,
        distance: AppStrings.oneKmSarthanaSurat,
        rating: 4.5,
      ),
      BranchModel(
        id: '${details.id}-2',
        name: '${details.title} - ${AppStrings.cityCenterBranch}',
        address: AppStrings.cityCenterSurat,
        distance: AppStrings.twoKmMottaVarachhaSurat,
        rating: 5.5,
      ),
    ];

    Get.bottomSheet(
      BranchesBottomSheet(
        branches: branches,
        title: '${details.title} ${AppStrings.branchSuffix}',
      ),
      isScrollControlled: true,
    );
  }
}


