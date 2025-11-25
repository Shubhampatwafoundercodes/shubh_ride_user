import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/common_network_img.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/view/firebase_service/ride/notifer/ride_notifer.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';

class RequestedDriversList extends ConsumerWidget {
  final String rideId;
  final List<Map<String, dynamic>> requestedDrivers;

  const RequestedDriversList({
    super.key,
    required this.rideId,
    required this.requestedDrivers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t=AppLocalizations.of(context)!;
    final rideState = ref.watch(rideNotifierProvider);
    final isLoading = rideState.isAcceptingDriver;
    if (requestedDrivers.isEmpty) {
      return Center(
        child: ConstText(
          text:t.searchNearbyDrivers,
          fontSize: 14.sp,
          color: context.hintTextColor,
        ),
      );
    }

    return ListView.builder(
      itemCount: requestedDrivers.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final driver = requestedDrivers[index];

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: context.popupBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: Colors.blue.shade100,
                child: (driver['img'] != null && (driver['img'] as String).isNotEmpty)
                    ? ClipOval(
                  child: CommonNetworkImage(
                    imageUrl: driver['img'],
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(Icons.person, color: Colors.blue, size: 28.sp),
              ),
              AppSizes.spaceW(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstText(
                      text: driver['name'].toString(),
                      fontWeight: AppConstant.bold,
                      fontSize: 14.sp,
                    ),
                    ConstText(
                      text: "📞 ${driver['mobile']}",
                      fontSize: 12.sp,
                      color: context.hintTextColor,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primary,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    ),
                    onPressed: isLoading
                        ? null // disable button while loading
                        : () async {
                      ref.read(mapControllerProvider.notifier).enableConfirmingPickup();
                      await ref
                          .read(rideNotifierProvider.notifier)
                          .acceptDriverIfAvailable(rideId, driver['id'], driver);
                    },
                    child: isLoading
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : ConstText(
                      text: t.accept,
                      color: context.textPrimary,
                      fontSize: AppConstant.fontSizeZero,
                    ),
                  ),                  AppSizes.spaceW(8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      side: BorderSide(
                        // ignore: deprecated_member_use
                        color: context.textPrimary.withOpacity(0.5),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    ),
                    onPressed: () {
                      ref.read(rideNotifierProvider.notifier)
                          .rejectDriver(rideId, driver['id']);
                    },
                    child: ConstText(
                      text: "Reject",
                      color: context.textPrimary,
                      fontSize: AppConstant.fontSizeZero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
