import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:convert' as convert;

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../../data/utils/printf.dart';
import '../../../data/utils/server_constants.dart';
import '../../../data/utils/text_field_component.dart';
import '../../cubit/button_data_cubit.dart';

class WifiConnected extends StatefulWidget {
  final String ssid;
  final String pwd;

  const WifiConnected({this.ssid = "", this.pwd = "", Key? key})
      : super(key: key);

  @override
  State<WifiConnected> createState() => _WifiConnectedState();
}

class _WifiConnectedState extends State<WifiConnected> {
  final TextEditingController _routerUser = TextEditingController();
  final TextEditingController _routerPass = TextEditingController();

  Future<bool> connectingToWifi() async {
    if (await WiFiForIoTPlugin.isConnected()) {
      if (await WiFiForIoTPlugin.getSSID() == Constants.usernameESP) {
        return true;
      } else {
        await WiFiForIoTPlugin.disconnect();
        if (!await WiFiForIoTPlugin.isRegisteredWifiNetwork(widget.ssid)) {
          await WiFiForIoTPlugin.registerWifiNetwork(widget.ssid);
        }
        return await WiFiForIoTPlugin.connect(widget.ssid,
            password: widget.pwd,
            timeoutInSeconds: 7,
            security: NetworkSecurity.WPA,
            joinOnce: false,
            withInternet: false);
      }
    } else {
      return await WiFiForIoTPlugin.connect(widget.ssid,
          password: widget.pwd,
          timeoutInSeconds: 7,
          security: NetworkSecurity.WPA,
          joinOnce: false,
          withInternet: false);
    }
  }

