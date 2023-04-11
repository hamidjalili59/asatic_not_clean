import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:convert' as convert;
import '../../data/hive/account_data/account_data.dart';
import '../../presentation/cubit/button_data_cubit.dart';
import 'app_constants.dart';
import 'printf.dart';
import 'server_constants.dart';

double? getSize(BuildContext context, {required bool isWidth}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  double? widthOrHeight;
  if (isWidth == true) {
    widthOrHeight = width;
  } else if (isWidth == false) {
    widthOrHeight = height;
  }
  return widthOrHeight;
}

Future<bool> isNotConnectedToWifi() async {
  bool isConnected = true;
  if (!(await WiFiForIoTPlugin.isConnected()) ||
      await WiFiForIoTPlugin.getSSID() != Constants.usernameESP) {
    isConnected = await WiFiForIoTPlugin.connect(Constants.usernameESP,
            password: Constants.pwdESP,
            security: NetworkSecurity.WPA,
            timeoutInSeconds: 5)
        .then((value) async {
      if (value) {
        await WiFiForIoTPlugin.forceWifiUsage(true)
            .whenComplete(() => isConnected);
        return true;
      } else {
        return isConnected;
      }
    });
  } else {
    await WiFiForIoTPlugin.forceWifiUsage(true).whenComplete(() => isConnected);
  }
  return isConnected;
}

Stream offlineListener() async* {
  while (Constants.isOffline == 'true') {
    try {
      await Future.delayed(const Duration(seconds: 3));
      // await isNotConnectedToWifi();
      await httpRequestPost(postUrl: 'http://192.168.1.210/', body: "")
          .then((value) async {
        Constants.itemList = {"10001": convert.jsonDecode(value.data)};
        if (Constants.itemList["10001"]["sensor_data"].toString().isNotEmpty) {
          Constants.itemListCurrentPage = convert.jsonDecode(
              Constants.itemList[Constants.itemList.keys.toList()[0]]
                  ["Device_Relay_Status"]);
          Constants.itemList[Constants.itemList.keys
              .toList()[Constants.appbarMenuPosation]]["chanel_Count"] = 5;
          Constants.itemListCurrentPage["sensor"] = {"status": true, "tp": "s"};
          Constants.itemList[Constants.itemList.keys
                      .toList()[Constants.appbarMenuPosation]]
                  ["Device_Relay_Status"] =
              convert.jsonEncode(Constants.itemListCurrentPage);
          //
          Constants.sensorSocketData["10001"] = {};
          Constants.sensorSocketData["10001"]["temp"] = convert
              .jsonDecode(Constants.itemList["10001"]["sensor_data"])["temp"];
          Constants.sensorSocketData["10001"]["humidity"] = convert.jsonDecode(
              Constants.itemList["10001"]["sensor_data"])["humidity"];
        } else {
          Constants.itemList[Constants.itemList.keys
              .toList()[Constants.appbarMenuPosation]]["chanel_Count"] = 4;
          if (Constants.itemListCurrentPage.containsKey("sensor")) {
            Constants.itemListCurrentPage.remove("sensor");
          }
        }
      });

      yield Constants.itemList;
    } catch (e) {
      await Future.delayed(const Duration(seconds: 3));
      await WiFiForIoTPlugin.forceWifiUsage(true);
      Constants.logger.e(e.toString());
    }
  }
}

TextStyle textStyler(
    {double? fontsize,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
    fontWeight: fontWeight,
    fontFamily: "IRANSans",
    fontSize: fontsize ?? 16.r,
    color: color,
  );
}

Future<void> initWithStoredJWT(BuildContext context) async {
  if (Constants.accountDataBox.isNotEmpty &&
      Constants.accountDataBox.containsKey("AccountData")) {
    AccountData storedAccountData = Constants.accountDataBox.get("AccountData");
    Constants.jwtCode = storedAccountData.cookie;
    RestAPIConstants.phoneNumberID = storedAccountData.phoneNum;
    Cookie jwt = Cookie.fromSetCookieValue(Constants.jwtCode);
    bool jwtIsExp = Jwt.isExpired(jwt.value);
    if (jwtIsExp) {
      return printF(text: jwtIsExp.toString());
    } else {
      printF(text: jwtIsExp.toString());
      await BlocProvider.of<ButtonDataCubit>(context)
          .getAllDevicesData(context, false, isHttpMode: true);
    }
  }
}

