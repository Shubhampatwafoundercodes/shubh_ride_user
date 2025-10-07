import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart' show AppPadding;
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/format/date_time_formater.dart';
import 'package:rider_pay/view/home/presentation/drawer/profile/wallet_screen.dart'
    show SectionHeader;
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay/view/home/presentation/widget/gradient_white_box.dart';
import 'package:rider_pay/view/home/provider/provider.dart';

class MyRewardScreen extends ConsumerStatefulWidget {
  const MyRewardScreen({super.key});

  @override
  ConsumerState<MyRewardScreen> createState() => _MyRewardScreenState();
}

class _MyRewardScreenState extends ConsumerState<MyRewardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voucherProvider.notifier).getVouchers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final voucherState = ref.watch(voucherProvider);

    if (voucherState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final vouchers = voucherState.vouchers?.data?.vouchers ?? [];
    print("Shubham $vouchers");
    final totalAmount = voucherState.vouchers?.data?.totalAmount ?? 0;

    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: vouchers.isEmpty
            ? _buildEmptyState( t)
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonBackBtnWithTitle(text: t.myRewards),
            Expanded(
              child: ListView(
                padding: AppPadding.screenPaddingH,
                children: [
                  SizedBox(height: 20.h),

                  /// Reward Balance Box
                  GradientContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstText(
                          text: "${t.rewardBalance}: ₹$totalAmount",
                          fontWeight: FontWeight.w600,
                        ),
                        ConstText(
                          text: t.redeemYourRewards,
                          fontSize: 12.sp,
                          color: context.textSecondary,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  SectionHeader(title: t.recentTransactions),
                  SizedBox(height: 12.h),

                  /// Voucher List
                  GradientContainer(
                    child: Column(
                      children: vouchers.map((voucher) {
                        final isExpired =
                        (voucher.status?.toLowerCase() == "expired");
                        return Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.card_giftcard,
                                color: isExpired
                                    ? Colors.red
                                    : context.primary,
                                size: 28,
                              ),
                              title: ConstText(
                                text: voucher.code.toString(),
                                fontWeight: FontWeight.w600,
                              ),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  ConstText(
                                    text: voucher.description.toString(),
                                    fontSize: 12.sp,
                                    color: context.textSecondary,
                                  ),
                                  ConstText(
                                    text:
                                    "Date: ${voucher.createdAt != null ? DateTimeFormat.formatShortDate(voucher.createdAt!) : "--"}",
                                    fontSize: 11.sp,
                                    color: context.greyMedium,
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  ConstText(
                                    text: "₹${voucher.amount}",
                                    fontWeight: AppConstant.semiBold,
                                    color: isExpired
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  if (isExpired)
                                    ConstText(
                                      text: "Expired",
                                      fontSize: 10.sp,
                                      color: Colors.red,
                                    ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 🛑 Empty state UI
  Widget _buildEmptyState( AppLocalizations t) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_giftcard,
                size: 80, color: Colors.grey.shade400),
            SizedBox(height: 16),
            ConstText(
              text: "No data found",
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: context.textSecondary,
            ),
            SizedBox(height: 8),
            ConstText(
              text: "You don’t have any rewards yet.",
              fontSize: 12.sp,
              color: context.greyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
