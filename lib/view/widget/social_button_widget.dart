import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

class SocialCircleButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final double imageSize;

  const SocialCircleButton({
    super.key,
    required this.assetPath,
    required this.onTap,
    this.imageSize = AppSizes.spacing30
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: SizedBox(
          width: imageSize,
          height: imageSize,
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
