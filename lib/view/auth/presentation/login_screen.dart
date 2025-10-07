import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/app_text_field.dart';
import 'package:rider_pay/res/constant/const_back_btn.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/validator/app_input_formatters.dart';
import 'package:rider_pay/res/validator/app_validator.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/utils/utils.dart';
import 'package:rider_pay/view/auth/provider/auth_provider.dart';
import '../../../l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Padding(
          padding: AppPadding.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSizes.spaceH(25),
              const ConstAppBackBtn(),
              AppSizes.spaceH(40),
              ConstText(
                text: loc.signIn,
                fontSize: AppConstant.fontSizeLarge,
                fontWeight: AppConstant.semiBold,
                color: context.textPrimary,
              ),
              AppSizes.spaceH(40),
              ConstText(
                text: loc.enterYourNumber,
                fontWeight: AppConstant.medium,
                fontSize: AppConstant.fontSizeThree,
                color: context.textPrimary,
              ),

              // 👇 Form
              Form(
                key: _formKey,
                child: AppTextField(
                  hintText: "0000000000",
                  controller: _phoneController,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(top: 14.h, left: 10.w),
                    child: ConstText(
                      text: "+91",
                      fontWeight: AppConstant.semiBold,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: AppInputFormatters.digitsOnly,
                  validator: AppValidator.validateMobile,
                  obscureText: false,
                ),
              ),

              Spacer(),
              DoubleText(
                firstText: loc.byContinuing,
                secondText: loc.termsAndPolicy,
                firstSize: 12,
                secondSize: 12,
                onTap: () {
                  print("Terms tapped!");
                },
              ),
              AppBtn(
                loading: authState.isLoading,
                border: Border.all(color: AppColor.primary, width: 1),
                title: loc.next,
                margin: AppPadding.screenPaddingV,
                onTap: () async {
                  // Validate form
                  if (!_formKey.currentState!.validate()) return;
                  final phone = _phoneController.text.trim();
                  final loginState = await ref.read(authNotifierProvider.notifier).login(phone);
                  if (loginState == 1) {
                    Navigator.pushNamed(context, RouteName.register , arguments: {"mobile": phone},);
                  } else if (loginState == 2) {
                    Navigator.pushNamed(context, RouteName.otp, arguments: {"mobile": phone});
                  } else {
                    toastMsg("Something went wrong");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
