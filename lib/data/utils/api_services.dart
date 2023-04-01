import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asatic/data/utils/printf.dart';
import '../../presentation/cubit/button_data_cubit.dart';
import 'app_constants.dart';
import 'functions_helper.dart';
import 'server_constants.dart';

class ApiServices {
// initial app with initialize data

  // Stream streamPingPong(BuildContext context) async* {
  //   while (true) {
  //     await Future.delayed(const Duration(seconds: 5)).whenComplete(() {
  //       Constants.channel.sink.add("ping");

  //       Constants.channel.stream.handleError((err) =>
  //           ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(content: Text("DoneeeeHandleErr"))));
  //     });
  //   }
  // }

  void socketFunc(BuildContext context, dynamic event) async {
    try {
      if (event != "pong") {
        if (event.toString().length > 10) {
          Map<String, dynamic> eventJson = jsonDecode(event);
          Map<String, dynamic>? eventMessageJson;
          if (eventJson["Event"] != "SENSOR") {
            eventMessageJson = jsonDecode(eventJson["Message"]);
          }
          switch (eventJson["Event"]) {
            case "initsocket":
              Map jsonResp = eventMessageJson!;
              Constants.appBarCardListLength = jsonResp.keys.length;
              Constants.itemList = jsonResp;
              Constants.itemListCurrentPage = jsonDecode(Constants.itemList[
                          Constants.itemList.keys
                                  .toList()[Constants.deviceSelectedIndex] ??
                              ""]["device_Relay_Status"] ??
                      "{}") ??
                  "";
              jsonResp.forEach((key, value) {
                Constants.timerData[key] =
                    jsonDecode(jsonResp[key]["device_Relay_Timer"] ?? "{}");
              });
              await BlocProvider.of<ButtonDataCubit>(context)
                  .getAllDevicesData(context, true, isHttpMode: false);
              break;
            case "UPDATE":
              BlocProvider.of<ButtonDataCubit>(context).streamStatusItemList(
                  currentStatus: eventMessageJson!["Device_Relay_Status"],
                  itemCount: eventMessageJson["Chanel_Count"],
                  remote: eventMessageJson["Remote"],
                  nameTag: eventMessageJson["ST"] == "device"
                      ? Constants
                              .itemList[eventMessageJson["DeviceID"].toString()]
                          ["Tag"]
                      : eventMessageJson["Tag"] ??
                          "دستگاه ${Constants.appbarMenuPosation + 1}",
                  sensorData: eventMessageJson["Sensor"] ?? "{}",
                  pos: eventMessageJson["DeviceID"].toString(),
                  isActived: eventMessageJson["Status_Conect"]);
              break;
            case "UPDATE_DEVICE":
              BlocProvider.of<ButtonDataCubit>(context).streamStatusItemList(
                  currentStatus: eventMessageJson!["Device_Relay_Status"],
                  itemCount: eventMessageJson["Chanel_Count"],
                  remote: eventMessageJson["Remote"],
                  nameTag: eventMessageJson["ST"] == "device"
                      ? Constants
                              .itemList[eventMessageJson["DeviceID"].toString()]
                          ["Tag"]
                      : eventMessageJson["Tag"] ??
                          "دستگاه ${Constants.appbarMenuPosation + 1}",
                  sensorData: eventMessageJson["Sensor"] ?? "{}",
                  pos: eventMessageJson["DeviceID"].toString(),
                  isActived: eventMessageJson["Status_Conect"]);
              break;
            case "Delete_Device":
              Constants.itemList
                  .remove([eventMessageJson!["DeviceID"].toString()]);
              BlocProvider.of<ButtonDataCubit>(context).streamStatusItemList(
                  currentStatus: eventMessageJson["Device_Relay_Status"],
                  itemCount: eventMessageJson["Chanel_Count"],
                  remote: eventMessageJson["Remote"],
                  nameTag: eventMessageJson["ST"] == "device"
                      ? Constants
                              .itemList[eventMessageJson["DeviceID"].toString()]
                          ["Tag"]
                      : eventMessageJson["Tag"] ??
                          "دستگاه ${Constants.appbarMenuPosation + 1}",
                  sensorData: eventMessageJson["Sensor"] ?? "{}",
                  pos: eventMessageJson["DeviceID"].toString(),
                  isActived: eventMessageJson["Status_Conect"]);
              break;
            case "UPDATE_REMOTE":
              Constants.remoteList = jsonDecode(eventMessageJson!["Remote"]);
              if (Constants.remoteList.containsKey("count")) {
                Constants.remoteList.remove("count");
                Constants.remoteList.remove("name");
              }
              Constants.remoteList.forEach((key, value) {
                Constants.remoteList[key]["isEditing"] = false;
                if (Constants.editTextList.length <=
                    Constants.remoteList.length) {
                  Constants.editTextList.add(TextEditingController());
                }
              });

              BlocProvider.of<ButtonDataCubit>(context).streamStatusItemList(
                  currentStatus: eventMessageJson["Device_Relay_Status"],
                  itemCount: eventMessageJson["Chanel_Count"],
                  remote: eventMessageJson["Remote"],
                  nameTag: eventMessageJson["ST"] == "device"
                      ? Constants
                              .itemList[eventMessageJson["DeviceID"].toString()]
                          ["Tag"]
                      : eventMessageJson["Tag"] ??
                          "دستگاه ${Constants.appbarMenuPosation + 1}",
                  sensorData: eventMessageJson["Sensor"] ?? "{}",
                  pos: eventMessageJson["DeviceID"].toString(),
                  isActived: eventMessageJson["Status_Conect"]);
              break;
            case "ADD_REMOTE":
              break;
            case "status_connection":
              BlocProvider.of<ButtonDataCubit>(context)
                  .changeStatusConnectionStream(
                      pos: eventMessageJson!.keys.toList().first,
                      isActived: eventMessageJson[
                                  eventMessageJson.keys.toList().first] ==
                              "connect"
                          ? true
                          : false);
              break;
            case "SENSOR":
              BlocProvider.of<ButtonDataCubit>(context)
                  .sensorRTCStreamStream(eventJson);
              break;
            default:
              printF(text: "defualt");
          }
        }
      }
    } catch (_) {}
  }

// in method baraye eijad taghir dar database va set kardan current status ast
  Future updateDocument(int pos,
      {required String event,
      required bool isEvent,
      required String log,
      String url = "http://asatic.ir/api/Devices",
      var body,
      bool isTimer = false}) async {
    Map<String, dynamic> updateDeviceDataJson = {};
    if (isTimer == false) {
      updateDeviceDataJson =
          Constants.itemList[Constants.itemList.keys.toList()[pos]];
      updateDeviceDataJson["log"] = log;
      updateDeviceDataJson["user"] = updateDeviceDataJson["user"].toString();
      updateDeviceDataJson["phonenum"] = RestAPIConstants.phoneNumberID;
      updateDeviceDataJson["events"] = event;
      updateDeviceDataJson["chanel_Count"] = Constants
          .itemList[Constants.itemList.keys.toList()[pos]]["chanel_Count"];
      updateDeviceDataJson["tag"] =
          Constants.itemList[Constants.itemList.keys.toList()[pos]]["tag"];
      updateDeviceDataJson["event_change"] = false;
    } else {
      updateDeviceDataJson["id"] =
          int.parse(Constants.itemList.keys.toList()[pos]);
      updateDeviceDataJson["timer"] = jsonEncode(body);
    }
    httpRequestPut(putUrl: url, body: updateDeviceDataJson);
  }

// in method baraye daryaft data az database ast va dar akhar data ra set mikonad
  Future getAllDevicesDataMethod() async {
    try {
      await httpRequestGet(
              getUrl:
                  "${Constants.hostUrl}api/Devices/${RestAPIConstants.phoneNumberID}")
          .then((value) async {
        if (value.statusCode == 200) {
          Map jsonResp = value.data ?? "{}";
          if (jsonResp.keys.toList().isNotEmpty) {
            Constants.appBarCardListLength = jsonResp.keys.length;
            // Constants.bodyItemLength = jsonResp[jsonResp.keys.toList()[0] ?? ""]["chanel_Count"] ?? 0;
            Constants.itemList = jsonResp;
            if (Constants.itemList.isNotEmpty ||
                Constants.itemList.keys.toList().isNotEmpty) {
              Constants.appBarCardListLength = Constants.itemList.length;
              Constants.itemListCurrentPage = jsonDecode(Constants.itemList[
                          Constants.itemList.keys
                                  .toList()[Constants.deviceSelectedIndex] ??
                              ""]["device_Relay_Status"] ??
                      {}) ??
                  "";
              jsonResp.forEach((key, value) {
                Constants.timerData[key] =
                    jsonDecode(jsonResp[key]["device_Relay_Timer"] ?? "{}");
              });
            }
          }
        } else {
          printF(text: value.data);
        }
      }).catchError((onError) {
        Constants.logger.e(onError.toString());
      });
    } catch (e) {
      printF(text: "step10");
    }
  }

  //This function triggers the Sign-up and Sign-in
  Future accountSession(BuildContext context) async {
    try {
      printF(text: "Log-in method starting ...");
      return httpRequestPost(postUrl: "http://asatic.ir/api/Users", body: {
        "token": "mohsenandhamidandhadiandasakrobo",
        "PhoneNum": RestAPIConstants.phoneNumberID
      }).then((value) {
        if (value.statusCode == 200) {
          Constants.verifyCode = value.data.toString();
          Constants.jwtCode = value.headers.value("set-cookie").toString();
          value.headers.forEach((name, values) {});
          // Navigator.of(context).pushNamedAndRemoveUntil("/verifyCode", (Route<dynamic> route) => false);
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/verifyCode", ModalRoute.withName('/authentication'));
          printF(text: "code : $Constants.verifyCode");
          Constants.currentUserData.cookie = Constants.jwtCode;
          Constants.currentUserData.phoneNum = RestAPIConstants.phoneNumberID;
        }
      });
    } catch (_) {
      printF(text: "step12");
    }
  }

  //This function triggers the Log-out
  // Future logOutAccount({required BuildContext context}) async {}

  //This function triggers the Log-out
  // Future deleteAccount({required BuildContext context}) async {}
}
