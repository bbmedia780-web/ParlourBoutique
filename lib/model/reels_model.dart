class ReelsModel {
  final String? id;
  final String videoUrl;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String authorName;
  final String authorProfileImage;
  final String musicTitle;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final bool isFollowing;
  final String category;
  final String duration;
  final DateTime createdAt;

  ReelsModel({
    this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.authorName,
    required this.authorProfileImage,
    required this.musicTitle,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    this.isLiked = false,
    this.isFollowing = false,
    this.category = 'beauty',
    this.duration = '0:00',
    required this.createdAt,
  });

  /// ✅ From API JSON
  factory ReelsModel.fromJson(Map<String, dynamic> json) {
    return ReelsModel(
      id: json['id'],
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      authorName: json['authorName'] ?? '',
      authorProfileImage: json['authorProfileImage'] ?? '',
      musicTitle: json['musicTitle'] ?? '',
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      sharesCount: json['sharesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isFollowing: json['isFollowing'] ?? false,
      category: json['category'] ?? 'beauty',
      duration: json['duration'] ?? '0:00',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// ✅ To JSON (if needed for POST)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "videoUrl": videoUrl,
      "thumbnailUrl": thumbnailUrl,
      "title": title,
      "description": description,
      "authorName": authorName,
      "authorProfileImage": authorProfileImage,
      "musicTitle": musicTitle,
      "likesCount": likesCount,
      "commentsCount": commentsCount,
      "sharesCount": sharesCount,
      "isLiked": isLiked,
      "isFollowing": isFollowing,
      "category": category,
      "duration": duration,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  /// ✅ Copy with modification
  ReelsModel copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? title,
    String? description,
    String? authorName,
    String? authorProfileImage,
    String? musicTitle,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
    bool? isFollowing,
    String? category,
    String? duration,
    DateTime? createdAt,
  }) {
    return ReelsModel(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      authorName: authorName ?? this.authorName,
      authorProfileImage: authorProfileImage ?? this.authorProfileImage,
      musicTitle: musicTitle ?? this.musicTitle,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// ✅ Format likes count for display
  String get formattedLikesCount {
    if (likesCount >= 1000000) {
      return '${(likesCount / 1000000).toStringAsFixed(1)}M';
    } else if (likesCount >= 1000) {
      return '${(likesCount / 1000).toStringAsFixed(1)}k';
    }
    return likesCount.toString();
  }

  /// ✅ Format comments count for display
  String get formattedCommentsCount {
    if (commentsCount >= 1000000) {
      return '${(commentsCount / 1000000).toStringAsFixed(1)}M';
    } else if (commentsCount >= 1000) {
      return '${(commentsCount / 1000).toStringAsFixed(1)}k';
    }
    return commentsCount.toString();
  }

  /// ✅ Format shares count for display
  String get formattedSharesCount {
    if (sharesCount >= 1000000) {
      return '${(sharesCount / 1000000).toStringAsFixed(1)}M';
    } else if (sharesCount >= 1000) {
      return '${(sharesCount / 1000).toStringAsFixed(1)}k';
    }
    return sharesCount.toString();
  }
}