Future<void> initialLocalDatabase() async {
  try {
    if (!Hive.isBoxOpen('Account_Data')) {
      await Hive.openBox('Account_Data').whenComplete(() {
        Constants.accountDataBox = Hive.box('Account_Data');
        printF(text: Constants.accountDataBox.keys.toString());
      });
    }
    if (!Hive.isBoxOpen('options')) {
      await Hive.openBox('options').whenComplete(() {
        Constants.optionsData = Hive.box('options');
        printF(text: Constants.optionsData.keys.toString());
      });
    }
    if (!Hive.isBoxOpen('wifi_list_data')) {
      await Hive.openBox('wifi_list_data').whenComplete(() {
        Constants.deviceWifiList = Hive.box('wifi_list_data');
        printF(text: Constants.deviceWifiList.keys.toString());
      });
    }
  } catch (e) {
    printF(text: e.toString());
  }
}

showErrorDialog(
    {required BuildContext? context,
    String title = "salam",
    String content = "error dari !"}) {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      MaterialButton(
        onPressed: () {
          Navigator.pop(context!);
        },
        child: textWidget("OK"),
      )
    ],
  );
  return showDialog(
      context: context!,
      builder: (BuildContext context) {
        return alert;
      });
}

Future<bool> wifiConnectiongMethod(String userMethod, String passwordMethod,
    {bool havePass = false}) async {
  try {
    await WiFiForIoTPlugin.connect(userMethod,
            password: passwordMethod,
            timeoutInSeconds: 8,
            security: havePass ? NetworkSecurity.WPA : NetworkSecurity.NONE)
        .then((value) async {
      if (value) {
        await WiFiForIoTPlugin.forceWifiUsage(true);
      } else {
        await WiFiForIoTPlugin.forceWifiUsage(false);
      }
    });
    if (await WiFiForIoTPlugin.getSSID() == userMethod) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    await WiFiForIoTPlugin.forceWifiUsage(false);
    return false;
  }
}

Material changeStatusButton(BuildContext context) {
  return Material(
    color: Constants.transparentColor,
    borderRadius: const BorderRadius.all(Radius.circular(300)),
    child: InkWell(
      onTap: () async {
        try {
          // BlocProvider.of<ButtonDataCubit>(context).changeStatusButton((!bool.fromEnvironment(currentStateCubit)).toString());
        } catch (err) {
          printF(text: err.toString());
        }
      },
      borderRadius: const BorderRadius.all(Radius.circular(300)),
      child: SizedBox(
          width: 100,
          height: 100,
          child: BlocBuilder<ButtonDataCubit, ButtonDataState>(
              bloc: BlocProvider.of<ButtonDataCubit>(context),
              builder: (context, state) {
                return CustomPaint(
                  // painter: PowerButtonPaint(status: state.status),
                  child: Container(),
                );
              })),
    ),
  );
}

Future<void> initApp() async {
  // baraye motmaen shodan az ejraee method haye lazem ghable shoroe
  WidgetsFlutterBinding.ensureInitialized();
  // baraye sabet kardan jahat application
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Constants.transparentColor,
    ),
  );
}

//Widget Constants

textWidget(String text, {TextStyle? style}) => Text(
      text,
      style: style,
    );

