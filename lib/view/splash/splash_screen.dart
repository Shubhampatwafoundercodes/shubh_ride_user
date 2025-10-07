import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/share_pref/user_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(appInfoNotifierProvider.notifier).loadAppInfo();
      _navigateNext();

    });
  }

  Future<void> _navigateNext() async {
    await ref.read(userProvider.notifier).loadUser();
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final user = ref.read(userProvider);
    if (user != null && user.token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, RouteName.home);
    } else {
      Navigator.pushReplacementNamed(context, RouteName.onBoard);
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
