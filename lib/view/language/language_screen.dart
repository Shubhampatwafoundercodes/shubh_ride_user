import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/const_back_btn.dart';
import 'package:rider_pay/res/constant/const_drop_down.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/constant/custom_slider_dialog.dart';
import 'package:rider_pay/view/language/language_controller.dart';
import 'package:rider_pay/view/widget/success_reject_popup.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = AppLocalizations.of(context)!;

    /// Available languages (from provider)
    final languages = ref.watch(availableLanguagesProvider);

    /// Current selected language name
    final selectedLanguage = ref.watch(currentLanguageProvider);
    print("object: ${tr.language}");
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizes.spaceH(15),
              const ConstAppBackBtn(),
              AppSizes.spaceH(30),

              /// Title
              ConstText(
                text: tr.selectYourLanguage,
                fontSize: AppConstant.fontSizeLarge,
                fontWeight: AppConstant.bold,
              ),

              AppSizes.spaceH(12),

              /// Subtitle
              ConstText(
                text: tr.changeLanguageHelp,
                fontWeight: AppConstant.regular,
                color: AppColor.textSecondary,
              ),

              AppSizes.spaceH(30),

              /// Language Dropdown
              CommonDropdown<String>(
                title: tr.language,
                hintText: tr.selectYourLanguage,
                items: languages,
                itemLabel: (v) => v,
                valueKey: (v) => v,
                selectedValue: selectedLanguage,
                onChanged: (val) {
                  if (val != null) {
                    final code = ref
                        .read(localeProvider.notifier)
                        .getCodeFromName(val);
                    ref.read(localeProvider.notifier).changeLocale(code);
                  }
                },
              ),

              const Spacer(),

              /// Continue Button
              // AppBtn(
              //   border: Border.all(color: AppColor.primary, width: 1),
              //   title: tr.continueLabel,
              //   margin: AppPadding.screenPaddingV,
              //   onTap: () {
              //     CustomSlideDialog.show(
              //       context: context,
              //       child: SuccessRejectPopup(
              //         isReject: false,
              //         title: tr.paymentFailed,
              //         subtitle: tr.somethingWentWrong,
              //         btnTitle: tr.retry,
              //         onAction: () {},
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
