import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../model/popular_model.dart';
import 'favourite_controller.dart';

class PopularController extends GetxController {
  final RxList<PopularModel> popularList = <PopularModel>[].obs;
  final RxBool isLoading = false.obs;
  final Dio _dio = Dio();

  // Maintain favorites locally for popular items
  final RxSet<String> favoriteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Load data immediately instead of with delay
    _loadPopularDataImmediately();
  }

  /// 🔹 Load Popular Data Immediately (for debugging)
  void _loadPopularDataImmediately() {
    print('Loading popular data immediately...');
    popularList.value = [
      PopularModel(
        id: 'popular_parlour_1',
        title: AppStrings.meenaBeauty,
        rating: 3.8,
        location: AppStrings.sarthanaSurat,
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
        title: AppStrings.raaniBeauty,
        rating: 4.5,
        location: AppStrings.motaVarachhaSurat,
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
        title: AppStrings.veeraBeauty,
        rating: 3.8,
        location: AppStrings.yogiChowkSurat,
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
        title: AppStrings.siyaMakeover,
        rating: 4.0,
        location: AppStrings.shyamdhamChowkSurat,
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
        title: AppStrings.b4uBridalAcademy,
        rating: 4.8,
        location: AppStrings.nanaVarachhaSurat,
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
        title: AppStrings.kajalMakeover,
        rating: 4.8,
        location: AppStrings.sarthanaSurat,
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
        title: AppStrings.priyaBeauty,
        rating: 4.5,
        location: AppStrings.adajanSurat,
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
        title: AppStrings.anjaliBeauty,
        rating: 4.0,
        location: AppStrings.vesuSurat,
        image: AppAssets.parlour4,
        discount: AppStrings.discount35Off,
        bestFamousService: AppStrings.bridalMakeup,
        service: AppStrings.homeService,
        isOpen: true,
        category: 'parlour',
        isFavorite: favoriteIds.contains('popular_parlour_8'),
      ),
      // Boutique items
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
      // Rent items
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
    print(
      'Popular data loaded immediately. Total items: ${popularList.length}',
    );
    print(
      'Parlour items: ${popularList.where((item) => item.category == 'parlour').length}',
    );
    print(
      'Boutique items: ${popularList.where((item) => item.category == 'boutique').length}',
    );
    print(
      'Rent items: ${popularList.where((item) => item.category == 'rent').length}',
    );
  }

  /// 🔹 Load Popular Data (with delay)
  void loadPopularData() {
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      print('Loading popular data...');
      popularList.value = [
        PopularModel(
          id: 'popular_parlour_1',
          title: AppStrings.meenaBeauty,
          rating: 3.8,
          location: AppStrings.sarthanaSurat,
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
          title: AppStrings.raaniBeauty,
          rating: 4.5,
          location: AppStrings.motaVarachhaSurat,
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
          title: AppStrings.veeraBeauty,
          rating: 3.8,
          location: AppStrings.yogiChowkSurat,
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
          title: AppStrings.siyaMakeover,
          rating: 4.0,
          location: AppStrings.shyamdhamChowkSurat,
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
          title: AppStrings.b4uBridalAcademy,
          rating: 4.8,
          location: AppStrings.nanaVarachhaSurat,
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
          title: AppStrings.kajalMakeover,
          rating: 4.8,
          location: AppStrings.sarthanaSurat,
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
          title: AppStrings.priyaBeauty,
          rating: 4.5,
          location: AppStrings.adajanSurat,
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
          title: AppStrings.anjaliBeauty,
          rating: 4.0,
          location: AppStrings.vesuSurat,
          image: AppAssets.parlour4,
          discount: AppStrings.discount35Off,
          bestFamousService: AppStrings.bridalMakeup,
          service: AppStrings.homeService,
          isOpen: true,
          category: 'parlour',
          isFavorite: favoriteIds.contains('popular_parlour_8'),
        ),
        // Boutique items
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
        // Rent items
        PopularModel(
          id: 'popular_rent_1',
          title: AppStrings.rentFashion,
          rating: 4.9,
          location: AppStrings.location18kmAdajan,
          image: AppAssets.rent1,
          discount: AppStrings.discount30OffFull,
          bestFamousService: AppStrings.lehengaRental,
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
          isOpen: true,
          category: 'rent',
          isFavorite: favoriteIds.contains('popular_rent_6'),
          price: 58900,
          view: 4.3,
        ),
      ];
      print('Popular data loaded. Total items: ${popularList.length}');
      print(
        'Parlour items: ${popularList.where((item) => item.category == 'parlour').length}',
      );
      print(
        'Boutique items: ${popularList.where((item) => item.category == 'boutique').length}',
      );
      print(
        'Rent items: ${popularList.where((item) => item.category == 'rent').length}',
      );
    });
  }

  /// 🔹 API Call (Dio)
  Future<void> fetchPopularData() async {
    try {
      isLoading.value = true;

      final response = await _dio.get("/popular"); // ✅ example endpoint

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        popularList.value = data.map((e) => PopularModel.fromJson(e)).toList();
      } else {
        print("${AppStrings.apiError}: ${response.statusCode}");
      }
    } catch (e) {
      print("${AppStrings.errorFetchingData}: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Toggle Favorite
  void toggleFavorite(int index) {
    final item = popularList[index];
    final itemId = item.id ?? '';

    if (favoriteIds.contains(itemId)) {
      favoriteIds.remove(itemId);
    } else {
      favoriteIds.add(itemId);
    }

    popularList[index] = popularList[index].copyWith(
      isFavorite: favoriteIds.contains(itemId),
    );

    // Notify favourite controller to refresh
    try {
      final favouriteController = Get.find<FavouriteController>();
      favouriteController.loadFavourites();
    } catch (e) {
      // FavouriteController might not be initialized yet
    }
  }

  /// 🔹 Toggle Favorite by Item ID (for filtered lists)
  void toggleFavoriteById(String itemId) {
    final index = popularList.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      toggleFavorite(index);
    }
  }

  // Get filtered items by category
  List<PopularModel> getFilteredItemsByCategory(String category) {
    return popularList.where((item) => item.category == category).toList();
  }

  // Get category display name
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
}
