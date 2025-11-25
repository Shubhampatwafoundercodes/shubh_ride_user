// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/main.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart' show AppSizes;
import 'package:rider_pay_user/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_user/res/constant/common_network_img.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_user/view/home/presentation/controller/complete_payment_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverAcceptedSection extends ConsumerWidget {
  final Map<String, dynamic> driverData;
  final Map<String, dynamic> pickupLocation;
  final Map<String, dynamic> dropLocation;
  final String otp;
  final String statusText;
  final String status;
  final String? paymentMode;
  final String? paymentStatus;
  final double? fare;
  final String rideId;

  const DriverAcceptedSection({
    super.key,
    required this.driverData,
    required this.pickupLocation,
    required this.dropLocation,
    required this.otp,
    required this.statusText,
    required this.status,
    this.paymentMode,
    this.paymentStatus,
    this.fare,
    required this.rideId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t=AppLocalizations.of(context)!;
    final driverDetails = Map<String, dynamic>.from(
      driverData['driverDetails'] ?? {},
    );
    final driverName = driverDetails['name'] ?? "Unknown Driver";
    final driverMobile = driverDetails['phone'] ?? "0000000000";
    final vehicleNumber = driverDetails['vehicle_number'] ?? "N/A";
    final driverRating = (driverDetails['rating'] ?? 0).toDouble();
    final driverImage = driverDetails['img'] ?? "";
    final isOtpVerified = status.toLowerCase() == "otp_verified";
    final isCompleted = status.toLowerCase() == "completed" && status.toLowerCase() == "cancelled";
    final isOnline = (paymentMode ?? "").toLowerCase() == "online";
    final isPaymentDone = (paymentStatus ?? "").toLowerCase() == "completed";

    return SingleChildScrollView(
      child: Container(
        margin: AppPadding.screenPadding,
        child: Column(
          children: [
            if (isOtpVerified && isOnline && !isPaymentDone && paymentStatus=="processing")
              Container(
                // margin: EdgeInsets.symmetric(vertical: 20.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.payment_rounded,
                      color: Colors.blueAccent,
                      size: 40.w,
                    ),
                    SizedBox(height: 10.h),
                    ConstText(
                      text: t.paymentPending,
                      fontSize: 16.sp,
                      fontWeight: AppConstant.bold,
                      color: Colors.black87,
                    ),
                    SizedBox(height: 6.h),
                    ConstText(
                      text: t.completePaymentMsg,
                      fontSize: 13.sp,
                      color: context.hintTextColor,
                    ),
                    SizedBox(height: 16.h),
                    AppBtn(
                      onTap: () {
                        _showPaymentConfirmationBottomSheet(context, ref,t);
                      },
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      title: "Pay Now ₹${fare?.toStringAsFixed(0) ?? '—'}",
                    ),
                  ],
                ),
              ),
            AppSizes.spaceH(10),
            if (!isCompleted )
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: context.popupBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🧍‍♂️ DRIVER HEADER (IMAGE + NAME + CALL)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Driver Image
                        CircleAvatar(
                          radius: 26.r,
                          backgroundColor: Colors.grey.shade200,
                          child: (driverImage.isNotEmpty)
                              ? ClipOval(
                            child: CommonNetworkImage(
                              imageUrl: driverImage,
                              width: 52.w,
                              height: 52.w,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Icon(Icons.person, color: Colors.blue, size: 30.sp),
                        ),

                        AppSizes.spaceW(14),

                        /// Driver Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstText(
                                text: driverName,
                                fontSize: 15.sp,
                                fontWeight: AppConstant.semiBold,
                                color: context.textPrimary,
                              ),
                              AppSizes.spaceH(2),
                              ConstText(
                                text: "+91 $driverMobile",
                                fontSize: 13.sp,
                                fontWeight: AppConstant.medium,
                                color: context.hintTextColor,
                              ),
                            ],
                          ),
                        ),

                        /// Call Button
                        if(!isOtpVerified)
                        GestureDetector(
                          onTap: () => _callDriver(driverMobile),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.call, color: Colors.white, size: 16.w),
                                AppSizes.spaceW(4),
                                ConstText(
                                  text: t.call,
                                  fontSize: AppConstant.fontSizeSmall,
                                  color: Colors.white,
                                  fontWeight: AppConstant.semiBold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    AppSizes.spaceH(16),
                    Divider(color: Colors.grey.shade300, thickness: 0.8),

                    /// 🚗 VEHICLE DETAILS
                    AppSizes.spaceH(10),
                    Row(
                      children: [
                        Icon(Icons.directions_car_rounded, color: Colors.blue, size: 20.w),
                        AppSizes.spaceW(8),
                        ConstText(
                          text: t.vehicleNumber,
                          fontSize: 14.sp,
                          fontWeight: AppConstant.medium,
                          color: context.hintTextColor,
                        ),
                        ConstText(
                          text: vehicleNumber,
                          fontSize: 16.sp,
                          fontWeight: AppConstant.bold,
                          color: context.textSecondary,
                        ),
                      ],
                    ),

                    AppSizes.spaceH(18),
                    Divider(color: Colors.grey.shade300, thickness: 0.8),

                    if(!isOtpVerified)...[
                      /// 🔢 OTP SECTION
                      AppSizes.spaceH(10),
                      Center(
                        child: ConstText(
                          text: t.startRidePin,
                          fontSize: AppConstant.fontSizeSmall,
                          color: context.hintTextColor,
                          fontWeight: AppConstant.semiBold,
                        ),
                      ),
                      AppSizes.spaceH(10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: otp
                            .padLeft(4, '0')
                            .split('')
                            .map(
                              (digit) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 6.w),
                            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ConstText(
                              text: digit,
                              fontSize: 18.sp,
                              fontWeight: AppConstant.bold,
                              color: context.textSecondary,
                            ),
                          ),
                        )
                            .toList(),
                      ),

                      AppSizes.spaceH(8),

                    ]


                  ],
                ),
              ),

          AppSizes.spaceH(10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: context.popupBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: t.pickupFrom,
                    fontSize: AppConstant.fontSizeSmall,
                    color: context.hintTextColor,
                    fontWeight: AppConstant.semiBold,
                  ),
                  AppSizes.spaceH(4),
                  ConstText(
                    text:
                        pickupLocation['address'] ?? "Unknown pickup location",
                    fontSize: 14.sp,
                    fontWeight: AppConstant.semiBold,
                    color: context.textSecondary,
                  ),
                ],
              ),
            ),

            AppSizes.spaceH(16),

            // Drop Location Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: context.popupBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(
                    text: t.dropTo,
                    fontSize: AppConstant.fontSizeSmall,
                    color: context.hintTextColor,
                    fontWeight: AppConstant.semiBold,
                  ),
                  AppSizes.spaceH(4),
                  ConstText(
                    text: dropLocation['address'] ?? "Unknown drop location",
                    fontSize: 14.sp,
                    fontWeight: AppConstant.semiBold,
                    color: context.textSecondary,
                  ),
                ],
              ),
            ),
            AppSizes.spaceH(16),

            AppBtn(
              width: screenWidth * 0.4,
              margin:EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom,),
              height: 40,
              borderRadius: 20,
              onTap: () async {
                final pickupLat = pickupLocation['lat'];
                final pickupLng = pickupLocation['lng'];
                final dropLat = dropLocation['lat'];
                final dropLng = dropLocation['lng'];
                if (pickupLat == null || pickupLng == null || dropLat == null || dropLng == null) {
                  toastMsg("Pickup or Drop location missing");
                  return;
                }
                final urlString = "https://www.google.com/maps/dir/?api=1&origin=$pickupLat,$pickupLng&destination=$dropLat,$dropLng&travelmode=driving";
                final url = Uri.parse(urlString);

                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  toastMsg("Could not open Google Maps");
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.navigation, color: Colors.black, size: 18),
                  SizedBox(width: 5),
                  ConstText(
                    text:t.goToMap,
                    color: Colors.black,
                    fontWeight: AppConstant.semiBold,
                  ),
                ],
              ),
            ),

            // AppSizes.spaceH(16),
          ],
        ),
      ),
    );
  }


  void _callDriver(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
    }
  }

  void _showPaymentConfirmationBottomSheet(
    BuildContext context,
    WidgetRef ref,
      AppLocalizations t
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommonBottomSheet(
        title: t.completeOnlinePayment,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ConstText(
                  text: "Confirm payment of",
                  fontWeight: AppConstant.medium,
                  textAlign: TextAlign.center,
                ),
                ConstText(
                  text: "₹${fare ?? '—'}",
                  fontWeight: AppConstant.medium,
                  textAlign: TextAlign.center,
                ),
                ConstText(
                  text: "for this ride?",
                  fontWeight: AppConstant.medium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            AppSizes.spaceH(20),
            AppBtn(
              title: t.ok,
              loading: ref.watch(completePaymentProvider).isLoading,
              onTap: () async {
                try {
                  final paymentNotifier = ref.read(completePaymentProvider.notifier);
                  final success = await paymentNotifier.completePaymentApi(rideId,fare.toString());
                  final rideNotifier = ref.read(rideNotifierProvider.notifier);
                  if (success) {
                    await rideNotifier.updateRide(rideId, {
                      "paymentStatus": "completed",
                    });
                    toastMsg("✅ Payment completed successfully!");
                    Navigator.pop(context);
                  } else {
                    toastMsg("❌ Payment failed. Please try again.");
                  }
                } catch (e) {
                  toastMsg("Payment Failed!");
                }
              },
            ),
            AppSizes.spaceH(20),

            AppBtn(
              title:t.cancel,
              color: Colors.transparent,
              titleColor: AppColor.error,
              border: Border.all(color: AppColor.error, width: 1),

              onTap: () => Navigator.pop(context),
            ),
            AppSizes.spaceH(20),
          ],
        ),
      ),
    );
  }

  void _showMessageBottomSheet(BuildContext context, String driverName,      AppLocalizations t
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: screenHeight * 0.7,
        decoration: BoxDecoration(
          color: context.popupBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstText(
                  text: "Message $driverName",
                  fontSize: 18.sp,
                  fontWeight: AppConstant.bold,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Center(
                child: ConstText(
                  text:t.chatInterfaceWillBeImplementedHere,
                  color: context.hintTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
