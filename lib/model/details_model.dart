/// Service category model for representing individual services
///
/// Contains service details like name, image, pricing, and ratings
class ServiceCategoryModel {
  final String name;
  final String image;
  final String price;
  final String? discount;
  final String? description;
  final String? oldPrice;
  final bool? isFavorite;
  final double rating; // Service rating (0.0 to 5.0)
  final int views; // Number of views

  ServiceCategoryModel({
    required this.name,
    required this.image,
    required this.price,
    this.discount,
    this.description,
    this.oldPrice,
    this.isFavorite,
    double? rating,
    int? views,
  })  : rating = rating ?? 0.0,
        views = views ?? 0;

  /// Creates ServiceCategoryModel from JSON
  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      discount: json['discount']?.toString(),
      description: json['description']?.toString(),
      oldPrice: json['oldPrice']?.toString(),
      isFavorite: json['isFavorite'] as bool?,
      rating: _parseDouble(json['rating']),
      views: _parseInt(json['views']),
    );
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Helper method to safely parse integer values
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Converts ServiceCategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'discount': discount,
      'description': description,
      'oldPrice': oldPrice,
      'isFavorite': isFavorite,
      'rating': rating,
      'views': views,
    };
  }

  /// Creates a copy of ServiceCategoryModel with updated fields
  ServiceCategoryModel copyWith({
    String? name,
    String? image,
    String? price,
    String? discount,
    String? description,
    String? oldPrice,
    bool? isFavorite,
    double? rating,
    int? views,
  }) {
    return ServiceCategoryModel(
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      description: description ?? this.description,
      oldPrice: oldPrice ?? this.oldPrice,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      views: views ?? this.views,
    );
  }

  @override
  String toString() => 'ServiceCategoryModel(name: $name, rating: $rating)';
}

/// Promotion model for displaying special offers
///
/// Contains promotional offer details with discount and pricing
class PromotionModel {
  final String discount;
  final String title;
  final String service;
  final double price;

  PromotionModel({
    required this.discount,
    required this.title,
    required this.service,
    required this.price,
  });

  /// Creates PromotionModel from JSON
  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      discount: json['discount']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      service: json['service']?.toString() ?? '',
      price: _parseDouble(json['price']),
    );
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Converts PromotionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'discount': discount,
      'title': title,
      'service': service,
      'price': price,
    };
  }

  /// Creates a copy of PromotionModel with updated fields
  PromotionModel copyWith({
    String? discount,
    String? title,
    String? service,
    double? price,
  }) {
    return PromotionModel(
      discount: discount ?? this.discount,
      title: title ?? this.title,
      service: service ?? this.service,
      price: price ?? this.price,
    );
  }

  @override
  String toString() => 'PromotionModel(title: $title, discount: $discount)';
}

/// Business details model for displaying comprehensive business information
///
/// Contains detailed information about a parlour/boutique including
/// services, promotions, ratings, and branch locations
class BusinessDetailsModel {
  final String id;
  final String title;
  final String? service;
  final String bestFamousService;
  final String location;
  final String image;
  final double rating;
  final bool isOpen;
  final bool isFavorite;
  final String category; // 'parlour' or 'boutique'
  final String description;
  final List<PromotionModel> promotions;
  final Map<String, List<ServiceCategoryModel>> servicesByCategory;
  final List<BranchModel>? branches;

  BusinessDetailsModel({
    required this.id,
    required this.title,
    this.service,
    required this.bestFamousService,
    required this.location,
    required this.image,
    required this.rating,
    required this.isOpen,
    required this.isFavorite,
    required this.category,
    required this.description,
    required this.promotions,
    required this.servicesByCategory,
    this.branches,
  });

  /// Creates BusinessDetailsModel from JSON
  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      service: json['service']?.toString(),
      bestFamousService: json['bestFamousService']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      rating: _parseDouble(json['rating']),
      isOpen: json['isOpen'] ?? true,
      isFavorite: json['isFavorite'] ?? false,
      category: json['category']?.toString() ?? 'parlour',
      description: json['description']?.toString() ?? '',
      promotions: (json['promotions'] as List<dynamic>?)
              ?.map((e) => PromotionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      servicesByCategory: (json['servicesByCategory'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(
                    key,
                    (value as List<dynamic>)
                        .map((e) => ServiceCategoryModel.fromJson(e as Map<String, dynamic>))
                        .toList(),
                  )) ??
          {},
      branches: (json['branches'] as List<dynamic>?)
          ?.map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Converts BusinessDetailsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'service': service,
      'bestFamousService': bestFamousService,
      'location': location,
      'image': image,
      'rating': rating,
      'isOpen': isOpen,
      'isFavorite': isFavorite,
      'category': category,
      'description': description,
      'promotions': promotions.map((e) => e.toJson()).toList(),
      'servicesByCategory': servicesByCategory.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()),
      ),
      if (branches != null) 'branches': branches!.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a copy of BusinessDetailsModel with updated fields
  BusinessDetailsModel copyWith({
    String? id,
    String? title,
    String? service,
    String? bestFamousService,
    String? location,
    String? image,
    double? rating,
    bool? isOpen,
    bool? isFavorite,
    String? category,
    String? description,
    List<PromotionModel>? promotions,
    Map<String, List<ServiceCategoryModel>>? servicesByCategory,
    List<BranchModel>? branches,
  }) {
    return BusinessDetailsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      service: service ?? this.service,
      bestFamousService: bestFamousService ?? this.bestFamousService,
      location: location ?? this.location,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      isOpen: isOpen ?? this.isOpen,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      description: description ?? this.description,
      promotions: promotions ?? this.promotions,
      servicesByCategory: servicesByCategory ?? this.servicesByCategory,
      branches: branches ?? this.branches,
    );
  }

  @override
  String toString() => 'BusinessDetailsModel(id: $id, title: $title, category: $category)';
}

/// Branch model for representing business branch locations
///
/// Contains branch details including name, address, distance, and rating
class BranchModel {
  final String id;
  final String name;
  final String address;
  final String distance; // e.g., "1.2 km" or "500 m"
  final double rating;

  BranchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
  });

  /// Creates BranchModel from JSON
  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      distance: json['distance']?.toString() ?? '',
      rating: _parseDouble(json['rating']),
    );
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Converts BranchModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distance': distance,
      'rating': rating,
    };
  }

  /// Creates a copy of BranchModel with updated fields
  BranchModel copyWith({
    String? id,
    String? name,
    String? address,
    String? distance,
    double? rating,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
    );
  }

  @override
  String toString() => 'BranchModel(name: $name, distance: $distance, rating: $rating)';
}
