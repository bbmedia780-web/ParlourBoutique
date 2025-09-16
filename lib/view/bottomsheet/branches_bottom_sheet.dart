import 'package:flutter/material.dart';
import 'package:parlour_app/view/widget/branch_tile_widget.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../model/details_model.dart';

class BranchesBottomSheet extends StatelessWidget {
  final List<BranchModel> branches;
  final String title;

  const BranchesBottomSheet({
    super.key,
    required this.branches,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.spacing20),
          topRight: Radius.circular(AppSizes.spacing20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(AppSizes.spacing16),
                itemCount: branches.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSizes.spacing12),
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  return BranchTileWidget(branch: branch);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
