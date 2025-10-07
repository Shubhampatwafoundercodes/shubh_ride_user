import 'dart:ui';

enum DeviceScreenType { mobile, tablet, desktop }

class AppDevice {
  static late DeviceScreenType deviceType;

  static void init(Size size) {
    final shortestSide = size.shortestSide;

    if (shortestSide < 600) {
      deviceType = DeviceScreenType.mobile;
    } else if (shortestSide < 950) {
      deviceType = DeviceScreenType.tablet;
    } else {
      deviceType = DeviceScreenType.desktop;
    }
  }

  static bool get isMobile => deviceType == DeviceScreenType.mobile;
  static bool get isTablet => deviceType == DeviceScreenType.tablet;
  static bool get isDesktop => deviceType == DeviceScreenType.desktop;
}