Widget circularRangeSlider(int min, int max, bool isTemp, bool draggable) {
  return SfRadialGauge(axes: <RadialAxis>[
    RadialAxis(
      minimum: isTemp ? -20 : 0,
      maximum: isTemp ? 120 : 100,
      ranges: <GaugeRange>[
        GaugeRange(
            startValue: max.toDouble(),
            endValue: min.toDouble(),
            color: Constants.greenCol,
            startWidth: 21.w,
            endWidth: 21.w),
      ],
      pointers: [
        WidgetPointer(
          value: max.toDouble(),
          enableDragging: draggable ? true : false,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 232, 16, 67),
                borderRadius: BorderRadius.circular(20)),
            child: const Center(
              child: Text(
                "Max",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        WidgetPointer(
          value: min.toDouble(),
          enableDragging: draggable ? true : false,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 232, 16, 67),
                borderRadius: BorderRadius.circular(20)),
            child: const Center(
                child: Text(
              "Min",
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
      ],
      annotations: <GaugeAnnotation>[
        GaugeAnnotation(
          widget: Padding(
            padding: EdgeInsets.only(left: 30.0.w),
            child: SizedBox(
              child: Text(
                isTemp
                    ? 'شروع دما از\n${min.toInt()}\u2103\nتا\n${max.toInt()}\u2103'
                    : 'شروع رطوبت از\n${min.toInt()}%\nتا\n${max.toInt()}%',
                style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
      canRotateLabels: false,
      showLastLabel: false,
      showAxisLine: true,
      showLabels: false,
      showTicks: false,
      axisLineStyle: const AxisLineStyle(
          thickness: 22, cornerStyle: CornerStyle.bothCurve),
    )
  ]);
}

// show Flash dialog

void showDialogFlashQR(
    {bool persistent = true,
    required BuildContext context,
    String title = "",
    String content = "",
    Function()? onPressNO,
    required String route}) {
  context.showFlashDialog(
      constraints: const BoxConstraints(maxWidth: 300),
      persistent: persistent,
      title: Text(
        title,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 16),
      ),
      negativeActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () {
            controller.dismiss();
          },
          child: const Text(
            'خیر',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      },
      positiveActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () {
            controller.dismiss();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(route, ModalRoute.withName('/home'));
          },
          child: const Text(
            'بله',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      });
}

void showDialogFlashTimer(
    {bool persistent = true, required BuildContext context}) {
  context.showFlashDialog(
    title: const Text("data"),
    constraints: const BoxConstraints(maxWidth: 300),
    persistent: persistent,
    content: Container(
      color: Constants.fourDarkCol,
      width: 50,
      height: 50,
      child: const Text("data"),
    ),
  );
}

Future<void> checkUpdate(BuildContext context) async {
  if (Constants.optionsData.get('updateData', defaultValue: false) == true) {
    _updateDialogMethod(context).show(context, dismissable: false);
  } else {
    await httpRequestGet(getUrl: 'http://asatic.ir/api/Version')
        .then((value) {
          if (value.statusCode == 200) {
            if (value.data['version'] != Constants.currentVersion) {
              if (value.data['isForced'] == true) {
                Constants.optionsData.put('updateData', value.data);
              }
              _updateDialogMethod(context).show(context, dismissable: false);
            }
          }
        })
        .timeout(const Duration(seconds: 15))
        .catchError((e) {});
  }
}

NDialog _updateDialogMethod(BuildContext context) {
  return NDialog(
    actions: [
      MaterialButton(
        onPressed: (Constants.optionsData
                    .get('updateData', defaultValue: {})['isForced'] ==
                true)
            ? () {
                exit(0);
              }
            : () {
                Navigator.pop(context);
              },
        minWidth: 50,
        child: Text(
          (Constants.optionsData
                      .get('updateData', defaultValue: {})['isForced'] ==
                  true)
              ? 'بستن'
              : 'بعدا',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.r),
        ),
      ),
      MaterialButton(
        onPressed: () async {
          const url = 'http://asatic.ir/resource/app.apk';
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $url';
          }
          // await downloadFile(
          //     'http://asatic.ir/resource/app.apk', 'apphamid.apk');
        },
        minWidth: 50,
        child: Text(
          'آپدیت',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.r),
        ),
      )
    ],
    content: WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: SizedBox(
        width: 0.5.sw,
        height: 0.2.sh,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text(
                'آپدیت جدید',
                style: TextStyle(fontSize: 26.r, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text(
                'آپدیت برای نرم‌افزار موجود است',
                style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10.h),
              Text(
                'ورژن فعلی : ${Constants.currentVersion}  ورژن جدید : ${Constants.optionsData.get('updateData', defaultValue: {})['version']}',
                style: TextStyle(fontSize: 14.r, fontWeight: FontWeight.w500),
              ),
            ]),
          ),
        ),
      ),
    ),
  );
}

Future<void> downloadFile(String url, String name) async {
  // final appStorage = await getApplicationSupportDirectory();
  // final file = File('${appStorage.path}/$name');
  // print('shoroe');
  // final response = await Dio().get(url,
  //     options: Options(
  //       responseType: ResponseType.bytes,
  //       followRedirects: false,
  //       receiveTimeout: 0,
  //     ));

  // final raf = file.openSync(mode: FileMode.write);
  // raf.writeFromSync(response.data);
  // await raf.close();
  // print('tamam');

  // return file;
}

