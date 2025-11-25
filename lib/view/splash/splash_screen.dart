import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/view/firebase_service/notification/notifi.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
// ignore: unused_import
import 'package:rider_pay_user/view/map/presentation/controller/state/map_state.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(appInfoNotifierProvider.notifier).loadAppInfo();
      _navigateNext();
    });
    notificationService.requestedNotificationPermission();
    notificationService.firebaseInit(context);
    notificationService.getDeviceToken();
    notificationService.setupInteractMassage(context);
  }

  Future<void> _navigateNext() async {
    await ref.read(userProvider.notifier).loadUser();
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    ref.read(locationServiceProvider.notifier).ensurePermission();
    final user = ref.read(userProvider);
     print(user?.onBoardSeen);
      if (user != null  && user.id.isNotEmpty  && user.token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, RouteName.home);
    } else {
      if (user?.onBoardSeen ?? true) {
        Navigator.pushReplacementNamed(context, RouteName.welcomeScreen);
      } else {
        Navigator.pushReplacementNamed(context, RouteName.onBoard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: Padding(
        padding: AppPadding.screenPadding,
        child: Center(
          child: Image.asset(AppConstant.appLogoLightMode),
        ),
      ),
    );
  }
}
