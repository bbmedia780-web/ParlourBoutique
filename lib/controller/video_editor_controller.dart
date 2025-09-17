import 'dart:io';
import 'package:flutter/material.dart';
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
      await previewController?.dispose();
      previewController = VideoPlayerController.file(File(path));
      await previewController!.initialize();
      previewController!.setLooping(true);
      await previewController!.play();
      isPreviewInitialized.value = true;
    } catch (e) {
      _showError('Failed to initialize video preview: $e');
      isPreviewInitialized.value = false;
    }
  }

  void _showError(String message) {
    ShowSnackBar.show(AppStrings.error, message, backgroundColor: AppColors.red);
  }

  @override
  void onClose() {
    previewController?.dispose();
    super.onClose();
  }
}
