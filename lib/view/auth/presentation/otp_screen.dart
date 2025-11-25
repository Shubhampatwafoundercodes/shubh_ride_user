import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_back_btn.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/validator/app_input_formatters.dart';
import 'package:rider_pay_user/res/validator/app_validator.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/utils/utils.dart';
import 'package:rider_pay_user/view/auth/provider/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final focusNode = FocusNode();
  final pinController = TextEditingController();
  String? phone;

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args["mobile"] != null) {
        setState(() {
          phone = args["mobile"] as String;
        });
        // ref.read(authNotifierProvider.notifier).sendOtp(phone.toString());
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resendOtp() async {
    if (_canResend && phone != null) {
      await ref.read(authNotifierProvider.notifier).sendOtp(phone.toString());
      _startTimer();
    }
  }

  Future<void> _verifyOtp() async {
    final otp = pinController.text.trim();
    if (otp.isEmpty) {
      toastMsg("Please enter OTP");
      return;
    }
    final verified = await ref.read(authNotifierProvider.notifier).verifyOtp(phone.toString(), otp);
    if (verified) {

      final loginStatus =
      await ref.read(authNotifierProvider.notifier).login(phone!);
      if (loginStatus == 2) {
        Navigator.pushNamedAndRemoveUntil(context, RouteName.home, (_) => false);
      } else if (loginStatus == 1) {
        Navigator.pushNamedAndRemoveUntil(context, RouteName.register, (_) => false);
      } else {
        toastMsg("Something went wrong Please try again");
      }

      // final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      // final isRegister = args?["isRegister"] ?? false;
      //
      // if (isRegister == true) {
      //   // Already registered → go Home
      //   Navigator.pushNamedAndRemoveUntil(context, RouteName.home, (route) => false);
      // } else {
      //   // Not registered → go Register
      //   Navigator.pushNamedAndRemoveUntil(context, RouteName.register, (route) => false, arguments: {"mobile": phone});
      // }


      // Navigator.pushNamedAndRemoveUntil(context, RouteName.home, (route) => false);
    } else {
      debugPrint("Verify OTP failed");
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
          child: Column(
            children: [
              AppSizes.spaceH(25),
              const ConstAppBackBtn(),
              AppSizes.spaceH(40),

              ConstText(
                text: loc.phoneVerification,
                fontSize: AppConstant.fontSizeHeading,
                fontWeight: AppConstant.semiBold,
                color: context.textPrimary,
              ),
              AppSizes.spaceH(10),

              ConstText(
                text: "${loc.enterYourNumber} $phone",
                fontSize: AppConstant.fontSizeOne,
              ),

              /// 🔹 OTP Input
              Pinput(
                controller: pinController,
                focusNode: focusNode,
                length: 4,
                keyboardType: TextInputType.number,
                inputFormatters: AppInputFormatters.digitsOnly,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: defaultPinTheme,
                showCursor: true,
                mainAxisAlignment: MainAxisAlignment.center,
                validator: AppValidator.validateOtp,
                onChanged: (v){
                  if(v.length==4){
                    _verifyOtp();
                  }
                },
              ),

              /// 🔹 Timer or Resend Button
              AppSizes.spaceH(10),
              _canResend
                  ? GestureDetector(
                onTap: _resendOtp,
                child: ConstText(
                  text: loc.resend,
                  fontSize: AppConstant.fontSizeTwo,
                  color: Colors.blue,
                  fontWeight: AppConstant.semiBold,
                ),
              )
                  : ConstText(
                text: "Resend OTP in 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                fontSize: AppConstant.fontSizeTwo,
                color: context.textSecondary,
              ),

              const Spacer(),

              /// 🔹 Verify Button
              AppBtn(
                loading: authState.isLoading,
                border: Border.all(color: AppColor.primary, width: 1),
                title: loc.verifyNow,
                margin: AppPadding.screenPaddingV,
                onTap: _verifyOtp,
              ),


              AppSizes.spaceH(30),

            ],
          ),
        ),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 50.w,
    height: 50.h,
    margin: EdgeInsets.only(left: 15.w, top: 30.h, bottom: 20.h),
    textStyle: TextStyle(
      fontSize: 22,
      color: AppColor.textSecondary,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColor.border, width: 1),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 50.w,
    height: 50.h,
    margin: EdgeInsets.only(left: 15.w, top: 30.h, bottom: 20.h),
    textStyle: TextStyle(
      fontSize: 22,
      color: AppColor.textSecondary,
      fontWeight: AppConstant.semiBold,
      fontFamily: "Poppins",
    ),
    decoration: BoxDecoration(
      color: Colors.yellow.withAlpha(50),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColor.primary, width: 1),
    ),
  );
}
