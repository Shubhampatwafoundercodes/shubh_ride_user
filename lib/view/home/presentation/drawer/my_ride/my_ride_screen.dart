import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/common_network_img.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/format/date_time_formater.dart';
import 'package:rider_pay_user/view/home/presentation/drawer/my_ride/my_ride_details.dart' show RideDetailsScreen;
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart' show CommonBackBtnWithTitle;
import 'package:rider_pay_user/view/home/provider/provider.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart';

class RideHistoryScreen extends ConsumerStatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  ConsumerState<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends ConsumerState<RideHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final userId=ref.watch(userProvider.notifier).userId;
      if(userId !=null){
        ref.read(rideBookingProvider.notifier).rideHistoryApi(userId);

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final rideState = ref.watch(rideBookingProvider);
    final rideData= rideState.bookingHistoryModelData?.data?.data??[];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CommonBackBtnWithTitle(text: "Ride History"),

            Expanded(
              child: rideState.isRideHistoryLoading
                  ? const Center(child: CircularProgressIndicator())
                  :rideData.isEmpty
                  ? const Center(child: Text("No Ride History Found"))
                    : ListView.separated(
                padding:  EdgeInsets.all(16.0.r),
                itemCount:rideData.length,
                itemBuilder: (context, index) {
                  final ride = rideData[index];
                  final isCancelled = ride.status?.toLowerCase() == "cancelled";
                  return InkWell(
                    onTap:() {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => RideDetailsScreen(ride: ride),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon(ride.vehicleIcon,
                            //     size: 24.h, color: Colors.grey),
                            if(ride.blackWhiteIcon !=null)
                            CommonNetworkImage(imageUrl: ride.blackWhiteIcon,height: 20.h,width: 20.w,fit: BoxFit.contain,),
                             SizedBox(width: 25.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstText(
                                    text: ride.dropAddress??"--",
                                    fontWeight: AppConstant.medium,
                                    color: context.textPrimary,
                                    maxLine: 1,
                                  ),
                                  AppSizes.spaceH(4),
                                  ConstText(
                                    text:
                                    DateTimeFormat.formatFullDateTime(ride.bookingTime.toString()),
                                    fontSize: AppConstant.fontSizeZero,
                                    color: context.hintTextColor,
                                  ),
                                  ConstText(
                                    text: ride.status.toString(),
                                    fontSize: AppConstant.fontSizeZero,
                                    color: _getStatusColor(ride.status),

                                  ),
                                ],
                              ),
                            ),
                              Icon(Icons.arrow_forward_ios,
                                  size: 15.h, color: context.greyMedium),
                          ],
                        ),
                        Divider(color: context.greyLight),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => AppSizes.spaceH(5),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "pending":
      case "processing":
      case "in-progress":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

}
