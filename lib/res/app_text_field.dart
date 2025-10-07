import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/res/app_border.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function()? onTap;
  final String? hintText;
  final bool readOnly;
  final int? maxLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool autofocus;
  final TextStyle? style;
  final TextAlign textAlign;
  final Color? textColor;
  final Color? hintColor;
  final FontWeight? hintWeight;
  final double? fontSize;
  final TextInputAction? textInputAction;
  final double? cursorHeight;
  final bool? enabled;
  final int? maxLength;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? cursorColor;
  final bool? filled;
  final String? errorText;
  final BorderRadius? fieldRadius;
  final BorderSide? borderSide;
  final BorderSide? focusBorderSide;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final String? titleText; // text above the input
  final String? labelText;
  final bool showClearButton;
  final Color? titleColor;

  const AppTextField({
    super.key,
    this.controller,
    this.onTap,
    this.hintText,
    this.readOnly = false,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.autofocus = false,
    this.style,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.hintColor,
    this.hintWeight,
    this.fontSize,
    this.textInputAction,
    this.cursorHeight,
    this.enabled,
    this.maxLength,
    this.height,
    this.width,
    this.margin,
    this.contentPadding,
    this.fillColor,
    this.filled = true,
    this.errorText,
    this.fieldRadius,
    this.borderSide,
    this.focusBorderSide,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.inputFormatters,
    this.titleText,
    this.labelText,
    this.cursorColor,
    this.showClearButton = true, this.titleColor,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  bool _obscureText = false;
  String? _errorText;
  Timer? _debounce;
  late final VoidCallback _listener;
  BorderRadius get _radius => widget.fieldRadius ?? AppBorders.btnRadius;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.obscureText;
    _errorText = widget.errorText;
    _listener = () {
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
      if (widget.validator != null) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          final error = widget.validator!(_controller.text);
          if (error != _errorText) {
            setState(() {
              _errorText = error;
            });
          }
        });
      }
    };

    _controller.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Remove listener from old controller if changed
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_listener);
      if (widget.controller == null) {
        // If new controller is null, use internal controller listener
        _controller.addListener(_listener);
      } else {
        // New controller non-null, add listener to it
        widget.controller?.addListener(_listener);
      }
    }
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _clearText() {
    _controller.clear();
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    if (widget.controller == null) {
      _controller
          .dispose(); // Only dispose if controller was internally created
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      margin: widget.margin ?? EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.titleText != null)
            Padding(
              padding:
                  widget.contentPadding ??
                  EdgeInsets.only(left: 5.w, bottom: 4.h),
              child: Text(
                widget.titleText!,
                style:widget.style?? TextStyle(
                  color: widget.titleColor ?? context.textPrimary,
                  fontSize: AppConstant.fontSizeThree,
                  fontWeight: widget.hintWeight,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          SizedBox(
            height: widget.height ?? 55.h,
            child: TextFormField(
              controller: _controller,
              validator: widget.validator,
              inputFormatters: widget.inputFormatters,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              style:
                  widget.style ??
                  TextStyle(
                    color: widget.textColor ?? context.textPrimary,
                    fontSize: widget.fontSize ?? AppConstant.fontSizeTwo,
                    // fontWeight: AppConstant.medium,
                    fontFamily: 'Poppins',
                  ),
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              enabled: widget.enabled,
              textAlign: widget.textAlign,
              autofocus: widget.autofocus,
              textInputAction: widget.textInputAction ?? TextInputAction.done,
              cursorColor: widget.cursorColor ?? context.primary,
              cursorHeight: widget.cursorHeight,
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: TextStyle(
                  color: widget.hintColor ?? context.greyDark,
                ),
                hintText: widget.hintText ?? '',
                hintStyle: TextStyle(
                  color: widget.hintColor ?? context.hintTextColor,
                  fontSize: widget.fontSize ?? AppConstant.fontSizeTwo,
                  fontWeight: widget.hintWeight,
                ),
                counter: const Offstage(),
                filled: widget.filled,
                fillColor: widget.fillColor ?? Colors.transparent,
                prefixIcon: widget.prefixIcon,
                prefix: widget.prefix,
                suffix:
                    widget.suffix ??
                    (_controller.text.isNotEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.obscureText)
                                GestureDetector(
                                  onTap: _toggleObscure,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Icon(
                                      _obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: widget.hintColor ??
                                          context.textSecondary,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              if (widget.showClearButton)
                                GestureDetector(
                                  onTap: _clearText,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Icon(
                                      Icons.clear,
                                      color: widget.hintColor ??
                                          context.textSecondary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : null),
                suffixIcon: widget.suffixIcon,
                contentPadding:
                    widget.contentPadding ??
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      widget.borderSide ??
                      BorderSide(color: context.greyMedium, width: 1.w),
                  borderRadius: widget.fieldRadius ?? _radius,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      widget.focusBorderSide ??
                      BorderSide(color: context.primary, width: 1.w),
                  borderRadius: widget.fieldRadius ?? _radius,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:   context.error, width: 1.2.w),
                  borderRadius: widget.fieldRadius ?? _radius,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:  context.error, width: 1.2.w),
                  borderRadius: widget.fieldRadius ?? _radius,
                ),
                // errorStyle: const TextStyle(
                //   color: Colors.redAccent,
                //   fontSize: 12,
                //   height: 0.9, // Controls spacing below field
                //   fontWeight: FontWeight.w400,
                // ),
                errorStyle: const TextStyle(fontSize: 0, height: 0),
                errorText: _errorText,
              ),
            ),
          ),
          // SizedBox(height: 1), // Reserve space always
          if (_errorText != null && _errorText!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                _errorText!,
                style: TextStyle(
                  color: context.error,
                  fontSize: 12.sp,
                  height: 1.1,
                  fontFamily: 'poppins',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// class AppTextField extends StatefulWidget {
//   final TextEditingController? controller;
//   final void Function()? onTap;
//   final String? hintText;
//   final bool readOnly;
//   final int? maxLines;
//   final bool obscureText;
//   final TextInputType? keyboardType;
//   final void Function(String)? onChanged;
//   final void Function(String?)? onSaved;
//   final String? Function(String?)? validator;
//   final bool autofocus;
//   final TextStyle? style;
//   final TextAlign textAlign;
//   final Color? textColor;
//   final Color? titleColor;
//   final Color? hintColor;
//   final FontWeight? hintWeight;
//   final double? fontSize;
//   final TextInputAction? textInputAction;
//   final double? cursorHeight;
//   final bool? enabled;
//   final int? maxLength;
//   final double? height;
//   final double? width;
//   final EdgeInsetsGeometry? margin;
//   final EdgeInsetsGeometry? contentPadding;
//   final Color? fillColor;
//   final Color? cursorColor;
//   final bool? filled;
//   final String? errorText;
//   final BorderRadius? fieldRadius;
//   final BorderSide? borderSide;
//   final BorderSide? focusBorderSide;
//
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final Widget? prefix;
//   final Widget? suffix;
//   final List<TextInputFormatter>? inputFormatters;
//   final String? titleText;    // text above the input
//   final String? labelText;
//   final bool showClearButton;
//
//   const AppTextField({
//     super.key,
//     this.controller,
//     this.onTap,
//     this.hintText,
//     this.readOnly = false,
//     this.maxLines = 1,
//     this.obscureText = false,
//     this.keyboardType,
//     this.onChanged,
//     this.onSaved,
//     this.validator,
//     this.autofocus = false,
//     this.style,
//     this.textAlign = TextAlign.start,
//     this.textColor,
//     this.hintColor,
//     this.hintWeight,
//     this.fontSize,
//     this.textInputAction,
//     this.cursorHeight,
//     this.enabled,
//     this.maxLength,
//     this.height,
//     this.width,
//     this.margin,
//     this.contentPadding,
//     this.fillColor,
//     this.filled = true,
//     this.errorText,
//     this.fieldRadius,
//     this.borderSide,
//     this.focusBorderSide,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.prefix,
//     this.suffix, this.inputFormatters, this.titleText, this.labelText, this.cursorColor,  this.showClearButton = true, this.titleColor,
//   });
//
//   @override
//   State<AppTextField> createState() => _AppTextFieldState();
// }
//
// class _AppTextFieldState extends State<AppTextField> {
//   late TextEditingController _controller;
//   bool _obscureText = false;
//   String? _errorText;
//   Timer? _debounce;
//   late final VoidCallback _listener;
//   BorderRadius get _radius => widget.fieldRadius ?? BorderRadius.circular(8);
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller ?? TextEditingController();
//     _obscureText = widget.obscureText;
//     _errorText = widget.errorText;
//
//     _listener = () {
//       if (widget.onChanged != null) {
//         widget.onChanged!(_controller.text);
//       }
//       if (widget.validator != null) {
//         _debounce?.cancel();
//         _debounce = Timer(const Duration(milliseconds: 300), () {
//           if (!mounted) return;
//           final error = widget.validator!(_controller.text);
//           if (error != _errorText) {
//             setState(() {
//               _errorText = error;
//             });
//           }
//         });
//       }
//     };
//
//     _controller.addListener(_listener);
//   }
//
//   @override
//   void didUpdateWidget(covariant AppTextField oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Remove listener from old controller if changed
//     if (oldWidget.controller != widget.controller) {
//       oldWidget.controller?.removeListener(_listener);
//       if (widget.controller == null) {
//         // If new controller is null, use internal controller listener
//         _controller.addListener(_listener);
//       } else {
//         // New controller non-null, add listener to it
//         widget.controller?.addListener(_listener);
//       }
//     }
//   }
//
//   void _toggleObscure() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }
//
//   void _clearText() {
//     _controller.clear();
//     if (widget.onChanged != null) {
//       widget.onChanged!('');
//     }
//   }
//   @override
//   void dispose() {
//     _controller.removeListener(_listener);
//     if (widget.controller == null) {
//       _controller.dispose();
//     }
//     _debounce?.cancel();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width ?? MediaQuery.of(context).size.width,
//       margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.titleText != null)
//             Padding(
//               padding: widget.contentPadding ??
//                   const EdgeInsets.only(left: 5.0, bottom: 3),
//               child: Text(
//                 widget.titleText!,
//                 style: TextStyle(
//                   color: widget.titleColor ?? Colors.black,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//             ),
//           SizedBox(
//             height: widget.height ?? 50,
//
//             child: TextFormField(
//               controller: _controller,
//               validator:widget.validator,
//               inputFormatters: widget.inputFormatters,
//               onTap: widget.onTap,
//               readOnly: widget.readOnly,
//               obscureText: _obscureText,
//               keyboardType: widget.keyboardType ?? TextInputType.text,
//               style: widget.style ??
//                   TextStyle(
//                     color: widget.textColor ?? AppColor.black,
//                     fontSize: widget.fontSize ?? 15,
//                     fontWeight: AppConstant.medium,
//                     fontFamily: 'Poppins',
//                   ),
//               maxLines: widget.maxLines,
//               maxLength: widget.maxLength,
//               enabled: widget.enabled,
//               textAlign: widget.textAlign,
//               autofocus: widget.autofocus,
//               textInputAction: widget.textInputAction ?? TextInputAction.done,
//               cursorColor: widget.cursorColor ?? AppColor.primary,
//               cursorHeight: widget.cursorHeight,
//               decoration: InputDecoration(
//                 labelText: widget.labelText,
//                 labelStyle: TextStyle(
//                   color: widget.hintColor ?? Colors.black87,
//                 ),
//                 hintText: widget.hintText ?? '',
//                 hintStyle: TextStyle(
//                   color: widget.hintColor ?? Colors.grey,
//                   fontSize: widget.fontSize ?? 14,
//                   fontWeight: widget.hintWeight ?? FontWeight.w400,
//                 ),
//                 counter: const Offstage(),
//                 filled: widget.filled,
//                 fillColor: widget.fillColor ?? Colors.white,
//                 prefixIcon: widget.prefixIcon,
//                 prefix: widget.prefix,
//                 suffix: widget.suffix ??
//                     (_controller.text.isNotEmpty ?
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         if (widget.obscureText)
//                           GestureDetector(
//                             onTap: _toggleObscure,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                               child: Icon(
//                                 _obscureText ? Icons.visibility_off : Icons.visibility,
//                                 color: widget.hintColor ?? Colors.black87,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         if(widget.showClearButton)
//                           GestureDetector(
//                             onTap: _clearText,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                               child: Icon(
//                                 Icons.clear,
//                                 color: widget.hintColor ?? Colors.black87,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                       ],
//                     )
//                         : null),
//                 suffixIcon: widget.suffixIcon,
//                 contentPadding: widget.contentPadding ??
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: widget.borderSide ??  BorderSide(color: AppColor.primary, width: 1),
//                   borderRadius: _radius,
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: widget.focusBorderSide ?? const BorderSide(color:AppColor.primary, width: 1),
//                   borderRadius:_radius,
//                 ),
//                 errorBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color:  AppColor.error, width: 1.2),
//                   borderRadius: _radius,
//
//                 ),
//                 focusedErrorBorder:  OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColor.error, width: 1.5),
//                   borderRadius: _radius,
//
//                 ),
//                 // errorStyle: const TextStyle(
//                 //   color: Colors.redAccent,
//                 //   fontSize: 12,
//                 //   height: 0.9, // Controls spacing below field
//                 //   fontWeight: FontWeight.w400,
//                 // ),
//                 errorStyle: const TextStyle(fontSize: 0, height: 0),
//                 errorText: _errorText,
//               ),
//             ),
//           ),
//           // SizedBox(height: 1), // Reserve space always
//           if (_errorText != null && _errorText!.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0),
//               child: Text(
//                 _errorText!,
//                 style: const TextStyle(
//                     color: Colors.redAccent,
//                     fontSize: 12,
//                     height: 1.1,
//                     fontFamily: 'Poppins'
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//
//   }
// }
