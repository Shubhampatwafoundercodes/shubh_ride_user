import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_color.dart';
// ignore: unused_import
import 'package:rider_pay_user/view/home/presentation/drawer/drawer_screen.dart';
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay_user/view/widget/help_drop_down_widget.dart';

class Rating extends StatelessWidget {
  const Rating({super.key});

  @override
  Widget build(BuildContext context) {
    final t=AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body:SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonBackBtnWithTitle(text: t.profile),
                Padding(
                  padding:  EdgeInsets.only(right: 18.w),
                  child: HelpDropDownWidget(),
                ),
              ],
            ),
          ],
        ),
      ) ,
    );
  }
}
