import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/view/home/presentation/drawer/profile/wallet_screen.dart'
    show SectionHeader;
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart'
    show CommonBackBtnWithTitle;
import 'package:rider_pay_user/view/home/presentation/widget/gradient_white_box.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
// ignore: deprecated_member_use
import 'package:share_plus/share_plus.dart' show Share;

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
              children: [CommonBackBtnWithTitle(text: t.referAndEarn)],
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
                        Icon(
                          Icons.card_giftcard,
                          size: 48,
                          color: context.primary,
                        ),
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
                  Consumer(
                    builder: (context, ref, _) {
                      final profileNotifier = ref.watch(profileProvider);
                      final referCode =
                          profileNotifier.profile?.data?.inviteCode ?? "---";
                      return GradientContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstText(
                              text: referCode.toString(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final message =
                                    '''
🚖 Invite & Earn Rewards!

Use my referral code **$referCode** while signing up and get instant rewards on your first ride! 🎉

Download the app now 👇
https://play.google.com/store/apps/details?id=com.yourapp.package

Let's ride together! 🚗💨
''';

                                // ignore: deprecated_member_use
                                await Share.share(
                                  message,
                                  subject: 'Join me on Shubh Ride!',
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: ConstText(text: t.share),
                            ),
                          ],
                        ),
                      );
                    },
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
