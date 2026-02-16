import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_sizes.dart';

class AppTextStyles {
  // ----------------- BLACK TEXTS -----------------
  static TextStyle heading1 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    letterSpacing: -0.3,
  );

  // Heading - Medium (for section titles)
  static TextStyle heading2 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    letterSpacing: -0.2,
  );

  // Sub-heading - Medium (for descriptions)
  static TextStyle subHeading = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
    height: 1.3,
  );

  // Normal text - Regular (for body text)
  static TextStyle regular = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
    height: 1.4,
  );
  static final TextStyle displayText = GoogleFonts.inter(
    fontSize: AppSizes.display,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final TextStyle appBarText = GoogleFonts.inter(
    fontSize: AppSizes.subHeading,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle welcomeBack = GoogleFonts.sansita(
    fontSize: AppSizes.largeHeading,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final TextStyle welcomePageTitle = GoogleFonts.inter(
    fontSize: AppSizes.heading,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle bottomSheetHeading = GoogleFonts.inter(
    fontSize: AppSizes.titleLarge,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle tickerText = GoogleFonts.inter(
    fontSize: AppSizes.title,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static final TextStyle titleText = GoogleFonts.inter(
    fontSize: AppSizes.title,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static final TextStyle titleSmall = GoogleFonts.inter(
    fontSize: AppSizes.titleSmall,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle inputText = GoogleFonts.inter(
    fontSize: AppSizes.body,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static final TextStyle bodyTitle = GoogleFonts.inter(
    fontSize: AppSizes.body,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle cardTitle = GoogleFonts.inter(
    fontSize: AppSizes.bodySmall,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle profilePageText = GoogleFonts.inter(
    fontSize: AppSizes.bodySmall,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static final TextStyle bodySmallText = GoogleFonts.inter(
    fontSize: AppSizes.bodySmall,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static final TextStyle bodyText = GoogleFonts.inter(
    fontSize: AppSizes.body,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static final TextStyle faqsPageText = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static final TextStyle hashTag = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w500,
    color: AppColors.kBlueGrey,
  );

  static final TextStyle captionTitle = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final TextStyle captionText = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static final TextStyle captionMediumTitle = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static final TextStyle smallTitle = GoogleFonts.inter(
    fontSize: AppSizes.small,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle homeBanner = GoogleFonts.neuton(
    fontSize: AppSizes.heading,
    color: AppColors.black,
    fontWeight: FontWeight.bold,
  );

  // ----------------- WHITE TEXTS -----------------

  static final TextStyle whiteHeadingText = GoogleFonts.inter(
    fontSize: AppSizes.subHeading,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static final TextStyle buttonText = GoogleFonts.inter(
    fontSize: AppSizes.titleSmall,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static final TextStyle whiteNameText = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static final TextStyle whiteNormalText = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static final TextStyle whiteCaptionText = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );


  static final TextStyle whiteAddressText = GoogleFonts.inter(
    fontSize: AppSizes.small,
    color: AppColors.extraLightGrey,
  );

  static final TextStyle whiteSmallText = GoogleFonts.inter(
    fontSize: AppSizes.small,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final TextStyle whiteLargeText = GoogleFonts.inter(
    fontSize: AppSizes.largeHeading,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final TextStyle whiteMediumText = GoogleFonts.inter(
    fontSize: AppSizes.body,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static final TextStyle whiteTinyText = GoogleFonts.inter(
    fontSize: AppSizes.tiny,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final TextStyle homeBannerWhite = GoogleFonts.neuton(
    fontSize: AppSizes.heading,
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );

  // ----------------- GREY TEXTS -----------------

  static final TextStyle skipButtonText = GoogleFonts.inter(
    fontSize: AppSizes.titleSmall,
    fontWeight: FontWeight.w600,
    color: AppColors.mediumGrey,
  );

  static final TextStyle welcomePageDes = GoogleFonts.inter(
    fontSize: AppSizes.bodySmall,
    fontWeight: FontWeight.w500,
    color: AppColors.greyDark,
  );

  static final TextStyle hintText = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w500,
    color: AppColors.mediumGrey,
  );

  static final TextStyle cardSubTitle = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  static final TextStyle reviewTextTitle = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w400,
    color: AppColors.greyDark,
  );

  static final TextStyle paymentHistoryDate = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w300,
    color: AppColors.grey,
  );

  static final TextStyle addressText = GoogleFonts.inter(
    fontSize: AppSizes.caption,
    fontWeight: FontWeight.w400,
    color: AppColors.mediumLightGray,
  );

  static final TextStyle faqsDescriptionText = GoogleFonts.inter(
    fontSize: AppSizes.small,
    fontWeight: FontWeight.w400,
    color: AppColors.greyDark,
  );

  static final TextStyle greyVerySmall = GoogleFonts.inter(
    fontSize: AppSizes.verySmall,
    fontWeight: FontWeight.w300,
    color: AppColors.grey,
  );

  static final TextStyle grayTiny = GoogleFonts.inter(
    fontSize: AppSizes.tiny,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );


  static final TextStyle bottomNavBarText = GoogleFonts.inter(
    fontSize: AppSizes.small,
    fontWeight: FontWeight.w400,
  );

  // ----------------- PINK / PRIMARY TEXTS -----------------

  static final TextStyle lightPinkText = GoogleFonts.inter(
    fontSize: AppSizes.body,
    fontWeight: FontWeight.w500,
    color: AppColors.lightPink,
  );

  static final TextStyle primaryButtonText = GoogleFonts.inter(
    fontSize: AppSizes.body,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static final TextStyle helpCardSubTitle = GoogleFonts.inter(
    fontSize: AppSizes.bodySmall,
    color: AppColors.darkMauve,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle priceText = GoogleFonts.inter(
    fontSize: AppSizes.small,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // ----------------- RED TEXT -----------------

  static final TextStyle redText = GoogleFonts.inter(
    fontSize: AppSizes.bodySmall,
    fontWeight: FontWeight.w500,
    color: AppColors.red,
  );

  // ----------------- SPECIAL -----------------

  static final TextStyle paymentHistoryAmount = GoogleFonts.inter(
    fontSize: AppSizes.bodySmall,
    fontWeight: FontWeight.w600,
  );
}
