import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/res/app_border.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_text_field.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/view/home/presentation/controller/add_money_provider.dart';
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';


class AddMoneyScreen extends ConsumerWidget {
  const AddMoneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final controller = ref.watch(amountControllerProvider);
    final selectedAmount = ref.watch(selectedAmountProvider);
    final presetAmounts = ref.watch(presetAmountsProvider);

    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: Padding(
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
                    final value = int.parse(val);
                    ref.read(selectedAmountProvider.notifier).select(value);
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
                        borderRadius:AppBorders.btnRadius,
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
                title: t.addMoney,
                onTap: () {
                  final entered = controller.text.trim();
                  if (entered.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter an amount")),
                    );
                    return;
                  }

                  final amount = int.tryParse(entered);
                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter valid amount")),
                    );
                    return;
                  }

                  // Navigator.pop(context, amount);
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
