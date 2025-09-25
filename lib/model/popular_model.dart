/*
class PopularModel {
  final String? id;
  final String title;
  final double rating;
  final String location;
  final String image;
  final String discount;
  final String? service;
  final String bestFamousService;
  final bool isFavorite;
  final bool isOpen; // Business open status (Parlor/Boutique)
  final String category; // 'parlour' or 'boutique'
  // Rent-specific fields
  final int? price;
  final double? view;

  PopularModel({
    this.id,
    required this.title,
    required this.rating,
    required this.location,
    required this.image,
    required this.discount,
    required this.bestFamousService,
    this.service,
    this.isFavorite = false,
    this.isOpen = true,
    this.category = 'parlour', // Default to parlour
    this.price,
    this.view
  });

  /// ✅ From API JSON (robust parsing for number-like values)
  factory PopularModel.fromJson(Map<String, dynamic> json) {
    int? parsePrice(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.round();
      if (value is String) {
        final normalized = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (normalized.isEmpty) return 0;
        return int.tryParse(normalized) ?? 0;
      }
      return 0;
    }

    double? parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    double parseRating(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return PopularModel(
      id: json['id'],
      title: json['title'] ?? '',
      rating: parseRating(json['rating']),
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      discount: json['discount'] ?? '',
      bestFamousService: json['bestFamousService'] ?? '',
      service: json['service'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      isOpen: json['isOpen'] ?? true,
      category: json['category'] ?? 'parlour',
      price: parsePrice(json['price']),
      view: parseDouble(json['view']),
    );
  }

  /// ✅ To JSON (if needed for POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "rating": rating,
      "location": location,
      "image": image,
      "discount": discount,
      "bestFamousService": bestFamousService,
      "service": service,
      "isFavorite": isFavorite,
      "isOpen": isOpen,
      "category": category,
      "price": price,
      "view": view,
    };
  }

  /// ✅ Copy with modification
  PopularModel copyWith({
    String? id,
    String? title,
    double? rating,
    String? location,
    String? image,
    String? discount,
    String? service,
    String? bestFamousService,
    bool? isFavorite,
    bool? isOpen,
    String? category,
    int? price,
    bool? isRent,
    double? view,
  }) {
    return PopularModel(
      id: id ?? this.id,
      title: title ?? this.title,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      image: image ?? this.image,
      discount: discount ?? this.discount,
      bestFamousService: bestFamousService ?? this.bestFamousService,
      service: service ?? this.service,
      isFavorite: isFavorite ?? this.isFavorite,
      isOpen: isOpen ?? this.isOpen,
      category: category ?? this.category,
      price: price ?? this.price,
      view: view ?? this.view,
    );
  }
}
*/

class PopularModel {
  final String? id;
  final String title;
  final double rating;
  final String location;
  final String image;
  final String discount;
  final String? service;
  final String bestFamousService;
  final bool isFavorite;
  final bool isOpen; // Business open status (Parlor/Boutique)
  final String category; // 'parlour' or 'boutique'
  final int? price;
  final double? view;

  PopularModel({
    this.id,
    required this.title,
    required this.rating,
    required this.location,
    required this.image,
    required this.discount,
    required this.bestFamousService,
    this.service,
    this.isFavorite = false,
    this.isOpen = true,
    this.category = 'parlour',
    this.price,
    this.view
  });

  /// ✅ From API JSON
  factory PopularModel.fromJson(Map<String, dynamic> json) {
    return PopularModel(
      id: json['id'],
      title: json['title'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      discount: json['discount'] ?? '',
      bestFamousService: json['bestFamousService'] ?? '',
      service: json['service'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      isOpen: json['isOpen'] ?? true,
      category: json['category'] ?? 'parlour',
      price: (json['price'] ?? 0).toInt(),
      view: (json['view'] ?? 0).toDouble(),


    );
  }

  /// ✅ To JSON (if needed for POST)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "rating": rating,
      "location": location,
      "image": image,
      "discount": discount,
      "bestFamousService": bestFamousService,
      "service": service,
      "isFavorite": isFavorite,
      "isOpen": isOpen,
      "category": category,
      "price": price,
      "view": view,
    };
  }

  /// ✅ Copy with modification
  PopularModel copyWith({
    String? id,
    String? title,
    double? rating,
    String? location,
    String? image,
    String? discount,
    String? service,
    String? bestFamousService,
    bool? isFavorite,
    bool? isOpen,
    String? category,
    int? price,
    double? view,
  }) {
    return PopularModel(
      id: id ?? this.id,
      title: title ?? this.title,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      image: image ?? this.image,
      discount: discount ?? this.discount,
      bestFamousService: bestFamousService ?? this.bestFamousService,
      service: service ?? this.service,
      isFavorite: isFavorite ?? this.isFavorite,
      isOpen: isOpen ?? this.isOpen,
      category: category ?? this.category,
      price: price ?? this.price,
      view: view ?? this.view,
    );
  }
}