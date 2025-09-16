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
    );
  }
}
