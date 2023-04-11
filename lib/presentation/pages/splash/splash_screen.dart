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
    // permissionHandler();
    Future.delayed(const Duration(seconds: 1))
        .then((value) => checkUpdate(context));
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
                                      onTap: () async {
                                        if (await Constants.accountDataBox
                                                .get('policy') ??
                                            false) {
                                          Constants.isOnline = 'true';
                                          Constants.setOnline = true;
                                          if (Constants.accountDataBox
                                                  .get('AccountData') !=
                                              null) {
                                            await initWithStoredJWT(context);
                                          } else {
                                            Navigator.pushNamed(
                                                context, '/authentication');
                                          }
                                        } else {
                                          NDialog(
                                            content: SizedBox(
                                                width: 0.25.sw,
                                                height: 0.2.sh,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'لطفا بر روی شرایط استفاده از خدمات و حریم خصوصی کلیک کنید و بعد از مطالعه در انتهای مطلب آنرا تایید کنید.',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                )),
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
                                        if (await Constants.accountDataBox
                                                .get('policy') ??
                                            false) {
                                          if (await Permission.locationWhenInUse
                                              .serviceStatus.isEnabled) {
                                            WiFiForIoTPlugin.isEnabled()
                                                .then((value) {
                                              if (value == true) {
                                                Constants.isOnline = 'false';
                                                Constants.setOnline = false;
                                                Navigator.pushNamed(
                                                    context, '/add_device');
                                              } else {
                                                NDialog(
                                                  title: Text(
                                                      "برای اتصال آفلاین به نرم افزار باید wifi دستگاه خود را روشن کنید",
                                                      style: textStyler(
                                                          color: Constants
                                                              .themeLight),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                          color: Constants
                                                              .greenCol,
                                                          height: 0.05.sh,
                                                          child: Text(
                                                              "بازکردن تنظیمات",
                                                              style: textStyler(
                                                                  color: Constants
                                                                      .themeLight),
                                                              textAlign:
                                                                  TextAlign
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
                                                    permissionHandler();
                                                    AppSettings
                                                        .openLocationSettings();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
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
                                                              TextDirection
                                                                  .rtl)),
                                                ),
                                              ],
                                            ).show(context);
                                          }
                                        } else {
                                          NDialog(
                                            content: SizedBox(
                                                width: 0.25.sw,
                                                height: 0.2.sh,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'لطفا بر روی شرایط استفاده از خدمات و حریم خصوصی کلیک کنید و بعد از مطالعه در انتهای مطلب آنرا تایید کنید.',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                )),
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
                          InkWell(
                            onTap: () async {
                              String privacy =
                                  '''با استفاده از دستگاه کنترل دستگاه های الکتریکی از راه دور، شما موافقت خود را با شرایط استفاده از خدمات و حریم خصوصی زیر اعلام می‌کنید:

این دستگاه با استفاده از اینترنت و وای فای کار می‌کند و برای دسترسی به وای فای به موقعیت مکانی نیاز دارد.

دستگاه دارای چهار رله برای کنترل دستگاه های برقی است و دارای عوامل کنترلی مثل تایمر های مختلف برای هر رله و حسگر سنسور دما و رطوبت برای کنترل جداگانه هر رله است.

دستگاه قابلیت کنترل رله ها توسط ریموت کنترل را هم فراهم می‌کند و دارای نرم‌افزاری قدرتمند است که توسط آن می‌توانید هر ریموت را حذف یا غیر فعال کنید،تایمر ها را کنترل کنید و با استفاده از داده های سنسور ، رله ها را روشن یا خاموش کنید و با استفاده از نرم‌افزار می‌توانید بصورت دستی رله ها را روشن یا خاموش کنید.

با استفاده از نرم‌افزار می‌توانید اجازه دسترسی کامل کنترل دستگاه را به کاربران دیگر بدهید و یا آنها را محدود کنید.

دستگاه دارای محافظ برق برای نجات دستگاه های الکتریکی از نوسانات برق است و دستگاه میتواند بصورت آنلاین با آفلاین کار کند.
اینجانب تایید می‌کنم که قوانین و شرایط استفاده از خدمات ارائه شده توسط این دستگاه را مطالعه کرده و می‌پذیرم.
حریم خصوصی:
این دستگاه حفاظت از حریم خصوصی کاربران را بسیار جدی می‌گیرد و از اطلاعات شما به دقت محافظت می‌کند. این دستگاه از اطلاعات شما به منظور ارتباط با دستگاه و کنترل آن استفاده می‌کند و هیچگونه اطلاعات شما را با شخص یا سازمان دیگری به اشتراک نمی‌گذارد.

اطلاعاتی که در این دستگاه ذخیره می‌شود شامل شماره تلفن  شما می‌باشد که برای متمایز کردن با دیگر کاربران استفاده می‌شود.

همچنین، این دستگاه از اطلاعات دستگاه‌های متصل به آن برای کنترل و مدیریت آنها استفاده می‌کند، اما هیچگونه اطلاعاتی را در مورد شما و دستگاه‌های شما با سایرین به اشتراک نمی‌گذارد.

اطلاعات حساسی مانند شماره و کد نشست شما با استفاده از الگوریتم‌های رمزنگاری پیچیده محافظت می‌شوند و هیچ کس به جز شما قادر به دسترسی به آنها نیست.''';
                              NDialog(
                                content: SizedBox(
                                  width: 0.7.sw,
                                  height: 0.5.sh,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 20.h),
                                        Text(
                                          'شرایط استفاده از خدمات و حریم خصوصی:',
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.r),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 50.h),
                                        Text(
                                          privacy,
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(height: 30.h),
                                        MaterialButton(
                                          onPressed: () async {
                                            await Constants.accountDataBox
                                                .put('policy', true);
                                            Future.delayed(const Duration(
                                                    milliseconds: 300))
                                                .then(
                                              (value) => Navigator.pop(context),
                                            );
                                          },
                                          color: Constants.greenCol,
                                          minWidth: 80.w,
                                          height: 50.h,
                                          child:
                                              const Text('شرایط را میپذیرم.'),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ).show(context);
                            },
                            child: SizedBox(
                              width: 1.sw,
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'شرایط استفاده از خدمات',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' و ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'حریم خصوصی',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ' را میپذیرم.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
