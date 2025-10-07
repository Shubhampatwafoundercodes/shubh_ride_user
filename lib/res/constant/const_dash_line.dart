import 'package:flutter/material.dart';

class ConstDashLine extends StatelessWidget {
  final double dashLength;
  final double dashThickness;
  final double dashSpacing;
  final int dashCount;
  final Color color;
  final bool isHorizontal;

  const ConstDashLine({
    super.key,
    this.dashLength = 7,
    this.dashThickness = 1,
    this.dashSpacing = 4,
    this.dashCount = 20,
    this.color = Colors.grey,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal
        ? Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(dashCount, (index) {
        return Container(
          width: dashLength,
          height: dashThickness,
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(dashThickness / 2),
          ),
        );
      }),
    )
        : Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(dashCount, (index) {
        return Container(
          width: dashThickness,
          height: dashLength,
          margin: EdgeInsets.symmetric(vertical: 2),

          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(dashThickness / 2),
          ),
        );
      }),
    );
  }
}
