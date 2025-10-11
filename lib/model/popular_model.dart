
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
  final bool isOpen;
  final String category;
  final int? price;
  final double? view;

  /// Constructor
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
    this.view,
  });


  factory PopularModel.fromJson(Map<String, dynamic> json) {
    return PopularModel(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? '',
      rating: _parseDouble(json['rating']),
      location: json['location']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      discount: json['discount']?.toString() ?? '',
      bestFamousService: json['bestFamousService']?.toString() ?? '',
      service: json['service']?.toString(),
      isFavorite: json['isFavorite'] == true,
      isOpen: json['isOpen'] ?? true,
      category: json['category']?.toString() ?? 'parlour',
      price: _parseInt(json['price']),
      view: _parseDouble(json['view']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'rating': rating,
      'location': location,
      'image': image,
      'discount': discount,
      'bestFamousService': bestFamousService,
      'service': service,
      'isFavorite': isFavorite,
      'isOpen': isOpen,
      'category': category,
      'price': price,
      'view': view,
    };
  }


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

  @override
  String toString() {
    return 'PopularModel(id: $id, title: $title, category: $category, rating: $rating)';
  }
}