Future<Response> httpRequestGet({required String getUrl}) async {
  // Await the http get response, then decode the json-formatted response.
  print('get $getUrl');

  Response response = await Constants.dio
      .get(
    getUrl,
    options: Options(
      headers: {
        "Content-Type": "application/json",
        "Cookie": Constants.jwtCode,
        "iam": "mobile"
      },
    ),
  )
      .catchError((e) {
    Constants.logger.e("$e  ==== HTTP get Error ");
  });
  Constants.logger.i(
      "METHOD => [${response.requestOptions.method}]\nBODY Request => [${response.requestOptions.data}] \nBODY Response => [${response.data}] \nStatusCode = [${response.statusCode}] \nPATH => [${response.requestOptions.path}]");
  return response;
}

// ----------------------------------------------------

Future<Response> httpRequestPost(
    {required String postUrl, required dynamic body}) async {
  print('post $postUrl');
  print('post $body');
  Response response = await Constants.dio
      .post(
    postUrl,
    data: convert.jsonEncode(body),
    options: Options(
      contentType: "application/json",
      method: "POST",
      receiveTimeout: 8000,
      sendTimeout: 5000,
      headers: Constants.isOnline == 'true'
          ? {
              "iam": "mobile",
            }
          : {},
    ),
  )
      .catchError((e) {
    Constants.logger.e("$e  ==== HTTP post Error");
  });
  Constants.logger.i(
      "METHOD => [${response.requestOptions.method}]\nBODY Request => [${response.requestOptions.data}] \nBODY Response => [${response.data}] \nStatusCode = [${response.statusCode}] \nPATH => [${response.requestOptions.path}]");
  return response;
}

Future<Response> httpRequestPut(
    {required String putUrl, required Map<String, dynamic> body}) async {
  print('post $putUrl');
  print('post $body');
  if (body.containsKey("device_Relay_Timer")) {
    body.remove("device_Relay_Timer");
  }
  Response response = await Constants.dio
      .put(
    putUrl,
    data: convert.jsonEncode(body),
    options: Options(
      receiveTimeout: 8000,
      sendTimeout: 5000,
      headers: {
        "Content-Type": "application/json",
        "Cookie": Constants.jwtCode,
        "iam": "mobile"
      },
    ),
  )
      .catchError(
    (e) {
      Constants.logger.i("$body \n $e  ==== HTTP Put Error ");
    },
  );
  Constants.logger.i(
      "METHOD => [${response.requestOptions.method}]\nBODY Request => [${response.requestOptions.data}] \nBODY Response => [${response.data}] \nStatusCode = [${response.statusCode}] \nPATH => [${response.requestOptions.path}]\n________________________________________________________________________\n");
  return response;
}

Future<Response> httpRequestDelete(
    {required String deleteUrl, required dynamic body}) async {
  print('post $deleteUrl');
  print('post $body');
  Response response = await Constants.dio
      .delete(
    deleteUrl,
    data: convert.jsonEncode(body),
    options: Options(
      headers: {
        "Content-Type": "application/json",
        "Cookie": Constants.jwtCode,
        "iam": "mobile"
      },
      sendTimeout: 5000,
    ),
  )
      .catchError((e) {
    Constants.logger.i("$e  ==== HTTP delete Error ");
  });
  Constants.logger.i(
      "METHOD => [${response.requestOptions.method}]\nBODY Request => [${response.requestOptions.data}] \nBODY Response => [${response.data}] \nStatusCode = [${response.statusCode}] \nPATH => [${response.requestOptions.path}]");
  return response;
}

Future<bool> isDataInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}

