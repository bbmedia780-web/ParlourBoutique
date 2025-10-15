/// Booking service model for displaying booked services
///
/// Represents a booked service with image, title, subtitle, address, price, and type
class BookingServiceModel {
  final String id; // Unique identifier for the service
  final String image;
  final String title;
  final String subtitle;
  final String? address;
  final double price;
  final String type; // 'parlour', 'boutique', or 'rent'

  BookingServiceModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    this.address,
    required this.price,
    required this.type,
  });

  /// Creates BookingServiceModel from JSON
  factory BookingServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceModel(
      id: json['id']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      address: json['address']?.toString(),
      price: _parseDouble(json['price']),
      type: json['type']?.toString() ?? 'parlour',
    );
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Converts BookingServiceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'subtitle': subtitle,
      'address': address,
      'price': price,
      'type': type,
    };
  }

  /// Creates a copy of BookingServiceModel with updated fields
  BookingServiceModel copyWith({
    String? id,
    String? image,
    String? title,
    String? subtitle,
    String? address,
    double? price,
    String? type,
  }) {
    return BookingServiceModel(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      address: address ?? this.address,
      price: price ?? this.price,
      type: type ?? this.type,
    );
  }

  @override
  String toString() => 'BookingServiceModel(id: $id, title: $title, type: $type, price: $price)';
}

