import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/generated/assets.dart';

import 'app_device.dart';

class AppConstant {
  static const String appName = "RiderPay";
  static const String appVersion = '1.0.0';
  static final String appLogoLightMode = Assets.imagesAppLogoLightMode;

  // Font Sizes responsive based on device
  static double get fontSizeZero =>
      AppDevice.isMobile ? 12.sp : AppDevice.isTablet ? 14.sp : 16.sp;

  static double get fontSizeSmall =>
      AppDevice.isMobile ? 11.sp : AppDevice.isTablet ? 12.sp : 14.sp;

  static double get fontSizeOne =>
      AppDevice.isMobile ? 13.sp : AppDevice.isTablet ? 15.sp : 17.sp;

  static double get fontSizeTwo =>
      AppDevice.isMobile ? 14.sp : AppDevice.isTablet ? 16.sp : 18.sp;

  static double get fontSizeThree =>
      AppDevice.isMobile ? 16.sp : AppDevice.isTablet ? 22.sp : 24.sp;

  static double get fontSizeLarge =>
      AppDevice.isMobile ? 20.sp : AppDevice.isTablet ? 26.sp : 28.sp;

  static double get fontSizeHeading =>
      AppDevice.isMobile ? 28.sp : AppDevice.isTablet ? 30.sp : 32.sp;

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w900;
}
