import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_style.dart';
import '../../constants/app_sizes.dart';
import '../../controller/home_controller/reels_controller.dart';
import '../../model/reels_model.dart';

class ReelsScreen extends StatelessWidget {
  ReelsScreen({super.key});

  final ReelsController controller = Get.find<ReelsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(() {
          // Ensure playback is controlled by active tab state
          // (UI still builds; controller manages play/pause)
          if (controller.isLoading.value && controller.reelsList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.reelsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 100,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Error Loading Reels',
                    style: AppTextStyles.appBarText.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    controller.errorMessage.value,
                    style: AppTextStyles.hintText.copyWith(
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => controller.loadDummyData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return _buildReelsList(controller);
        }),
    );
  }

  Widget _buildReelsList(ReelsController controller) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: controller.reelsList.length + (controller.hasMoreData ? 1 : 0),
      onPageChanged: controller.onPageChanged,
      itemBuilder: (context, index) {
        if (index < controller.reelsList.length) {
          return _buildReelItem(
            context,
            index,
            controller.reelsList[index],
            controller,
          );
        } else {
          // Loading indicator for pagination
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
      },
    );
  }

  Widget _buildReelItem(
    BuildContext context,
    int index,
    ReelsModel reel,
    ReelsController controller,
  ) {
    final videoController = controller.getVideoController(reel.id!);
    final EdgeInsets viewPadding = MediaQuery.of(context).padding;
    final double bottomSafeInset = viewPadding.bottom;

    return GestureDetector(
      onTap: controller.onVideoTap,
      onDoubleTap: () => controller.toggleLike(index),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.black,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.spacing8),
          child: Stack(
          children: [
            // Video player - full screen cover
            if (videoController != null && videoController.value.isInitialized)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: videoController.value.size.width,
                    height: videoController.value.size.height,
                    child: VideoPlayer(videoController),
                  ),
                ),
              )
            else
              // Fallback while video initializes
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: reel.thumbnailUrl.startsWith('http')
                    ? Image.network(
                        reel.thumbnailUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        cacheWidth: 400, // Reduce memory by caching at lower resolution
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (frame == null) {
                            return const Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            );
                          }
                          return child;
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error, color: AppColors.white),
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
              ),

            // Play/Pause overlay indicator
            if (videoController != null && videoController.value.isInitialized)
              _buildPlayPauseOverlay(videoController),

            // Bottom gradient overlay for readability
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: AppSizes.size200,
              child: IgnorePointer(
                ignoring: true,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Right side interaction buttons
            Positioned(
              right: AppSizes.spacing16,
              bottom: bottomSafeInset + AppSizes.size70,
              child: Column(
                children: [
                  _buildActionButton(
                    icon: Icons.favorite,
                    count: reel.formattedLikesCount,
                    isActive: reel.isLiked,
                    onTap: () => controller.toggleLike(index),
                  ),
                  const SizedBox(height: AppSizes.spacing20),
                  _buildActionButton(
                    icon: Icons.chat_bubble_outline,
                    count: reel.formattedCommentsCount,
                    onTap: () => controller.commentOnReel(index),
                  ),
                  const SizedBox(height: AppSizes.spacing20),
                  _buildActionButton(
                    icon: Icons.share,
                    count: reel.formattedSharesCount,
                    onTap: () => controller.shareReel(index),
                  ),
                  const SizedBox(height: AppSizes.spacing20),
                  _buildActionButton(
                    icon: Icons.more_vert,
                    onTap: () => _showMoreOptions(context, reel),
                  ),
                ],
              ),
            ),

            // (Removed top-right mute/unmute icon per request)

            // Bottom-left pill info and description
            Positioned(
              left: AppSizes.spacing12,
              right: AppSizes.size80,
              bottom: bottomSafeInset + AppSizes.size70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacing12,
                      vertical: AppSizes.spacing8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(AppSizes.spacing24),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: AppSizes.spacing14,
                          backgroundColor: AppColors.grey,
                          backgroundImage: reel.authorProfileImage.startsWith('http')
                              ? NetworkImage(reel.authorProfileImage)
                              : null,
                          child: !reel.authorProfileImage.startsWith('http')
                              ? const Icon(Icons.person, color: Colors.white, size: 16)
                              : null,
                        ),
                        const SizedBox(width: AppSizes.spacing8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                reel.title,
                                style: AppTextStyles.captionTitle.copyWith(
                                  color: AppColors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                reel.authorName,
                                style: AppTextStyles.captionText.copyWith(
                                  color: AppColors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing6),
                  Text(
                    reel.description,
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildPlayPauseOverlay(VideoPlayerController videoController) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: videoController,
      builder: (context, value, child) {
        final isPlaying = value.isPlaying;
        return AnimatedOpacity(
          opacity: isPlaying ? 0.0 : 0.7,
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(AppSizes.spacing20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.white,
                size: AppSizes.spacing40,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    String? count,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.white,
              size: AppSizes.spacing24,
            ),
          ),
          if (count != null) ...[
            const SizedBox(height: AppSizes.spacing4),
            Text(
              count,
              style: AppTextStyles.captionText.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context, ReelsModel reel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.spacing20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.spacing20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.spacing40,
              height: AppSizes.spacing4,
              decoration: BoxDecoration(
                color: AppColors.slightGrey,
                borderRadius: BorderRadius.circular(AppSizes.spacing2),
              ),
            ),
            const SizedBox(height: AppSizes.spacing20),
            _buildOptionItem(
              icon: Icons.report,
              title: 'Report',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement report functionality
              },
            ),
            _buildOptionItem(
              icon: Icons.block,
              title: 'Block User',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement block functionality
              },
            ),
            _buildOptionItem(
              icon: Icons.copy,
              title: 'Copy Link',
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement copy link functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: onTap,
    );
  }
}
