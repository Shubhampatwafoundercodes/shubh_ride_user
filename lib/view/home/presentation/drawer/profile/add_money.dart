import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_border.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_text_field.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/home/presentation/controller/add_money_provider.dart';
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay_user/view/payment_section/payment_service.dart';

class AddMoneyScreen extends ConsumerStatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  ConsumerState<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends ConsumerState<AddMoneyScreen> {
  final TextEditingController controller =TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedAmountProvider.notifier).reset();
      controller.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // final controller = ref.watch(amountControllerProvider);
    final selectedAmount = ref.watch(selectedAmountProvider);
    final presetAmounts = ref.watch(presetAmountsProvider);
    final paymentState = ref.watch(paymentProvider);



    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top Bar
                  CommonBackBtnWithTitle(
                    text: t.addMoney,
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 24.h),

                  /// Title
                  ConstText(
                    text: t.enterAmount,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: context.textPrimary,
                  ),
                  SizedBox(height: 8.h),

                  /// TextField
                  AppTextField(
                    controller: controller,
                    hintText: t.enterAmount,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      if (val.isEmpty) {
                        ref.read(selectedAmountProvider.notifier).select(null);
                      } else {
                        final value = int.tryParse(val);
                        if (value != null) {
                          ref.read(selectedAmountProvider.notifier).select(value);
                        }
                      }
                    },
                  ),
                  SizedBox(height: 30.h),

                  /// Preset Amounts
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    alignment: WrapAlignment.center,
                    children: presetAmounts.map((amount) {
                      final isSelected = selectedAmount == amount;
                      return GestureDetector(
                        onTap: () {
                          controller.text = amount.toString();
                        },
                        child: Container(
                          width: 100.w,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? context.primary : Colors.transparent,
                            borderRadius: AppBorders.btnRadius,
                            border: Border.all(
                              color: isSelected ? context.primary : context.greyDark,
                              width: 1.2,
                            ),
                          ),
                          child: ConstText(
                            text: "₹$amount",
                            fontWeight: AppConstant.semiBold,
                            color: isSelected ? context.white : context.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const Spacer(),

                  /// Add Money Button
                  AppBtn(
                    title: paymentState.status == PaymentStatus.loading
                        ? "Processing..."
                        : t.addMoney,
                    onTap: paymentState.status == PaymentStatus.loading
                        ? null
                        : () async {
                      final amount = double.tryParse(controller.text.trim());
                      if (amount == null || amount <= 0) {
                        toastMsg("❌ Invalid amount: ${controller.text}");
                        return;
                      }

                      try {

                        /// 1️⃣ Prepare session
                        // await ref.read(paymentProvider.notifier).preparePayment(
                        //   amount: amount.toDouble(),
                        // );

                        /// 2️⃣ Clear fields before launching Cashfree sheet
                        ref.read(selectedAmountProvider.notifier).select(null);
                        controller.clear();
                        debugPrint("🧹 Cleared selected amount + text");
                        await ref.read(paymentProvider.notifier).startPayment(amount);

                      } catch (e) {
                        toastMsg("❌ Payment error: $e");
                        // ref.read(paymentProvider.notifier)
                        //     .setFailed(e.toString());
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),

            /// 🔄 Fullscreen White Loader Overlay (like PhonePe)
            if (paymentState.status == PaymentStatus.loading)
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  color: Colors.white.withAlpha(90),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 50.w,
                          width: 50.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 4,
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(width: 20.h),
                        const Text(
                          "Processing Payment...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
