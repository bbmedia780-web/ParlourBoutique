class ReviewModel {
  final String userName;
  final String userAvatarAsset; // local asset path
  final double rating; // 0..5
  final String dateString; // preformatted date like 22-05-2025
  final String reviewText;

  const ReviewModel({
    required this.userName,
    required this.userAvatarAsset,
    required this.rating,
    required this.dateString,
    required this.reviewText,
  });
}


