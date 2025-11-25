import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/main.dart' show screenWidth, screenHeight;
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/view/widget/help_drop_down_widget.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: AppPadding.screenPaddingH,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      AppConstant.appLogoLightMode,
                      height: 50.h,
                      width: screenWidth * 0.3,
                    ),
                  ),
                  const HelpDropDownWidget(),
                ],
              ),
            ),
            AppSizes.spaceH(50),
            Container(
              height: screenHeight * 0.26,
              width: screenWidth * 0.8,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.imagesWelcomeScreenIc),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            AppSizes.spaceH(20),
            ConstText(
              text: loc.welcome,
              fontWeight: AppConstant.semiBold,
              fontSize: AppConstant.fontSizeHeading,
              color: context.textPrimary,
            ),
            AppSizes.spaceH(5),
            ConstText(
              text: loc.welcomeSubTitle,
            ),
            Spacer(),
            AppBtn(
              // color: Colors.white,
              border: Border.all(color: AppColor.primary, width: 1),
              title: loc.signIn, // localized
              // titleColor: AppColor.primary,
              margin: AppPadding.screenPadding,
              onTap: () {
                Navigator.pushNamed(context, RouteName.login);
              },
            ),
            // DoubleText(
            //   firstText: loc.doNotAccount, // localized
            //   tappableText1: loc.signUp, // localized
            //   onTap1: () {
            //     Navigator.pushNamed(context, RouteName.register);
            //
            //   },
            // ),
            AppSizes.spaceH(35),
          ],
        ),
      ),
    );
  }
}

