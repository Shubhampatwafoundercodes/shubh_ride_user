import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/view/home/presentation/drawer/drawer_screen.dart';
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay/view/home/presentation/widget/gradient_white_box.dart';


/// Model (baad me API response se replace hoga)
class NotificationModel {
  final String title;
  final String message;
  final String time;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    /// Dummy list (API se aayega)
    final List<NotificationModel> notifications = [
      NotificationModel(
        title: "Anurag!",
        message: "Tell us how can we make your next ride better! 😍",
        time: "3 hours ago",
      ),
      NotificationModel(
        title: "Anurag, did this ride cost you ₹48?",
        message:
        "Psst...🤫 With Power Pass, you will get guaranteed discounts on every Rapido ride! Claim it now!",
        time: "13 hours ago",
      ),
      NotificationModel(
        title: "Ended ride at a different point?",
        message: "Please let us know why",
        time: "13 hours ago",
      ),
      NotificationModel(
        title: "Monday mood: 😓 → 😎",
        message:
        "Escape the office grind & ride easy! Book your cab @ Lowest Price & chill your way home 🚖",
        time: "14 hours ago",
      ),
      NotificationModel(
        title: "Hey anurag, your feedback is priceless to us!",
        message:
        "We'd love to hear about your cab ride 🚕 experience and make it even better next time! 😍",
        time: "21 hours ago",
      ),
    ];

    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Bar
            CommonBackBtnWithTitle(text: t.notifications),

            /// Notifications List
            Expanded(
              child: ListView.builder(
                padding: AppPadding.screenPaddingH,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return GradientContainer(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: ConstText(
                        text: item.title,
                        fontWeight: AppConstant.semiBold,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstText(
                            text: item.message,
                            fontSize: AppConstant.fontSizeTwo,
                            color: context.textSecondary,
                          ),
                          SizedBox(height: 4.h),
                          ConstText(
                            text: item.time,
                            fontSize: AppConstant.fontSizeZero,
                            color: context.hintTextColor,
                          ),
                        ],
                      ),
                      dense: true,
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
