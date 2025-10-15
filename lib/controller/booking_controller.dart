import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../model/booking_service_model.dart';
import '../utility/navigation_helper.dart';

class BookingController extends GetxController with GetSingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  final RxInt selectedServiceIndex = 0.obs;
  late TabController tabController;
  
  // Track booked service IDs
  final RxList<String> bookedServiceIds = <String>[].obs;
  
  // Booking services data
  final RxList<BookingServiceModel> bookingServices = <BookingServiceModel>[
    BookingServiceModel(
      id: 'parlour_1',
      image: AppAssets.parlour1,
      title: AppStrings.kanyaKaya,
      subtitle: AppStrings.hairCuttingHomeService,
      price: 12.00,
      address: AppStrings.meeraBeautyAdd,
      type: AppStrings.parlourType,
    ),
    BookingServiceModel(
      id: 'parlour_2',
      image: AppAssets.parlour2,
      title: AppStrings.auraShineBeauty,
      subtitle: AppStrings.engagementMakeup,
      price: 12.00,
      address:AppStrings.theBeautyRoomAdd,
      type: AppStrings.parlourType,
    ),
    /*BookingServiceModel(
      image: AppAssets.boutique1,
      title: AppStrings.zivaBridal,
      subtitle: AppStrings.westernWear,
      price: 1235.00,
      address: AppStrings.meeraBeautyAdd,
      type: AppStrings.boutiqueType,
    ),
    BookingServiceModel(
      image: AppAssets.boutique2,
      title: AppStrings.vrutiBoutique,
      subtitle: AppStrings.weddingSherwani,
      price: 145.00,
      address:AppStrings.theBeautyRoomAdd,
      type: AppStrings.boutiqueType,
    ),*/
    BookingServiceModel(
      id: 'rent_1',
      image: AppAssets.rent1,
      title: AppStrings.fashionRentals,
      subtitle: AppStrings.lehengaRental,
      price: 2500.00,
      address: AppStrings.meeraBeautyAdd,
      type: AppStrings.rentType,
    ),
    BookingServiceModel(
      id: 'rent_2',
      image: AppAssets.rent2,
      title: AppStrings.bridalRentals,
      subtitle: AppStrings.sareeRental,
      price: 3500.00,
      address: AppStrings.theBeautyRoomAdd,
      type: AppStrings.rentType,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Disabled Boutique for Phase 1 -> reduce tabs to 3 (All, Parlour, Rent)
    tabController = TabController(length: 3, vsync: this);
    _loadBookedServices();
  }
  
  /// Load booked services from shared preferences
  Future<void> _loadBookedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final bookedIds = prefs.getStringList('booked_service_ids') ?? [];
    bookedServiceIds.addAll(bookedIds);
  }
  
  /// Check if a service is booked
  bool isServiceBooked(String serviceId) {
    return bookedServiceIds.contains(serviceId);
  }
  
  /// Mark a service as booked
  Future<void> markServiceAsBooked(String serviceId) async {
    if (!bookedServiceIds.contains(serviceId)) {
      bookedServiceIds.add(serviceId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('booked_service_ids', bookedServiceIds);
    }
  }

  void onBackTap() {
    Get.back();
  }

  void onSearchTap() {
    // Add search functionality
  }

  void onServiceTap(BookingServiceModel service) {
    // Navigate to service detail or booking flow
  }

  void onBookNowTap(BookingServiceModel service) {
    // Navigate to unified booking screen with auth check
    NavigationHelper.navigateToUnifiedBooking(service);
  }

  void onLearnMoreTap() {
    // Handle learn more button tap for sponsored ad
  }

  void onInfoTap() {
    // Handle info button tap for sponsored ad
  }

  void onShareTap() {
    // Handle share button tap for sponsored ad - COMMENTED OUT
  }

  @override
  void onClose() {
    searchController.dispose();
    tabController.dispose();
    super.onClose();
  }

  List<BookingServiceModel> get allServices => bookingServices;
  List<BookingServiceModel> get parlourServices =>
      bookingServices.where((s) => s.type == AppStrings.parlourType).toList();
  List<BookingServiceModel> get boutiqueServices =>
      bookingServices.where((s) => s.type == AppStrings.boutiqueType).toList();
  List<BookingServiceModel> get rentServices =>
      bookingServices.where((s) => s.type == AppStrings.rentType).toList();
}
