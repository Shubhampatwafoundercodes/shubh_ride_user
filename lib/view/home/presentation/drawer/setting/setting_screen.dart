import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/home/presentation/controller/profile_notifier.dart';
import 'package:rider_pay/view/home/presentation/drawer/drawer_screen.dart';
import 'package:rider_pay/view/home/presentation/drawer/setting/cms_term_condition_screen.dart';
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay/view/home/provider/provider.dart'
    show profileProvider, cmsProvider;
import 'package:rider_pay/view/share_pref/user_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cmsProvider.notifier).getCmsTermConditionApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final profileNotifier = ref.read(profileProvider.notifier);
    final cmsState = ref.watch(cmsProvider);

    // final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: Column(
          children: [
            CommonBackBtnWithTitle(text: t.settings),
            Expanded(
              child: ListView(
                children: [
                  const DrawerDivider(),
                  DrawerItem(
                    icon: Icons.language_outlined,
                    label: t.language,
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.language);
                    },
                  ),
                  const DrawerDivider(),
                  DrawerItem(
                    icon: Icons.color_lens_outlined,
                    label: t.theme,
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.theme);
                    },
                  ),
                  const DrawerDivider(),
                  // Terms & Conditions
                  DrawerItem(
                    icon: Icons.description_outlined,
                    label: t.termsConditions,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CmsPageScreen(
                            title: t.termsConditions,
                            htmlData:
                                cmsState.pages?["terms_conditions"] ??
                                "<p>No data found</p>",
                          ),
                        ),
                      );
                    },
                  ),
                  const DrawerDivider(),

                  // Privacy Policy
                  DrawerItem(
                    icon: Icons.privacy_tip_outlined,
                    label: t.privacyPolicy,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CmsPageScreen(
                            title: t.privacyPolicy,
                            htmlData:
                                cmsState.pages?["privacy_policy"] ??
                                "<p>No data found</p>",
                          ),
                        ),
                      );
                    },
                  ),
                  const DrawerDivider(),

                  // Safety Concern
                  DrawerItem(
                    icon: Icons.security_outlined,
                    label: t.safetyConcern,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CmsPageScreen(
                            title: t.safetyConcern,
                            htmlData:
                                cmsState.pages?["safety_concern"] ??
                                "<p>No data found</p>",
                          ),
                        ),
                      );
                    },
                  ),
                  const DrawerDivider(),

                  DrawerItem(
                    icon: Icons.info_outline,
                    label: t.aboutUs,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CmsPageScreen(
                            title: t.aboutUs,
                            htmlData:
                                cmsState.pages?["about_us"] ??
                                "<p>No data found</p>",
                          ),
                        ),
                      );
                    },
                  ),
                  const DrawerDivider(),

                  DrawerItem(
                    icon: Icons.cached_outlined,
                    label: t.cancelRefund,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CmsPageScreen(
                            title: t.cancelRefund,
                            htmlData:
                                cmsState.pages?["cancel_refund"] ??
                                "<p>No data found</p>",
                          ),
                        ),
                      );
                    },
                  ),
                  const DrawerDivider(),

                  /// Delete Account
                  DrawerItem(
                    icon: Icons.delete_outline,
                    label: t.deleteAccount,
                    onTap: () {
                      _showDeleteAccountBottomSheet(
                        context,
                        profileNotifier,
                        t,
                      );
                    },
                  ),
                  const DrawerDivider(),

                  /// Logout
                  InkWell(
                    onTap: () {
                      _showLogoutBottomSheet(context, ref, t);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: context.error),
                          SizedBox(width: 28.w),
                          ConstText(text: t.logout),
                        ],
                      ),
                    ),
                  ),
                  const DrawerDivider(),

                  DrawerItem(
                    showArrow: false,
                    subLabel: "1.0.0",
                    icon: Icons.info_outline,
                    label: "App Version",
                    onTap: () {},
                  ),

                  AppSizes.spaceH(30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Delete Account BottomSheet
  void _showDeleteAccountBottomSheet(
    BuildContext context,
    ProfileNotifier notifier,
    AppLocalizations t,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(profileProvider);

            return CommonBottomSheet(
              title: t.deleteAccount,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstText(text: t.deleteAccountConfirmMsg),
                  SizedBox(height: 26.h),
                  AppBtn(
                    title: t.delete,
                    loading: state.isDeletingAccount,
                    onTap: () {
                      notifier.deleteAccount().then((_) async {
                        await ref.read(userProvider.notifier).clearUser();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteName.splash,
                          (route) => false,
                        );
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  AppBtn(
                    titleColor: context.textPrimary,
                    color: Colors.transparent,
                    border: Border.all(color: context.greyDark, width: 2),
                    title: t.cancel,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// 🔹 Logout BottomSheet
  void _showLogoutBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations t,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CommonBottomSheet(
          showCloseButton: false,
          title: t.logout,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstText(text: t.logoutConfirmMsg),
              SizedBox(height: 26.h),
              AppBtn(
                title: t.logout,
                onTap: () async {
                  await ref.read(userProvider.notifier).clearUser();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteName.splash,
                    (route) => false,
                  );
                },
              ),
              SizedBox(height: 20.h),
              AppBtn(
                titleColor: context.textPrimary,
                color: Colors.transparent,
                border: Border.all(color: context.greyDark, width: 2),
                title: t.cancel,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

