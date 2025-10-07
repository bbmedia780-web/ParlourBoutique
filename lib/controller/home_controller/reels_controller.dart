/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../model/reels_model.dart';
import '../../services/reels_api.dart';

class ReelsController extends GetxController with WidgetsBindingObserver {
  // -------------------- SERVICES --------------------
  final ReelServices reelServices = ReelServices();

  // -------------------- OBSERVABLE STATE --------------------
  final RxList<ReelsModel> reelsList = <ReelsModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentVideoIndex = 0.obs;
  final RxBool isVideoInitialized = false.obs;
  final RxBool isActiveTab = false.obs; // whether Reels tab is currently visible
  final RxBool isMuted = false.obs;

  // -------------------- VIDEO MANAGEMENT --------------------
  final Map<String, VideoPlayerController> videoControllers = {};
  VideoPlayerController? currentVideoController;

  // -------------------- PAGINATION --------------------
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMoreData = true;

  // -------------------- LIFECYCLE --------------------
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
    _loadInitialData();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeVideoControllers();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _handleAppLifecycleChange(state);
  }

  // ==================== INITIAL DATA & LIFECYCLE HANDLING ====================
  void _loadInitialData() {
    loadDummyData();
  }

  void _handleAppLifecycleChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        pauseCurrentVideo();
        break;
      case AppLifecycleState.resumed:
        if (isActiveTab.value) resumeCurrentVideo();
        break;
      default:
        break;
    }
  }

  void _disposeVideoControllers() {
    for (var controller in videoControllers.values) {
      controller.dispose();
    }
    videoControllers.clear();
    currentVideoController = null;
  }

  // ==================== VIDEO CONTROLLER MANAGEMENT ====================
  Future<void> initializeVideoController(String reelId, String videoUrl) async {
    if (videoControllers.containsKey(reelId)) return;

    try {
      final controller = videoUrl.startsWith('http')
          ? VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          : VideoPlayerController.file(File(videoUrl));

      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(isMuted.value ? 0.0 : 1.0);
      videoControllers[reelId] = controller;
    } catch (e) {
      print('Failed to initialize video controller for $reelId: $e');
    }
  }

  Future<void> playVideoAtIndex(int index) async {
    if (index < 0 || index >= reelsList.length) return;

    currentVideoIndex.value = index;
    _pauseAllVideos();

    final reel = reelsList[index];
    final controller = videoControllers[reel.id];
    if (controller != null && !controller.value.isPlaying) {
      currentVideoController = controller;
      controller.setVolume(isMuted.value ? 0.0 : 1.0);
      await controller.play();
    }
  }

  void _pauseAllVideos() {
    for (var controller in videoControllers.values) {
      if (controller.value.isPlaying) controller.pause();
    }
  }

  void pauseCurrentVideo() => currentVideoController?.pause();
  void resumeCurrentVideo() => currentVideoController?.play();

  void togglePlayPause() {
    if (currentVideoController == null) return;
    currentVideoController!.value.isPlaying ? pauseCurrentVideo() : resumeCurrentVideo();
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    applyMuteToAllControllers();
  }

  void applyMuteToAllControllers() {
    final volume = isMuted.value ? 0.0 : 1.0;
    for (var controller in videoControllers.values) {
      if (controller.value.isInitialized) controller.setVolume(volume);
    }
  }

  VideoPlayerController? getVideoController(String reelId) => videoControllers[reelId];
  bool isVideoPlaying(String reelId) => videoControllers[reelId]?.value.isPlaying ?? false;
  VideoPlayerController? getCurrentVideoController() => currentVideoController;

  // ==================== DATA MANAGEMENT ====================
  void loadDummyData() {
    _setLoadingState(true);
    errorMessage.value = '';

    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        await _loadReelsData();
      } catch (e) {
        _handleError('Failed to load reels: $e');
      }
    });
  }

  Future<void> _loadReelsData() async {
    final dummyReels = _generateDummyReels();
    reelsList.assignAll(dummyReels);
    await _initializeAllVideoControllers(dummyReels);

    if (dummyReels.isNotEmpty && isActiveTab.value) await playVideoAtIndex(0);

    _setLoadingState(false);
  }

  Future<void> _initializeAllVideoControllers(List<ReelsModel> reels) async {
    for (final reel in reels) {
      await initializeVideoController(reel.id!, reel.videoUrl);
    }
  }

  void _setLoadingState(bool loading) => isLoading.value = loading;

  void _handleError(String error) {
    errorMessage.value = error;
    _setLoadingState(false);
  }

  Future<void> loadMoreReels() async {
    if (!hasMoreData || isLoading.value) return;
    // TODO: Implement pagination
  }

  Future<void> refreshReels() async {
    // TODO: Implement refresh
  }

  // ==================== USER INTERACTIONS ====================
  void toggleLike(int index) {
    if (index < 0 || index >= reelsList.length) return;

    final reel = reelsList[index];
    final updatedReel = reel.copyWith(
      isLiked: !reel.isLiked,
      likesCount: reel.isLiked ? reel.likesCount - 1 : reel.likesCount + 1,
    );
    reelsList[index] = updatedReel;
    _updateLikeStatus(reel.id, updatedReel.isLiked);
  }

  void toggleFollow(int index) {
    if (index < 0 || index >= reelsList.length) return;

    final reel = reelsList[index];
    final updatedReel = reel.copyWith(isFollowing: !reel.isFollowing);
    reelsList[index] = updatedReel;
    _updateFollowStatus(reel.id, updatedReel.isFollowing);
  }

  void shareReel(int index) {
    if (index < 0 || index >= reelsList.length) return;
    _shareReel(reelsList[index]);
  }

  void commentOnReel(int index) {
    if (index < 0 || index >= reelsList.length) return;
    _navigateToComments(reelsList[index]);
  }

  Future<void> onPageChanged(int index) async {
    await playVideoAtIndex(index);

    if (index == reelsList.length - 1 && hasMoreData) {
      loadMoreReels();
    }
  }

  void onVideoTap() => togglePlayPause();

  void setActiveTab(bool isActive) {
    isActiveTab.value = isActive;

    if (isActive) {
      if (currentVideoController != null && !currentVideoController!.value.isPlaying) {
        resumeCurrentVideo();
      } else if (reelsList.isNotEmpty && currentVideoController == null) {
        playVideoAtIndex(currentVideoIndex.value);
      }
    } else {
      _pauseAllVideos();
    }
  }

  Future<void> addLocalReel(ReelsModel reel) async {
    reelsList.insert(0, reel);
    await initializeVideoController(reel.id ?? UniqueKey().toString(), reel.videoUrl);
    await playVideoAtIndex(0);
  }

  // ==================== PRIVATE HELPERS ====================
  void _shareReel(ReelsModel reel) => print('Sharing reel: ${reel.title}');
  void _navigateToComments(ReelsModel reel) => print('Opening comments for reel: ${reel.title}');

  Future<void> _updateLikeStatus(String? reelId, bool isLiked) async {
    if (reelId == null) return;

    try {
      await reelServices.toggleLike(reelId, isLiked);
    } catch (e) {
      print('Failed to update like status: $e');
    }
  }

  Future<void> _updateFollowStatus(String? reelId, bool isFollowing) async {
    if (reelId == null) return;

    try {
      await reelServices.toggleFollow(reelId, isFollowing);
    } catch (e) {
      print('Failed to update follow status: $e');
    }
  }

  // ==================== DUMMY DATA ====================
  List<ReelsModel> _generateDummyReels() {
    return [
      // ... Your existing dummy reels
    ];
  }
}
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../model/reels_model.dart';
import '../../services/reels_api.dart';

