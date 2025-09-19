import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parlour_app/constants/app_strings.dart';

class HelpChatController extends GetxController {
  // ---------------- State ----------------
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final TextEditingController messageController = TextEditingController();

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    _loadInitialMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  // ---------------- Initial Messages ----------------
  /// Load default welcome messages
  void _loadInitialMessages() {
    messages.value = [
      {
        'type': AppStrings.messageTypeAgent,
        'message': AppStrings.helpChatWelcomeMessage,
        'time': AppStrings.helpChatTime1130AM,
      },
      {
        'type': AppStrings.messageTypeUser,
        'message': AppStrings.helpChatUserHi,
        'time': AppStrings.helpChatTime1131AM,
      },
      {
        'type': AppStrings.messageTypeAgent,
        'message': AppStrings.helpChatAgentResponse,
        'time': AppStrings.helpChatTime1132AM,
      },
      {
        'type': AppStrings.messageTypeUser,
        'message': AppStrings.helpChatUserYes,
        'time': AppStrings.helpChatTime1133AM,
      },
    ];
  }

  // ---------------- Send Message ----------------
  /// Sends user message and triggers simulated agent response
  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    messages.add({
      'type': AppStrings.messageTypeUser,
      'message': text,
      'time': _getCurrentTime(),
    });

    messageController.clear();

    // Simulate agent response after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      messages.add({
        'type': AppStrings.messageTypeAgent,
        'message': AppStrings.helpChatAgentAutoResponse,
        'time': _getCurrentTime(),
      });
    });
  }

  // ---------------- Helpers ----------------
  /// Get current time in `hh:mm AM/PM` format
  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour == 0 ? 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? AppStrings.timePM : AppStrings.timeAM;
    return '$hour:$minute $period';
  }
}
