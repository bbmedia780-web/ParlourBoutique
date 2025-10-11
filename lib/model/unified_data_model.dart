/// Unified data model for displaying various business/service types
///
/// A flexible model used across Parlour, Boutique, and Rent screens
/// Contains common fields and optional fields for specific use cases
class UnifiedDataModel {
  final String? id;
  final String title;
  final String subtitle;
  final String rating;
  final String location;
  final String image;
  final String discount;
  final String? best; // Best/famous service
  final bool isFavorite;
  final String type; // 'parlour', 'boutique', or 'rent'
  final bool isOpen; // Business open status
  
  // Optional details fields (used especially for Rent details screen)
  final double? price; // Current price
  final double? oldPrice; // Old/crossed price
  final String? offerText; // e.g., "Flat 20% Off"
  final String? description; // Details description text
  final double? view; // View count

  UnifiedDataModel({
    this.id,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.location,
    required this.image,
    required this.discount,
    this.best,
    this.isFavorite = false,
    required this.type,
    this.isOpen = true,
    this.price,
    this.oldPrice,
    this.offerText,
    this.description,
    this.view,
  });

  /// Creates UnifiedDataModel from JSON
  factory UnifiedDataModel.fromJson(Map<String, dynamic> json) {
    return UnifiedDataModel(
      id: json['id']?.toString(),
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      location: json['location']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      discount: json['discount']?.toString() ?? '',
      best: json['best']?.toString(),
      isFavorite: json['isFavorite'] == true,
      type: json['type']?.toString() ?? 'parlour',
      isOpen: json['isOpen'] ?? true,
      price: _parseDouble(json['price']),
      oldPrice: _parseDouble(json['oldPrice']),
      offerText: json['offerText']?.toString(),
      description: json['description']?.toString(),
      view: _parseDouble(json['view']),
    );
  }

  /// Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Converts UnifiedDataModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'rating': rating,
      'location': location,
      'image': image,
      'discount': discount,
      'best': best,
      'isFavorite': isFavorite,
      'type': type,
      'isOpen': isOpen,
      'price': price,
      'oldPrice': oldPrice,
      'offerText': offerText,
      'description': description,
      'view': view,
    };
  }

  /// Creates a copy of UnifiedDataModel with updated fields
  UnifiedDataModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? rating,
    String? location,
    String? image,
    String? discount,
    String? best,
    bool? isFavorite,
    String? type,
    bool? isOpen,
    double? price,
    double? oldPrice,
    String? offerText,
    String? description,
    double? view,
  }) {
    return UnifiedDataModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      image: image ?? this.image,
      discount: discount ?? this.discount,
      best: best ?? this.best,
      isFavorite: isFavorite ?? this.isFavorite,
      type: type ?? this.type,
      isOpen: isOpen ?? this.isOpen,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      offerText: offerText ?? this.offerText,
      description: description ?? this.description,
      view: view ?? this.view,
    );
  }

  @override
  String toString() => 'UnifiedDataModel(id: $id, title: $title, type: $type)';
}
