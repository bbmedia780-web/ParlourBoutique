class UnifiedDataModel {
  final String? id;
  final String title;
  final String subtitle;
  final String rating;
  final String location;
  final String image;
  final String discount;
  String? best;
  final bool isFavorite;
  final String type; // 'parlour' or 'boutique'
  final bool isOpen; // Business open status (Parlor/Boutique)
  // Optional details fields (used especially for Rent details screen)
  final double? price;      // current price
  final double? oldPrice;   // old/crossed price
  final String? offerText;  // e.g., "Flat 20% Off"
  final String? description; // details description text

  UnifiedDataModel({
    this.id,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.location,
    required this.image,
    required this.discount,
    //this.tag,
    this.isFavorite = false,
    required this.type,
    this.isOpen = true,
    this.price,
    this.oldPrice,
    this.offerText,
    this.description,
  });

  UnifiedDataModel copyWith({String? id, bool? isFavorite, bool? isOpen}) {
    return UnifiedDataModel(
      id: id ?? this.id,
      title: title,
      subtitle: subtitle,
      rating: rating,
      location: location,
      image: image,
      discount: discount,
     // tag: tag,
      isFavorite: isFavorite ?? this.isFavorite,
      type: type,
      isOpen: isOpen ?? this.isOpen,
      price: price,
      oldPrice: oldPrice,
      offerText: offerText,
      description: description,
    );
  }
}
