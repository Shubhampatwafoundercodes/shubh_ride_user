import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/res/app_device.dart';
import 'package:rider_pay/theme/app_theme.dart';
import 'package:rider_pay/theme/theme_controller.dart';
import 'package:rider_pay/utils/routes/routes.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/language/language_controller.dart';
import 'package:rider_pay/view/share_pref/user_provider.dart' show User, userProvider;

double screenWidth = 0;
double screenHeight = 0;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen<User?>(userProvider, (previousState, nextState) {
    //   if (previousState != null && nextState == null) {
    //     navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //     RouteName.login, (route) => false,
    //     );
    //   }
    // });
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

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
          title: 'Rider Pay',
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
              child: child!,
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
