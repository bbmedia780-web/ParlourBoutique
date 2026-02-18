import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:parlour_app/controller/create_reels_controller.dart';
import 'package:parlour_app/utility/global.dart';
import 'package:parlour_app/view/screen/add_rent_product_screen.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../view/screen/reels/create_reels/screens/create_reels_screen.dart';
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
    print('++++++++++=>>> index ${index}');
    if (Get.isRegistered<ReelsController>()) {
      Get.find<ReelsController>()
          .updateActivation(index == 3); // 2 = reels tab
    }
  }

  /// Handle Add (+) button tap
  void onAddButtonTapped() async{
    final HomeController homeController = Get.find<HomeController>();
    final int topTab = homeController.selectedTopTabIndex.value;
    if (Get.isRegistered<ReelsController>()) {
      Get.find<ReelsController>().updateActivation(false);
    }

    await Future.delayed(const Duration(milliseconds: 100));

    if (topTab == 2) {
      // Rent tab
      Get.to(() =>  AddRentProductScreen());

    } else {
      Get.to(() => const CreateReelsScreen());
    }
  }
}
