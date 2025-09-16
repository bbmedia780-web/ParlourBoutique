import 'package:flutter/cupertino.dart';
import 'package:parlour_app/constants/app_assets.dart';
import 'package:parlour_app/model/details_model.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_style.dart';

class BranchTileWidget extends StatelessWidget {
  final BranchModel branch;

  const BranchTileWidget({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.spacing20,
        right: AppSizes.spacing20,
        top: AppSizes.spacing10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(branch.name, style: AppTextStyles.inputText),
                    ),
                    Image.asset(
                      AppAssets.star,
                      height: AppSizes.spacing16,
                      scale: AppSizes.scaleSize,
                    ),
                    const SizedBox(width: AppSizes.spacing6),
                    Text(
                      branch.rating.toString(),
                      style: AppTextStyles.welcomePageDes,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing4),
                Row(
                  children: [
                    Image.asset(AppAssets.location, height: AppSizes.spacing20),
                    const SizedBox(width: AppSizes.spacing6),
                    Expanded(
                      child: Text(
                        branch.address,
                        style: AppTextStyles.hintText,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
