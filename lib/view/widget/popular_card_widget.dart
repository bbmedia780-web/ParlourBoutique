import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_sizes.dart';
import '../../model/popular_model.dart';
import '../../routes/app_routes.dart';
import 'common_popular_card_widget.dart';

class PopularCard extends StatelessWidget {
  final PopularModel data;
  final VoidCallback onFavoriteTap;
  final VoidCallback? onCardTap;

  const PopularCard({
    super.key,
    required this.data,
    required this.onFavoriteTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.details, arguments: data),
      child: SizedBox(
        width: AppSizes.size180,
        child: CommonPopularCard(
          data: data,
          onFavoriteTap: onFavoriteTap,
        ),
      ),
    );
  }
}