bool dateCompair(
    {required int startIndex,
    required int endIndex,
    bool isMin = false,
    Map<String, dynamic> tempAlarm = const {},
    bool isChecking = false}) {
  if (isChecking == false) {
    if (isMin
        ? !(int.parse(tempAlarm["start"].substring(startIndex, endIndex)) >=
            int.parse(tempAlarm["end"].substring(startIndex, endIndex)))
        : !(int.parse(tempAlarm["start"].substring(startIndex, endIndex)) >
            int.parse(tempAlarm["end"].substring(startIndex, endIndex)))) {
      return true;
    } else {
      return false;
    }
  } else {
    if (int.parse(tempAlarm["start"].substring(startIndex, endIndex)) >=
        int.parse(tempAlarm["end"].substring(startIndex, endIndex))) {
      return true;
    } else {
      return false;
    }
  }
}
//

void apSettings(BuildContext context, TextEditingController? ssid,
    TextEditingController? pass) {
  NAlertDialog(
    title: Text("تنظیم نام کاربری و رمزعبور AP مود",
        textDirection: TextDirection.rtl,
        style: textStyler(color: Constants.themeLight)),
    content: SizedBox(
      height: 0.15.sh,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: SizedBox(
                      height: 0.15.sh / 2,
                      child: const Center(
                          child: Text("نام وای فای دستگاه",
                              textAlign: TextAlign.center)))),
              Expanded(
                  flex: 4,
                  child: SizedBox(
                      height: 0.15.sh / 2,
                      child: const Center(
                          child:
                              Text("رمز عبور", textAlign: TextAlign.center)))),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: 150,
                  height: 0.15.sh / 2,
                  child: TextField(
                    controller: ssid,
                    keyboardType: TextInputType.text,
                    maxLength: 32,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                  flex: 4,
                  child: SizedBox(
                      width: 150,
                      height: 0.15.sh / 2,
                      child: TextField(
                          controller: pass,
                          keyboardType: TextInputType.text,
                          maxLength: 32,
                          enableInteractiveSelection: false,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder())))),
            ],
          ),
        ],
      ),
    ),
    actions: <Widget>[
      MaterialButton(
        child: Text("تایید",
            textDirection: TextDirection.rtl,
            style: textStyler(color: Constants.themeLight)),
        onPressed: () async {
          if (ssid!.text.trim().length > 4 && pass!.text.trim().length > 8) {
            Map temp = {};
            temp["ap_ssid"] = ssid.text.trim().endsWith("_Asatic")
                ? ssid.text.trim()
                : "${ssid.text.trim()}_Asatic";
            temp["ap_password"] = pass.text.trim();
            temp["time"] =
                ("${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}-${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}-${Jalali.now().weekDay}");
            temp["event"] = "ap_set";
            temp.clear();
          } else {
            displaySnackBar(context,
                message:
                    'باید نام بیشتر از 4 کاراکتر و پسورد بیشتر از 8 کاراکتر باشد');
          }
          Navigator.of(context).pop();
        },
      ),
      MaterialButton(
        child: Text("لغو",
            textDirection: TextDirection.rtl,
            style: textStyler(color: Constants.themeLight)),
        onPressed: () {
          ssid!.clear();
          pass!.clear();
          WiFiForIoTPlugin.forceWifiUsage(false)
              .then((v) => WiFiForIoTPlugin.disconnect());
          Navigator.of(context).pop();
        },
      )
    ],
  ).show(context);
}

//
Future<void> checkTimersActivity(BuildContext context) async {
  Constants.timerData.forEach((deviceKey, deviceValue) {
    Constants.timerData[deviceKey].forEach((relaykey, relayValue) {
      Constants.timerData[deviceKey][relaykey].forEach((key, value) {
        DateTime endTime = Jalali(
                int.parse(value["end"].substring(0, 4)),
                int.parse(value["end"].substring(5, 7)),
                int.parse(value["end"].substring(8, 10)),
                int.parse(value["end"].substring(11, 13)),
                int.parse(value["end"].substring(14, 16)))
            .toDateTime();
        if (value["mode"] == "date" || value["mode"] == "none") {
          if (Jalali.now().isAtSameMomentAs(Jalali(
              int.parse(value["end"].substring(0, 4)),
              int.parse(value["end"].substring(5, 7)),
              int.parse(value["end"].substring(8, 10))))) {
            if (endTime.isBefore(DateTime.now())) {
              Constants.timerData[deviceKey][relaykey].remove(key);
              BlocProvider.of<ButtonDataCubit>(context).changeTimers(
                  // log: "تایمر ${tempAlarm["mode"]} اضافه کرد",
                  log:
                      """{"e":"UPDATE_TIMER","r":${Constants.bodyItemPosation - 1},"t":${RestAPIConstants.phoneNumberID},"s":1}""",
                  appbarPos: Constants.appbarMenuPosation,
                  event: "UPDATE_TIMER",
                  isEvent: false,
                  timerData: Constants.timerData[Constants.itemList.keys
                      .toList()[Constants.appbarMenuPosation]]);
            }
            //
          }
          //
        }
      });
    });
  });
}

