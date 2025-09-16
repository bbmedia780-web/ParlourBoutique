import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import '../model/booking_service_model.dart';
import '../routes/app_routes.dart';

class BookingController extends GetxController with GetSingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  final RxInt selectedServiceIndex = 0.obs;
  late TabController tabController;
  
  // Booking services data
  final RxList<BookingServiceModel> bookingServices = <BookingServiceModel>[
    BookingServiceModel(
      image: AppAssets.parlour1,
      title: AppStrings.kanyaKaya,
      subtitle: AppStrings.hairCuttingHomeService,
      price: 12.00,
      address: AppStrings.meeraBeautyAdd,
      type: AppStrings.parlourType,
    ),
    BookingServiceModel(
      image: AppAssets.parlour2,
      title: AppStrings.auraShineBeauty,
      subtitle: AppStrings.engagementMakeup,
      price: 12.00,
      address:AppStrings.theBeautyRoomAdd,
      type: AppStrings.parlourType,
    ),
    BookingServiceModel(
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
    ),
    BookingServiceModel(
      image: AppAssets.rent1,
      title: AppStrings.fashionRentals,
      subtitle: AppStrings.lehengaRental,
      price: 2500.00,
      address: AppStrings.meeraBeautyAdd,
      type: AppStrings.rentType,
    ),
    BookingServiceModel(
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
    tabController = TabController(length: 4, vsync: this);
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
    // Navigate to unified booking screen
    Get.toNamed(AppRoutes.unifiedBooking, arguments: service);
  }

  void onLearnMoreTap() {
    // Handle learn more button tap for sponsored ad
  }

  void onInfoTap() {
    // Handle info button tap for sponsored ad
  }

  void onShareTap() {
    // Handle share button tap for sponsored ad
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
