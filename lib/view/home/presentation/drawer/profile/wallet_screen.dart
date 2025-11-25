import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/view/home/data/model/wallet_data_model.dart';
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay_user/view/home/presentation/widget/gradient_white_box.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart';
import 'package:rider_pay_user/view/widget/help_drop_down_widget.dart';


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
                  padding:EdgeInsets.only(right: 16.r),
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




class WalletDesignWidget extends ConsumerStatefulWidget {
  const WalletDesignWidget({super.key});

  @override
  ConsumerState<WalletDesignWidget> createState() => _WalletDesignWidgetState();
}

class _WalletDesignWidgetState extends ConsumerState<WalletDesignWidget> {
  @override
  void initState() {
    super.initState();

    /// Call wallet API when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = ref.read(userProvider.notifier).userId;
      if (userId != null) {
        await ref.read(walletProvider.notifier).getWalletHistory();
        await ref.read(profileProvider.notifier).getProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final walletNotifier = ref.watch(walletProvider.notifier);
    final state = ref.watch(walletProvider);
    final amount = walletNotifier.walletAmount;

    return RefreshIndicator(
      onRefresh: () async {
        final userId = ref.read(userProvider.notifier).userId;
        if (userId != null) {
          await walletNotifier.getWalletHistory();
          await ref.read(profileProvider.notifier).getProfile();

        }
      },
      child: Padding(
        padding: AppPadding.screenPaddingH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            /// Wallet Section
            SectionHeader(title: t.wallets),
            SizedBox(height: 12.h),

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
                            text: "${t.lowBalance}: ₹${amount.toStringAsFixed(2)}",
                            color: amount == 0.0
                                ? context.error
                                : context.textSecondary,
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
                    icon: Icon(Icons.add, color: context.textPrimary),
                    label:
                    ConstText(text: t.addMoney, color: context.textPrimary),
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
            SectionHeader(title: "Deposit History"),
            SizedBox(height: 12.h),

        Expanded(
          child: Builder(
            builder: (_) {
              final history =
                  state.walletData?.data?.payinHistory ?? const <PayinHistory>[];

              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (history.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet_outlined,
                          size: 50.sp, color: Colors.grey.shade400),
                      SizedBox(height: 10.h),
                      ConstText(
                        text: "No Deposit History Found",
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 4.h),
                      ConstText(
                        text: "Your recent transactions will appear here.",
                        fontSize: 12.sp,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
                itemCount: history.length,
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (_, index) {
                  final item = history[index];

                  // ✅ Safely parse datetime
                  final datetime = item.datetime;
                  final formattedDate = datetime != null
                      ? "${datetime.day.toString().padLeft(2, '0')}-"
                      "${datetime.month.toString().padLeft(2, '0')}-"
                      "${datetime.year} at "
                      "${datetime.hour.toString().padLeft(2, '0')}:"
                      "${datetime.minute.toString().padLeft(2, '0')}"
                      : "—";

                  // ✅ Determine color & icon safely
                  final status = item.status?.toLowerCase() ?? "unknown";
                  Color statusColor;
                  IconData statusIcon;

                  switch (status) {
                    case "success":
                    case "completed":
                      statusColor = Colors.green;
                      statusIcon = Icons.check_circle_rounded;
                      break;
                    case "failed":
                    case "cancelled":
                      statusColor = Colors.redAccent;
                      statusIcon = Icons.cancel_rounded;
                      break;
                    case "pending":
                      statusColor = Colors.orange;
                      statusIcon = Icons.hourglass_bottom_rounded;
                      break;
                    default:
                      statusColor = Colors.grey;
                      statusIcon = Icons.help_outline_rounded;
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: context.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: context.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left side — status icon
                        Container(
                          height: 44.h,
                          width: 44.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor.withOpacity(0.1),
                          ),
                          child: Icon(statusIcon, color: statusColor, size: 24.sp),
                        ),
                        SizedBox(width: 12.w),

                        // Right side — info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order ID Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ConstText(
                                      text: "Order ID: ${item.orderId ?? '--'}",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: context.textPrimary,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),


                                  ConstText(
                                    text: "₹${item.amount?.toString() ?? '—'}",
                                    fontSize: 14.sp,
                                    color: context.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),

                              SizedBox(height: 6.h),

                              // Status & Date Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.circle, size: 8.sp, color: statusColor),
                                      SizedBox(width: 5.w),
                                      ConstText(
                                        text: (item.status ?? '--').toUpperCase(),
                                        fontSize: 12.sp,
                                        color: statusColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today_outlined,
                                          size: 12.sp, color: Colors.grey.shade500),
                                      SizedBox(width: 4.w),
                                      ConstText(
                                        text: formattedDate,
                                        fontSize: 11.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        )
          ],
        ),
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
