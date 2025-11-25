import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_device.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/theme/app_theme.dart';
import 'package:rider_pay_user/theme/theme_controller.dart';
import 'package:rider_pay_user/utils/routes/routes.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/view/internet_checker/internet_provider.dart';
import 'package:rider_pay_user/view/language/language_controller.dart';
import 'package:rider_pay_user/view/share_pref/user_provider.dart' show User, userProvider;

import 'firebase_options.dart';

double screenWidth = 0;
double screenHeight = 0;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Connectivity().checkConnectivity();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // FirebaseMessaging.onBackgrou`ndMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(const ProviderScope(child: MyApp()));
}


@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage massage) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Hit massage delivered API here
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<User?>(userProvider, (previousState, nextState) {
      if (previousState != null && nextState == null) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RouteName.login, (route) => false,
        );
      }
    });
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final networkStatus = ref.watch(networkStatusProvider);
    // final fcmToken = ref.watch(fcmTokenProvider);
    // final user = ref.watch(userProvider);
    //
    // if (user != null && fcmToken != null) {
    //   saveFcmToken(uid: user.id, token: fcmToken, isDriver: false);
    // }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        screenWidth = 1.sw;
        screenHeight = 1.sh;
        final size = MediaQuery.of(context).size;
        AppDevice.init(size);

        return MaterialApp(
          title: 'RiderPay',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('hi')],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            final brightness = Theme.of(context).brightness;
            final overlayStyle =
            (themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    brightness == Brightness.dark))
                ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Colors.black,
              systemNavigationBarIconBrightness: Brightness.light,
            )
                : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Color(0xff0D0B21),
              systemNavigationBarIconBrightness: Brightness.light,
            );

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: overlayStyle,
              child: Stack(
                children: [
                  child!,
                  if (networkStatus == NetworkStatus.disconnected)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: InternetBanner(),

                    ),
                ],
              ),
            );
          },
          initialRoute: RouteName.splash,
          onGenerateRoute: (settings) {
            if (settings.name != null) {
              return CupertinoPageRoute(
                builder: (_) => AppRoute.generateRoute(settings.name!),
                settings: settings,
              );
            }
            return null;
          },
        );
      },
    );
  }
}



/// A reusable banner that shows when there is no internet connection.
class InternetBanner extends ConsumerWidget {
  const InternetBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: networkStatus == NetworkStatus.disconnected
          ? Offset.zero
          : const Offset(0, -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: networkStatus == NetworkStatus.disconnected ? 1 : 0,
        child: Material( // ✅ FIX: give Material context to render properly
          elevation: 2,
          color: Colors.redAccent,
          child: Container(
            height: 80,
            width: double.infinity, padding:
             EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            alignment: Alignment.center,
            child:  ConstText(text: '🚫 No Internet Connection', textAlign: TextAlign.center,
              color: context.white,
              fontSize: AppConstant.fontSizeTwo,
            ),
          ),
        ),
      ),
    );
  }
}
