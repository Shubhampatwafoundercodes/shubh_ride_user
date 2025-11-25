import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/format/date_time_formater.dart';
import 'package:rider_pay_user/view/home/presentation/controller/notification_api_notifer.dart';
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay_user/view/home/presentation/widget/gradient_white_box.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // API call on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationApiProvider.notifier).notificationApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final state = ref.watch(notificationApiProvider);
    final notifications = state.notificationModelData?.data ?? [];

    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Bar
            CommonBackBtnWithTitle(text: t.notifications),

            /// Loader
            if (state.isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (notifications.isEmpty)
              const Expanded(
                child: Center(child: ConstText(text: "No notifications found.")),
              )
            else
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
                        leading: Container(
                          height: 12,
                          width: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent,
                          ),
                        ),
                        title: ConstText(
                          text: item.title ?? "No title",
                          fontWeight: AppConstant.semiBold,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstText(
                              text: item.description ?? "",
                              fontSize: AppConstant.fontSizeTwo,
                              color: context.textSecondary,
                            ),
                            SizedBox(height: 4.h),
                            ConstText(
                              text: DateTimeFormat.formatFullDateTime(item.datetime.toString()),
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
