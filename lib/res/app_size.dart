import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/res/app_device.dart';

class AppSizes {
  static SizedBox spaceW(double size) =>
      SizedBox(width: AppDevice.isMobile ? size.w : AppDevice.isTablet ? (size+4).w : (size+6).w);

  static SizedBox spaceH(double size) =>
      SizedBox(height: AppDevice.isMobile ? size.h : AppDevice.isTablet ? (size+4).h : (size+6).h);
}