class ReelsController extends GetxController with WidgetsBindingObserver {

  final ReelServices reelServices = ReelServices();

  // Observable state
  final RxList<ReelsModel> reelsList = <ReelsModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentVideoIndex = 0.obs;
  final RxBool isVideoInitialized = false.obs;
  final RxBool isActiveTab = false.obs; // whether Reels tab is currently visible

  // Video management
  final Map<String, VideoPlayerController> videoControllers = {};
  VideoPlayerController? currentVideoController;
  final RxBool isMuted = false.obs;

  // Memory optimization: Only keep video controllers for nearby reels
  static const int _maxVideoControllersInMemory = 3; // Current + 1 before + 1 after
  final Set<String> _initializedReelIds = {}; // Track which reels have been initialized

  // Pagination
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMoreData = true;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onReady() {
    super.onReady();
    _loadInitialData();
  }

  @override
  void onClose() {
    _disposeResources();
    super.onClose();
  }

  /// ✅ Initialize controller and setup lifecycle observer
  void _initializeController() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// ✅ Load initial data
  void _loadInitialData() {
    loadDummyData();
  }

  /// ✅ Dispose all resources
  void _disposeResources() {
    WidgetsBinding.instance.removeObserver(this);

    // Dispose all video controllers
    for (var controller in videoControllers.values) {
      try {
        controller.dispose();
      } catch (e) {
        print('Error disposing video controller: $e');
      }
    }
    videoControllers.clear();
    _initializedReelIds.clear();
    currentVideoController = null;

  }

