import 'package:flutter/material.dart';
import 'package:rider_pay_user/res/app_color.dart';

class AppRefresher extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AppRefresher({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: context.primary,
      backgroundColor: context.black,
      displacement: 50,
      strokeWidth: 2.5,
      child: child,
    );
  }
}
