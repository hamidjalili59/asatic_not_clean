import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ndialog/ndialog.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:asatic/data/hive/wifi_data/wifi_data.dart';
import 'package:asatic/data/utils/app_constants.dart';
import 'package:asatic/data/utils/functions_helper.dart';
import 'package:asatic/data/utils/printf.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiTileButton extends StatelessWidget {
  final WifiData wifiFilteredList;
  const WifiTileButton({required this.wifiFilteredList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController ssidAPController =
        TextEditingController(text: "");
    final TextEditingController passwordAPController =
        TextEditingController(text: "");

    Future<bool> sendMethod(
        WifiData wifiFilteredList, bool isOffline, bool havePass) async {
      ProgressDialog progressDialog = ProgressDialog(context,
          message: const Text("در حال اتصال"),
          title: const Text("در حال بررسی اتصال به دستگاه لطفا منتظر بمانید"));
      try {
        return await wifiConnectiongMethod(
                wifiFilteredList.ssid,
                havePass
                    ? passwordAPController.text
                    : wifiFilteredList.password,
                havePass: true)
            .then((connectingResult) async {
          if (connectingResult == true) {
            Constants.pwdESP = "";
            Constants.usernameESP = wifiFilteredList.ssid;
            if (Constants.setOnline) {
              await Navigator.of(context).pushNamedAndRemoveUntil(
                "/wifiConnect",
                (Route<dynamic> route) => false,
              );
              return true;
            } else {
              progressDialog.show();
              await httpRequestPost(postUrl: "http://192.168.1.210", body: "{}")
                  .catchError((e) {
                printF(text: "$e inja 1");
                progressDialog.dismiss();
              }).then((value) {
                if (isOffline) {
                  Constants.usernameESP = wifiFilteredList.ssid;
                  Constants.pwdESP = havePass
                      ? passwordAPController.text
                      : wifiFilteredList.password;
                  Constants.itemList = {"10001": jsonDecode(value.data)};
                  Constants.itemListCurrentPage = jsonDecode(
                      Constants.itemList["10001"]["Device_Relay_Status"]);
                  Constants.timerData["10001"] = jsonDecode(
                      Constants.itemList["10001"]["Device_Relay_Timer"]);
                  Constants.appBarCardListLength = 1;
                  Constants.appbarMenuPosation = 0;
                  progressDialog.dismiss();
                  if (value.statusCode == 200) {
                    Constants.isOnline = 'false';
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/home",
                      (Route<dynamic> route) => false,
                    );
                    Constants.deviceWifiList.put(
                      wifiFilteredList.ssid,
                      WifiData(
                        capabilities: wifiFilteredList.capabilities,
                        password: havePass
                            ? passwordAPController.text
                            : wifiFilteredList.password,
                        ssid: wifiFilteredList.ssid,
                      ),
                    );
                  }
                }
              });
              return false;
            }
          }
          return false;
        });
      } catch (e) {
        WiFiForIoTPlugin.forceWifiUsage(false);
        return false;
      }
    }

    Future<void> initWifi(String text, String pass) async {
      if (text.trim().length > 3 && pass.trim().length > 7) {
        ProgressDialog progressDialog = ProgressDialog(context,
            message: const Text("در انجام عملیات"),
            title: const Text("در حال تنظیم دستگاه لطفا منتظر بمانید"));
        Map temp = {};
        temp["ap_ssid"] = text.trim().endsWith("_Asatic")
            ? text.trim()
            : "${text.trim()}_Asatic";
        temp["ap_password"] = pass.trim();
        temp["time"] =
            ("${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}-${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}-${Jalali.now().weekDay}");
        temp["event"] = "ap_set";

        Response requestToDevice = await httpRequestPost(
                postUrl: "http://192.168.1.210/init", body: temp)
            .whenComplete(() {
          Navigator.of(context).pop();
          progressDialog.show();
          Future.delayed(const Duration(seconds: 15)).then((v) {
            progressDialog.dismiss();
          });
        });
        if (requestToDevice.statusCode == 200) {
          Constants.deviceWifiList.put(
            temp["ap_ssid"],
            WifiData(
              capabilities: "[WPA]",
              password: temp["ap_password"] ?? "",
              ssid: temp["ap_ssid"] ?? "",
            ),
          );
        }
        temp.clear();
      } else {
        displaySnackBar(context,
            message:
                'باید نام بیشتر از 4 کاراکتر و پسورد بیشتر از 8 کاراکتر باشد');
      }
    }

    Future<void> apSettings(BuildContext context, TextEditingController? ssid,
        TextEditingController? pass) async {
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
                              child: Text("رمز عبور",
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
                        controller: ssid,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(Constants.regexValidator)),
                        ],
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
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(Constants.regexValidator)),
                          ],
                          keyboardType: TextInputType.text,
                          maxLength: 32,
                          enableInteractiveSelection: false,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder())),
                    ),
                  ),
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
            onPressed: () async => initWifi(ssid!.text, pass!.text),
          ),
          MaterialButton(
            child: Text("لغو",
                textDirection: TextDirection.rtl,
                style: textStyler(color: Constants.themeLight)),
            onPressed: () {
              WiFiForIoTPlugin.forceWifiUsage(false)
                  .then((v) => WiFiForIoTPlugin.disconnect());

              ssid!.clear();
              pass!.clear();
              Navigator.of(context).pop();
            },
          )
        ],
      ).show(context);
    }

    Future<void> connectingDialog(BuildContext context,
        TextEditingController? pass, var wifiFilteredList) async {
      NAlertDialog(
        title: Text("اتصال به شبکه ${wifiFilteredList.ssid}",
            textDirection: TextDirection.rtl,
            style: textStyler(color: Constants.themeLight)),
        content: SizedBox(
          height: 0.15.sh,
          child: Column(
            children: [
              SizedBox(
                  height: 0.15.sh / 2,
                  child: const Center(
                      child: Text("رمز شبکه", textAlign: TextAlign.center))),
              SizedBox(
                width: 0.5.sw,
                height: 0.15.sh / 2,
                child: TextField(
                  controller: pass,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(Constants.regexValidator)),
                  ],
                  keyboardType: TextInputType.text,
                  maxLength: 32,
                  enableInteractiveSelection: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
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
              await sendMethod(
                      wifiFilteredList, !(Constants.isOnline == 'true'), true)
                  .whenComplete(() async {
                if (Constants.isOnline == 'true') {
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      "/wifiConnect", ModalRoute.withName("/add_device"));
                }
              });
            },
          ),
          MaterialButton(
            child: Text("لغو",
                textDirection: TextDirection.rtl,
                style: textStyler(color: Constants.themeLight)),
            onPressed: () {
              WiFiForIoTPlugin.forceWifiUsage(false)
                  .then((v) => WiFiForIoTPlugin.disconnect());

              Navigator.of(context).pop();
            },
          )
        ],
      ).show(context);
    }

    return InkWell(
      onLongPress: () {
        if (wifiFilteredList.password.length > 6) {
          NDialog(
            title: Text(
              'فراموشی وای فای',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.r),
            ),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "خیر",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16.r),
                  )),
              InkWell(
                  onTap: () {
                    Constants.deviceWifiList.delete(
                      wifiFilteredList.ssid,
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.greenAccent,
                    child: Text(
                      "بله",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16.r),
                    ),
                  )),
            ],
            content: SizedBox(
              width: 0.55.sw,
              height: 0.07.sh,
              child: Column(
                children: [
                  Text(
                    'آیا اطمینان دارید؟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16.r),
                  ),
                ],
              ),
            ),
          ).show(context);
        }
      },
      onTap: () async {
        if (wifiFilteredList.password.length > 6) {
          await sendMethod(
                  wifiFilteredList, !(Constants.isOnline == 'true'), false)
              .then(
            (value) async {
              if (Constants.isOnline == 'true') {
                if (value) {
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      "/wifiConnect", ModalRoute.withName("/add_device"));
                }
              }
            },
          );
        } else {
          if (wifiFilteredList.capabilities != "[ESS]") {
            await connectingDialog(
                context, passwordAPController, wifiFilteredList);
          } else {
            ProgressDialog progressDialog = ProgressDialog(context,
                message: const Text("در حال اتصال"),
                title: const Text(
                    "در حال بررسی اتصال به دستگاه لطفا منتظر بمانید"));
            await wifiConnectiongMethod(wifiFilteredList.ssid, '',
                    havePass: false)
                .then((value) async {
              if (value == true) {
                Constants.pwdESP = "";
                Constants.usernameESP = wifiFilteredList.ssid;
                if (Constants.setOnline) {
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      "/wifiConnect", ModalRoute.withName("/add_device"));
                } else {
                  await apSettings(
                      context, ssidAPController, passwordAPController);
                }
              }
            });

            await Future.delayed(const Duration(milliseconds: 300));

            progressDialog.dismiss();
          }
        }
        //--
      },
      child: Container(
        color: Constants.secondryDarkCol,
        alignment: Alignment.center,
        child: Text(wifiFilteredList.ssid.toString(),
            style: textStyler(color: Constants.themeLight)),
      ),
    );
  }
}