bool phoneNumberValidator(String value) {
  RegExp regex = RegExp(Constants.regexValidator);
  if (!regex.hasMatch(value)) {
    return false;
  }
  return true;
}

void hiveDataSaving() {}

void showBottomFlash(
  BuildContext context, {
  String event = "",
  String title = "",
  String content = "",
  bool persistent = true,
  EdgeInsets margin = EdgeInsets.zero,
}) {
  showFlash(
    context: context,
    persistent: persistent,
    builder: (_, controller) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Flash(
          controller: controller,
          margin: margin,
          behavior: FlashBehavior.fixed,
          position: FlashPosition.bottom,
          backgroundColor: Constants.thirdryDarkCol,
          onTap: () {
            Constants.flashDialogflag = false;
            controller.dismiss();
          },
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          child: DefaultTextStyle(
            style: TextStyle(color: Constants.themeLight),
            child: FlashBar(
              title: Text(title),
              content: Text(content),
              indicatorColor: Constants.greenCol,
              icon: const Icon(Icons.info_outline),
              primaryAction: TextButton(
                onPressed: () {
                  Constants.flashDialogflag = false;
                  controller.dismiss();
                },
                child: Icon(Icons.close, color: Constants.themeLight),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Constants.flashDialogflag = false;
                      controller.dismiss(false);
                    },
                    child: Text(
                      event == "disconnected" ? "بستن" : 'خیر',
                      style: textStyler(color: Constants.themeLight),
                    )),
                TextButton(
                    onPressed: () {
                      if (event == "logout") {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/splash", (Route<dynamic> route) => false);
                        Constants.itemList = {};
                        Constants.itemListCurrentPage = {};
                        Constants.appBarCardListLength = 0;
                        Constants.devicesListitems.clear();
                        Constants.isOnline = '';
                        Constants.isOffline = '';
                        Constants.setOnline = false;
                        Constants.currentIndex = 0;
                        Constants.accountDataBox.delete("AccountData");
                        // Constants.accountDataBox.clear();
                        // .put("AccountData", AccountData(cookie: '',phoneNum: 0));
                      } else if (event == "disconnected") {
                        BlocProvider.of<ButtonDataCubit>(context)
                            .getAllDevicesData(context, true);
                      }
                      Constants.flashDialogflag = false;
                      controller.dismiss(true);
                    },
                    child: Text(
                      event == "disconnected" ? "سعی مجدد" : 'بله',
                      style: textStyler(color: Constants.themeLight),
                    )),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    return value;
  });
}

Future<bool?> showDialogFlash(
  BuildContext context, {
  String title = "",
  String content = "",
  bool persistent = true,
}) {
  // bool accepted = false;
  return context.showFlashDialog(
      constraints: const BoxConstraints(maxWidth: 300),
      transitionDuration: const Duration(milliseconds: 300),
      persistent: persistent,
      title: Text(title),
      content: Text(content),
      negativeActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () {
            controller.dismiss(false);
          },
          child: const Text('خیر'),
        );
      },
      positiveActionBuilder: (context, controller, _) {
        return TextButton(
            onPressed: () {
              controller.dismiss(true);
            },
            child: const Text('بله'));
      });
}

Future<void> permissionHandler() async {
  // PermissionStatus sPermissionStatus = await Permission.storage.status;
  PermissionStatus lPermissionStatus = await Permission.location.status;
  // if (sPermissionStatus.isDenied) {
  //   await Permission.storage.request();
  // }
  if (lPermissionStatus.isDenied) {
    await Permission.location.request();
  }
}

