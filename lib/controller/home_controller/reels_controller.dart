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
