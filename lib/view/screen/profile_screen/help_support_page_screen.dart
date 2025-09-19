import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_assets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_style.dart';
import '../../../controller/profile_controller/help_support_controller.dart';
import '../../../model/support_ticket_model.dart';


class HelpSupportPageView extends StatelessWidget {
  HelpSupportPageView({super.key});

  final HelpSupportController controller = Get.find<HelpSupportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.black,
          size: AppSizes.spacing20,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
       AppStrings.helpSupport.tr,
        style: AppTextStyles.appBarText
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Image.asset(
            AppAssets.helpSupportAdd,
            height: AppSizes.spacing24,
            scale: AppSizes.scaleSize,
          ),
          onPressed: controller.onAddNewTicket,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing20),
      child: Obx(() => _buildSupportTicketsList()),
    );
  }

  Widget _buildSupportTicketsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
      itemCount: controller.supportTickets.length,
      separatorBuilder: (context, index) =>
      const SizedBox(height: AppSizes.spacing12),
      itemBuilder: (context, index) {
        final ticket = controller.supportTickets[index];
        return _buildSupportTicketCard(ticket);
      },
    );
  }

  Widget _buildSupportTicketCard(SupportTicketModel ticket) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.spacing12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ticket Number
          Text(
            ticket.ticketNumber,
            style: AppTextStyles.tickerText
          ),

          const SizedBox(height: AppSizes.spacing6),

          // Dotted line
          DottedLine(
            dashColor: AppColors.lightGrey,
            lineThickness: 1,
            dashLength: 4,
            dashGapLength: 3,
          ),

          const SizedBox(height: AppSizes.spacing8),

          // Row with Issue/Date + View Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Issue & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.issue,
                      style: AppTextStyles.helpCardSubTitle
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Text(
                      ticket.date,
                      style: AppTextStyles.paymentHistoryDate
                    ),
                  ],
                ),
              ),

              // Right: View Button
              _buildViewButton(ticket),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton(SupportTicketModel ticket) {
    return Container(
      height: AppSizes.spacing32,
      width: AppSizes.size70,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing6,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(AppSizes.spacing6),
      ),
      child: TextButton(
        onPressed: () => controller.onViewTicketTapped(ticket),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          AppStrings.view.tr,
          style: AppTextStyles.priceText
        ),
      ),
    );
  }
}
