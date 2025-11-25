import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';

class CommonBottomSheet extends StatelessWidget {
  final String? title; // Optional title
  final Widget content; // Dynamic content
  final bool isDismissible; // Allow dismiss or not
  final bool showCloseButton; // Show close button or not
  final double borderRadius; // Radius
  final Color? backgroundColor; // BG color

  const CommonBottomSheet({
    super.key,
    this.title,
    required this.content,
    this.isDismissible = false,
    this.showCloseButton = true,
    this.borderRadius = 25,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom ,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close Button (optional)
            if (showCloseButton)
              Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);

                    },
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: context.popupBackground,
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

            // Main Container
            Container(
              padding: EdgeInsets.only(left:16.w,right: 16.w,bottom: 15.h,top: 10.h),
              decoration: BoxDecoration(
                color: backgroundColor ?? context.popupBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius.r),
                  topRight: Radius.circular(borderRadius.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 10.h),

                  // Drag handle (UI only)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 3.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                        color: context.greyMedium,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // Title (optional)
                  if (title != null) ...[
                    ConstText(
                      text: title!,
                      fontSize: AppConstant.fontSizeLarge,
                      fontWeight: AppConstant.semiBold,
                    ),
                    SizedBox(height: 20.h),
                  ],

                  content,

                  // SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
