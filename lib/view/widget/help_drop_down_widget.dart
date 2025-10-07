import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, WidgetRef;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_border.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_size.dart' show AppSizes;
import 'package:rider_pay/res/constant/const_drop_down.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';

import '../../l10n/app_localizations.dart' show AppLocalizations;

class HelpDropDownWidget extends ConsumerWidget {
  const HelpDropDownWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!; // localized

    return CommonDropdown<String>(
      hintText: loc.help,
      items: [loc.help, loc.language,loc.theme],
      itemLabel: (v) => v,
      valueKey: (v) => v,
      onChanged: (val) {
        if (val == loc.help) {
          // Navigate to Help page
        } else if (val == loc.language) {
          Navigator.pushNamed(context, RouteName.language);
        }else if(val == loc.theme ){
          Navigator.pushNamed(context, RouteName.theme);

        }
      },
      dropdownWidth: screenWidth * 0.4,
      customBox: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.border, width: 1),
          borderRadius: AppBorders.largeRadius,
        ),
        child: Row(
          children: [
            Icon(Icons.help_outline,color: context.textPrimary,),
            AppSizes.spaceW(8),
            ConstText(text: loc.help,color: context.textPrimary,),
             Icon(Icons.arrow_drop_down_outlined,color:context.textPrimary,),
          ],
        ),
      ),
    );
  }
}
