import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../common/common_button.dart';
import '../../common/modal_components.dart';
import '../../common/tool_button.dart';
import '../widget/video_preview_widget.dart';
import '../../common/overlay_widget.dart';
import '../../controller/upload_creation_controller.dart';
import '../../controller/effect_controller.dart';
import '../../controller/media_selection_controller.dart';

class UploadCreationScreen extends StatelessWidget {
  UploadCreationScreen({super.key});

  final UploadCreationController controller = Get.find<UploadCreationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
        child: Column(
          children: [
            Expanded(child: _buildVideoPreview()),
            const SizedBox(height: AppSizes.spacing12),
            _buildVideoSelectionButtons(),
            const SizedBox(height: AppSizes.spacing12),
            _buildToolButtons(context),
            const SizedBox(height: AppSizes.spacing16),
            _buildUploadButton(),
            const SizedBox(height: AppSizes.spacing20),
          ],
        ),
        ),
      ),
    );
  }

  /// Builds the app bar with settings and close buttons
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.settings, color: AppColors.black),
        onPressed: () {
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  /// Builds the video preview section
  Widget _buildVideoPreview() {
    return Center(
      child: Obx(() {
        final videoController = controller.videoController;
        final overlayController = controller.overlayController;
        final effectController = controller.effectController;

        return VideoPreviewWidget(
          videoFile: videoController.selectedVideo.value,
          videoController: videoController.previewController,
          isInitialized: videoController.isPreviewInitialized.value,
          colorFilter: effectController.currentColorFilter,
          overlays: [
            OverlayCollection(
              overlays: overlayController.overlays,
              onOverlayActive: controller.startEditing,
            ),
          ],
        );
      }),
    );
  }

  /// Builds video selection buttons
  Widget _buildVideoSelectionButtons() {
    return Obx(() {
      final hasVideo = controller.videoController.selectedVideo.value != null;
      
      if (hasVideo) {
        return const SizedBox.shrink();
      }

      return VideoSelectionButtons(
        onRecordVideo: controller.recordVideoFromCamera,
        onPickFromGallery: controller.pickVideoFromGallery,
      );
    });
  }

  /// Builds the tool buttons row
  Widget _buildToolButtons(BuildContext context) {
    final tools = [
      ToolButtonData(
        label: AppStrings.music,
        icon: Icons.music_note,
        onTap: () => _openMusicPicker(context),
      ),
      ToolButtonData(
        label: AppStrings.text,
        icon: Icons.text_fields,
        onTap: () => _openTextAdder(context),
      ),
      ToolButtonData(
        label: AppStrings.effect,
        icon: Icons.auto_fix_high,
        onTap: () => _openEffectPicker(context),
      ),
      ToolButtonData(
        label: AppStrings.sticker,
        icon: Icons.emoji_emotions_outlined,
        onTap: () => _openStickerPicker(context),
      ),
      ToolButtonData(
        label: AppStrings.location,
        icon: Icons.location_on_outlined,
        onTap: () => _openLocationPicker(context),
      ),
      ToolButtonData(
        label: AppStrings.hashtag,
        icon: Icons.tag,
        onTap: () => _openHashtagPicker(context),
      ),
    ];

    return ToolButtonRow(tools: tools);
  }

  /// Builds the upload button
  Widget _buildUploadButton() {
    return Obx(() {
      final isUploading = controller.isUploading.value;
      return AppButton(
        text: isUploading ? AppStrings.uploading : AppStrings.upload,
        onPressed: isUploading ? null : () => controller.upload(),
        width: double.infinity,
        height: AppSizes.spacing45,
      );
    });
  }

  // Modal picker methods using the new reusable components
  void _openMusicPicker(BuildContext context) {
    final mediaController = controller.mediaController;
    ModalComponents.showListPicker(
      context: context,
      title: AppStrings.selectMusic,
      items: MediaSelectionController.availableMusic,
      selectedItem: mediaController.selectedMusic.value,
      onItemSelected: controller.chooseMusic,
    );
  }

  void _openTextAdder(BuildContext context) {
    ModalComponents.showTextInputDialog(
      context: context,
      title: AppStrings.addText,
      hintText: AppStrings.enterTextToAddToVideo,
      onConfirm: controller.addText,
    );
  }

  void _openStickerPicker(BuildContext context) {
    final mediaController = controller.mediaController;
    ModalComponents.showChipPicker(
      context: context,
      title: AppStrings.selectStickers,
      items: MediaSelectionController.availableStickers,
      selectedItems: mediaController.selectedStickers,
      onItemToggled: controller.toggleSticker,
    );
  }

  void _openEffectPicker(BuildContext context) {
    final effectController = controller.effectController;
    ModalComponents.showListPicker(
      context: context,
      title: AppStrings.selectEffect,
      items: EffectController.availableEffects,
      selectedItem: effectController.selectedEffect.value,
      onItemSelected: controller.chooseEffect,
    );
  }

  void _openLocationPicker(BuildContext context) {
    final mediaController = controller.mediaController;
    ModalComponents.showRadioPicker(
      context: context,
      title: AppStrings.selectLocation,
      items: MediaSelectionController.availableLocations,
      selectedItem: mediaController.selectedLocation.value,
      onItemSelected: controller.chooseLocation,
    );
  }

  void _openHashtagPicker(BuildContext context) {
    final mediaController = controller.mediaController;
    ModalComponents.showChipPicker(
      context: context,
      title: AppStrings.selectHashtags,
      items: MediaSelectionController.popularHashtags,
      selectedItems: mediaController.selectedHashtags,
      onItemToggled: controller.toggleHashtag,
    );
  }
}
