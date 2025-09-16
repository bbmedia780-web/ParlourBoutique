import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing video effects and filters
class EffectController extends GetxController {
  // Available effects
  static const List<String> availableEffects = [
    'None',
    'Vintage',
    'Vibrant',
    'Flash',
    'SlowMo',
  ];

  // User selections
  final RxString selectedEffect = 'None'.obs;

  /// Choose an effect
  void chooseEffect(String effect) {
    selectedEffect.value = effect;
  }

  /// Get the color filter for the current effect
  ColorFilter? get currentColorFilter {
    switch (selectedEffect.value) {
      case 'Vintage':
        return const ColorFilter.matrix([
          0.9, 0.2, 0.1, 0, 0,
          0.0, 0.9, 0.1, 0, 0,
          0.0, 0.2, 0.8, 0, 0,
          0,   0,   0,   1, 0,
        ]);
      case 'Vibrant':
        return const ColorFilter.matrix([
          1.2, 0,   0,   0, 0,
          0,   1.2, 0,   0, 0,
          0,   0,   1.2, 0, 0,
          0,   0,   0,   1, 0,
        ]);
      case 'Flash':
        return const ColorFilter.matrix([
          1.5, 0,   0,   0, 20,
          0,   1.5, 0,   0, 20,
          0,   0,   1.5, 0, 20,
          0,   0,   0,   1, 0,
        ]);
      default:
        return null;
    }
  }

  /// Reset to no effect
  void resetEffect() {
    selectedEffect.value = 'None';
  }
}
