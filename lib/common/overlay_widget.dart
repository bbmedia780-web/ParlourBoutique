import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/overlay_controller.dart';
import '../controller/upload_creation_controller.dart';
import '../constants/app_text_style.dart';

/// A reusable overlay widget for text and stickers on video
class OverlayWidget extends StatelessWidget {
  final OverlayItem item;
  final VoidCallback onActive;
  final VoidCallback? onRemove;

  const OverlayWidget({
    super.key,
    required this.item,
    required this.onActive,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: item.position.dx,
      top: item.position.dy,
      child: GestureDetector(
        onTap: onActive,
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: _buildOverlayContent(),
      ),
    );
  }

  Widget _buildOverlayContent() {
    return Transform.rotate(
      angle: item.rotation,
      child: Transform.scale(
        scale: item.scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: item.type == OverlayType.text
                ? Colors.black26
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: _buildOverlayText(),
        ),
      ),
    );
  }

  Widget _buildOverlayText() {
    if (item.type == OverlayType.text) {
      return Text(
        item.text ?? '',
        style: AppTextStyles.whiteMediumText,
      );
    } else {
      return Text(
        item.emoji ?? '',
        style: AppTextStyles.whiteLargeText,
      );
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    onActive();
    final controller = Get.find<UploadCreationController>();
    controller.onOverlayScaleStart(details);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final controller = Get.find<UploadCreationController>();
    controller.onOverlayScaleUpdate(details);
  }
}

/// A collection of overlay widgets
class OverlayCollection extends StatelessWidget {
  final List<OverlayItem> overlays;
  final Function(String) onOverlayActive;

  const OverlayCollection({
    super.key,
    required this.overlays,
    required this.onOverlayActive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: overlays
          .map((overlay) => OverlayWidget(
                item: overlay,
                onActive: () => onOverlayActive(overlay.id),
              ))
          .toList(),
    );
  }
}
