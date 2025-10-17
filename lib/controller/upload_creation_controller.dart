import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/global.dart';
import '../constants/app_strings.dart';
import '../constants/app_colors.dart';
import 'package:parlour_app/controller/home_controller/reels_controller.dart';
import '../../model/reels_model.dart';
import 'video_editor_controller.dart';
import 'overlay_controller.dart';
import 'effect_controller.dart';
import 'media_selection_controller.dart';

/// Main controller for upload creation screen
/// Coordinates between different specialized controllers
class UploadCreationController extends GetxController {
  // Specialized controllers
  late final VideoEditorController _videoController;
  late final OverlayController _overlayController;
  late final EffectController _effectController;
  late final MediaSelectionController _mediaController;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    _videoController = Get.find<VideoEditorController>();
    _overlayController = Get.find<OverlayController>();
    _effectController = Get.find<EffectController>();
    _mediaController = Get.find<MediaSelectionController>();
  }

  // Getters for easy access to controller properties
  VideoEditorController get videoController => _videoController;
  OverlayController get overlayController => _overlayController;
  EffectController get effectController => _effectController;
  MediaSelectionController get mediaController => _mediaController;

  // Delegate methods to specialized controllers
  Future<void> pickVideoFromGallery() => _videoController.pickVideoFromGallery();
  Future<void> recordVideoFromCamera() => _videoController.recordVideoFromCamera();
  
  void chooseMusic(String music) => _mediaController.chooseMusic(music);
  void addText(String text) => _overlayController.addTextOverlay(text);
  void toggleSticker(String sticker) => _overlayController.addStickerOverlay(sticker);
  void chooseEffect(String effect) => _effectController.chooseEffect(effect);
  void chooseLocation(String location) => _mediaController.chooseLocation(location);
  void toggleHashtag(String tag) => _mediaController.toggleHashtag(tag);

  // Loading state
  final RxBool isUploading = false.obs;

  /// Upload the video with all selected effects and overlays
  Future<void> upload() async {
    final file = _videoController.selectedVideo.value;
    if (file == null) {
      ShowToast.warning(AppStrings.pleaseSelectOrRecordVideo);
      return;
    }

    // Prevent multiple uploads
    if (isUploading.value) {
      return;
    }

    try {
      isUploading.value = true;

      // Properly dispose preview controller to free MediaCodec resources
      await _videoController.disposePreview();
      
      // Add delay to ensure MediaCodec is fully released
      await Future.delayed(const Duration(milliseconds: 200));

      // Create reel model
      final newReel = _createReelsModel(file);
      
      // Insert into reels
      if (Get.isRegistered<ReelsController>()) {
        final rc = Get.find<ReelsController>();
        await rc.addLocalReel(newReel);
        
        // Toast message removed - Success toasts are disabled per requirement
      } else {
        throw Exception('ReelsController not found');
      }

      // Clear uploaded video and reset state
      _videoController.selectedVideo.value = null;
      _overlayController.clearAllOverlays();
      _mediaController.clearAllSelections();

      // Navigate back after upload
      Get.back();
    } catch (e) {
      print('DEBUG: Upload error: $e');
      ShowToast.error('${AppStrings.failedToUploadVideo}: $e');
    } finally {
      isUploading.value = false;
    }
  }

  /// Create a ReelsModel from current selections
  ReelsModel _createReelsModel(dynamic file) {
    final hashtags = _mediaController.selectedHashtags;
    final texts = _overlayController.overlays
        .where((overlay) => overlay.type == OverlayType.text)
        .map((overlay) => overlay.text ?? '')
        .toList();

    return ReelsModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      videoUrl: file.path,
      thumbnailUrl: '',
      title: hashtags.isNotEmpty ? hashtags.join(' ') : 'New Reel',
      description: texts.join(' | '),
      authorName: 'You',
      authorProfileImage: '',
      musicTitle: _mediaController.selectedMusic.value,
      likesCount: 0,
      commentsCount: 0,
      sharesCount: 0,
      isLiked: false,
      isFollowing: true,
      category: 'beauty',
      duration: '0:00',
      createdAt: DateTime.now(),
    );
  }

  // Delegate overlay methods
  void startEditing(String id) => _overlayController.startEditing(id);
  void moveActive(Offset delta) => _overlayController.moveActive(delta);
  void scaleRotateActive(double scale, double rotation) =>
      _overlayController.scaleRotateActive(scale, rotation);
  void removeActive() => _overlayController.removeActive();

  // Gesture handling for overlay interactions
  void onOverlayScaleStart(ScaleStartDetails details) {
    _overlayController.onScaleStart(details);
  }

  void onOverlayScaleUpdate(ScaleUpdateDetails details) {
    _overlayController.onScaleUpdate(details);
  }
}
