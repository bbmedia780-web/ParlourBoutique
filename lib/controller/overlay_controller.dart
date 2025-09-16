import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing overlay items (text, stickers) on video
class OverlayController extends GetxController {
  // Overlay items to render over preview
  final RxList<OverlayItem> overlays = <OverlayItem>[].obs;
  final RxString activeOverlayId = ''.obs;

  // Gesture state management
  Offset _lastFocalPoint = Offset.zero;
  double _lastScale = 1;
  double _lastRotation = 0;

  /// Start editing a specific overlay
  void startEditing(String id) {
    activeOverlayId.value = id;
  }

  /// Move the active overlay by the given delta
  void moveActive(Offset delta) {
    final index = overlays.indexWhere((e) => e.id == activeOverlayId.value);
    if (index == -1) return;
    
    overlays[index] = overlays[index].copyWith(
      position: overlays[index].position + delta,
    );
  }

  /// Scale and rotate the active overlay
  void scaleRotateActive(double scale, double rotation) {
    final index = overlays.indexWhere((e) => e.id == activeOverlayId.value);
    if (index == -1) return;
    
    overlays[index] = overlays[index].copyWith(
      scale: (overlays[index].scale * scale).clamp(0.4, 5.0),
      rotation: overlays[index].rotation + rotation,
    );
  }

  /// Remove the active overlay
  void removeActive() {
    overlays.removeWhere((e) => e.id == activeOverlayId.value);
    activeOverlayId.value = '';
  }

  /// Add a text overlay
  void addTextOverlay(String text) {
    if (text.trim().isEmpty) return;
    
    final item = OverlayItem.text(text: text.trim());
    overlays.add(item);
    activeOverlayId.value = item.id;
  }

  /// Add a sticker overlay
  void addStickerOverlay(String emoji) {
    final item = OverlayItem.sticker(emoji: emoji);
    overlays.add(item);
    activeOverlayId.value = item.id;
  }

  /// Clear all overlays
  void clearAllOverlays() {
    overlays.clear();
    activeOverlayId.value = '';
  }

  /// Handle scale start gesture
  void onScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _lastScale = 1;
    _lastRotation = 0;
  }

  /// Handle scale update gesture
  void onScaleUpdate(ScaleUpdateDetails details) {
    final delta = details.focalPoint - _lastFocalPoint;
    moveActive(delta);
    scaleRotateActive(
      details.scale / _lastScale,
      details.rotation - _lastRotation,
    );
    _lastFocalPoint = details.focalPoint;
    _lastScale = details.scale;
    _lastRotation = details.rotation;
  }
}

/// Data class for overlay items
class OverlayItem {
  final String id;
  final OverlayType type;
  final String? text;
  final String? emoji;
  final Offset position;
  final double scale;
  final double rotation; // radians
  final Color color;

  OverlayItem._({
    required this.id,
    required this.type,
    this.text,
    this.emoji,
    this.position = const Offset(100, 100),
    this.scale = 1,
    this.rotation = 0,
    this.color = const Color(0xFFFFFFFF),
  });

  factory OverlayItem.text({required String text}) => OverlayItem._(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: OverlayType.text,
        text: text,
        color: const Color(0xFFFFFFFF),
      );

  factory OverlayItem.sticker({required String emoji}) => OverlayItem._(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: OverlayType.sticker,
        emoji: emoji,
      );

  OverlayItem copyWith({
    Offset? position,
    double? scale,
    double? rotation,
    String? text,
    Color? color,
  }) {
    return OverlayItem._(
      id: id,
      type: type,
      text: text ?? this.text,
      emoji: emoji,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      color: color ?? this.color,
    );
  }
}

enum OverlayType { text, sticker }
