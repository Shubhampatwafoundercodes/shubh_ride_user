import 'package:flutter/material.dart';

class ConstIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? topPadding;
  final double? leftPadding;
  final IconData? icon;
  final String? image;
  final Color? color;
  final double? scale;
  final double? size;
  final EdgeInsetsGeometry? padding;

  const ConstIconButton({
    super.key,
    this.onTap,
    this.topPadding,
    this.leftPadding,
    this.icon,
    this.image,
    this.color = Colors.black,
    this.scale,
    this.size, this.padding ,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:padding ?? EdgeInsets.symmetric(
          horizontal: leftPadding ?? 15,
          vertical: topPadding ?? 15,
        ),
        child: image != null
            ? Image.asset(
          image!,
          scale: scale ?? 6,
          color: color,
          width: size,
          height: size,
        )
            : Icon(
          icon ?? Icons.help_outline,
          color: color ?? Colors.black,
          size: size ?? 24,
        ),
      ),
    );
  }
}
