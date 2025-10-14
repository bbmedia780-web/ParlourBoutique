import 'dart:io';
import 'package:get/get.dart';
import '../utility/global.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

/// Controller for video editing functionality
class VideoEditorController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Video state
  final Rx<File?> selectedVideo = Rx<File?>(null);
  VideoPlayerController? previewController;
  final RxBool isPreviewInitialized = false.obs;

  // Video selection methods
  Future<void> pickVideoFromGallery() async {
    try {
      final XFile? xFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );
      
      if (xFile != null) {
        await _setVideoFile(File(xFile.path));
      }
    } catch (e) {
      _showError('Failed to pick video from gallery: $e');
    }
  }

  Future<void> recordVideoFromCamera() async {
    try {
      final XFile? xFile = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5),
      );
      
      if (xFile != null) {
        await _setVideoFile(File(xFile.path));
      }
    } catch (e) {
      _showError('Failed to record video: $e');
    }
  }

  Future<void> _setVideoFile(File file) async {
    selectedVideo.value = file;
    await _initializePreview(file.path);
  }

  Future<void> _initializePreview(String path) async {
    try {
      // Properly dispose existing controller
      if (previewController != null) {
        await previewController!.pause();
        await previewController!.dispose();
        previewController = null;
        isPreviewInitialized.value = false;
      }

      // Add a small delay to ensure MediaCodec is released
      await Future.delayed(const Duration(milliseconds: 100));

      // Create and initialize new controller
      previewController = VideoPlayerController.file(File(path));
      await previewController!.initialize();
      previewController!.setLooping(true);
      await previewController!.play();
      isPreviewInitialized.value = true;
    } catch (e) {
      _showError('Failed to initialize video preview: $e');
      isPreviewInitialized.value = false;
      previewController?.dispose();
      previewController = null;
    }
  }

  void _showError(String message) {
    ShowToast.error(message);
  }

  @override
  void onClose() {
    _disposeController();
    super.onClose();
  }

  /// Properly dispose video controller
  Future<void> _disposeController() async {
    try {
      if (previewController != null) {
        await previewController!.pause();
        await previewController!.dispose();
        previewController = null;
        isPreviewInitialized.value = false;
      }
    } catch (e) {
      print('Error disposing video controller: $e');
    }
  }

  /// Public method to dispose controller
  Future<void> disposePreview() async {
    await _disposeController();
  }
}
