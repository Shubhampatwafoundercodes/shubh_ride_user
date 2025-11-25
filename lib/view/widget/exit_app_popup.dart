import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/res/app_btn.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_pop_up.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';


class ExitAppPopup extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ExitAppPopup({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ConstPopUp(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: onCancel,
              child: Icon(
                Icons.close,
                color: context.textSecondary,
                size: 20,
              ),
            ),
          ),
          AppSizes.spaceH(25),

          Icon(Icons.exit_to_app, size: 80.h, color: AppColor.primary),
          AppSizes.spaceH(20),

          ConstText(
            text: "Exit App?",
            fontWeight: AppConstant.semiBold,
            fontSize: AppConstant.fontSizeLarge,
            color: context.textPrimary,
          ),
          AppSizes.spaceH(10),

          // 💬 Subtitle
          ConstText(
            text: "Are you sure you want to close the app?",
            color: context.textSecondary,
            fontSize: AppConstant.fontSizeOne,
            textAlign: TextAlign.center,
          ),
          AppSizes.spaceH(30),

          Row(
            children: [
              Expanded(
                child: AppBtn(
                  title: "No",
                  onTap: onCancel,
                  border: Border.all(color: context.primary),
                  color: Colors.transparent,
                  titleColor: context.black,
                ),
              ),
              AppSizes.spaceW(15),
              Expanded(
                child: AppBtn(
                  title: "Yes",
                  onTap: onConfirm,
                ),
              ),
            ],
          ),
          AppSizes.spaceH(20),
        ],
      ),
    );
  }
}
