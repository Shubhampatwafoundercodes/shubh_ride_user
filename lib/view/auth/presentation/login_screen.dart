import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/app_text_field.dart';
import 'package:rider_pay_user/res/constant/const_back_btn.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/validator/app_input_formatters.dart';
import 'package:rider_pay_user/res/validator/app_validator.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/auth/provider/auth_provider.dart';
import 'package:rider_pay_user/view/home/presentation/drawer/setting/cms_term_condition_screen.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
// ignore: unused_import
import 'package:rider_pay_user/view/share_pref/user_provider.dart';
import 'package:rider_pay_user/view/widget/exit_app_popup.dart';
import '../../../l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cmsProvider.notifier).getCmsTermConditionApi();

    });
    _phoneController.addListener(() {
      final text = _phoneController.text.trim();
      final enable = text.length == 10;

      if (enable != _isButtonEnabled) {
        setState(() => _isButtonEnabled = enable);
      }

      if (enable) {
        FocusScope.of(context).unfocus();
      }
    });

  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final cmsState = ref.watch(cmsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async{
        if (!didPop) {
          showDialog(
            context: context,
            builder: (_) => ExitAppPopup(
              onCancel: () => Navigator.pop(context),
              onConfirm: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }
              },
            ),
          );
        }
      },
      child: SafeArea(
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

                Form(
                  key: _formKey,
                  child: AppTextField(
                    hintText: "0000000000",
                    controller: _phoneController,
                    // prefixIcon: Padding(
                    //   padding: EdgeInsets.only(top: 12.h, left: 10.w),
                    //   child: ConstText(
                    //     text: "+91",
                    //     fontWeight: AppConstant.semiBold,
                    //   ),
                    // ),
                    keyboardType: TextInputType.number,
                    inputFormatters: AppInputFormatters.digitsOnly,
                    validator: AppValidator.validateMobile,
                    obscureText: false,
                    maxLength: 10,
                    onChanged: (value) {
                      if (value.length == 10) {
                        FocusScope.of(context).unfocus(); // ✅ hides keyboard
                      }
                    },
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left:  8.0),
                      child: ConstText(
                        text: "+91",
                        fontWeight: AppConstant.medium,
                        color: context.textPrimary,
                      ),
                    ),
                    showClearButton: false,

                  ),
                ),
                Spacer(),
                DoubleText(
                  firstText: loc.byContinuing,
                  tappableText1: loc.termsConditions,
                  tappableText2: loc.privacyPolicy,
                  text3: " & ",
                  onTap1: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => CmsPageScreen(
                          title: loc.privacyPolicy,
                          htmlData:
                          cmsState.pages?["terms_conditions"] ??
                              "<p>No data found</p>",
                        ),
                      ),
                    );
                  },
                  onTap2: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => CmsPageScreen(
                          title: loc.termsConditions,
                          htmlData:
                          cmsState.pages?["privacy_policy"] ??
                              "<p>No data found</p>",
                        ),
                      ),
                    );
                  },
                ),
                AppBtn(
                  loading: authState.isLoading,
                  title: loc.next,
                  margin: AppPadding.screenPaddingV,
                  color: _isButtonEnabled
                      ? context.primary
                      : context.greyMedium, // 🔒 visual disable
                  titleColor: _isButtonEnabled
                      ? context.white
                      : context.textSecondary,
                  onTap: _isButtonEnabled
                      ? () async {
                    // Validate form
                    if (!_formKey.currentState!.validate()) return;
                    final phone = _phoneController.text.trim();
                     final sendOtp= await ref.read(authNotifierProvider.notifier).sendOtp(phone.toString());
                        if(sendOtp){
                          Navigator.pushNamed(context, RouteName.otp, arguments: {"mobile": phone,});
                        }else{

                          toastMsg("Send OTP failed");

                        }

                    // final loginState = await ref.read(authNotifierProvider.notifier).login(phone);
                    // if (loginState == 1) {
                    //   Navigator.pushNamed(context, RouteName.otp, arguments: {"mobile": phone, "isRegister": false});
                    // } else if (loginState == 2) {
                    //   Navigator.pushNamed(context, RouteName.otp, arguments: {"mobile": phone, "isRegister": true});
                    // } else {
                    //   toastMsg("Something went wrong");
                    // }



                  }:null,

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
