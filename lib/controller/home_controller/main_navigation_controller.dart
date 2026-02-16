import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:parlour_app/utility/global.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../view/screen/reels/reels_controller.dart';
import 'home_controller.dart';

class MainNavigationController extends GetxController {
  // -------------------- State --------------------
  final RxInt selectedBottomBarIndex = 0.obs;

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxString currentAddress = "".obs;

  // -------------------- Lifecycle --------------------
  @override
  void onInit() {
    super.onInit();
    _setReelsActive(false);
    _handleLocationPermission();
  }

  // -------------------- Location Handling --------------------
  /// Request and handle location permissions
  Future<void> _handleLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ShowSnackBar.show(AppStrings.error, AppStrings.locationService);
      return;
    }

    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        await Geolocator.openAppSettings();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }

    // Listen for location updates
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update after moving 10 meters
      ),
    ).listen((Position position) async {
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      await _updateAddressFromCoordinates(position);
    });
  }

  /// Convert coordinates into a human-readable address
  Future<void> _updateAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String fullAddress =
            "${place.name}, ${place.street}, ${place.locality}, ${place.subLocality}, "
            "${place.administrativeArea}, ${place.postalCode}, ${place.country}";

        currentAddress.value = fullAddress;
        print("Current Address: $fullAddress");
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
  }

  // -------------------- Navigation --------------------
  /// Handle bottom navigation bar taps
  void onBottomNavItemTapped(int index) {
    selectedBottomBarIndex.value = index;
    _setReelsActive(index == 3); // Reels tab at index 3
  }

  /// Handle Add (+) button tap
  void onAddButtonTapped() {
    final HomeController homeController = Get.find<HomeController>();
    final int topTab = homeController.selectedTopTabIndex.value;

    if (topTab == 2) {
      // Rent tab
      Get.toNamed(AppRoutes.addRentProduct);
    } else {
      // Parlour or Boutique tab
      Get.toNamed(AppRoutes.createReels);
    }
  }

  // -------------------- Reels Handling --------------------
  /// Activate or deactivate Reels tab
  void _setReelsActive(bool isActive) {
    if (Get.isRegistered<ReelsController>()) {
      final ReelsController reelsController = Get.find<ReelsController>();
      // reelsController.setActiveTab(isActive);
    }
  }
}
