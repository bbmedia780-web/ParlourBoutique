import '../api/base_api.dart';
import '../model/reels_model.dart';
import '../config/api_config.dart';

class ReelServices extends BaseApi {
  // Fetch reels with optional pagination & category
  Future<List<ReelsModel>> getReels({int page = 1, int limit = 10, String? category}) async {
    try {
      final response = await dio.get(
        ApiConfig.getReels,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (category != null) 'category': category,
        },
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => ReelsModel.fromJson(e)).toList();
    } catch (error) {
      print('Error getReels: $error');
      return [];
    }
  }

  Future<void> toggleLike(String reelId, bool isLiked) async {
    try {
      await dio.post(ApiConfig.toggleLike, data: {'reelId': reelId, 'like': isLiked});
    } catch (e) {
      print('Error toggleLike: $e');
    }
  }

  Future<void> toggleFollow(String reelId, bool isFollowing) async {
    try {
      await dio.post(ApiConfig.toggleFollow, data: {'reelId': reelId, 'follow': isFollowing});
    } catch (e) {
      print('Error toggleFollow: $e');
    }
  }
}
