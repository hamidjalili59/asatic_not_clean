import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_client/flutter_socket_client.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:asatic/data/utils/api_services.dart';
import 'package:asatic/data/utils/server_constants.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:io';
import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../cubit/button_data_cubit.dart';
import '../profile_and_settings/profile_page.dart';
import 'home_mobile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

DateTime? currentBackPressTime;

Future<void> socketInitaialHome(ctx) async {
  StreamSubscription<dynamic>? ss;
  try {
    if (!Constants.streamStarted) {
      Constants.streamStarted = true;
      ss = Constants.streamPingPongInternal(ctx)!.listen((event) async {
        if (!event) {
          if (Constants.isOnline == 'true') {
            if (!FlutterSocketClientImpl.socketStarted) {
              FlutterSocketClientImpl(RestAPIConstants.phoneNumberID)
                  .closeSocket();
            }
            await FlutterSocketClientImpl(RestAPIConstants.phoneNumberID)
                .initializeConnecting()
                .whenComplete(() =>
                    FlutterSocketClientImpl(RestAPIConstants.phoneNumberID)
                        .listenWithAutoReConnect(customFunction: (e) {
                      ApiServices().socketFunc(ctx, e);
                    }).join());
          }
        }
      });
    }
    if (Constants.isOnline == 'true') {
      if (!FlutterSocketClientImpl.socketStarted) {
        FlutterSocketClientImpl(RestAPIConstants.phoneNumberID).closeSocket();
      }
      await FlutterSocketClientImpl(RestAPIConstants.phoneNumberID)
          .initializeConnecting()
          .whenComplete(() =>
              FlutterSocketClientImpl(RestAPIConstants.phoneNumberID)
                  .listenWithAutoReConnect(customFunction: (e) {
                ApiServices().socketFunc(ctx, e);
              }).join());
    }
  } on SocketException {
    if (Constants.isOnline == 'false') {
      if (ss != null) {
        ss.cancel();
      }
    }
    socketInitaialHome(ctx);
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    checkUpdate(context);
  }

  @override
  void dispose() {
    if (!(Constants.isOnline == 'true')) {
      WiFiForIoTPlugin.disconnect()
          .then((value) => WiFiForIoTPlugin.forceWifiUsage(false));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Constants.isOnline == 'true') {
      socketInitaialHome(context);
    }

    ScreenUtil.init(context, designSize: Constants.hamidPhoneSize);
    Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
        currentBackPressTime = now;
        displaySnackBar(context, message: 'برای خروج دوباره کلیک کنید');
        return Future.value(false);
      }
      return Future.value(true);
    }

    List<Widget> currentHomePageWidget = [
      const HomeMobileWidget(),
      const ProfilePage()
    ];
    setNameMapForLog();
    return BlocBuilder<ButtonDataCubit, ButtonDataState>(
      bloc: BlocProvider.of<ButtonDataCubit>(context),
      builder: (context, state) => BlurryModalProgressHUD(
        progressIndicator: Platform.isAndroid
            ? Column(
                children: [
                  SizedBox(
                    height: getSize(context, isWidth: false)! / 6.5,
                  ),
                  SizedBox(
                    height: getSize(context, isWidth: false)! -
                        getSize(context, isWidth: false)! / 6.5,
                    width: getSize(context, isWidth: true),
                    child: Center(
                      child: SizedBox(
                          height: 80,
                          width: 80,
                          child: CircularProgressIndicator(
                              strokeWidth: 10,
                              color: Constants.greenCol,
                              backgroundColor:
                                  Constants.greenCol.withAlpha(130))),
                    ),
                  ),
                ],
              )
            : SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                    strokeWidth: 10,
                    color: Constants.themeLight,
                    backgroundColor: Constants.greenCol),
              ),
        inAsyncCall: state.isLoading,
        child: WillPopScope(
          onWillPop: onWillPop,
          child: BaseWidget(
            appbar: PreferredSize(
              preferredSize: Size.fromHeight(80.0.h),
              child: Container(
                alignment: Alignment.centerLeft,
                height: 0.1.sh,
                color: Constants.secondryDarkCol,
                child: Builder(
                  builder: (context) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 0.23.sw,
                        child: Image.asset(
                          "assets/images/logo_asatic.png",
                          color: Constants.greenCol,
                        ),
                      ),
                      SizedBox(
                        width: 50.w,
                        child: IconButton(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 15),
                          iconSize: 35.r,
                          onPressed: Constants.currentIndex != 0
                              ? () {
                                  NAlertDialog(
                                      blur: 0.7,
                                      dialogStyle: DialogStyle(
                                          titleDivider: false,
                                          contentPadding:
                                              const EdgeInsets.all(6)),
                                      title: const Text('راهنما',
                                          textAlign: TextAlign.center),
                                      content: Container(
                                        height: 0.6.sh,
                                        width: 0.75.sw,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white38),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              '\nریموت کنترل 4 کانال هوشمند\n\nبا قابلیت کنترل از طریق اینترنت و accessPoints'
                                              '\n\nدارای قابلیت تعریف تایمر و تنظیم دما و رطوبت برای هر رله\nاز طریق سنسور'
                                              '\n\nدارای خروجی هایی با توان خروجی 1500 وات و حداکثر جریان 7 آمپر و حداکثر ولتاژ 220 ولت برای هر خروجی'
                                              '\n\nقابلیت استفاده برای کنترل کننده دما محیط تبدیل به سیستم bms برای منازل',
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              style: textStyler(
                                                  color: Colors.white,
                                                  fontsize: 13.r),
                                            ),
                                            SizedBox(height: 0.08.sh),
                                            SizedBox(
                                              width: 0.45.sw,
                                              child: Image.asset(
                                                'assets/images/logo_asatic.png',
                                                color: Constants.greenCol,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: const []).show(context);
                                }
                              : () async {
                                  if (Constants.isOnline == 'true') {
                                    //
                                    if (await Permission.locationWhenInUse
                                        .serviceStatus.isEnabled) {
                                      WiFiForIoTPlugin.isEnabled()
                                          .then((value) async {
                                        if (value == true) {
                                          // if (await isDataInternet() == false) {
                                          showDialogAddDevice(
                                            context: context,
                                            title:
                                                "آیا قصد اتصال دستگاه به اینترنت را دارید",
                                            content:
                                                "با زدن بر روی کلید بله شما به تنظیمات مودم منتقل میشوید",
                                            route: "/add_device",
                                          );
                                          // } else {
                                          //   displaySnackBar(context,
                                          //       message:
                                          //           'لطفا برای برقراری ارتباط با دستگاه اینترنت دیتا خود را خاموش کنید');
                                          // }
                                        } else {
                                          NDialog(
                                            title: Text(
                                                "برای اتصال آفلاین به نرم افزار باید wifi دستگاه خود را روشن کنید",
                                                style: textStyler(
                                                    color:
                                                        Constants.themeLight),
                                                textAlign: TextAlign.center,
                                                textDirection:
                                                    TextDirection.rtl),
                                            actions: [
                                              InkWell(
                                                onTap: () {
                                                  AppSettings
                                                      .openWIFISettings();
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    color: Constants.greenCol,
                                                    height: 0.05.sh,
                                                    child: Text(
                                                        "بازکردن تنظیمات",
                                                        style: textStyler(
                                                            color: Constants
                                                                .themeLight),
                                                        textAlign:
                                                            TextAlign.center,
                                                        textDirection:
                                                            TextDirection.rtl)),
                                              ),
                                            ],
                                          ).show(context);
                                        }
                                      });
                                    } else {
                                      NDialog(
                                        title: Text(
                                            "برای پیدا کردن wifi های اطراف باید سرویس location دستگاه خود را روشن کنید",
                                            style: textStyler(
                                                color: Constants.themeLight),
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl),
                                        actions: [
                                          InkWell(
                                            onTap: () {
                                              AppSettings
                                                  .openLocationSettings();
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                color: Constants.greenCol,
                                                height: 0.05.sh,
                                                child: Text("بازکردن تنظیمات",
                                                    style: textStyler(
                                                        color: Constants
                                                            .themeLight),
                                                    textAlign: TextAlign.center,
                                                    textDirection:
                                                        TextDirection.rtl)),
                                          ),
                                        ],
                                      ).show(context);
                                    }
                                    //
                                  } else {
                                    if (true) {
                                      Constants.isOffline = 'false';
                                      await WiFiForIoTPlugin.forceWifiUsage(
                                              false)
                                          .whenComplete(() async =>
                                              await WiFiForIoTPlugin
                                                  .disconnect());
                                      if (await isDataInternet() == false) {
                                        showDialogAddDevice(
                                          context: context,
                                          title:
                                              "آیا قصد اتصال دستگاه به اینترنت را دارید",
                                          content:
                                              "برای اتصال دستگاه به اینترنت باید وارد اکانت خود شوید با زدن بر روی کلید بله شما به صفحه ورود منتقل میشوید",
                                          route: "/authentication",
                                        );
                                      } else {
                                        displaySnackBar(context,
                                            message:
                                                'لطفا برای برقراری ارتباط با دستگاه اینترنت دیتا خود را خاموش کنید');
                                      }
                                    }
                                  }
                                },
                          icon: Icon(
                            Constants.currentIndex == 0
                                ? Constants.isOnline == 'true'
                                    ? Icons.add
                                    : Icons.travel_explore_rounded
                                : Icons.help_outline_rounded,
                            color: Constants.themeLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: Constants.secondryDarkCol,
            bottomNavigationBar: SalomonBottomBar(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              currentIndex: Constants.currentIndex,
              onTap: (i) async {
                setState(() {
                  // Constants.appbarMenuPosation = i;
                  Constants.currentIndex = i;
                });
              },
              itemPadding:
                  EdgeInsets.symmetric(horizontal: 40.w, vertical: 0.02.sh),
              curve: Curves.fastOutSlowIn,
              duration: const Duration(seconds: 1),
              items: [
                /// Home
                SalomonBottomBarItem(
                  icon: Icon(Icons.home, color: Constants.greenCol, size: 20.r),
                  title: textWidget("خانه",
                      style: textStyler(
                          color: Constants.greenCol, fontsize: 13.r)),
                  selectedColor: Constants.greenCol,
                  activeIcon:
                      Icon(Icons.home, color: Constants.greenCol, size: 25.r),
                ),

                /// Profile
                SalomonBottomBarItem(
                  icon: Icon(Icons.settings,
                      color: Constants.greenCol, size: 20.r),
                  title: textWidget("تنظیمات",
                      style: textStyler(
                          color: Constants.greenCol, fontsize: 13.r)),
                  selectedColor: Constants.greenCol,
                  activeIcon: Icon(Icons.settings,
                      color: Constants.greenCol, size: 25.r),
                ),
              ],
            ),
            child: Platform.isAndroid
                ? currentHomePageWidget[Constants.currentIndex]
                : Container(),
          ),
        ),
      ),
    );
  }
}
