class BookingServiceModel {
  final String image;
  final String title;
  final String subtitle;
  final String? address;
  final double price;
  final String type; // 'parlour' or 'boutique'

  BookingServiceModel({
    required this.image,
    required this.title,
    required this.subtitle,
    this.address,
    required this.price,
    required this.type,
  });
}

