/// Review model for displaying user reviews
///
/// Contains user information, rating, date, and review text
class ReviewModel {
  final String userName;
  final String userAvatarAsset; // local asset path or URL
  final double rating; // 0.0 to 5.0
  final String dateString; // preformatted date like 22-05-2025
  final String reviewText;

  const ReviewModel({
    required this.userName,
    required this.userAvatarAsset,
    required this.rating,
    required this.dateString,
    required this.reviewText,
  });

  /// Creates ReviewModel from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userName: json['userName']?.toString() ?? '',
      userAvatarAsset: json['userAvatarAsset']?.toString() ?? '',
      rating: _parseDouble(json['rating']),
      dateString: json['dateString']?.toString() ?? '',
      reviewText: json['reviewText']?.toString() ?? '',
    );
  }

  /// Helper method to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Converts ReviewModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userAvatarAsset': userAvatarAsset,
      'rating': rating,
      'dateString': dateString,
      'reviewText': reviewText,
    };
  }

  /// Creates a copy of ReviewModel with updated fields
  ReviewModel copyWith({
    String? userName,
    String? userAvatarAsset,
    double? rating,
    String? dateString,
    String? reviewText,
  }) {
    return ReviewModel(
      userName: userName ?? this.userName,
      userAvatarAsset: userAvatarAsset ?? this.userAvatarAsset,
      rating: rating ?? this.rating,
      dateString: dateString ?? this.dateString,
      reviewText: reviewText ?? this.reviewText,
    );
  }

  @override
  String toString() => 'ReviewModel(userName: $userName, rating: $rating)';
}


