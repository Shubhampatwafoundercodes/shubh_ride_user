import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_border.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/common_network_img.dart';
import 'package:rider_pay/res/constant/const_dash_line.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/format/date_time_formater.dart';
import 'package:rider_pay/view/home/data/model/ride_history_booking_model.dart';
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay/view/home/presentation/widget/gradient_white_box.dart';

// class RideDetailsScreen extends StatelessWidget {
// final  RideHistorySingleDataModel ride;
//
//   const RideDetailsScreen({super.key, required this.ride});
//
//   @override
//   Widget build(BuildContext context) {
//     final isCancelled = ride.status?.toLowerCase() == "cancelled";
//
//     return Scaffold(
//       backgroundColor: context.lightSkyBack,
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// 🔹 Top Bar
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const CommonBackBtnWithTitle(text: "Details"),
//                 _ticketButton(context),
//               ],
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: AppPadding.screenPadding,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AppSizes.spaceH(10),
//                     _rideSummary(context, isCancelled),
//
//                       AppSizes.spaceH(30),
//                       _sectionHeader(
//                         context,
//                         icon: Icons.info_outline,
//                         title: "RIDE DETAILS",
//                       ),
//                       AppSizes.spaceH(8),
//                       _rideDetails(context),
//
//                       AppSizes.spaceH(20),
//                       _sectionHeader(
//                         context,
//                         icon: Icons.receipt_long,
//                         title: "INVOICE",
//                       ),
//                       AppSizes.spaceH(8),
//                       _invoice(context),
//
//                       AppSizes.spaceH(20),
//                       _supportCard(context),
//                     ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// 🔹 Top Ticket Button
//   Widget _ticketButton(BuildContext context) {
//     return Container(
//       margin: AppPadding.screenPaddingH,
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
//       decoration: BoxDecoration(
//         border: Border.all(color: context.hintTextColor),
//         borderRadius: AppBorders.mediumRadius,
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.airplane_ticket_outlined,
//               color: context.textSecondary, size: 18),
//           AppSizes.spaceW(4.w),
//           ConstText(
//             text: "Tickets",
//             fontSize: AppConstant.fontSizeOne,
//             color: context.textSecondary,
//           )
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Ride Summary Card
//   Widget _rideSummary(BuildContext context, bool isCancelled) {
//     return GradientContainer(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Icon(ride.vehicleIcon, size: 24.h, color: Colors.grey),
//           const SizedBox(width: 25),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ConstText(
//                   text: ride.destination,
//                   fontWeight: AppConstant.medium,
//                   color: context.textPrimary,
//                   maxLine: 1,
//                 ),
//                 AppSizes.spaceH(4),
//                 ConstText(
//                   text: "${ride.formattedDate} • ${ride.formattedTime}",
//                   fontSize: AppConstant.fontSizeZero,
//                   color: context.hintTextColor,
//                 ),
//                 ConstText(
//                   text: isCancelled
//                       ? "₹${ride.price.toStringAsFixed(1)} • Cancelled"
//                       : "₹${ride.price.toStringAsFixed(1)} • Completed",
//                   fontSize: AppConstant.fontSizeZero,
//                   color: isCancelled ? context.error : context.hintTextColor,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Ride Details Card
//   Widget _rideDetails(BuildContext context) {
//     return GradientContainer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Pickup & Drop
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.place_outlined,
//                       color: Colors.green, size: 12),
//                   ConstDashLine(
//                     dashCount: 5,
//                     dashThickness: 1,
//                     dashLength: 5,
//                     color: context.hintTextColor,
//                     isHorizontal: false,
//                   ),
//                   const Icon(Icons.circle, color: Colors.red, size: 12),
//                 ],
//               ),
//               AppSizes.spaceW(8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ConstText(
//                     text: ride.pickupLocation,
//                     color: context.textPrimary,
//                     fontSize: AppConstant.fontSizeOne,
//                   ),
//                   ConstText(
//                     text: ride.pickupLocation,
//                     color: context.hintTextColor,
//                     fontSize: AppConstant.fontSizeSmall,
//                   ),
//                   AppSizes.spaceH(8),
//                   ConstText(
//                     text: ride.destination,
//                     color: context.textPrimary,
//                     fontSize: AppConstant.fontSizeOne,
//                   ),
//                   ConstText(
//                     text: ride.pickupLocation,
//                     color: context.hintTextColor,
//                     fontSize: AppConstant.fontSizeSmall,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           AppSizes.spaceH(15),
//           _divider(context),
//           AppSizes.spaceH(15),
//
//           _infoRow(context, "Duration", "20 mins"),
//           AppSizes.spaceH(8),
//           _infoRow(context, "Distance", "4.8 km"),
//           AppSizes.spaceH(8),
//           _infoRow(context, "Ride ID", ride.id, flexibleValue: true),
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Invoice Card
//   Widget _invoice(BuildContext context) {
//     return GradientContainer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _infoRow(context, "Total fare", "₹${ride.price.toStringAsFixed(1)}",
//               isBold: true),
//           AppSizes.spaceH(8),
//           _divider(context),
//           AppSizes.spaceH(15),
//           _infoRow(context, "Ride Charge",
//               "₹${(ride.price - 20).toStringAsFixed(2)}"),
//           AppSizes.spaceH(8),
//           _infoRow(context, "Booking Fees & Convenience Charges", "₹20.00"),
//           AppSizes.spaceH(12),
//
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Support Card
//   Widget _supportCard(BuildContext context) {
//     return GradientContainer(
//       child: Row(
//         children: [
//           Icon(Icons.support_agent, size: 20, color: context.textPrimary),
//           AppSizes.spaceW(8),
//           ConstText(
//             text: "SUPPORT",
//             fontWeight: AppConstant.semiBold,
//             color: context.textPrimary,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// 🔹 Section Header (Icon + Title)
//   Widget _sectionHeader(BuildContext context,
//       {required IconData icon, required String title}) {
//     return Row(
//       children: [
//         Icon(icon, size: 18.h, color: context.textSecondary),
//         AppSizes.spaceW(6),
//         ConstText(
//           text: title,
//           fontWeight: AppConstant.semiBold,
//           fontSize: AppConstant.fontSizeOne,
//           color: context.textSecondary,
//         ),
//       ],
//     );
//   }
//
//   /// 🔹 Reusable Info Row
//   Widget _infoRow(BuildContext context, String label, String value,
//       {bool isBold = false, bool flexibleValue = false}) {
//     final textStyle = ConstText(
//       text: value,
//       color: context.hintTextColor,
//       fontSize: AppConstant.fontSizeZero,
//       fontWeight: isBold ? AppConstant.medium : null,
//       maxLine: flexibleValue ? 1 : null,
//     );
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         ConstText(
//           text: label,
//           color: context.hintTextColor,
//           fontSize: AppConstant.fontSizeZero,
//           fontWeight: isBold ? AppConstant.medium : null,
//         ),
//         flexibleValue ? Flexible(child: textStyle) : textStyle,
//       ],
//     );
//   }
//
//   /// 🔹 Divider Line
//   Widget _divider(BuildContext context) {
//     return SizedBox(
//       width: screenWidth,
//       child: ConstDashLine(
//         dashCount: 26,
//         dashThickness: 1,
//         dashLength: 5,
//         color: context.hintTextColor,
//         isHorizontal: true,
//       ),
//     );
//   }
// }


class RideDetailsScreen extends StatelessWidget {
  final RideHistorySingleDataModel ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final isCancelled = ride.status?.toLowerCase() == "cancelled";

    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CommonBackBtnWithTitle(text: "Details"),
                _ticketButton(context),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: AppPadding.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSizes.spaceH(10),
                    _rideSummary(context, isCancelled),


                      AppSizes.spaceH(30),
                      _sectionHeader(
                        context,
                        icon: Icons.info_outline,
                        title: "RIDE DETAILS",
                      ),
                      AppSizes.spaceH(8),
                      _rideDetails(context),


                      if(!isCancelled)...[
                        AppSizes.spaceH(20),
                        _sectionHeader(
                          context,
                          icon: Icons.receipt_long,
                          title: "INVOICE",
                        ),
                        AppSizes.spaceH(8),
                        _invoice(context),

                      ],

                      AppSizes.spaceH(20),
                      _supportCard(context),
                    ],

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Top Ticket Button
  Widget _ticketButton(BuildContext context) {
    return Container(
      margin: AppPadding.screenPaddingH,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: context.hintTextColor),
        borderRadius: AppBorders.mediumRadius,
      ),
      child: Row(
        children: [
          Icon(Icons.airplane_ticket_outlined,
              color: context.textSecondary, size: 18),
          AppSizes.spaceW(4),
          ConstText(
            text: "Tickets",
            fontSize: AppConstant.fontSizeOne,
            color: context.textSecondary,
          )
        ],
      ),
    );
  }

  /// 🔹 Ride Summary Card
  Widget _rideSummary(BuildContext context, bool isCancelled) {
    return GradientContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (ride.blackWhiteIcon != null)
            CommonNetworkImage(imageUrl:
              ride.blackWhiteIcon!,
              height: 24.h,
              width: 24.w,
              fit: BoxFit.contain,
            ),
           SizedBox(width: 25.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstText(
                  text: ride.dropAddress ?? "--",
                  fontWeight: AppConstant.medium,
                  color: context.textPrimary,
                  maxLine: 1,
                ),
                AppSizes.spaceH(4),
                ConstText(
                  text:
                  DateTimeFormat.formatFullDateTime(ride.bookingTime.toString()??""),
                  fontSize: AppConstant.fontSizeZero,
                  color: context.hintTextColor,
                ),
                ConstText(
                  text: isCancelled
                      ? "₹${ride.finalFare ?? '0'} • Cancelled"
                      : "₹${ride.finalFare ?? '0'} • Completed",
                  fontSize: AppConstant.fontSizeZero,
                  color: isCancelled ? context.error : context.hintTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Ride Details Card
  Widget _rideDetails(BuildContext context) {
    final pickupAddress = formatAddress(ride.pickupAddress);
    final dropAddress = formatAddress(ride.dropAddress);
    return GradientContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Pickup & Drop
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.place_outlined,
                      color: Colors.green, size: 12),
                  ConstDashLine(
                    dashCount: 5,
                    dashThickness: 1,
                    dashLength: 5,
                    color: context.hintTextColor,
                    isHorizontal: false,
                  ),
                  const Icon(Icons.circle, color: Colors.red, size: 12),
                ],
              ),
              AppSizes.spaceW(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: pickupAddress,
                    color: context.textPrimary,
                    fontSize: AppConstant.fontSizeOne,
                    maxLine: 3, // 1st line + 2nd line allowed
                  ),
                  AppSizes.spaceH(8),

                  /// Drop
                  ConstText(
                    text: dropAddress,
                    color: context.textPrimary,
                    fontSize: AppConstant.fontSizeOne,
                    maxLine: 3,
                  ),
                ],
              ),
            ],
          ),
          AppSizes.spaceH(15),
          _divider(context),
          AppSizes.spaceH(15),

          _infoRow(context, "Duration", "N/A"),
          AppSizes.spaceH(8),
          _infoRow(
              context, "Distance", "${ride.distanceKm ?? '0.0'} km"), // API data
          AppSizes.spaceH(8),
          _infoRow(context, "Ride ID", ride.rideId ?? "--",
              flexibleValue: true),
        ],
      ),
    );
  }

  /// 🔹 Invoice Card
  Widget _invoice(BuildContext context) {
    return GradientContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(context, "Suggested Fare", "₹${ride.suggestFare ?? '0'}", isBold: true),
          AppSizes.spaceH(8),
          _divider(context),
          AppSizes.spaceH(15),
          _infoRow(context, "Total Charge", "₹${((double.tryParse(ride.finalFare?? '0') ?? 0) ).toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  /// 🔹 Support Card
  Widget _supportCard(BuildContext context) {
    return GradientContainer(
      child: Row(
        children: [
          Icon(Icons.support_agent, size: 20, color: context.textPrimary),
          AppSizes.spaceW(8),
          ConstText(
            text: "SUPPORT",
            fontWeight: AppConstant.semiBold,
            color: context.textPrimary,
          ),
        ],
      ),
    );
  }

  /// 🔹 Section Header (Icon + Title)
  Widget _sectionHeader(BuildContext context,
      {required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.textSecondary),
        AppSizes.spaceW(6),
        ConstText(
          text: title,
          fontWeight: AppConstant.semiBold,
          fontSize: AppConstant.fontSizeOne,
          color: context.textSecondary,
        ),
      ],
    );
  }

  /// 🔹 Reusable Info Row
  Widget _infoRow(BuildContext context, String label, String value,
      {bool isBold = false, bool flexibleValue = false}) {
    final textStyle = ConstText(
      text: value,
      color: context.hintTextColor,
      fontSize: AppConstant.fontSizeZero,
      fontWeight: isBold ? AppConstant.medium : null,
      maxLine: flexibleValue ? 1 : null,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ConstText(
          text: label,
          color: context.hintTextColor,
          fontSize: AppConstant.fontSizeZero,
          fontWeight: isBold ? AppConstant.medium : null,
        ),
        flexibleValue ? Flexible(child: textStyle) : textStyle,
      ],
    );
  }

  /// 🔹 Divider Line
  Widget _divider(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ConstDashLine(
        dashCount: 26,
        dashThickness: 1,
        dashLength: 5,
        color: context.hintTextColor,
        isHorizontal: true,
      ),
    );
  }
}
String formatAddress(String? address) {
  if (address == null || address.isEmpty) return "--";
  final parts = address.split(',');
  if (parts.length == 1) return address;

  final first = parts.first.trim();
  final rest = parts.sublist(1).join(',').trim();
  return "$first\n$rest"; // 🔹 Direct new line
}