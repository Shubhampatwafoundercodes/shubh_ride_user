import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/view/home/presentation/drawer/drawer_screen.dart';
import 'package:rider_pay/view/home/presentation/drawer/profile/wallet_screen.dart' show SectionHeader;
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart' show CommonBackBtnWithTitle;
import 'package:rider_pay/view/home/presentation/widget/gradient_white_box.dart';
import 'package:rider_pay/view/home/provider/provider.dart';

class ReferAndEarnScreen extends StatelessWidget {
  const ReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonBackBtnWithTitle(text: t.referAndEarn),
              ],
            ),

            Expanded(
              child: ListView(
                padding: AppPadding.screenPaddingH,
                children: [
                  SizedBox(height: 20.h),

                  /// Banner / Reward Highlight
                  GradientContainer(
                    child: Column(
                      children: [
                        Icon(Icons.card_giftcard, size: 48, color: context.primary),
                        SizedBox(height: 8.h),
                        ConstText(
                          text: t.inviteFriendsEarn,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                        SizedBox(height: 4.h),
                        ConstText(
                          text: t.referDescription,
                          fontSize: 12.sp,
                          color: context.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// Referral Code
                  GradientContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer(
                          builder: (context,ref,_) {
                            final profileNotifier = ref.watch(profileProvider);
                            final referCode=profileNotifier.profile?.data?.inviteCode??"---";
                            return ConstText(
                              text:referCode.toString(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            );
                          }
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            // Share logic here
                          },
                          icon: const Icon(Icons.share),
                          label: ConstText(text: t.share),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// Steps Section
                  SectionHeader(title: t.howItWorks),
                  SizedBox(height: 12.h),

                  Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_add_alt),
                        title: ConstText(text: t.inviteYourFriend),
                        subtitle: ConstText(
                          text: t.sendInviteLink,
                          fontSize: 12.sp,
                          color: context.textSecondary,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.app_registration),
                        title: ConstText(text: t.friendSignsUp),
                        subtitle: ConstText(
                          text: t.signupWithReferral,
                          fontSize: 12.sp,
                          color: context.textSecondary,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.currency_rupee),
                        title: ConstText(text: t.earnRewards),
                        subtitle: ConstText(
                          text: t.getCashbackOnFirstRide,
                          fontSize: 12.sp,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
