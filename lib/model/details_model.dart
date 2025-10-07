class ServiceCategoryModel {
  final String name;
  final String image;
  final String price;
  final String? discount;
  final String? description;
  final String? oldPrice;
  final bool? isFavorite;
  final double rating; // non-null with default
  final int views; // non-null with default

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

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '',
      discount: json['discount'],
      description: json['description'],
      oldPrice: json['oldPrice'],
      isFavorite: json['isFavorite'],
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
      views: json['views'] is int
          ? json['views'] as int
          : (json['views'] is String ? int.tryParse(json['views']) ?? 0 : 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'discount': discount,
      'description': description,
      if (oldPrice != null) 'oldPrice': oldPrice,
      if (isFavorite != null) 'isFavorite': isFavorite,
      'rating': rating,
      'views': views,
    };
  }
}

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

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      discount: json['discount'] ?? '',
      title: json['title'] ?? '',
      service: json['service'] ?? '',
      price: json['price'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discount': discount,
      'title': title,
      'service': service,
      'price': price,
    };
  }
}

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

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      service: json['service'] ?? '',
      bestFamousService: json['bestFamousService'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      isOpen: json['isOpen'] ?? true,
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'] ?? 'parlour',
      description: json['description'] ?? '',
      promotions: (json['promotions'] as List<dynamic>?)
          ?.map((e) => PromotionModel.fromJson(e))
          .toList() ?? [],
      servicesByCategory: (json['servicesByCategory'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(
                key,
                (value as List<dynamic>)
                    .map((e) => ServiceCategoryModel.fromJson(e))
                    .toList(),
              )) ?? {},
      branches: (json['branches'] as List<dynamic>?)
          ?.map((e) => BranchModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
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
      if (branches != null)
        'branches': branches!.map((e) => e.toJson()).toList(),
    };
  }

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
  }) {
    return BusinessDetailsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      service: title ?? this.service,
      bestFamousService: title ?? this.bestFamousService,
      location: location ?? this.location,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      isOpen: isOpen ?? this.isOpen,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      description: description ?? this.description,
      promotions: promotions ?? this.promotions,
      servicesByCategory: servicesByCategory ?? this.servicesByCategory,
      branches: branches ?? branches,
    );
  }
}

class BranchModel {
  final String id;
  final String name;
  final String address;
  final String distance; // e.g., "1.2 km"
  final double rating;

  BranchModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      distance: json['distance'] ?? '',
      rating: json['rating'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distance': distance,
      'rating': rating,
    };
  }
}
