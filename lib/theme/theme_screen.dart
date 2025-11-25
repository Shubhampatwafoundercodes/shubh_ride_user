import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_back_btn.dart';
import 'package:rider_pay_user/res/constant/const_drop_down.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/theme/theme_controller.dart' show themeModeProvider;

class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);

    final themes = {
      ThemeMode.system: tr.systemDefault,
      ThemeMode.light: tr.light,
      ThemeMode.dark: tr.dark,
    };

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

              ConstText(
                text: tr.selectTheme,
                fontSize: AppConstant.fontSizeLarge,
                fontWeight: AppConstant.bold,
                color: context.textPrimary,
              ),
              AppSizes.spaceH(20),

              CommonDropdown<ThemeMode>(
                title: tr.theme,
                hintText: tr.selectTheme,
                items: themes.keys.toList(),
                itemLabel: (v) => themes[v]!,
                valueKey: (v) => v.name,
                selectedValue: themeMode,
                onChanged: (val) {
                  if (val != null) {
                    ref.read(themeModeProvider.notifier).changeTheme(val);
                  }
                },
              ),

              const Spacer(),

              AppBtn(
                border: Border.all(color: AppColor.primary, width: 1),
                title: tr.continueLabel,
                margin: AppPadding.screenPaddingV,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
