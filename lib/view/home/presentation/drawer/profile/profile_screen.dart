// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rider_pay/l10n/app_localizations.dart';
// import 'package:rider_pay/res/app_btn.dart';
// import 'package:rider_pay/res/app_color.dart';
// import 'package:rider_pay/res/app_constant.dart';
// import 'package:rider_pay/res/app_text_field.dart';
// import 'package:rider_pay/res/constant/common_bottom_sheet.dart';
// import 'package:rider_pay/res/constant/const_text.dart';
// import 'package:rider_pay/view/home/presentation/drawer/drawer_screen.dart';
// import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';
// import 'package:rider_pay/view/widget/help_drop_down_widget.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final t=AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: context.lightSkyBack,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               /// Top Title Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CommonBackBtnWithTitle(text: t.profile),
//                   Padding(
//                     padding:  EdgeInsets.only(right: 18.w),
//                     child: HelpDropDownWidget(),
//                   ),
//                 ],
//               ),
//                SizedBox(height: 16.h),
//
//               /// Profile Items
//               _buildProfileItem(
//                 icon: Icons.person_outline,
//                 title: t.fullName,
//                 value: "Shubham Patwa",
//                 onTap: () => _showEditBottomSheet(
//                   context,
//                   title: "${t.edit} ${t.fullName}",
//                   hint: "${t.enter} ${t.fullName}",
//                 ),
//               ),
//               DrawerDivider(),
//
//               _buildProfileItem(
//                 icon: Icons.phone_outlined,
//                 title: t.phoneNumber,
//                 value: "+91 7271023722",
//                 onTap: null,
//               ),
//               DrawerDivider(),
//
//               _buildProfileItem(
//                 icon: Icons.email_outlined,
//                 title: t.email,
//                 value: "null",
//                 onTap: () => _showEditBottomSheet(
//                   context,
//                   title: "${t.edit} ${t.email}",
//                   hint: "${t.enter} ${t.email}",
//                 ),
//               ),
//               DrawerDivider(),
//
//               _buildProfileItem(
//                 icon: Icons.male_outlined,
//                 title: t.gender,
//                 value: t.male,
//               ),
//               DrawerDivider(),
//
//               _buildProfileItem(
//                 icon: Icons.calendar_today_outlined,
//                 title: t.dob,
//                 value: "08/09/2013",
//                 onTap: () => _showEditBottomSheet(
//                   context,
//                   title: "${t.edit} ${t.dob}",
//                   hint: "${t.enter} ${t.dob}",
//                   isDob: true,
//                 ),
//               ),
//               DrawerDivider(),
//
//               _buildProfileItem(
//                 icon: Icons.star_border,
//                 title: t.memberSince,
//                 value: "October 2021",
//                 onTap: null,
//               ),
//               DrawerDivider(),
//
//               /// Emergency Contact
//               ListTile(
//                 leading: const Icon(Icons.warning_amber_outlined),
//                 title:  ConstText(
//                   text: t.emergencyContact,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 subtitle:  ConstText(
//                   text: t.required,
//                   color: Colors.red,
//                 ),
//                 trailing: TextButton(
//                   onPressed: () {
//                     _showEditBottomSheet(
//                       context,
//                       title: "${t.add} ${t.emergencyContact}",
//                       hint: "${t.enter} ${t.phoneNumber}",
//                     );
//                   },
//                   child:  ConstText(
//                     text: t.add,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Common item row
//   Widget _buildProfileItem({
//     required IconData icon,
//     required String title,
//     required String value,
//     VoidCallback? onTap,
//   }) {
//     return ListTile(
//       onTap: onTap,
//       leading: Icon(icon, color: context.textSecondary),
//       title: ConstText(
//         text: title,
//         fontWeight:AppConstant.medium,
//         fontSize: AppConstant.fontSizeTwo,
//         color: context.textPrimary,
//       ),
//       subtitle: ConstText(
//         text: value,
//         color: context.textSecondary,
//         fontSize: AppConstant.fontSizeTwo,
//       ),
//       trailing: onTap != null
//           ?  Icon(Icons.arrow_forward_ios, size: 16.h,color: context.textSecondary ,)
//           : null,
//     );
//   }
//
//
//   /// DOB ke liye Date Picker
//   Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
//     final ThemeData theme = Theme.of(context);
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2000, 1, 1), // default date
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: theme.copyWith(
//             colorScheme: theme.colorScheme.copyWith(
//               primary: theme.colorScheme.primary, // date picker primary color
//               onSurface: theme.colorScheme.onSurface, // text color
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       controller.text = "${picked.day}/${picked.month}/${picked.year}";
//     }
//   }
//
//   /// BottomSheet for editing with DOB support
//   void _showEditBottomSheet(
//       BuildContext context, {
//         required String title,
//         required String hint,
//         bool isDob = false,
//       }) {
//     final controller = TextEditingController();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return CommonBottomSheet(
//           title: title,
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               GestureDetector(
//                 onTap: isDob
//                     ? () => _selectDate(context, controller)
//                     : null,
//                 child: AbsorbPointer(
//                   absorbing: isDob, // disable manual typing if DOB
//                   child: AppTextField(
//                     controller: controller,
//                     hintText: hint,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               AppBtn(
//                 title: "Save Changes",
//                 onTap: () {
//                   // Save logic here
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_text_field.dart';
import 'package:rider_pay/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/view/home/presentation/drawer/drawer_screen.dart'
    show DrawerDivider;
import 'package:rider_pay/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/widget/help_drop_down_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    // Riverpod se profile state aur notifier
    final profileState = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    // API call agar first load

    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: profileState.isLoadingProfile
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    /// Top Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonBackBtnWithTitle(text: t.profile),
                        Padding(
                          padding: EdgeInsets.only(right: 18.w),
                          child: HelpDropDownWidget(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    /// Profile Items using notifier getters
                    _buildProfileItem(
                      context,
                      icon: Icons.person_outline,
                      title: t.fullName,
                      value: profileNotifier.name,
                      onTap: () {
                        _showEditBottomSheet(
                          context,
                          title: "${t.edit} ${t.fullName}",
                          hint: "${t.enter} ${t.fullName}",
                          initialValue: profileNotifier.name,
                          onSave: (value) {
                            if (value.isNotEmpty) {
                              profileNotifier.updateProfileField("name", value); // 🔹 key = "name"
                            }
                          },
                        );
                      }


                    ),
                    DrawerDivider(),

                    _buildProfileItem(
                      context,
                      icon: Icons.phone_outlined,
                      title: t.phoneNumber,
                      value: profileNotifier.phone,
                    ),
                    DrawerDivider(),

                    _buildProfileItem(
                      context,
                      icon: Icons.email_outlined,
                      title: t.email,
                      value: profileNotifier.email,
                      onTap: () {
                        _showEditBottomSheet(
                          context,
                          title: "${t.edit} ${t.email}",
                          hint: "${t.enter} ${t.email}",
                          initialValue: profileNotifier.email,
                          onSave: (value) {
                            if (value.isNotEmpty) {
                              profileNotifier.updateProfileField("email", value); // 🔹 key = "email"
                            }
                          },
                        );
                      }

                    ),
                    DrawerDivider(),

                    _buildProfileItem(
                      context,
                      icon: Icons.male_outlined,
                      title: t.gender,
                      value: profileNotifier.gender,
                    ),
                    DrawerDivider(),

                    _buildProfileItem(
                      context,
                      icon: Icons.calendar_today_outlined,
                      title: t.dob,
                      value: profileNotifier.dob,
                      onTap: () => _showEditBottomSheet(
                        context,
                        title: "${t.edit} ${t.dob}",
                        hint: "${t.enter} ${t.dob}",
                        isDob: true,
                          initialValue:  profileNotifier.dob,
                          onSave: (v){
                            if (v.isNotEmpty) {
                              profileNotifier.updateProfileField("dob", v); // 🔹 key = "bod" (backend expects bod)
                            }
                          }
                      ),
                    ),
                    DrawerDivider(),

                    _buildProfileItem(
                      context,
                      icon: Icons.star_border,
                      title: t.memberSince,
                      value: profileNotifier.memberSince,
                    ),
                    DrawerDivider(),

                    /// Emergency Contact
                    ListTile(
                      leading: const Icon(Icons.warning_amber_outlined),
                      title: ConstText(
                        text: t.emergencyContact,
                        fontWeight: AppConstant.semiBold,
                      ),
                      subtitle: ConstText(
                        text: profileNotifier.emergencyContact.isNotEmpty
                            ? profileNotifier.emergencyContact // backend se value
                            : t.required, // agar null/empty ho
                        color: profileNotifier.emergencyContact.isNotEmpty
                            ? context.textSecondary
                            : Colors.red,
                      ),
                      trailing: TextButton(
                        onPressed: () => _showEditBottomSheet(
                          context,
                          title: profileNotifier.emergencyContact.isNotEmpty
                              ? "${t.edit} ${t.emergencyContact}"
                              : "${t.add} ${t.emergencyContact}",
                          hint: "${t.enter} ${t.phoneNumber}",
                          initialValue: profileNotifier.emergencyContact ?? "",
                          onSave: (v) {
                            if (v.isNotEmpty) {
                              profileNotifier.updateProfileField("emergencyContact", v);
                            }
                          },
                        ),
                        child: ConstText(
                          text: profileNotifier.emergencyContact.isNotEmpty
                              ? t.edit
                              : t.add,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: context.textSecondary),
      title: ConstText(
        text: title,
        fontWeight: AppConstant.medium,
        fontSize: AppConstant.fontSizeTwo,
        color: context.textPrimary,
      ),
      subtitle: ConstText(
        text: value,
        color: context.textSecondary,
        fontSize: AppConstant.fontSizeTwo,
      ),
      trailing: onTap != null
          ? Icon(
              Icons.arrow_forward_ios,
              size: 16.h,
              color: context.textSecondary,
            )
          : null,
    );
  }
  //
  // void _showEditBottomSheet(
  //     BuildContext context, {
  //       required String title,
  //       required String hint,
  //       required String initialValue,
  //       required void Function(String) onSave,
  //       bool isDob = false,
  //     }) {
  //   final controller = TextEditingController(text: initialValue);
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) {
  //       return CommonBottomSheet(
  //         title: title,
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             GestureDetector(
  //               onTap: isDob ? () => _selectDate(context, controller) : null,
  //               child: AbsorbPointer(
  //                 absorbing: isDob,
  //                 child: AppTextField(controller: controller, hintText: hint),
  //               ),
  //             ),
  //             SizedBox(height: 16.h),
  //             AppBtn(
  //               title: "Save Changes",
  //               onTap: () {
  //                 final value = controller.text.trim();
  //                 if (value.isNotEmpty) {
  //                   onSave(value); // Riverpod notifier ke update function call
  //                 }
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  void _showEditBottomSheet(
      BuildContext context, {
        required String title,
        required String hint,
        required String initialValue,
        required void Function(String) onSave,
        bool isDob = false,
      }) {
    final controller = TextEditingController(text: initialValue);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Consumer(
          builder: (context, ref, _) {
            final isUpdating = ref.watch(profileProvider).isUpdatingProfile;

            return CommonBottomSheet(
              title: title,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: isDob ? () => _selectDate(context, controller) : null,
                    child: AbsorbPointer(
                      absorbing: isDob,
                      child: AppTextField(controller: controller, hintText: hint),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppBtn(
                    title: isUpdating ? "" : "Save Changes",
                    loading: isUpdating,
                    onTap: () {
                      final value = controller.text.trim();
                      if (value.isNotEmpty) {
                        onSave(value); // pass key and value to notifier
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }
}