  @override
  void dispose() {
    _routerPass.dispose();
    _routerUser.dispose();

    WiFiForIoTPlugin.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      backgroundColor: Constants.secondryDarkCol,
      child: SizedBox(
        width: getSize(context, isWidth: true),
        height: getSize(context, isWidth: false),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        try {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/home", (Route<dynamic> route) => false);
                        } catch (e) {
                          printF(text: e.toString());
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded,
                          color: Constants.themeLight))),
              SizedBox(
                width: getSize(context, isWidth: true)! / 1.2,
                height: getSize(context, isWidth: false)! / 4,
                child: Center(
                  child: Text(
                    "برای اتصال پریز به مودم لطفا نام و رمزعبور مودم خود را در کادرهای زیر وارد کنید",
                    style:
                        textStyler(color: Constants.themeLight, fontsize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              _textFieldContainer(context, _routerUser, "نام مودم"),
              const SizedBox(height: 20),
              _textFieldContainer(context, _routerPass, "رمز عبور"),
              const SizedBox(height: 50),
              InkWell(
                onTap: () async {
                  // if (Constants.isOnline) {
                  try {
                    await connectingToWifi().then((value) async {
                      ProgressDialog progressDialog = ProgressDialog(context,
                          message: const Text("منتظر بمانید"),
                          title: const Text(
                              "منتظر اتصال به اینترنت اگر بعد از 5 ثانیه متصل نشد به صورت دستی به اینترنت متصل شوید"));

                      if (value) {
                        progressDialog.setTitle(const Text("منتظر بمانید"));
                        progressDialog.setMessage(const Text(
                            "منتظر اتصال به اینترنت اگر بعد از 20 ثانیه متصل نشد به صورت دستی به اینترنت متصل شوید"));
                        progressDialog.show();
                        await localWSClient(
                                user: _routerUser.text, pass: _routerPass.text)
                            .whenComplete(() async {
                          await WiFiForIoTPlugin.forceWifiUsage(false);
                          await WiFiForIoTPlugin.disconnect();
                          if (value == true) {
                            await Future.delayed(const Duration(seconds: 8));
                            for (var i = 0; i < 10; i++) {
                              await Future.delayed(const Duration(seconds: 1));
                              if (!await InternetConnectionChecker()
                                      .hasConnection &&
                                  i == 10) {
                                progressDialog
                                    .setTitle(const Text("اتصال انجام نشد"));
                                progressDialog.setMessage(const Text(
                                    "اگر به مدت 5 ثانیه دیگر به اینترنت متصل نشود برنامه بسته میشود"));
                              }

                              var connectivityResult =
                                  await (Connectivity().checkConnectivity());
                              if (connectivityResult !=
                                  ConnectivityResult.none) {
                                i = 9;
                                Constants.isOnline = 'true';
                                await Future.delayed(const Duration(seconds: 3))
                                    .then((value) async =>
                                        await BlocProvider.of<ButtonDataCubit>(
                                                context)
                                            .getAllDevicesData(context, false));
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                progressDialog.dismiss();
                              }
                              if (i == 9) {
                                progressDialog.dismiss();
                              }
                            }
                          }
                        });
                      }
                      //
                    });
                  } catch (e) {
                    printF(text: e.toString());
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Constants.greenCol,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  width: 120,
                  height: getSize(context, isWidth: false)! / 18,
                  child: Text(
                    "ثبت",
                    style:
                        textStyler(color: Constants.themeLight, fontsize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _textFieldContainer(
      BuildContext context, TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          color: Constants.thirdryDarkCol,
          borderRadius: BorderRadius.circular(6)),
      width: getSize(context, isWidth: true)! / 1.5,
      height: getSize(context, isWidth: false)! / 15,
      child: customTextField(
          textAlign: TextAlign.center,
          isEnable: true,
          controller: controller,
          style: textStyler(color: Constants.themeLight),
          hintStyle: textStyler(color: Constants.themeLight.withOpacity(0.6)),
          obscureText: false,
          hintText: hint,
          textType: TextInputType.text,
          maxLength: 25),
    );
  }

  Map<String, dynamic> docJson = {};

  //
  Future<bool> localWSClient(
      {required String user, required String pass}) async {
    try {
      int countRelay = 0;
      // Map reciveJsonFromESP = {};
      Constants.usernameModem = user;
      Constants.pwdModem = pass;
      docJson["token"] = "mohsenandhamidandhadiandasakrobo";
      docJson["jwt"] = Constants.jwtCode;
      docJson["phonenum"] = RestAPIConstants.phoneNumberID.toString();
      docJson["username"] = user;
      docJson["password"] = pass;
      docJson["remote"] = "{\"count\":0}";
      docJson["makeDevice_link"] = "http://asatic.ir/api/Devices";
      docJson["server_ip"] = "asatic.ir";
      docJson["server_port"] = 80;
      docJson["recive_status"] = Constants.reciveStatus;
      docJson["database_socket"] = Constants.dataBaseSocket;
      docJson["update_doc_link"] = Constants.updateDocLink;
      docJson["event"] = "initonline";
      await WiFiForIoTPlugin.forceWifiUsage(true).then((value) async {
        if (countRelay == 4) {
          docJson["doc_devices_status"] = convert.jsonEncode({
            "1": {"status_button": false, "timer": []},
            "2": {"status_button": false, "timer": []},
            "3": {"status_button": false, "timer": []},
            "4": {"status_button": false, "timer": []},
            "channelCount": 4
          });
        } else if (countRelay == 2) {
          docJson["doc_devices_status"] = convert.jsonEncode({
            "1": {"status_button": false, "timer": []},
            "2": {"status_button": false, "timer": []},
            "channelCount": 2
          });
        } else {}
        await httpRequestPost(postUrl: 'http://192.168.1.210', body: docJson)
            .then((value) {
          if (value.statusCode == 200) {
            BlocProvider.of<ButtonDataCubit>(context).connectingToOnline();
          }
        });
      });
      return true;
    } catch (_) {
      WiFiForIoTPlugin.forceWifiUsage(false).whenComplete(
        () => WiFiForIoTPlugin.disconnect(),
      );
      return false;
    }
  }
}
