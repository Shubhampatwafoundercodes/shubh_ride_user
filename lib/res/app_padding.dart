import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppPadding {
  static EdgeInsets get screenPadding => EdgeInsets.symmetric(
    horizontal: 15.w,
    vertical: 15.h,
  );

  static EdgeInsets get screenPaddingH => EdgeInsets.symmetric(horizontal: 15.w);

  static EdgeInsets get screenPaddingV => EdgeInsets.symmetric(vertical: 15.h);

  static EdgeInsets get extraSmallPadding => EdgeInsets.all(5.w);

  static EdgeInsets get smallPadding => EdgeInsets.all(10.w);

  static EdgeInsets get mediumPadding => EdgeInsets.all(16.w);

  static EdgeInsets get largePadding => EdgeInsets.all(24.w);
}
