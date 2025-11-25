import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rider_pay_user/generated/assets.dart' show Assets;
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_pop_up.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';

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
                ? "Location access is blocked.\n Please enable it in settings."
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
              if (!context.mounted) return;

              debugPrint("[POPUP] Button tapped — closing popup");
              Navigator.pop(context);

              final notifier = ref.read(locationServiceProvider.notifier);

              if (isServiceOff) {
                debugPrint("[POPUP] Opening location settings...");
                await Geolocator.openLocationSettings();
              } else if (isBlocked) {
                debugPrint("[POPUP] Opening app settings...");
                await Geolocator.openAppSettings();
              } else {
                debugPrint("[POPUP] Requesting permission directly...");
              }

              bool granted = false;
              for (int i = 0; i < 3; i++) {
                await Future.delayed(const Duration(seconds: 1));
                granted = await notifier.ensurePermission();
                if (granted) break;
                debugPrint("[POPUP] Retry #$i — still not granted");
              }
              debugPrint("[POPUP] Permission check after settings: $granted");

              if (granted) {
                debugPrint("[POPUP] ✅ Permission granted — continuing");
                if (context.mounted) onAction();
              } else {
                debugPrint("[POPUP] ❌ Permission still not granted");
                toastMsg("⚠️ Could not get location permission");
              }
            },
          ),
          AppSizes.spaceH(20),
        ],
      ),
    );
  }
}
