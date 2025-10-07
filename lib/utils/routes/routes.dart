
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rider_pay/theme/theme_screen.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/auth/presentation/login_screen.dart';
import 'package:rider_pay/view/auth/presentation/otp_screen.dart';
import 'package:rider_pay/view/auth/presentation/register_screen.dart';
import 'package:rider_pay/view/home/presentation/drawer/profile/add_money.dart' show AddMoneyScreen;
import 'package:rider_pay/view/home/presentation/drawer/drawer_screen.dart' show DrawerContent;
import 'package:rider_pay/view/home/presentation/drawer/help_screen.dart';
import 'package:rider_pay/view/home/presentation/drawer/my_reward_screen.dart';
import 'package:rider_pay/view/home/presentation/drawer/my_ride/my_ride_details.dart';
import 'package:rider_pay/view/home/presentation/drawer/my_ride/my_ride_screen.dart';
import 'package:rider_pay/view/home/presentation/drawer/notification_screen.dart';
import 'package:rider_pay/view/home/presentation/drawer/profile/profile_screen.dart';
import 'package:rider_pay/view/home/presentation/drawer/rating.dart';
import 'package:rider_pay/view/home/presentation/drawer/refer_and_earn.dart';
import 'package:rider_pay/view/home/presentation/drawer/setting/setting_screen.dart';
import 'package:rider_pay/view/home/presentation/drawer/profile/wallet_screen.dart';
import 'package:rider_pay/view/home/presentation/home_screen.dart';
import 'package:rider_pay/view/language/language_screen.dart';
import 'package:rider_pay/view/map/presentation/map_screen.dart';
import 'package:rider_pay/view/map/presentation/search_location_screen.dart';
import 'package:rider_pay/view/onboarding/location_on_screen.dart';
import 'package:rider_pay/view/onboarding/onboard_screen.dart';
import 'package:rider_pay/view/onboarding/welcome_screen.dart';
import 'package:rider_pay/view/splash/splash_screen.dart';
class AppRoute {
  static Widget generateRoute(String routeName) {
    switch (routeName) {
      case RouteName.splash:
        return const SplashScreen();
      case RouteName.onBoard:
        return const OnboardingScreen();
      case RouteName.welcomeScreen:
        return const WelcomeScreen();
      case RouteName.locationScreen:
        return const LocationOnScreen();
      case RouteName.login:
        return const LoginScreen();
      case RouteName.otp:
        return const OtpScreen();
      case RouteName.register:
        return const RegisterScreen();
      case RouteName.home:
        return const HomeScreen();
      case RouteName.language:
        return const LanguageScreen();
      case RouteName.theme:
        return const ThemeScreen();
      case RouteName.drawer:
        return const DrawerContent();
      case RouteName.profile:
        return const ProfileScreen();
      case RouteName.rating:
        return const Rating();
      case RouteName.help:
        return const HelpScreen();
      case RouteName.walletScreen:
        return const WalletScreen();
      case RouteName.addMoney:
        return const AddMoneyScreen();
      case RouteName.notification:
        return const NotificationScreen();
      case RouteName.myReward:
        return const MyRewardScreen();
      case RouteName.referAndEarn:
        return const ReferAndEarnScreen();
      case RouteName.mapScreen:
        return const MapScreen();
      // case RouteName.rideDetails:
      //   return const RideDetailsScreen(ride: ride);
      case RouteName.rideHistory:
        return  RideHistoryScreen();
      case RouteName.settingScreen:
        return  SettingsScreen();
      case RouteName.searchLocationScreen:
        return  SearchLocationScreen();
      default:
        return const SplashScreen();
    }
  }
}