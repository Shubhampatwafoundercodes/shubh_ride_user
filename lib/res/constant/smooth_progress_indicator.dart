import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/res/app_color.dart';

class SmoothProgressIndicator extends StatefulWidget {
  final int totalMinutes;
  final int totalSegments;
  final VoidCallback onCompleted;

  const SmoothProgressIndicator({
    super.key,
    required this.totalMinutes,
    this.totalSegments = 4,
    required this.onCompleted,
  });

  @override
  State<SmoothProgressIndicator> createState() => _SmoothProgressIndicatorState();
}

class _SmoothProgressIndicatorState extends State<SmoothProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.totalMinutes),
    )..forward().whenComplete(widget.onCompleted);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSmoothProgress(double value) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.greenAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        double progress = _controller.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.totalSegments, (index) {
            double segmentProgress = (progress * widget.totalSegments) - index;
            segmentProgress = segmentProgress.clamp(0.0, 1.0);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6.h,
              width: 70.w,
              decoration: BoxDecoration(
                color: context.hintTextColor.withAlpha(50),
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: segmentProgress,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: _buildSmoothProgress(progress),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
