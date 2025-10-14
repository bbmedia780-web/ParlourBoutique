import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_sizes.dart';
import '../../model/popular_model.dart';
import '../../routes/app_routes.dart';
import '../../utility/navigation_helper.dart';
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
      onTap: () => NavigationHelper.navigateToDetails(data),
      child: SizedBox(
        width: AppSizes.size160,
        child: CommonPopularCard(
          data: data,
          onFavoriteTap: onFavoriteTap,
        ),
      ),
    );
  }
}
