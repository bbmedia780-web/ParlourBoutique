import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';

/// A reusable video preview widget with overlay support
class VideoPreviewWidget extends StatelessWidget {
  final File? videoFile;
  final VideoPlayerController? videoController;
  final bool isInitialized;
  final List<Widget> overlays;
  final ColorFilter? colorFilter;
  final String placeholderText;

  const VideoPreviewWidget({
    super.key,
    this.videoFile,
    this.videoController,
    this.isInitialized = false,
    this.overlays = const [],
    this.colorFilter,
    this.placeholderText = 'Select or record a video',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.spacing16),
      child: Container(
        color: AppColors.extraLightGrey,
        width: double.infinity,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (videoFile == null || !isInitialized || videoController == null) {
      return _buildPlaceholder();
    }

    return AspectRatio(
      aspectRatio: videoController!.value.aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildVideoPlayer(),
          ...overlays,
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_outlined,
            size: AppSizes.spacing48,
            color: AppColors.mediumGrey,
          ),
          const SizedBox(height: AppSizes.spacing12),
          Text(
            placeholderText,
            style: AppTextStyles.greyVerySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    Widget videoPlayer = VideoPlayer(videoController!);
    
    if (colorFilter != null) {
      videoPlayer = ColorFiltered(
        colorFilter: colorFilter!,
        child: videoPlayer,
      );
    }
    
    return videoPlayer;
  }
}

/// A widget for video selection buttons
class VideoSelectionButtons extends StatelessWidget {
  final VoidCallback onRecordVideo;
  final VoidCallback onPickFromGallery;

  const VideoSelectionButtons({
    super.key,
    required this.onRecordVideo,
    required this.onPickFromGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSelectionButton(
          icon: Icons.videocam,
          label: 'Record',
          onTap: onRecordVideo,
        ),
        const SizedBox(width: AppSizes.spacing16),
        _buildSelectionButton(
          icon: Icons.video_library,
          label: 'Gallery',
          onTap: onPickFromGallery,
        ),
      ],
    );
  }

  Widget _buildSelectionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.size50,
          height: AppSizes.size50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.spacing8),
            border: Border.all(color: AppColors.primary),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: AppSizes.spacing6),
        Text(
          label,
          style: AppTextStyles.grayTiny.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
