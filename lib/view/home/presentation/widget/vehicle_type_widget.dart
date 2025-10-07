import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/generated/assets.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_border.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay/res/constant/common_network_img.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/map/presentation/controller/ride_flow_controller.dart';

class VehicleTypeWidget extends ConsumerWidget {
  const VehicleTypeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final vehicleState = ref.watch(vehicleTypeProvider);
    final vehiclesList = vehicleState.vehicleTypeModelData?.data ?? [];
    if (vehicleState.isLoading == true || vehiclesList.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: AppPadding.screenPaddingH,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstText(
                text: loc.explore,
                fontWeight: AppConstant.semiBold,
                fontSize: AppConstant.fontSizeThree,
                color: context.greyDark,
                // color: ,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    // isDismissible: false,
                    // enableDrag: false,
                    builder: (context) {
                      return CommonBottomSheet(
                        title: "All Services",
                        // isDismissible: false,
                        // showCloseButton: true,
                        content: SingleChildScrollView(
                          child: Center(
                            child: Wrap(
                              spacing: 10.w,
                              runSpacing: 20.h,
                              alignment: WrapAlignment.center,
                              children: List.generate(vehiclesList.length, (index) => GestureDetector(
                                  onTap: () {
                                    final rideController = ref.watch(rideFlowProvider.notifier,);
                                    final vehicle = vehiclesList[index];

                                    rideController.selectVehicle(vehicle.id??-1, 0);
                                    Navigator.pushNamed(context, RouteName.searchLocationScreen);

                                  },
                                  child: ExploreItemWidget(
                                    imageUrl: vehiclesList[index].icon,
                                    title: vehiclesList[index].name,
                                    itemWidth: screenWidth * 0.2,
                                    itemHeight: screenHeight * 0.09,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    ConstText(
                      text: loc.viewAll,
                      color: context.greyDark,
                      fontSize: AppConstant.fontSizeTwo,

                      // fontSize: AppConstant.fontSizeOne,
                      // fontWeight: AppConstant.,
                    ),

                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: context.greyDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppSizes.spaceH(10),
        Row(
          children: List.generate(
            4,
                (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: GestureDetector(
                  onTap: () {
                    final rideController = ref.watch(rideFlowProvider.notifier);
                    rideController.selectVehicle(index, 0);
                    Navigator.pushNamed(context, RouteName.searchLocationScreen);
                  },
                  child: ExploreItemWidget(
                    imageUrl: vehiclesList[index].icon,
                    title: vehiclesList[index].name,
                    itemWidth: double.infinity,
                    itemHeight: screenHeight * 0.09,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ExploreItemWidget extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final double? itemWidth;
  final double? itemHeight;
  final VoidCallback? onTap;

  const ExploreItemWidget({
    super.key,
    this.itemWidth,
    this.itemHeight,
    this.onTap,
    this.imageUrl,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final iconUrl = imageUrl ?? "";
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: itemWidth,
        child: Column(
          children: [
            Container(
              padding: AppPadding.extraSmallPadding,
              height: itemHeight ?? screenHeight * 0.08,
              width: itemWidth ?? screenWidth * 0.2,
              decoration: BoxDecoration(
                color: context.greyLight,
                borderRadius: AppBorders.defaultRadius,
              ),
              child: iconUrl.isEmpty
                  ? ConstText(text: AppConstant.appName)
                  : CommonNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain),
            ),
            AppSizes.spaceH(6),
            FittedBox(
              child: ConstText(
                text: title ?? AppConstant.appName,
                maxLine: 2,
                fontSize: AppConstant.fontSizeOne,
                textAlign: TextAlign.center,
                fontWeight: AppConstant.semiBold,
                color: context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
