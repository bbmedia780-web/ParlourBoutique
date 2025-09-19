import 'package:get/get.dart';
import '../../constants/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../model/support_ticket_model.dart';

class HelpSupportController extends GetxController {
  // ---------------- State ----------------
  /// List of support tickets
  final RxList<SupportTicketModel> supportTickets = <SupportTicketModel>[].obs;

  // ---------------- Lifecycle ----------------
  @override
  void onInit() {
    super.onInit();
    _loadSupportTickets();
  }

  // ---------------- Load Tickets ----------------
  /// Initialize tickets with sample data
  void _loadSupportTickets() {
    supportTickets.value = [
      SupportTicketModel(
        id: '1',
        ticketNumber: AppStrings.ticketNumber1234,
        issue: AppStrings.appointmentIssue.tr,
        date: AppStrings.ticketDate10July2025,
        status: AppStrings.ticketStatusOpen,
        isSelected: false,
      ),
      SupportTicketModel(
        id: '2',
        ticketNumber: AppStrings.ticketNumber3234,
        issue: AppStrings.parlourServices.tr,
        date: AppStrings.ticketDate12July2025,
        status: AppStrings.ticketStatusInProgress,
        isSelected: false,
      ),
      SupportTicketModel(
        id: '3',
        ticketNumber: AppStrings.ticketNumber2234,
        issue: AppStrings.other.tr,
        date: AppStrings.ticketDate14July2025,
        status: AppStrings.ticketStatusResolved,
        isSelected: true, // Pre-selected ticket
      ),
    ];
  }

  // ---------------- Actions ----------------
  /// Handles user tapping on a ticket to view details
  void onViewTicketTapped(SupportTicketModel ticket) {
    // Mark only the tapped ticket as selected
    for (int i = 0; i < supportTickets.length; i++) {
      supportTickets[i] = supportTickets[i].copyWith(
        isSelected: supportTickets[i].id == ticket.id,
      );
    }

    // Navigate to Help Chat screen
    Get.toNamed(AppRoutes.helpChat);
  }

  /// Handles adding a new support ticket
  void onAddNewTicket() {
    Get.toNamed(AppRoutes.supportTicketForm);
  }
}
