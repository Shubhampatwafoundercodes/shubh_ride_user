import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/res/app_border.dart';
import 'package:rider_pay/res/app_btn.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/const_back_btn.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/validator/app_input_formatters.dart';
import 'package:rider_pay/res/validator/app_validator.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/auth/provider/auth_provider.dart';
// class OtpScreen extends StatefulWidget {
//   const OtpScreen({super.key});
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   final focusNode = FocusNode();
//   final pinController = TextEditingController();
//   @override
//   void dispose() {
//     super.dispose();
//     pinController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final loc = AppLocalizations.of(context)!;
//     return Scaffold(
//       body: Padding(
//         padding: AppPadding.screenPadding,
//         child: Column(
//           // crossAxisAlignment: CrossAxisAlignment.start,
//
//           children: [
//             AppSizes.spaceH(25),
//             ConstAppBackBtn(),
//             AppSizes.spaceH(40),
//
//             ConstText(
//               text: loc.phoneVerification,
//               fontSize: AppConstant.fontSizeHeading,
//               fontWeight: AppConstant.semiBold,
//               color: context.textPrimary,
//
//             ),
//             AppSizes.spaceH(10),
//
//             ConstText(
//               text: "${loc.enterYourNumber} +919876567887",
//               // color: AppColor.greyDark,
//               fontSize: AppConstant.fontSizeOne,
//
//             ),
//             Pinput(
//               controller: pinController,
//               focusNode: focusNode,
//               length: 4,
//               keyboardType: TextInputType.number,
//               inputFormatters: AppInputFormatters.digitsOnly,
//               defaultPinTheme: defaultPinTheme,
//               focusedPinTheme: focusedPinTheme,
//               submittedPinTheme: defaultPinTheme,
//               showCursor: true,
//               mainAxisAlignment: MainAxisAlignment. center,
//               validator: AppValidator.validateOtp,
//             ),
//
//             DoubleText(
//               firstText: loc.doNotAccount,
//               secondText: loc.resend,
//               firstSize: AppConstant.fontSizeTwo,
//               secondSize: AppConstant.fontSizeTwo,
//               // firstColor: Colors.black,
//               // secondColor: Colors.blue,
//               onTap: () {
//
//                 print("Sign Up tapped!");
//               },
//             ),
//             Spacer(),
//
//             AppBtn(
//               // color: Colors.white,
//               border: Border.all(color:AppColor.primary,width: 1),
//               title: loc.verifyNow,
//               // titleColor: AppColor.primary,
//               margin: AppPadding.screenPaddingV,
//               onTap: (){
//                 Navigator.pushNamed(context, RouteName.register);
//               },
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//   final defaultPinTheme = PinTheme(
//     width: 50,
//     height: 50,
//     margin:EdgeInsets.only(left: 15.w,top: 30.h,bottom: 20.h),
//
//     textStyle: TextStyle(
//       fontSize: 22,
//       color: AppColor.textSecondary,
//       fontFamily: "Poppins",
//       fontWeight: FontWeight.w600,
//     ),
//     decoration: BoxDecoration(
//       color: Colors.white70,
//       borderRadius: AppBorders.smallRadius,
//       border: Border.all(color: AppColor.border,width: 1)
//     ),
//   );
//
//   final focusedPinTheme = PinTheme(
//     width: 50,
//     height: 50,
//     textStyle: TextStyle(
//       fontSize: 22,
//      color:  AppColor.textSecondary,
//       fontWeight: FontWeight.bold,
//       fontFamily: "Poppins"
//     ),
//     margin:EdgeInsets.only(left: 15.w,top: 30.h,bottom: 20.h),
//     decoration: BoxDecoration(
//       color: Colors.yellow.withAlpha(300),
//       borderRadius: AppBorders.smallRadius,
//         border: Border.all(color: AppColor.primary,width: 1)
//
//     ),
//   );
// }
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final focusNode = FocusNode();
  final pinController = TextEditingController();
  String? phone; // Make it nullable

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args["mobile"] != null) {
        setState(() {
          phone = args["mobile"] as String;
        });
        ref.read(authNotifierProvider.notifier).sendOtp(phone.toString());
      }
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  void _resendOtp() async {
    await ref.read(authNotifierProvider.notifier).sendOtp(phone.toString());

  }

  void _verifyOtp() async {
    final otp = pinController.text.trim();
    final verified = await ref.read(authNotifierProvider.notifier).verifyOtp(phone.toString(), otp);

    if (verified) {
      Navigator.pushNamedAndRemoveUntil(context, RouteName.home, (route) => false);

    } else {
      debugPrint("Shubham: OTP Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: Padding(
        padding: AppPadding.screenPadding,
        child: Column(
          children: [
            AppSizes.spaceH(25),
            ConstAppBackBtn(),
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
            ),

            DoubleText(
              firstText: loc.doNotAccount,
              secondText: loc.resend,
              firstSize: AppConstant.fontSizeTwo,
              secondSize: AppConstant.fontSizeTwo,
              onTap: _resendOtp,
            ),
            Spacer(),

            AppBtn(
              loading: authState.isLoading,
              border: Border.all(color: AppColor.primary, width: 1),
              title: loc.verifyNow,
              margin: AppPadding.screenPaddingV,
              onTap: _verifyOtp,
            ),
          ],
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
