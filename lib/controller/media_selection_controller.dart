import 'package:get/get.dart';

/// Controller for managing media selections (music, stickers, locations, hashtags)
class MediaSelectionController extends GetxController {
  // Available options
  static const List<String> availableMusic = [
    'Romantic vibe',
    'Epic beat',
    'Calm piano',
    'Dance pop',
  ];

  static const List<String> availableStickers = [
    '❤️', '✨', '🎉', '🌸', '🔥', '⭐️'
  ];

  static const List<String> availableLocations = [
    'Surat', 'Ahmedabad', 'Mumbai', 'Delhi'
  ];

  static const List<String> popularHashtags = [
    '#bridal', '#makeup', '#hair', '#beauty', '#fashion'
  ];

  // User selections
  final RxString selectedMusic = ''.obs;
  final RxList<String> selectedStickers = <String>[].obs;
  final RxString selectedLocation = ''.obs;
  final RxList<String> selectedHashtags = <String>[].obs;

  /// Choose music
  void chooseMusic(String music) {
    selectedMusic.value = music;
  }

  /// Toggle sticker selection
  void toggleSticker(String sticker) {
    if (selectedStickers.contains(sticker)) {
      selectedStickers.remove(sticker);
    } else {
      selectedStickers.add(sticker);
    }
  }

  /// Choose location
  void chooseLocation(String location) {
    selectedLocation.value = location;
  }

  /// Toggle hashtag selection
  void toggleHashtag(String tag) {
    if (selectedHashtags.contains(tag)) {
      selectedHashtags.remove(tag);
    } else {
      selectedHashtags.add(tag);
    }
  }

  /// Clear all selections
  void clearAllSelections() {
    selectedMusic.value = '';
    selectedStickers.clear();
    selectedLocation.value = '';
    selectedHashtags.clear();
  }
}
