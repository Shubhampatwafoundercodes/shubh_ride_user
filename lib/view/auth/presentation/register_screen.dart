import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
// ignore: unused_import
import 'package:rider_pay_user/main.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/app_text_field.dart';
import 'package:rider_pay_user/res/constant/const_back_btn.dart';
import 'package:rider_pay_user/res/constant/const_drop_down.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/validator/app_input_formatters.dart';
import 'package:rider_pay_user/res/validator/app_validator.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/auth/provider/auth_provider.dart';
import 'package:rider_pay_user/view/firebase_service/fcm/fcm_token_provider.dart';


class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedGender;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args["mobile"] != null) {
        phoneController.text = args["mobile"];
      }
    });
  }
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate() || selectedGender == null) {
      if (nameController.text.trim().isEmpty) {
        toastMsg("Please enter your full name");
        return;
      }

      if (phoneController.text.trim().isEmpty) {
        toastMsg("Please enter your mobile number");
        return;
      } else if (phoneController.text.trim().length != 10) {
        toastMsg("Mobile number must be 10 digits");
        return;
      }

      if (selectedGender == null) {
        toastMsg("Please select gender");
      }
      return;
    }
    final notifier = ref.read(authNotifierProvider.notifier);
    final fcmToken = await ref.read(fcmTokenProvider.notifier).generateFCMToken();
      final data = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "gender": selectedGender!.toLowerCase(),
        "fcmToken":fcmToken
    };
      final res = await notifier.register(data);
      if (res) {
        final phone = phoneController.text.trim();

        Navigator.pushNamed(
          context,
          RouteName.otp,
          arguments: {"mobile": phone},
        );

        // Navigator.pushNamedAndRemoveUntil(context, RouteName.splash, (route) => false);
      } else {
        toastMsg("Registration Failed");
      }
  }



  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final authNo = ref.watch(authNotifierProvider.notifier);

    return PopScope(
      canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          authNo.reset();
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.login,
                (route) => false,
          );
        },
      child: Scaffold(
        body: Padding(
          padding: AppPadding.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSizes.spaceH(25),
                const ConstAppBackBtn(),
                AppSizes.spaceH(30),
                ConstText(
                  text: loc.signUp,
                  fontSize: AppConstant.fontSizeHeading,
                  fontWeight: AppConstant.semiBold,
                  color: context.textPrimary,
                ),
                AppSizes.spaceH(10),
                ConstText(
                  text: loc.createAccount,
                  fontWeight: AppConstant.medium,
                  fontSize: AppConstant.fontSizeThree,
                ),
                AppSizes.spaceH(20),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          titleText: loc.fullName,
                          hintText: loc.fullName,
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          inputFormatters: AppInputFormatters.nameOnly,
                          validator: AppValidator.validateName,
                          obscureText: false,
                        ),
                        AppSizes.spaceH(15),




                        AppTextField(
                          titleText: loc.mobileNumber,
                          hintText: "0000000000",
                          controller: phoneController,
                          maxLength: 10,
                          readOnly: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left:  8.0),
                            child: ConstText(
                              text: "+91",
                              fontWeight: AppConstant.medium,
                              color: context.textPrimary,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: AppInputFormatters.digitsOnly,
                          validator: AppValidator.validateMobile,
                          obscureText: false,
                          showClearButton: false,

                        ),
                        AppSizes.spaceH(15),
                        AppTextField(
                          titleText: loc.emailOptional,
                          hintText: loc.emailOptional,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: AppInputFormatters.email,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            return AppValidator.validateEmail(value);
                          },
                          obscureText: false,
                        ),
                        AppSizes.spaceH(15),
                        CommonDropdown<String>(
                          title: loc.gender,
                          hintText: loc.gender,
                          items: [loc.male, loc.female, loc.other],
                          itemLabel: (v) => v,
                          valueKey: (v) => v,
                          selectedValue: selectedGender,
                          onChanged: (val) {
                            setState(() {
                              selectedGender = val;
                            });
                          },
                        ),
                        AppSizes.spaceH(30),
                        AppBtn(
                          border: Border.all(color: AppColor.primary, width: 1),
                          title: loc.signUp,
                          margin: AppPadding.screenPaddingV,
                          loading: authState.isLoading,
                          onTap: _register,
                        ),

                      ],
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
}
