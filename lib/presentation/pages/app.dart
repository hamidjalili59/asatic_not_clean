import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/utils/app_constants.dart';
import 'authentication/user_authentication_page.dart';
import 'client_managment/client_managment.dart';
import 'wifi_connecting/wifi_connecting.dart';
import 'devices_settings/devices_settings.dart';
import 'devices_settings/relay_settings.dart';
import 'home_page/home_page.dart';
import 'offline_wifi_list/offline_wifi_list.dart';
import 'profile_and_settings/logger_page.dart';
import 'sensor_page/sensor_config_page.dart';
import 'sensor_page/sensor_page.dart';
import 'splash/splash_screen.dart';
import 'timer_page/timer_config_page.dart';
import 'timer_page/timer_page.dart';
import 'verification_code/verification_code_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Constants.hamidPhoneSize,
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (ctx, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: ColorScheme(
                    brightness: Brightness.dark,
                    primary: Constants.greenCol,
                    onPrimary: Constants.primeryDarkCol,
                    secondary: Constants.secondryDarkCol,
                    onSecondary: Constants.greenCol,
                    error: Constants.themeLight,
                    onError: Constants.thirdryDarkCol,
                    background: Constants.greenCol,
                    onBackground: Constants.primeryDarkCol,
                    surface: Constants.secondryDarkCol,
                    onSurface: Constants.greenCol)),
            routes: {
              '/home': (context) => const HomePage(),
              '/authentication': (context) => const UserAuthenticationPage(),
              '/restart': (context) => const MyApp(),
              '/splash': (context) => const SplashScreen(),
              '/verifyCode': (context) => const VerificationCodeScreen(),
              '/timer': (context) => TimerPage(
                  devicePos: Constants.appbarMenuPosation,
                  relayPos: Constants.bodyItemPosation),
              '/timer_config': (context) => const TimerConfigPage(),
              '/sensor': (context) => const SensorPage(),
              '/sensor_config': (context) => const SensorConfigPage(),
              '/devicesSettings': (context) =>
                  DevicesSettings(devicePos: Constants.appbarMenuPosation),
              '/client_manage': (context) =>
                  ClientManagment(devicePos: Constants.deviceSelected),
              '/relaySettings': (context) => const RelaySettings(),
              '/wifiConnect': (context) => WifiConnected(
                  pwd: Constants.pwdESP, ssid: Constants.usernameESP),
              // '/wifiListOffline': (context) => const WifiListOffline(),
              '/add_device': (context) => const WifiListOffline(),
              // '/qr_scan': (context) => const QRScaningView(),
              '/logger': (context) => const LoggerPage(),
            },
            initialRoute: '/splash',
          );
        });
  }
}
