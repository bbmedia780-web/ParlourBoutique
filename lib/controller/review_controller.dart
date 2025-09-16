import 'package:get/get.dart';
import '../model/review_model.dart';
import '../constants/app_assets.dart';
import '../constants/app_strings.dart';

class ReviewController extends GetxController {
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxDouble averageRating = 4.5.obs;
  final RxInt totalReviews = 90.obs;

  @override
  void onInit() {
    super.onInit();
    // Demo data, can be replaced with API later
    reviews.value = [
      ReviewModel(
        userName: AppStrings.defaultUserName,
        userAvatarAsset: AppAssets.user,
        rating: 4.5,
        dateString: '22-05-2025',
        reviewText: AppStrings.review1,
      ),
      ReviewModel(
        userName: AppStrings.defaultUserName,
        userAvatarAsset: AppAssets.user,
        rating: 4.5,
        dateString: '22-05-2025',
        reviewText: AppStrings.review2,
      ),
    ];
  }
}


