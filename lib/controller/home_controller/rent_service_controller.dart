import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_strings.dart';
import '../../model/unified_data_model.dart';

/// Controller to manage locally saved rent products
/// Follows the same architecture pattern as UnifiedServiceDataController
class RentServiceController extends GetxController {
  // -------------------- STATE --------------------
  final RxList<UnifiedDataModel> savedProducts = <UnifiedDataModel>[].obs;
  static const String _prefsKey = 'saved_rent_products';
  static const String _imageDirName = 'rent_product_images';

  // -------------------- LIFECYCLE --------------------
  @override
  void onInit() {
    super.onInit();
    loadSavedProducts();
  }

  // ==================== SAVE PRODUCT ====================

  /// Save a new rent product to local storage
  /// Returns true if successful, false otherwise
  Future<bool> saveProduct({
    required String productName,
    required String category,
    required double rentPerDay,
    required double discountPercent,
    required String details,
    required String location,
    required List<File> images,
  }) async {
    try {
      // Validate required fields
      if (productName.trim().isEmpty ||
          category.trim().isEmpty ||
          images.isEmpty) {
        return false;
      }

      // Save images to app documents directory
      final List<String> imagePaths = await _saveImages(images);

      if (imagePaths.isEmpty) {
        return false;
      }

      // Calculate old price and discount text
      final double oldPrice = discountPercent > 0
          ? rentPerDay / (1 - discountPercent / 100)
          : rentPerDay;
      // Build badge text like "10% OFF" (uppercase OFF)
      final String discountText = discountPercent > 0
          ? '${discountPercent.toStringAsFixed(0)}% ${AppStrings.off.toUpperCase()}'
          : '';

      // Create product ID
      final String productId = 'rent_user_${DateTime.now().millisecondsSinceEpoch}';

      // Create UnifiedDataModel with multiple images
      final product = UnifiedDataModel(
        id: productId,
        title: productName,
        subtitle: category,
        rating: '4.0',
        location: location.isNotEmpty ? location : AppStrings.location12kmKatargam,
        image: imagePaths.first, // Use first image as primary
        discount: discountText,
        isFavorite: false,
        type: AppStrings.rentType,
        isOpen: true,
        price: rentPerDay,
        oldPrice: oldPrice > rentPerDay ? oldPrice : null,
        offerText: discountPercent > 0 ? '${AppStrings.flat}  ${discountPercent.toStringAsFixed(0)}% ${AppStrings.off}' : null,
        description: details.isNotEmpty ? details : AppStrings.rentDescriptionGeneric,
        view: 0.0,
        images: imagePaths, // Store all images for carousel
      );

      // Add to saved products
      savedProducts.add(product);

      // Save to SharedPreferences
      await _saveToPreferences();

      return true;
    } catch (e) {
      print('Error saving rent product: $e');
      return false;
    }
  }

  // ==================== LOAD PRODUCTS ====================

  /// Load saved products from SharedPreferences
  Future<void> loadSavedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? productsJson = prefs.getString(_prefsKey);

      if (productsJson == null || productsJson.isEmpty) {
        savedProducts.value = [];
        return;
      }

      final List<dynamic> decoded = json.decode(productsJson);
      savedProducts.value = decoded
          .map((json) => UnifiedDataModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading saved rent products: $e');
      savedProducts.value = [];
    }
  }

  // ==================== DELETE PRODUCT ====================

  /// Delete a product by ID
  Future<bool> deleteProduct(String productId) async {
    try {
      final index = savedProducts.indexWhere((p) => p.id == productId);
      if (index == -1) return false;

      // Delete associated images
      final product = savedProducts[index];
      await _deleteImage(product.image);

      // Remove from list
      savedProducts.removeAt(index);

      // Save to SharedPreferences
      await _saveToPreferences();

      return true;
    } catch (e) {
      print('Error deleting rent product: $e');
      return false;
    }
  }

  // ==================== PRIVATE HELPERS ====================

  /// Save images to app documents directory
  Future<List<String>> _saveImages(List<File> images) async {
    final List<String> savedPaths = [];

    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory imageDir = Directory('${appDocDir.path}/$_imageDirName');

      // Create directory if it doesn't exist
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      for (int i = 0; i < images.length; i++) {
        final File imageFile = images[i];
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final String destinationPath = '${imageDir.path}/$fileName';

        // Copy file to destination
        final File savedFile = await imageFile.copy(destinationPath);
        savedPaths.add(savedFile.path);
      }
    } catch (e) {
      print('Error saving images: $e');
    }

    return savedPaths;
  }

  /// Delete an image file
  Future<void> _deleteImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  /// Save products list to SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> productsJson = savedProducts
          .map((product) => product.toJson())
          .toList();

      await prefs.setString(_prefsKey, json.encode(productsJson));
    } catch (e) {
      print('Error saving to preferences: $e');
    }
  }

  /// Get all saved products (for UnifiedServiceDataController to merge)
  List<UnifiedDataModel> getAllProducts() {
    return List.from(savedProducts);
  }
}

