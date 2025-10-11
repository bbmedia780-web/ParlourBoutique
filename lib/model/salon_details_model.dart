/// Business details model (alternative version) for salon/boutique information
///
/// Note: This appears to be an alternative version. Consider consolidating with details_model.dart
/// Contains business information with service categories and promotional offers
class BusinessDetailsModel {
  final String id;
  final String name;
  final String image;
  final String serviceType;
  final double rating;
  final String location;
  final String description;
  final bool isFavorite;
  final List<ServiceCategoryModel> serviceCategories;
  final List<PromotionalOfferModel> promotionalOffers;

  BusinessDetailsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.serviceType,
    required this.rating,
    required this.location,
    required this.description,
    this.isFavorite = false,
    required this.serviceCategories,
    required this.promotionalOffers,
  });

  /// Creates BusinessDetailsModel from JSON
  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      serviceType: json['serviceType']?.toString() ?? 'parlour',
      rating: _parseDouble(json['rating']),
      location: json['location']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isFavorite: json['isFavorite'] == true,
      serviceCategories: (json['serviceCategories'] as List<dynamic>?)
              ?.map((e) => ServiceCategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      promotionalOffers: (json['promotionalOffers'] as List<dynamic>?)
              ?.map((e) => PromotionalOfferModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      'name': name,
      'image': image,
      'serviceType': serviceType,
      'rating': rating,
      'location': location,
      'description': description,
      'isFavorite': isFavorite,
      'serviceCategories': serviceCategories.map((e) => e.toJson()).toList(),
      'promotionalOffers': promotionalOffers.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a copy of BusinessDetailsModel with updated fields
  BusinessDetailsModel copyWith({
    String? id,
    String? name,
    String? image,
    String? serviceType,
    double? rating,
    String? location,
    String? description,
    bool? isFavorite,
    List<ServiceCategoryModel>? serviceCategories,
    List<PromotionalOfferModel>? promotionalOffers,
  }) {
    return BusinessDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      serviceType: serviceType ?? this.serviceType,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      promotionalOffers: promotionalOffers ?? this.promotionalOffers,
    );
  }

  @override
  String toString() => 'BusinessDetailsModel(id: $id, name: $name, serviceType: $serviceType)';
}

/// Service category model for grouping related services
///
/// Contains a category with a list of services and selection state
class ServiceCategoryModel {
  final String id;
  final String name;
  final bool isSelected;
  final List<ServiceItemModel> services;

  ServiceCategoryModel({
    required this.id,
    required this.name,
    this.isSelected = false,
    required this.services,
  });

  /// Creates ServiceCategoryModel from JSON
  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isSelected: json['isSelected'] == true,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Converts ServiceCategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isSelected': isSelected,
      'services': services.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a copy of ServiceCategoryModel with updated fields
  ServiceCategoryModel copyWith({
    String? id,
    String? name,
    bool? isSelected,
    List<ServiceItemModel>? services,
  }) {
    return ServiceCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      services: services ?? this.services,
    );
  }

  @override
  String toString() => 'ServiceCategoryModel(name: $name, isSelected: $isSelected)';
}

/// Service item model representing an individual service
///
/// Contains service details including name, image, price, and discount
class ServiceItemModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final String? discount;

  ServiceItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.discount,
  });

  /// Creates ServiceItemModel from JSON
  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      price: _parseDouble(json['price']),
      discount: json['discount']?.toString(),
    );
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Converts ServiceItemModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'discount': discount,
    };
  }

  /// Creates a copy of ServiceItemModel with updated fields
  ServiceItemModel copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    String? discount,
  }) {
    return ServiceItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      discount: discount ?? this.discount,
    );
  }

  @override
  String toString() => 'ServiceItemModel(name: $name, price: $price)';
}

/// Promotional offer model for special promotions and discounts
///
/// Contains promotional offer details for a business service
class PromotionalOfferModel {
  final String id;
  final String businessName;
  final String serviceName;
  final String discount;
  final String color; // Color code for UI display

  PromotionalOfferModel({
    required this.id,
    required this.businessName,
    required this.serviceName,
    required this.discount,
    required this.color,
  });

  /// Creates PromotionalOfferModel from JSON
  factory PromotionalOfferModel.fromJson(Map<String, dynamic> json) {
    return PromotionalOfferModel(
      id: json['id']?.toString() ?? '',
      businessName: json['businessName']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',
      discount: json['discount']?.toString() ?? '',
      color: json['color']?.toString() ?? '#FFFFFF',
    );
  }

  /// Converts PromotionalOfferModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessName': businessName,
      'serviceName': serviceName,
      'discount': discount,
      'color': color,
    };
  }

  /// Creates a copy of PromotionalOfferModel with updated fields
  PromotionalOfferModel copyWith({
    String? id,
    String? businessName,
    String? serviceName,
    String? discount,
    String? color,
  }) {
    return PromotionalOfferModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      serviceName: serviceName ?? this.serviceName,
      discount: discount ?? this.discount,
      color: color ?? this.color,
    );
  }

  @override
  String toString() => 'PromotionalOfferModel(businessName: $businessName, discount: $discount)';
}