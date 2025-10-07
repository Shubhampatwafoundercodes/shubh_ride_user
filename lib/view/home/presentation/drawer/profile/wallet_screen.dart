import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay/generated/assets.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/app_text_field.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/home/presentation/drawer/drawer_screen.dart';
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay/view/home/presentation/widget/gradient_white_box.dart';
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/widget/help_drop_down_widget.dart';



class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t= AppLocalizations.of(context)!;
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
                CommonBackBtnWithTitle(text:t.payment),
                Padding(
                  padding:  EdgeInsets.only(right: 16.r),
                  child: HelpDropDownWidget(),
                ),
              ],
            ),
            Expanded(
              child: WalletDesignWidget(),
            )
          ],
        ),
      ),
    );
  }
}

class WalletDesignWidget extends ConsumerWidget {
  const WalletDesignWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t= AppLocalizations.of(context)!;
    final walletNotifier = ref.read(walletProvider.notifier);
    final amount = walletNotifier.walletAmount;

    return Padding(
      padding: AppPadding.screenPaddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          /// Wallet Section
           SectionHeader(title: t.wallets),
            SizedBox(height: 12.h),

          /// Rider Wallet
          GradientContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         ConstText(
                          text: t.wallets,
                          fontWeight: FontWeight.w600,
                        ),
                        ConstText(
                          text: "${t.lowBalance}: ₹$amount",
                          color: amount == 0.0 ? context.error : context.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.addMoney);
                  },
                  icon:  Icon(Icons.add,color: context.textPrimary,),
                  label:  ConstText(text: t.addMoney,color: context.textPrimary,),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 16.h),
          /// UPI Section
          Row(
            children: [
              SizedBox(
                width: screenWidth*0.1,
                  child: Image.asset(Assets.imagesUpiLogo,)),
              AppSizes.spaceW(10),
               SectionHeader(title: t.payByUpi),
            ],
          ),
          SizedBox(height: 12.h),

          GradientContainer(
            child: Column(
              children: [
                PaymentTile(
                  title: "Paytm",
                  subtitle: ConstText(
                    text:
                    "₹10 - ₹200 Cashback | Min order ₹49 | ",
                    fontSize:AppConstant.fontSizeOne,
                    color: context.textSecondary,
                  ),
                  avatar: Assets.imagesPaytmLogo,
                ),
                Divider(height: 1, color: Colors.grey.shade300),
                PaymentTile(
                  title: "RazorPay",
                  avatar: Assets.imagesRozorPay,
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          /// Pay Later
           SectionHeader(title: t.payLater),
          SizedBox(height: 12.h),

          GradientContainer(
            child: Column(
              children: [
                PaymentTile(
                  title: t.payAtDrop,
                  leadingIcon: const Icon(Icons.qr_code),
                  subtitle: ConstText(
                    text: t.goCashless,
                    fontSize: 12.sp,
                    color: context.textSecondary,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}


/// Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ConstText(
      text: title,
      fontSize: AppConstant.fontSizeThree,
      fontWeight: AppConstant.semiBold,
      color: context.textSecondary,
    );
  }
}

/// PaymentTile Widget
class PaymentTile extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final Widget? trailing;
  final String? avatar;
  final Widget? leadingIcon;

  const PaymentTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.avatar,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon ??
        Container(
          height: 35.w,
          width: 35.w,
          decoration: BoxDecoration(
            color:context.greyLight,
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(avatar??Assets.imagesUpiLogo),fit: BoxFit.contain)
          ),
        ),
      title: ConstText(
        text: title,
        fontWeight: FontWeight.w600,
      ),
      subtitle: subtitle,
      trailing: trailing,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
