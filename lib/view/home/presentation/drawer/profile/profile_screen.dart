import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_text_field.dart';
import 'package:rider_pay_user/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/validator/app_input_formatters.dart';
import 'package:rider_pay_user/res/validator/app_validator.dart';
import 'package:rider_pay_user/view/home/presentation/drawer/drawer_screen.dart'
    show DrawerDivider;
import 'package:rider_pay_user/view/home/presentation/widget/common_btn_with_title.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
// ignore: unused_import
import 'package:rider_pay_user/view/widget/help_drop_down_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    final profileState = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    return Scaffold(
      backgroundColor: context.lightSkyBack,
      body: SafeArea(
        child: profileState.isLoadingProfile ||profileState.isUpdatingProfile
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: () async {
            await profileNotifier.getProfile(); // assuming you have this method
          },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                    children: [
                      /// Top Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonBackBtnWithTitle(text: t.profile),
                          // Padding(
                          //   padding: EdgeInsets.only(right: 18.w),
                          //   child: HelpDropDownWidget(),
                          // ),
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
                                profileNotifier.updateProfileField("name", value);
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
                                profileNotifier.updateProfileField("email", value);
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
                        value:  profileNotifier.dob,
                        onTap: () => _showEditBottomSheet(
                          context,
                          title: "${t.edit} ${t.dob}",
                          hint: "${t.enter} ${t.dob}",
                          isDob: true,
                            initialValue:  profileNotifier.dob,
                            onSave: (v){
                              if (v.isNotEmpty) {
                                final apiDob = v.split("T").first;
                                profileNotifier.updateProfileField("dob", apiDob);
                                // 🔹 key = "bod" (backend expects bod)
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
                            initialValue: profileNotifier.emergencyContact,
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
  void _showEditBottomSheet(
      BuildContext context, {
        required String title,
        required String hint,
        required String initialValue,
        required void Function(String) onSave,
        bool isDob = false,
      }) {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Consumer(
          builder: (context, ref, _) {
            final isUpdating = ref.watch(profileProvider).isUpdatingProfile;

            String? Function(String?)? validator;
            List<TextInputFormatter> inputFormatters = [];
            if (title.toLowerCase().contains('name')) {
              validator = AppValidator.validateName;
              inputFormatters = AppInputFormatters.nameOnly;
            } else if (title.toLowerCase().contains('email')) {
              validator = AppValidator.validateEmail;
              inputFormatters = AppInputFormatters.email;
            } else if (title.toLowerCase().contains('phone')) {
              validator = AppValidator.validateMobile;
              inputFormatters = AppInputFormatters.digitsOnly;
            } else {
              validator = (v) {
                if (v == null || v.trim().isEmpty) {
                  return "This field is required";
                }
                return null;
              };
            }

            return CommonBottomSheet(
              title: title,
              content: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: isDob ? () => _selectDate(context, controller) : null,
                      child: AbsorbPointer(
                        absorbing: isDob,
                        child: AppTextField(
                          controller: controller,
                          hintText: hint,
                          validator: validator,
                          inputFormatters: inputFormatters,
                          keyboardType: title.toLowerCase().contains('email')
                              ? TextInputType.emailAddress
                              : title.toLowerCase().contains('phone')
                              ? TextInputType.phone
                              : TextInputType.text,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    AppBtn(
                      title: isUpdating ? "" : "Save Changes",
                      loading: isUpdating,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          final value = controller.text.trim();
                          if (value.isNotEmpty) {
                            onSave(value);
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  /// Convert ISO date string (2000-01-24T00:00:00.000Z) to dd/MM/yyyy

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async
  {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text =
      "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }
}
