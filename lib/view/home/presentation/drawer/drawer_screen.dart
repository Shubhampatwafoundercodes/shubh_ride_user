import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/main.dart';
import 'package:rider_pay_user/res/app_border.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay_user/view/home/presentation/widget/gradient_white_box.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            CommonBackBtnWithTitle(text: t.menu,),
            AppSizes.spaceH(10),

            /// Profile Card
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: AppPadding.screenPaddingH,
                      child: GradientContainer(child: Column(
                        children: [
                          /// Top Profile Row
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, RouteName.profile);
                            },
                            child: Consumer(
                              builder: (context, ref, _) {
                                final profileNotifier = ref.read(profileProvider.notifier);
                                return Row(
                                  children: [
                                    Container(
                                      height: 50.h,
                                      width: 50.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: context.primary, width: 2),
                                      ),
                                      child: Icon(Icons.person, size: 30.h, color: context.black),
                                    ),
                                    SizedBox(width: 12.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ConstText(
                                          text: profileNotifier.name.isNotEmpty
                                              ? profileNotifier.name[0].toUpperCase() + profileNotifier.name.substring(1).toLowerCase()
                                              : "N/A",
                                          fontSize: AppConstant.fontSizeThree,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        ConstText(
                                          text: profileNotifier.phone,
                                          color: context.textSecondary,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Icon(Icons.arrow_forward_ios, size: 16.h, color: context.textSecondary),
                                  ],
                                );
                              },
                            ),
                          ),


                          SizedBox(height: 14.h),
                          // Divider(color: context.greyMedium, thickness: 1),
                          // SizedBox(height: 10.h),
                          /// Rating Row
                          // Row(
                          //   children: [
                          //     Icon(Icons.star, color: AppColor.primary, size: 22.h),
                          //     SizedBox(width: 8.w),
                          //     ConstText(
                          //       text: "5.00 My Rating",
                          //       fontWeight: AppConstant.semiBold,
                          //     ),
                          //     const Spacer(),
                          //     Icon(Icons.arrow_forward_ios,
                          //         size: 16.h, color: context.textSecondary),
                          //   ],
                          // )
                        ],
                      ),),
                    ),

                    SizedBox(height: 20.h),

                    /// Drawer Menu Items
                    DrawerItem(icon: Icons.help_outline, label:t.help,
                      onTap: (){
                      Navigator.pushNamed(context, RouteName.help);
                      },
                    ),

                    DrawerDivider(),
                    DrawerItem(icon: Icons.payment, label: t.payment,onTap: (){
                      Navigator.pushNamed(context, RouteName.walletScreen);
                    },),
                    DrawerDivider(),
                    DrawerItem(icon: Icons.history, label: t.myRides,
                    onTap: (){
                      Navigator.pushNamed(context, RouteName.rideHistory);

                    },),
                    DrawerDivider(),
                    DrawerItem(
                        icon: Icons.card_giftcard,
                        label: t.referAndEarn,

                        subLabel: "Get ₹50"  ,onTap: (){
                      Navigator.pushNamed(context, RouteName.referAndEarn);
                    },),
                    // DrawerDivider(),
                    // DrawerItem(icon: Icons.redeem, label: t.myRewards  ,onTap: (){
                    //   Navigator.pushNamed(context, RouteName.myReward);
                    // },),
                    DrawerDivider(),
                    DrawerItem(
                      icon: Icons.notifications_outlined,
                      label: t.notifications,
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.notification);
                      },
                    ),
                    DrawerDivider(),
                    //
                    // DrawerItem(
                    //   icon: Icons.color_lens_outlined,
                    //   label: t.theme,
                    //   onTap: () {
                    //     Navigator.pushNamed(context, RouteName.theme);
                    //   },
                    // ),
                    // DrawerDivider(),

                    // DrawerItem(
                    //   icon: Icons.language_outlined,
                    //   label: t.language,
                    //   onTap: () {
                    //     Navigator.pushNamed(context, RouteName.language);
                    //   },
                    // ),
                    // DrawerDivider(),
                    // DrawerItem(
                    //     icon: Icons.confirmation_num_outlined,
                    //     label: t.powerPass),
                    DrawerDivider(),
                    // DrawerItem(
                    //     icon: Icons.monetization_on_outlined,
                    //     label: t.rapidoCoins),
                    // DrawerDivider(),
                    DrawerItem(
                      icon: Icons.settings_outlined,
                      label:t.settings,
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.settingScreen);
                      },
                    ),
                    DrawerDivider(),
                    AppSizes.spaceH(30)
                    /// Logout Button - Fixed at Bottom

                  ],
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, _) {
                final userP = ref.watch(appInfoNotifierProvider);
                final driverAppUrl = userP.appInfoModel?.data?.driverAppUrl ?? "";

                return GestureDetector(
                  onTap: () async {
                    if (driverAppUrl.isNotEmpty) {
                      final Uri url = Uri.parse(driverAppUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {

                        toastMsg("Could not open Play Store link");
                      }
                    } else {
                      toastMsg("App link not available");
                    }
                  },
                  child: Container(
                    margin: AppPadding.screenPadding,
                    decoration: BoxDecoration(
                      borderRadius: AppBorders.mediumRadius,
                      border: Border.all(
                        color: Colors.lightBlue.withAlpha(100),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstText(
                                text: t.driver,
                                color: context.textSecondary,
                                fontWeight: AppConstant.bold,
                                fontSize: AppConstant.fontSizeLarge,
                              ),
                              ConstText(
                                text: t.getEarning,
                                color: Colors.blue,
                                fontSize: AppConstant.fontSizeOne,
                                fontWeight: AppConstant.semiBold,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.blue,
                                size: 17.h,
                                weight: 30,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.12,
                          width: screenWidth * 0.36,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.imagesOnboarding1),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(18.r),
                              bottomRight: Radius.circular(18.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            AppSizes.spaceH(20),




          ],
        ),
      ),
    );
  }
}


/// Drawer Item
class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subLabel;
  final void Function()? onTap;
  final bool showArrow;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    this.subLabel,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 30.w,
      leading: Icon(icon, color: context.textSecondary),
      title: ConstText(text: label),
      subtitle: subLabel != null
          ? ConstText(
        text: subLabel!,
        fontSize: AppConstant.fontSizeOne,
        color: context.greyMedium,
      )
          : null,
      trailing: showArrow
          ? Icon(Icons.arrow_forward_ios,
          size: 16.h, color: context.textSecondary)
          : null,
      onTap: onTap,
    );
  }
}

/// Divider styled for drawer
class DrawerDivider extends StatelessWidget {
  const DrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.3,
      color: context.greyMedium,
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