void showDialogAddDevice(
    {bool persistent = true,
    required BuildContext context,
    String title = "",
    String content = "",
    Function()? onPressNO,
    required String route}) {
  context.showFlashDialog(
      constraints: const BoxConstraints(maxWidth: 300),
      persistent: persistent,
      title: Text(
        title,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 16),
      ),
      negativeActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () {
            controller.dismiss();
          },
          child: const Text(
            'خیر',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      },
      positiveActionBuilder: (context, controller, _) {
        return TextButton(
          onPressed: () {
            controller.dismiss();
            Constants.setOnline = true;
            if (Constants.isOnline == 'true') {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(route, ModalRoute.withName('/home'));
            } else {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(route, ModalRoute.withName('/home'));
            }
          },
          child: const Text(
            'بله',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      });
}

Future<void> userManagmentDialog(
    BuildContext context,
    TextEditingController deviceNumberController,
    TextEditingController deviceTagController,
    bool creating,
    {Map<String, dynamic> user = const {},
    int pos = 0}) async {
  if (creating) {
    deviceNumberController.text = '';
    deviceTagController.text = '';
  }
  NAlertDialog(
    title: Text(creating ? "اضافه کردن کاربر جدید" : "تغییر اطلاعات کاربر",
        textDirection: TextDirection.rtl,
        style: textStyler(color: Constants.themeLight)),
    content: SizedBox(
      height: 0.15.sh,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: SizedBox(
                      height: 0.15.sh / 2,
                      child: const Center(
                          child: Text("شماره کاربر",
                              textAlign: TextAlign.center)))),
              Expanded(
                  flex: 4,
                  child: SizedBox(
                      height: 0.15.sh / 2,
                      child: const Center(
                          child: Text("اسم مستعار",
                              textAlign: TextAlign.center)))),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: 150,
                  height: 0.15.sh / 2,
                  child: TextField(
                    controller: deviceNumberController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                  flex: 4,
                  child: SizedBox(
                      width: 150,
                      height: 0.15.sh / 2,
                      child: TextField(
                          controller: deviceTagController,
                          keyboardType: TextInputType.text,
                          maxLength: 18,
                          enableInteractiveSelection: false,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder())))),
            ],
          ),
        ],
      ),
    ),
    actions: <Widget>[
      MaterialButton(
        child: Text("تایید",
            textDirection: TextDirection.rtl,
            style: textStyler(color: Constants.themeLight)),
        onPressed: () async {
          if (creating) {
            List<Map<String, dynamic>> temp = [];
            Map<String, dynamic> tempUser = {};
            tempUser["deviceID"] = int.parse(Constants.itemList.keys
                .toList()[Constants.deviceSelected]
                .toString());
            tempUser["phonenumber"] = int.parse(deviceNumberController.text);
            tempUser["name_Tag"] = deviceTagController.text;
            tempUser["owner"] = false;
            tempUser["isEnable"] = true;
            temp.add(tempUser);
            await BlocProvider.of<ButtonDataCubit>(context)
                .userManagment(temp, 0, true, user: tempUser);
          } else {
            user["phonenumber"] = int.parse(deviceNumberController.text);
            user["name_Tag"] = deviceTagController.text;
            await BlocProvider.of<ButtonDataCubit>(context)
                .userManagment([user], pos, false, user: user);
          }
          Navigator.of(context).pop();
        },
      ),
      MaterialButton(
        child: Text("لغو",
            textDirection: TextDirection.rtl,
            style: textStyler(color: Constants.themeLight)),
        onPressed: () {
          deviceTagController.clear();
          Navigator.of(context).pop();
        },
      )
    ],
  ).show(context);
}

void displaySnackBar(
  context, {
  required String message,
  bool isFailureMessage = false,
}) {
  final snackBar = SnackBar(
    content: Text(
      message.isNotEmpty ? message : 'Empty',
      textAlign: TextAlign.center,
      style:
          const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    ),
    duration: const Duration(milliseconds: 800),
    backgroundColor: isFailureMessage ? Colors.redAccent : Colors.greenAccent,
  );

  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(snackBar);
}

void setNameMapForLog() {
  Constants.nameAndDeviceID = {};
  Constants.itemList.values.toList().forEach((element) {
    if (!Constants.nameAndDeviceID.containsKey(element['tag'].toString())) {
      Constants.nameAndDeviceID[(element['tag'] ??
              '${Constants.itemList.values.toList().indexOf(element)} دستگاه')] =
          element['deviceID'].toString();
    }
  });
}
