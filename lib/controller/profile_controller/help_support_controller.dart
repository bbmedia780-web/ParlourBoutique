import 'package:get/get.dart';
import 'package:parlour_app/controller/profile_controller/support_ticket_model.dart';
import 'package:parlour_app/constants/app_strings.dart';
import 'package:parlour_app/routes/app_routes.dart';

class HelpSupportController extends GetxController {
  final RxList<SupportTicketModel> supportTickets = <SupportTicketModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSupportTickets();
  }

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
        isSelected: true, // This is the selected ticket with blue line
      ),
    ];
  }

  void onViewTicketTapped(SupportTicketModel ticket) {
    // Update selection state
    for (int i = 0; i < supportTickets.length; i++) {
      supportTickets[i] = supportTickets[i].copyWith(
        isSelected: supportTickets[i].id == ticket.id,
      );
    }
    
    // Navigate to help chat screen
    Get.toNamed(AppRoutes.helpChat);
  }

  void onAddNewTicket() {
    // Navigate to create new ticket screen
    Get.toNamed(AppRoutes.supportTicketForm);
  }
}
