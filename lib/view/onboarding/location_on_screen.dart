import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';
import 'package:rider_pay_user/view/widget/location_on_popup.dart';
import '../../utils/routes/routes_name.dart';

class LocationOnScreen extends ConsumerStatefulWidget {
  const LocationOnScreen({super.key});

  @override
  ConsumerState<LocationOnScreen> createState() => _LocationOnScreenState();
}

class _LocationOnScreenState extends ConsumerState<LocationOnScreen> {
  @override
  Widget build(BuildContext context) {
    final locState = ref.watch(locationServiceProvider);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesMapBg),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Overlay LocationOnPopup in center only if permission not granted
          if (!locState.isGranted)
            Positioned(
              child: LocationOnPopup(
                isBlocked: locState.isBlocked,
                isServiceOff: !locState.isGranted && !locState.isBlocked,
                onAction: () async {
                  final notifier = ref.read(locationServiceProvider.notifier);
                  final granted = await notifier.ensurePermission();
                  if (granted && mounted) {
                    Navigator.pushReplacementNamed(context, RouteName.welcomeScreen);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