  /// ✅ Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _handleAppLifecycleChange(state);
  }

  /// ✅ Handle app lifecycle state changes
  void _handleAppLifecycleChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        pauseCurrentVideo();
        break;
      case AppLifecycleState.resumed:
        if (isActiveTab.value) {
          resumeCurrentVideo();
        }
        break;
      default:
        break;
    }
  }

  // ==================== VIDEO MANAGEMENT ====================

  /// ✅ Initialize video controller for a reel
  Future<void> initializeVideoController(String reelId, String videoUrl) async {
    if (videoControllers.containsKey(reelId)) {
      return; // Already initialized
    }

    try {
      final bool isNetwork = videoUrl.startsWith('http');
      final controller = isNetwork
          ? VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          : VideoPlayerController.file(File(videoUrl));
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(isMuted.value ? 0.0 : 1.0);
      videoControllers[reelId] = controller;
      _initializedReelIds.add(reelId);
    } catch (e) {
      print('Failed to initialize video controller for $reelId: $e');
    }
  }

  /// ✅ Dispose video controller for a specific reel
  Future<void> _disposeVideoController(String reelId) async {
    final controller = videoControllers[reelId];
    if (controller != null) {
      try {
        await controller.pause();
        await controller.dispose();
        videoControllers.remove(reelId);
        _initializedReelIds.remove(reelId);
      } catch (e) {
        print('Error disposing video controller for $reelId: $e');
      }
    }
  }

  /// ✅ Clean up video controllers that are far from current index
  Future<void> _cleanupDistantVideoControllers(int currentIndex) async {
    if (reelsList.isEmpty) return;

    final reelsToKeep = <String>{};
    
    // Keep current and adjacent videos
    for (int i = currentIndex - 1; i <= currentIndex + 1; i++) {
      if (i >= 0 && i < reelsList.length) {
        final reelId = reelsList[i].id;
        if (reelId != null) {
          reelsToKeep.add(reelId);
        }
      }
    }

    // Dispose controllers not in the keep list
    final controllersToDispose = videoControllers.keys
        .where((reelId) => !reelsToKeep.contains(reelId))
        .toList();

    for (final reelId in controllersToDispose) {
      await _disposeVideoController(reelId);
    }
  }

  /// ✅ Preload videos near current index
  Future<void> _preloadAdjacentVideos(int currentIndex) async {
    if (reelsList.isEmpty) return;

    // Load current and adjacent videos
    for (int i = currentIndex - 1; i <= currentIndex + 1; i++) {
      if (i >= 0 && i < reelsList.length) {
        final reel = reelsList[i];
        if (reel.id != null && !_initializedReelIds.contains(reel.id)) {
          await initializeVideoController(reel.id!, reel.videoUrl);
        }
      }
    }
  }

  /// ✅ Play video at specific index with lazy loading
  Future<void> playVideoAtIndex(int index) async {
    if (index < 0 || index >= reelsList.length) return;

    // Update current index
    currentVideoIndex.value = index;

    // Pause all other videos
    _pauseAllVideos();

    // Preload current and adjacent videos
    await _preloadAdjacentVideos(index);

    // Clean up distant video controllers to free memory
    await _cleanupDistantVideoControllers(index);

    // Play the current video
    final reel = reelsList[index];
    final controller = videoControllers[reel.id];
    if (controller != null && !controller.value.isPlaying) {
      currentVideoController = controller;
      controller.setVolume(isMuted.value ? 0.0 : 1.0);
      await controller.play();
    }
  }

  /// ✅ Pause all videos
  void _pauseAllVideos() {
    for (var controller in videoControllers.values) {
      if (controller.value.isPlaying) {
        controller.pause();
      }
    }
  }

  /// ✅ Pause current video
  void pauseCurrentVideo() {
    currentVideoController?.pause();
  }

  /// ✅ Resume current video
  void resumeCurrentVideo() {
    currentVideoController?.play();
  }

  /// ✅ Toggle play/pause for current video
  void togglePlayPause() {
    if (currentVideoController == null) return;

    if (currentVideoController!.value.isPlaying) {
      pauseCurrentVideo();
    } else {
      resumeCurrentVideo();
    }
  }

  /// ✅ Toggle mute state and apply to current/all controllers
  void toggleMute() {
    isMuted.value = !isMuted.value;
    applyMuteToAllControllers();
  }

  void applyMuteToAllControllers() {
    final double volume = isMuted.value ? 0.0 : 1.0;
    for (final controller in videoControllers.values) {
      if (controller.value.isInitialized) {
        controller.setVolume(volume);
      }
    }
  }

  /// ✅ Get video controller for a reel
  VideoPlayerController? getVideoController(String reelId) {
    return videoControllers[reelId];
  }

  /// ✅ Check if video is playing
  bool isVideoPlaying(String reelId) {
    final controller = videoControllers[reelId];
    return controller?.value.isPlaying ?? false;
  }

  /// ✅ Get current video controller
  VideoPlayerController? getCurrentVideoController() {
    return currentVideoController;
  }

  // ==================== DATA MANAGEMENT ====================

  /// ✅ Load dummy data (temporary implementation)
  void loadDummyData() {
    _setLoadingState(true);
    errorMessage.value = '';

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        await _loadReelsData();
      } catch (e) {
        _handleError('Failed to load reels: $e');
      }
    });
  }

  /// ✅ Load reels data with lazy video initialization
  Future<void> _loadReelsData() async {
    final dummyReels = _generateDummyReels();
    reelsList.assignAll(dummyReels);

    // Only initialize the first video and its adjacent ones (lazy loading)
    if (dummyReels.isNotEmpty) {
      await _preloadAdjacentVideos(0);
    }

    // Auto-play the first video only when Reels tab is active
    if (dummyReels.isNotEmpty && isActiveTab.value) {
      await playVideoAtIndex(0);
    }

    _setLoadingState(false);
  }

  /// ✅ Set loading state
  void _setLoadingState(bool loading) {
    isLoading.value = loading;
  }

  /// ✅ Handle errors
  void _handleError(String error) {
    errorMessage.value = error;
    _setLoadingState(false);
  }


  /// ✅ Load more reels (for pagination)
  Future<void> loadMoreReels() async {
    if (!hasMoreData || isLoading.value) return;

    //await loadReelsFromAPI();
  }

  /// ✅ Refresh reels
  Future<void> refreshReels() async {
    // await loadReelsFromAPI(isRefresh: true);
  }

  // ==================== USER INTERACTIONS ====================

  /// ✅ Toggle like on a reel
  void toggleLike(int index) {
    if (index >= 0 && index < reelsList.length) {
      final reel = reelsList[index];
      final updatedReel = reel.copyWith(
        isLiked: !reel.isLiked,
        likesCount: reel.isLiked ? reel.likesCount - 1 : reel.likesCount + 1,
      );
      reelsList[index] = updatedReel;

      // Call API to update like status
      _updateLikeStatus(reel.id, updatedReel.isLiked);
    }
  }

  /// ✅ Toggle follow status
  void toggleFollow(int index) {
    if (index >= 0 && index < reelsList.length) {
      final reel = reelsList[index];
      final updatedReel = reel.copyWith(
        isFollowing: !reel.isFollowing,
      );
      reelsList[index] = updatedReel;

      // Call API to update follow status
      _updateFollowStatus(reel.id, updatedReel.isFollowing);
    }
  }

  /// ✅ Share reel
  void shareReel(int index) {
    if (index >= 0 && index < reelsList.length) {
      final reel = reelsList[index];
      _shareReel(reel);
    }
  }

  /// ✅ Comment on reel
  void commentOnReel(int index) {
    if (index >= 0 && index < reelsList.length) {
      final reel = reelsList[index];
      _navigateToComments(reel);
    }
  }

  /// ✅ Handle page change in PageView
  Future<void> onPageChanged(int index) async {
    // Play the new video and pause others
    await playVideoAtIndex(index);

    // Load more when reaching the last item
    if (index == reelsList.length - 1 && hasMoreData) {
      loadMoreReels();
    }
  }

  /// ✅ Handle video tap (play/pause toggle)
  void onVideoTap() {
    togglePlayPause();
  }

  /// ✅ Set whether the Reels tab is currently active/visible
  void setActiveTab(bool isActive) {
    isActiveTab.value = isActive;
    if (isActive) {
      // If we have videos and none is playing, resume the current one
      if (currentVideoController != null && !currentVideoController!.value.isPlaying) {
        resumeCurrentVideo();
      } else if (reelsList.isNotEmpty && currentVideoController == null) {
        // If nothing selected yet, start the first
        playVideoAtIndex(currentVideoIndex.value);
      }
    } else {
      _pauseAllVideos();
    }
  }

  /// ✅ Generate dummy reels data
  List<ReelsModel> _generateDummyReels() {
    return [
      ReelsModel(
        id: '1',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        thumbnailUrl: 'https://picsum.photos/400/700?random=1',
        title: 'Bridal Hair Design Cut',
        description: 'Our expert stylists craft haircuts tailored to your face shape and wedding theme. From classic bobs to elegant updos, we create the perfect look for your special day.',
        authorName: 'Beauty Studio Pro',
        authorProfileImage: 'https://picsum.photos/100/100?random=1',
        musicTitle: 'Tuck claon bgm',
        likesCount: 2200,
        commentsCount: 20,
        sharesCount: 22,
        isLiked: false,
        isFollowing: false,
        category: 'bridal',
        duration: '0:45',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ReelsModel(
        id: '2',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        thumbnailUrl: 'https://picsum.photos/400/700?random=2',
        title: 'Glamorous Makeup Look',
        description: 'Transform your look with our professional makeup services. From natural beauty to bold glam, we bring out your best features.',
        authorName: 'Glamour Hub',
        authorProfileImage: 'https://picsum.photos/100/100?random=2',
        musicTitle: 'Beauty vibes',
        likesCount: 1850,
        commentsCount: 35,
        sharesCount: 18,
        isLiked: true,
        isFollowing: true,
        category: 'makeup',
        duration: '1:20',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      ReelsModel(
        id: '3',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        thumbnailUrl: 'https://picsum.photos/400/700?random=3',
        title: 'Spa Relaxation Therapy',
        description: 'Indulge in our premium spa treatments designed to rejuvenate your mind, body, and soul. Experience ultimate relaxation.',
        authorName: 'Serenity Spa',
        authorProfileImage: 'https://picsum.photos/100/100?random=3',
        musicTitle: 'Relaxing sounds',
        likesCount: 3200,
        commentsCount: 45,
        sharesCount: 28,
        isLiked: false,
        isFollowing: false,
        category: 'spa',
        duration: '2:15',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      ReelsModel(
        id: '4',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        thumbnailUrl: 'https://picsum.photos/400/700?random=4',
        title: 'Nail Art Masterpiece',
        description: 'Discover stunning nail art designs that express your personality. From elegant French tips to bold geometric patterns.',
        authorName: 'Nail Art Studio',
        authorProfileImage: 'https://picsum.photos/100/100?random=4',
        musicTitle: 'Creative vibes',
        likesCount: 1500,
        commentsCount: 25,
        sharesCount: 15,
        isLiked: true,
        isFollowing: false,
        category: 'nail_art',
        duration: '1:05',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      ReelsModel(
        id: '5',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        thumbnailUrl: 'https://picsum.photos/400/700?random=5',
        title: 'Hair Color Transformation',
        description: 'Watch amazing hair color transformations that will inspire your next salon visit. From subtle highlights to bold colors.',
        authorName: 'Color Magic Salon',
        authorProfileImage: 'https://picsum.photos/100/100?random=5',
        musicTitle: 'Transformation beats',
        likesCount: 2800,
        commentsCount: 40,
        sharesCount: 32,
        isLiked: false,
        isFollowing: true,
        category: 'hair_color',
        duration: '1:45',
        createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      ReelsModel(
        id: '6',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        thumbnailUrl: 'https://picsum.photos/400/700?random=6',
        title: 'Facial Treatment Demo',
        description: 'Experience our signature facial treatments that leave your skin glowing and refreshed. Professional skincare at its best.',
        authorName: 'Skin Care Experts',
        authorProfileImage: 'https://picsum.photos/100/100?random=6',
        musicTitle: 'Skincare zen',
        likesCount: 1950,
        commentsCount: 30,
        sharesCount: 20,
        isLiked: true,
        isFollowing: false,
        category: 'facial',
        duration: '2:30',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];
  }

  /// ✅ Add a newly created local reel to the top and initialize its controller
  Future<void> addLocalReel(ReelsModel reel) async {
    reelsList.insert(0, reel);
    await initializeVideoController(reel.id ?? UniqueKey().toString(), reel.videoUrl);
    await playVideoAtIndex(0);
  }

  /// ✅ Share reel functionality
  void _shareReel(ReelsModel reel) {
    // TODO: Implement share functionality
    // This could use share_plus package or native sharing
    print('Sharing reel: ${reel.title}');
  }

  /// ✅ Navigate to comments screen
  void _navigateToComments(ReelsModel reel) {
    // TODO: Navigate to comments screen
    // Get.toNamed(AppRoutes.reelsComments, arguments: reel);
    print('Opening comments for reel: ${reel.title}');
  }

  /// ✅ Update like status via API
  Future<void> _updateLikeStatus(String? reelId, bool isLiked) async {
    if (reelId == null) return;

    try {
      await reelServices.toggleLike(reelId, isLiked);
    } catch (e) {
      // Handle error silently or show toast
      print('Failed to update like status: $e');
    }
  }

  /// ✅ Update follow status via API
  Future<void> _updateFollowStatus(String? reelId, bool isFollowing) async {
    if (reelId == null) return;

    try {
      // Note: This would need the author's user ID, not the reel ID
      // For now, we'll use the reel ID as a placeholder
      await reelServices.toggleFollow(reelId, isFollowing);
    } catch (e) {
      // Handle error silently or show toast
      print('Failed to update follow status: $e');
    }
  }

}