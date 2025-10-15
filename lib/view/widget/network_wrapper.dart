import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/network_controller.dart';
import '../screen/no_internet_screen.dart';

/// Widget that wraps the app content and shows no internet screen when connectivity is lost
class NetworkWrapper extends StatelessWidget {
  final Widget child;
  
  const NetworkWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final NetworkController networkController = Get.find<NetworkController>();

    return Obx(() {
      // Show no internet screen if not connected
      if (!networkController.isConnectedObs.value) {
        return const NoInternetScreen();
      }
      
      // Show normal app content if connected
      return child;
    });
  }
}
