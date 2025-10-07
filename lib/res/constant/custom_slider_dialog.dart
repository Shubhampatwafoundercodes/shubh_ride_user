import 'package:flutter/material.dart';

class CustomSlideDialog {
  static Future<void>  show({
    required BuildContext context,
    required Widget child,
    bool dismissible = true,
   })
  async {
    showGeneralDialog(
      context: context,
      barrierDismissible: dismissible,
      barrierLabel: 'CustomDialog',
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox.shrink(); // Required, but not used
      },
      transitionBuilder: (context, animation1, animation2, _) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1), // From bottom
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation1,
          curve: Curves.easeOut,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: Opacity(
            opacity: animation1.value,
            child: Center(child: child), // Your passed dialog
          ),
        );
      },
    );
  }
}
