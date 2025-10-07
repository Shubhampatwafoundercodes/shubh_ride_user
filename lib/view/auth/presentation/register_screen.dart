import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/app_text_field.dart';
import 'package:rider_pay/res/constant/const_back_btn.dart';
import 'package:rider_pay/res/constant/const_drop_down.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/validator/app_input_formatters.dart';
import 'package:rider_pay/res/validator/app_validator.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/utils/utils.dart';
import 'package:rider_pay/view/auth/provider/auth_provider.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   // List<String> genderList = ["Male", "Female"];
//   String? selectedGender;
//
//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context)!;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: Padding(
//         padding: AppPadding.screenPadding,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppSizes.spaceH(25),
//
//             /// 👇 BackBtn fixed
//             const ConstAppBackBtn(),
//
//             AppSizes.spaceH(30),
//
//             /// 👇 Header fixed
//             ConstText(
//               text: loc.signUp,
//               fontSize: AppConstant.fontSizeHeading,
//               fontWeight: AppConstant.semiBold,
//               color: context.textPrimary,
//             ),
//             AppSizes.spaceH(10),
//             ConstText(
//               text: loc.createAccount,
//               fontWeight: AppConstant.medium,
//               fontSize: AppConstant.fontSizeThree,
//               // color: AppColor.textSecondary,
//             ),
//
//             AppSizes.spaceH(20),
//
//             /// 👇 Form Scrollable Only
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// Full Name
//                     AppTextField(
//                       titleText: loc.fullName,
//                       hintText: loc.fullName,
//                       keyboardType: TextInputType.name,
//                       inputFormatters: AppInputFormatters.nameOnly,
//                       validator: AppValidator.validateName,
//                       obscureText: false,
//                     ),
//                     AppSizes.spaceH(15),
//
//                     /// Mobile
//                     AppTextField(
//                       titleText: loc.mobileNumber,
//                       hintText: "0000000000",
//                       prefixIcon: Padding(
//                         padding: EdgeInsets.only(top: 14.h, left: 10.w),
//                         child: ConstText(
//                           text: "+91",
//                           fontWeight: AppConstant.semiBold,
//                           color: context.greyMedium,
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                       inputFormatters: AppInputFormatters.digitsOnly,
//                       validator: AppValidator.validateMobile,
//                       obscureText: false,
//                     ),
//                     AppSizes.spaceH(15),
//
//                     /// Email
//                     AppTextField(
//                       titleText: loc.emailOptional, // 👉 Localized
//                       hintText: loc.emailOptional,
//                       keyboardType: TextInputType.emailAddress,
//                       inputFormatters: AppInputFormatters.email,
//                       validator: AppValidator.validateEmail,
//                       obscureText: false,
//                     ),
//                     AppSizes.spaceH(15),
//
//                     /// Gender Dropdown
//                     CommonDropdown<String>(
//                       title: loc.gender, // 👉 Localized
//                       hintText: loc.gender,
//                       items: [loc.male, loc.female,loc.other],
//                       itemLabel: (v) => v,
//                       valueKey: (v) => v,
//                       selectedValue: selectedGender,
//                       onChanged: (val) {
//                         setState(() {
//                           selectedGender = val;
//                         });
//                       },
//                     ),
//                     AppSizes.spaceH(30),
//
//                     /// Next Button
//                     AppBtn(
//                       border: Border.all(color: AppColor.primary, width: 1),
//                       title: loc.signUp,
//                       margin: AppPadding.screenPaddingV,
//                       onTap: () {
//                         Navigator.pushNamed(context, RouteName.home);
//                       },
//                     ),
//                     diverLine(),
//                     AppSizes.spaceH(20),
//
//                     /// Sign in text
//                     DoubleText(
//                       firstText: loc.alreadyHaveAccount,
//                       secondText: loc.signIn,
//                       firstSize: AppConstant.fontSizeOne,
//                       secondSize: AppConstant.fontSizeOne,
//                       onTap: () {
//                         print("Sign In tapped!");
//                         Navigator.pushNamed(context, RouteName.login);
//                       },
//                     ),
//                     AppSizes.spaceH(20),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Divider Line
//   Widget diverLine() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           height: 0.5,
//           width: screenWidth * 0.42,
//           color: AppColor.grey,
//         ),
//         const ConstText(text: 'or', color: AppColor.greyDark),
//         Container(
//           height: 0.5,
//           width: screenWidth * 0.42,
//           color: AppColor.grey,
//         ),
//       ],
//     );
//   }
// }
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
    // Get phone number from route arguments
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
    // final loc = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate() || selectedGender == null) {
      // Gender not selected
      if (selectedGender == null) {
        toastMsg("Please select gender");
      }
      return;
    }

    final notifier = ref.read(authNotifierProvider.notifier);

    final data = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "gender": selectedGender!.toLowerCase(),
    };

      final res = await notifier.register(data);
      if (res) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.home, (route) => false);
      } else {
        toastMsg("Registration Failed");
      }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: Padding(
        padding: AppPadding.screenPadding,
        child: Form(
          key: _formKey, // Wrap with Form for validator support
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 14.h, left: 10.w),
                          child: ConstText(
                            text: "+91",
                            fontWeight: AppConstant.semiBold,
                            color: context.greyMedium,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: AppInputFormatters.digitsOnly,
                        validator: AppValidator.validateMobile,
                        obscureText: false,
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
    );
  }
}
