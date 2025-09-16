import '../common/app_enums.dart';

class BusinessDetailsModel {
  final String id;
  final String name;
  final String image;
  final String serviceType;
  // Use only for parlour businesses; null for boutique
  final ParlourServiceType? parlourServiceType;
  final double rating;
  final String location;
  final String description;
  final bool isFavorite;
  final bool isOpen;
  final BusinessType businessType;
  final GenderType selectedGender;
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
    this.isOpen = true,
    this.parlourServiceType,
    this.businessType = BusinessType.parlour,
    this.selectedGender = GenderType.male,
    required this.serviceCategories,
    required this.promotionalOffers,
  });

  BusinessDetailsModel copyWith({
    String? id,
    String? name,
    String? image,
    String? serviceType,
    ParlourServiceType? parlourServiceType,
    double? rating,
    String? location,
    String? description,
    bool? isFavorite,
    bool? isOpen,
    BusinessType? businessType,
    GenderType? selectedGender,
    List<ServiceCategoryModel>? serviceCategories,
    List<PromotionalOfferModel>? promotionalOffers,
  }) {
    return BusinessDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      serviceType: serviceType ?? this.serviceType,
      parlourServiceType: parlourServiceType ?? this.parlourServiceType,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      isOpen: isOpen ?? this.isOpen,
      businessType: businessType ?? this.businessType,
      selectedGender: selectedGender ?? this.selectedGender,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      promotionalOffers: promotionalOffers ?? this.promotionalOffers,
    );
  }
}

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
}

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
}

class PromotionalOfferModel {
  final String id;
  final String businessName;
  final String serviceName;
  final String discount;
  final String color;
  final double price;
  final String badgeAsset;

  PromotionalOfferModel({
    required this.id,
    required this.businessName,
    required this.serviceName,
    required this.discount,
    required this.color,
    required this.price,
    required this.badgeAsset,
  });
}
