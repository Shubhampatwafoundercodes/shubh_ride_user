// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rider_pay/generated/assets.dart' show Assets;
// import 'package:rider_pay/l10n/app_localizations.dart';
// import 'package:rider_pay/res/app_color.dart';
// import 'package:rider_pay/res/app_padding.dart';
// import 'package:rider_pay/res/constant/const_text.dart';
// import 'package:rider_pay/view/home/presentation/drawer/drawer_screen.dart';
// import 'package:rider_pay/view/home/presentation/drawer/wallet_screen.dart' show PaymentTile;
// import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';
// import 'package:rider_pay/view/home/presentation/widget/gradient_white_box.dart';
//
// import '../../../../utils/routes/routes_name.dart';
//
// class HelpScreen extends StatelessWidget {
//   const HelpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: context.lightSkyBack,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Top Bar
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CommonBackBtnWithTitle(text: t.help),
//                 Padding(
//                   padding: EdgeInsets.only(right: 16.r),
//                   child: IconButton(
//                     icon: const Icon(Icons.confirmation_num_outlined),
//                     onPressed: () {
//                       // Navigator.pushNamed(context, RouteName.tickets);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//
//             Expanded(
//               child: ListView(
//                 padding: AppPadding.screenPaddingH,
//                 children: [
//                   SizedBox(height: 20.h),
//
//                   // /// Search Bar
//                   // GradientContainer(
//                   //   child: ListTile(
//                   //     leading: const Icon(Icons.search),
//                   //     title: ConstText(text: t.searchHelpTopics),
//                   //   ),
//                   // ),
//
//                   SizedBox(height: 16.h),
//
//                   /// Help Topics
//                   PaymentTile(
//                     title: t.rideFareIssues,
//                     // avatar: Assets.imagesRideIcon,
//                     trailing: const Icon(Icons.chevron_right),
//                   ),
//                   DrawerDivider(),
//                   PaymentTile(
//                     title: t.captainVehicleIssues,
//                     // avatar: Assets.imagesDriverIcon,
//                     trailing: const Icon(Icons.chevron_right),
//                   ),
//                   DrawerDivider(),
//                   PaymentTile(
//                     title: t.paymentIssues,
//                     // avatar: Assets.imagesPaymentIcon,
//                     trailing: const Icon(Icons.chevron_right),
//                   ),
//                   DrawerDivider(),
//                   PaymentTile(
//                     title: t.parcelIssues,
//                     // avatar: Assets.imagesParcelIcon,
//                     trailing: const Icon(Icons.chevron_right),
//                   ),
//                   DrawerDivider(),
//                   PaymentTile(
//                     title: t.otherTopics,
//                     // avatar: Assets.imagesOtherIcon,
//                     trailing: const Icon(Icons.chevron_right),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';

import 'package:rider_pay/view/home/provider/provider.dart';


class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfoState = ref.watch(appInfoNotifierProvider);
    final faqs = ref.watch(appInfoNotifierProvider.notifier).faqs;

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
                const CommonBackBtnWithTitle(text: "Help"),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: const Icon(Icons.confirmation_num_outlined),
                    onPressed: () {
                      // Navigator.pushNamed(context, RouteName.tickets);
                    },
                  ),
                ),
              ],
            ),

            Expanded(
              child: appInfoState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : faqs.isEmpty
                  ? const Center(child: Text("No FAQs available"))
                  : ListView.separated(
                padding:  EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 8.h),
                itemCount: faqs.length,
                separatorBuilder: (_, __) =>  SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.popupBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: context.black.withAlpha(50),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        tilePadding:  EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 0.h),
                        childrenPadding:  EdgeInsets.only(
                            left: 16.w, bottom: 8.h),
                        title: ConstText(text:
                          faq.question ?? "",
                          color: context.textPrimary,
                          fontWeight: AppConstant.medium,
                        ),
                        children: [
                          ConstText(text:
                            faq.answer ?? "",
                            fontSize: AppConstant.fontSizeOne,

                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

