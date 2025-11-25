// import 'package:flutter/material.dart';
// import 'package:rider_pay_user/main.dart';
// import 'package:rider_pay_user/res/app_border.dart';
// import 'package:rider_pay_user/res/app_color.dart';
// import 'package:rider_pay_user/res/app_constant.dart';
// import 'package:rider_pay_user/res/app_size.dart';
// import 'package:rider_pay_user/res/constant/const_text.dart';
//
//
// class CommonDropdown<T> extends StatefulWidget {
//   final String title;                        // Title label
//   final String hintText;                     // Hint text
//   final T? selectedValue;                    // Selected item
//   final List<T> items;                       // Dynamic item list
//   final String Function(T) itemLabel;        // Display text
//   final dynamic Function(T) valueKey;        // Unique key for selection
//   final ValueChanged<T?> onChanged;          // Callback on select
//   final double dropdownHeight;
//   final double offsetY;
//
//   const CommonDropdown({
//     super.key,
//     required this.title,
//     required this.hintText,
//     required this.items,
//     required this.itemLabel,
//     required this.valueKey,
//     required this.onChanged,
//     this.selectedValue,
//     this.dropdownHeight = 50,
//     this.offsetY = 55,
//   });
//
//   @override
//   State<CommonDropdown<T>> createState() => _CommonDropdownState<T>();
// }
//
// class _CommonDropdownState<T> extends State<CommonDropdown<T>> {
//   @override
//   Widget build(BuildContext context) {
//     // final screenWidth = MediaQuery.of(context).size.width;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ConstText(text:
//          widget.title,
//           fontSize:AppConstant.fontSizeThree,
//         ),
//         AppSizes.spaceH(5),
//         PopupMenuButton<T>(
//           offset: Offset(0, widget.offsetY),
//           color: AppColor.white,
//           constraints: BoxConstraints(
//             maxWidth: screenWidth * 0.92,
//             minWidth: screenWidth * 0.92,
//           ),
//           onSelected: widget.onChanged,
//           itemBuilder: (BuildContext context) {
//             return widget.items.map((item) {
//               return PopupMenuItem<T>(
//                 value: item,
//                 child: ConstText(
//                   text: widget.itemLabel(item),
//                   fontWeight: AppConstant.medium,
//                 ),
//               );
//             }).toList();
//           },
//           child: Container(
//             width: screenWidth,
//             height: widget.dropdownHeight,
//             decoration: BoxDecoration(
//               color: AppColor.primary.withAlpha(40),
//               borderRadius: AppBorders.defaultRadius,
//               border: Border.all(
//                 color: widget.selectedValue != null
//                     ? AppColor.primary
//                     : Colors.transparent,
//                 width: 1.5,
//               ),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             alignment: Alignment.centerLeft,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ConstText(
//                   text: widget.selectedValue != null
//                       ? widget.itemLabel(widget.selectedValue as T)
//                       : widget.hintText,
//                   color: widget.selectedValue != null
//                       ? AppColor.primary
//                       :AppColor.greyDark,
//                   fontWeight: AppConstant.medium,
//                 ),
//                 const Icon(Icons.arrow_drop_down),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/main.dart';
import 'package:rider_pay_user/res/app_border.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';

class CommonDropdown<T> extends StatefulWidget {
  final String? title;                        // Title label
  final String? hintText;                     // Hint text (only for default box)
  final T? selectedValue;                     // Selected item
  final List<T> items;                        // Dynamic item list
  final String Function(T)? itemLabel;        // Display text (nullable now)
  final dynamic Function(T)? valueKey;        // Unique key for selection (nullable now)
  final ValueChanged<T?> onChanged;           // Callback on select
  final double? dropdownHeight;
  final double offsetY;
  final double? buttonWidth;                 // Button width
  final double? dropdownWidth;               // Dropdown menu width
  final Widget? customBox;                   // 👉 Custom UI for box

  const CommonDropdown({
    super.key,
    this.title,
    this.hintText,
    required this.items,
    this.itemLabel,       // ab required nahi
    this.valueKey,        // ab required nahi
    required this.onChanged,
    this.selectedValue,
    this.dropdownHeight,
    this.offsetY = 55,
    this.buttonWidth,
    this.dropdownWidth,
    this.customBox,
  });

  @override
  State<CommonDropdown<T>> createState() => _CommonDropdownState<T>();
}

class _CommonDropdownState<T> extends State<CommonDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.only(left: 5.w, bottom: 4.h),
            child: ConstText(
              text: widget.title ?? "",
              fontSize: AppConstant.fontSizeThree,
              color: context.textPrimary,
              // color: context.greyMedium,
            ),
          ),

        PopupMenuButton<T>(
          offset: Offset(0, widget.offsetY),
          color: context.popupBackground,
          constraints: BoxConstraints(
            maxWidth: widget.dropdownWidth ?? screenWidth * 0.92,
            minWidth: widget.dropdownWidth ?? screenWidth * 0.92,
          ),
          onSelected: widget.onChanged,
          itemBuilder: (BuildContext context) {
            return widget.items.map((item) {
              return PopupMenuItem<T>(
                value: item,
                child: ConstText(
                  text: widget.itemLabel != null
                      ? widget.itemLabel!(item)
                      : item.toString(), // fallback
                  fontWeight: AppConstant.regular,
                  color: context.textPrimary,
                ),
              );
            }).toList();
          },
          child: widget.customBox ??
              Container(
                width: widget.buttonWidth ?? double.infinity,
                height: widget.dropdownHeight??50.h,
                padding: AppPadding.screenPaddingH,
                decoration: BoxDecoration(
                  border: Border.all(color:context.greyMedium, width: 1),
                  borderRadius: AppBorders.btnRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // AppSizes.spaceW(8),
                      if (widget.hintText != null)
                        ConstText(
                          text: widget.selectedValue != null
                              ? widget.itemLabel!(widget.selectedValue as T)
                              : widget.hintText!,
                          color: widget.selectedValue != null
                              ? context.textPrimary
                              : context.greyMedium,
                          fontWeight: widget.selectedValue != null
                              ? AppConstant.medium
                              : AppConstant.regular,
                        ),
                     Icon(Icons.arrow_drop_down_outlined, color: context.textSecondary,
    ),
                  ],
                ),
              ),
        ),
      ],
    );
  }
}


