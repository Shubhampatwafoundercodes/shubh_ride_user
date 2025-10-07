import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_btn.dart' show AppBtn;
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart' show AppConstant;
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/map/provider/map_provider.dart';
import 'package:rider_pay/view/share_pref/user_provider.dart';

class CancelReasonSheet extends ConsumerWidget {
  const CancelReasonSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reasonOfCancelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }



    final reasons = state.reasons?.data ?? [];
    if (reasons.isEmpty) {
      return Center(child: Text("Error: Data not found"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstText(
          text: "Why do you want to cancel?",
          fontSize: AppConstant.fontSizeThree,
          fontWeight: AppConstant.semiBold,
          color: context.textPrimary,
        ),
        AppSizes.spaceH(4.h),
        ConstText(
          text: "Please provide the reason for cancellation",
          fontSize: AppConstant.fontSizeZero,
          color: context.textSecondary,
        ),
        AppSizes.spaceH(12.h),

        ...reasons.map(
              (item) => Column(
            children: [
              ListTile(
                dense: true,
                minVerticalPadding: 8,
                minTileHeight: 10,
                contentPadding: EdgeInsets.zero,
                title: ConstText(
                  text: item.reason ?? "",
                  fontSize: AppConstant.fontSizeOne,
                  color: context.textSecondary,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 13.sp,
                  color: context.greyMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (_) {
                      return CommonBottomSheet(
                        content: CancelConfirmationSheet(
                          reasonId: item.id??0,
                          reasonText: item.reason ?? "",
                        ),
                      );
                    },
                  );
                },
              ),
              Divider(height: 1, color: context.greyLight),
            ],
          ),
        ),
      ],
    );
  }
}
class CancelConfirmationSheet extends ConsumerWidget {
  final int reasonId;
  final String reasonText;

  const CancelConfirmationSheet({
    super.key,
    required this.reasonId,
    required this.reasonText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final  destinationAddress= ref.read(mapControllerProvider).destinationAddress;
    final rideState=ref.read(rideBookingProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstText(
          text: "Are you sure you want to cancel this ride?",
          fontSize: AppConstant.fontSizeThree,
          fontWeight: AppConstant.semiBold,
          color: context.textPrimary,
        ),
        AppSizes.spaceH(13.h),
        ConstText(
          text: reasonText,
          fontSize: AppConstant.fontSizeZero,
          color: context.textSecondary,
        ),
        AppSizes.spaceH(12.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on, color: Colors.green, size: 18.sp),
            AppSizes.spaceW(6),
            Expanded(
              child: ConstText(
                text: destinationAddress??"---",
                fontSize: AppConstant.fontSizeZero,
                fontWeight: AppConstant.medium,
                maxLine: 2,
              ),
            ),
          ],
        ),
        AppSizes.spaceH(16.h),

        AppBtn(
          title: "Cancel my ride",
                    loading:rideState.isLoading ,
                    margin: AppPadding.screenPaddingV,
          onTap:rideState.isLoading?null: () async {
            final userId=ref.read(userProvider)?.id.toString()??"0";
           Map<String,dynamic> data= {
             "user_id":userId,
              "ride_id":rideState.rideId,
            "reason_id" : reasonId
          };
            final rideBook=ref.read(rideBookingProvider.notifier);
            rideBook.cancelRideApi(data);
            // Navigator.pushReplacementNamed(context, RouteName.home);


          },
        ),

        AppBtn(
          title: "Keep searching",
          color: Colors.transparent,
          border: Border.all(color: context.greyDark, width: 1),
          titleColor: context.textPrimary,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
