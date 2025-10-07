import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider_pay/generated/assets.dart' show Assets;
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/const_pop_up.dart';
import 'package:rider_pay/view/map/provider/map_provider.dart';

class LocationOnPopup extends ConsumerWidget {
  final bool isBlocked;
  final bool isServiceOff;
  final VoidCallback onAction;

  const LocationOnPopup({
    super.key,
    required this.onAction,
    this.isBlocked = false,
    this.isServiceOff = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstPopUp(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSizes.spaceH(15),
          Image.asset(
            Assets.iconCircleLocation,
            height: 70.h,
          ),
          AppSizes.spaceH(20),

          /// Title
          Text(
            isServiceOff
                ? "Location Off"
                : isBlocked
                ? "Location Blocked"
                : "Enable Location",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: AppConstant.fontSizeLarge,
            ),
          ),
          AppSizes.spaceH(10),

          /// Description
          Text(
            isServiceOff
                ? "Please turn on your device location services."
                : isBlocked
                ? "Location access is blocked.\nPlease enable it in settings."
                : "Allow location access to find rides near you.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstant.fontSizeTwo,
              color: context.textSecondary,
            ),
          ),
          AppSizes.spaceH(40),

          /// Button
          AppBtn(
            title: isServiceOff
                ? "Turn On Location"
                : isBlocked
                ? "Open Settings"
                : "Allow Access",
            onTap: () async {
              Navigator.pop(context); // popup close
              final notifier = ref.read(locationServiceProvider.notifier);
              if (isServiceOff) {
                await Geolocator.openLocationSettings();
              } else if (isBlocked) {
                await Geolocator.openAppSettings();
              }
              await notifier.ensurePermission();
              onAction();
            },
          ),
          AppSizes.spaceH(20),
        ],
      ),
    );
  }
}
