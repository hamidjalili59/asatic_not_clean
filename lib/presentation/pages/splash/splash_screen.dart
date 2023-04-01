import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../cubit/button_data_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Constants.appbarMenuPosation = 0;
    WiFiForIoTPlugin.forceWifiUsage(false);
  }

  @override
  Widget build(BuildContext context) {
    permissionHandler();
    Future.delayed(const Duration(seconds: 1)).then((value) => checkUpdate(context));
    return BaseWidget(
      backgroundColor: Constants.themeLight,
      child: Stack(
        children: [
          Positioned.fill(
              child: SvgPicture.asset(
            "assets/svg/bg.svg",
            fit: BoxFit.fill,
          )),
          Positioned.fill(
            child: BlocBuilder<ButtonDataCubit, ButtonDataState>(
              bloc: BlocProvider.of<ButtonDataCubit>(context),
              builder: (context, state) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    width: getSize(context, isWidth: true),
                    height: getSize(context, isWidth: false),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: getSize(context, isWidth: false)! / 7.5,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 35.0),
                                  child: SizedBox(
                                    width: getSize(context, isWidth: true)! / 5,
                                    child: Image.asset(
                                      "assets/images/logo_asatic.png",
                                      color: Constants.greenCol,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getSize(context, isWidth: true)! / 1.5,
                            height: getSize(context, isWidth: false)! / 15,
                            child: const FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  "نرم افزار سوییچ هوشمند",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "IRANSans"),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: getSize(context, isWidth: true)! / 1.5,
                              height: getSize(context, isWidth: false)! / 15,
                              child: const FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    "در دسترس , همه جا",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "IRANSans"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getSize(context, isWidth: false)! / 18,
                            child: const FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 10),
                                child: Text(
                                  "به دنیای بزرگ اینترنت بپیوندید",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: "IRANSans",
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getSize(context, isWidth: false)! / 15,
                          ),
                          Align(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: SizedBox(
                                width: getSize(context, isWidth: true),
                                height: getSize(context, isWidth: false)! / 3,
                                child: LottieBuilder.asset(
                                  'assets/lottie/iot.json',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getSize(context, isWidth: false)! / 10,
                          ),
                          state.isLoading == false
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Constants.isOnline = 'true';
                                        Navigator.pushNamed(
                                            context, '/authentication');
                                      },
                                      child: Container(
                                        width:
                                            getSize(context, isWidth: true)! /
                                                2.75,
                                        height:
                                            getSize(context, isWidth: false)! /
                                                13.5,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 240, 247, 209),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "ورود آنلاین",
                                          style: TextStyle(
                                              color: Constants.appBarColor
                                                  .withBlue(120),
                                              fontSize: 15,
                                              fontFamily: "IRANSans",
                                              fontWeight: FontWeight.w900),
                                        )),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (await Permission.locationWhenInUse
                                            .serviceStatus.isEnabled) {
                                          WiFiForIoTPlugin.isEnabled()
                                              .then((value) {
                                            if (value == true) {
                                              Constants.isOnline = 'false';
                                              Navigator.pushNamed(
                                                  context, '/add_device');
                                            } else {
                                              NDialog(
                                                title: Text(
                                                    "برای اتصال آفلاین به نرم افزار باید wifi دستگاه خود را روشن کنید",
                                                    style: textStyler(
                                                        color: Constants
                                                            .themeLight),
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
                                                        alignment:
                                                            Alignment.center,
                                                        color:
                                                            Constants.greenCol,
                                                        height: 0.05.sh,
                                                        child: Text(
                                                            "بازکردن تنظیمات",
                                                            style: textStyler(
                                                                color: Constants
                                                                    .themeLight),
                                                            textAlign: TextAlign
                                                                .center,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl)),
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
                                                    color:
                                                        Constants.themeLight),
                                                textAlign: TextAlign.center,
                                                textDirection:
                                                    TextDirection.rtl),
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
                                      },
                                      child: Container(
                                        width:
                                            getSize(context, isWidth: true)! /
                                                2.75,
                                        height:
                                            getSize(context, isWidth: false)! /
                                                13.5,
                                        decoration: BoxDecoration(
                                          color: Constants.appBarColor
                                              .withBlue(120),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "ورود آفلاین",
                                          style: TextStyle(
                                              color: Constants.themeLight,
                                              fontSize: 15,
                                              fontFamily: "IRANSans",
                                              fontWeight: FontWeight.w900),
                                        )),
                                      ),
                                    ),
                                  ],
                                )
                              : const Center(
                                  child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
