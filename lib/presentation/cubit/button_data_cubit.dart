import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../data/utils/api_services.dart';
import '../../data/utils/app_constants.dart';
import '../../data/utils/functions_helper.dart';
import '../../data/utils/printf.dart';
import '../../data/utils/server_constants.dart';

part 'button_data_state.dart';

class ButtonDataCubit extends Cubit<ButtonDataState> {
  ButtonDataCubit()
      : super(ButtonDataState(
            isLoading: false, status: {}, appbarItemLength: 0, actived: false));
//change Status Button with button
  Future<void> changeStatusButton(
      {int appbarPos = 0, int itemPos = 0, bool doChange = true}) async {
    try {
      if (Constants.isOnline == 'true') {
        loadingSet();
        if (doChange) {
          Constants.itemListCurrentPage[(itemPos + 1).toString()]["status"] =
              !(Constants.itemListCurrentPage[(itemPos + 1).toString()]
                  ["status"]);
        }
        Constants.itemList[Constants.itemList.keys.toList()[appbarPos]]
            ["device_Relay_Status"] = jsonEncode(Constants.itemListCurrentPage);

        await ApiServices()
            .updateDocument(
              appbarPos,
              log:
                  """{"e":"UPDATE","r":${itemPos + 1},"t":${RestAPIConstants.phoneNumberID},"s":${Constants.itemListCurrentPage[(itemPos + 1).toString()]["status"] == true ? 1 : 0}}""",
              event: "UPDATE",
              url: !(Constants.isOnline == 'true')
                  ? "http://192.168.1.210"
                  : "http://asatic.ir/api/Devices",
              isEvent: false,
            )
            .then((value) async {
              // Constants.buttonLoading = false;
            })
            .timeout(Constants.timeOutDuration)
            .catchError((e) {
              Constants.logger.e(e.toString());
            });
      } else {
        loadingSet();
        if (doChange) {
          Constants.itemListCurrentPage[(itemPos + 1).toString()]["status"] =
              !(Constants.itemListCurrentPage[(itemPos + 1).toString()]
                  ["status"]);
        }
        Constants.itemList[Constants.itemList.keys.toList()[appbarPos]]
            ["Device_Relay_Status"] = jsonEncode(Constants.itemListCurrentPage);
        Map<String, String> sendButtonOffline = {};
        String msg = jsonEncode(
            (Constants.itemList[Constants.itemList.keys.first]) ?? "{}");
        sendButtonOffline.addAll({
          "Message": msg,
          "Event": "UPDATE",
        });
        await httpRequestPost(
                postUrl: "http://192.168.1.210/", body: sendButtonOffline)
            .then((value) {
          if (value.statusCode == 200) {
            emit(
              ButtonDataState(
                  currentPageStatus: Constants.itemListCurrentPage,
                  status: {"10001": jsonDecode(value.data)}),
            );
          }
        });
      }
    } catch (_) {
      // Constants.buttonLoading = false;
      //
    }
  }

  Future<void> changeStatus(
      {int appbarPos = 0,
      required String event,
      required String log,
      required bool isEvent}) async {
    loadingSet();
    try {
      if (Constants.isOnline == 'true') {
        await ApiServices()
            .updateDocument(appbarPos,
                event: event,
                url: Constants.isOnline == 'true'
                    ? "http://asatic.ir/api/Devices"
                    : "http://192.168.1.210",
                log: log,
                isEvent: isEvent)
            .timeout(Constants.timeOutDuration)
            .catchError((e) {
          Constants.logger.e(e.toString());
        });
      } else {
        String msg = "";
        if (event == "Sensor_Data") {
          msg = jsonEncode({"Sensor": jsonEncode(Constants.sensorData)});
        } else if (event == "UPDATE_REMOTE") {
          msg = jsonEncode({
            "Remote": Constants.itemList[Constants.itemList.keys.first]
                ["remote"]
          });
        }
        await httpRequestPost(
          postUrl: Constants.hostUrl,
          body: {
            "Event": event,
            "Message": msg,
          },
        );
      }
    } catch (_) {}
  }

  Future<void> changeTimers(
      {int appbarPos = 0,
      required String event,
      required bool isEvent,
      required String log,
      required var timerData}) async {
    try {
      Future.delayed(const Duration(seconds: 1)).whenComplete(() async {
        await ApiServices()
            .updateDocument(appbarPos,
                log: log,
                event: event,
                isEvent: isEvent,
                body: timerData,
                url: !(Constants.isOnline == 'true')
                    ? "http://192.168.1.210"
                    : "${Constants.hostUrl}api/Devices/updatetimermobile",
                isTimer: true)
            .timeout(Constants.timeOutDuration)
            .catchError((e) {
          Constants.logger.e(e.toString());
        });
      });
    } catch (_) {}
  }

  void updateRemotes({int devicePos = 0}) async {
    try {
      // .whenComplete(() => emit(ButtonDataState(isLoading: false))));
    } catch (_) {}
  }

  fetchingDataLateLoading() {
    emit(
      ButtonDataState(
          status: Constants.itemListCurrentPage,
          appbarItemLength: Constants.appBarCardListLength),
    );
  }

  //
  Future getAllDevicesData(BuildContext context, bool justGet,
      {bool isHttpMode = true}) async {
    try {
      Future<ConnectivityResult> connectivityResult =
          Connectivity().checkConnectivity();
      await connectivityResult.then((connectivity) async {
        if (connectivity != ConnectivityResult.none) {
          if (isHttpMode) {
            Future<bool> result = InternetConnectionChecker().hasConnection;
            await result.then((value) async {
              if (value) {
                await ApiServices().getAllDevicesDataMethod().then((value) {
                  emit(
                    ButtonDataState(
                        status: Constants.itemList,
                        appbarItemLength: Constants.appBarCardListLength),
                  );
                  if (!justGet) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/home", (Route<dynamic> route) => false);
                  }
                });
              } else {
                displaySnackBar(context,
                    message: 'دسترسی به اینترنت موجود نیست');
              }
            });
          }
        } else {
          displaySnackBar(context, message: 'اتصال اینترنت خود را بررسی کنید');
        }
      });
      if (justGet == false) {
        if (Constants.itemList.isNotEmpty &&
            Constants.itemList.keys.toList().isNotEmpty) {
          Constants.itemList.forEach((key, value) {
            if (value["user"] == RestAPIConstants.phoneNumberID &&
                (!Constants.devicesListitems.contains(key))) {
              Constants.devicesListitems.add(key);
            }
          });
        }
      }
    } catch (e) {
      emit(ButtonDataState(
          status: Constants.itemListCurrentPage,
          appbarItemLength: Constants.appBarCardListLength));
    }
  }

  //
  void setTimerState(
    BuildContext context,
    int type, {
    bool isFirst = false,
    String relayPos = "",
    String timerPos = "",
    int devicePos = 0,
    int dayPos = 0,
    String label = "",
    DateTime? corno,
    required Jalali picked,
    required TimeOfDay time,
    Map dataJson = const {},
    String value = "",
    String mode = "",
    bool val = false,
  }) async {
    try {
      switch (type) {
        case 6:
          Constants.timerData[Constants.itemList.keys
                  .toList()[Constants.appbarMenuPosation]][relayPos]
              .remove(timerPos);
          break;
        case 7:
          if (Constants.timerData.keys.toList().contains(
              Constants.itemList.keys.toList()[Constants.appbarMenuPosation])) {
            if (Constants
                .timerData[Constants.itemList.keys
                    .toList()[Constants.appbarMenuPosation]]
                .keys
                .toList()
                .contains(relayPos)) {
              if (Constants
                  .timerData[Constants.itemList.keys
                      .toList()[Constants.appbarMenuPosation]][relayPos]
                  .isNotEmpty) {
                bool repeat = false;
                Constants
                    .timerData[Constants.itemList.keys
                        .toList()[Constants.appbarMenuPosation]][relayPos]
                    .values
                    .forEach((element) {
                  if (element.toString() == dataJson.toString()) {
                    repeat = true;
                  }
                });
                if (repeat == false || Constants.timerConfigPos != "new") {
                  if (Constants.timerConfigPos == "new") {
                    Constants.timerData[Constants.itemList.keys
                            .toList()[Constants.appbarMenuPosation]]
                        [relayPos][(int.parse(Constants
                                .timerData[Constants.itemList.keys
                                        .toList()[Constants.appbarMenuPosation]]
                                    [relayPos]
                                .keys
                                .toList()
                                .last) +
                            1)
                        .toString()] = dataJson;
                  } else {
                    Constants.timerData[Constants.itemList.keys
                            .toList()[Constants.appbarMenuPosation]][relayPos]
                        [Constants.timerConfigPos] = dataJson;
                  }
                } else {
                  displaySnackBar(context, message: 'این تایمر قبلا وجود داشت');
                }
              } else {
                Constants.timerData[Constants.itemList.keys
                        .toList()[Constants.appbarMenuPosation]]
                    [relayPos] = {"0": {}};
                Constants.timerData[Constants.itemList.keys
                        .toList()[Constants.appbarMenuPosation]][relayPos]
                    ["0"] = dataJson;
              }
            } else {
              Constants.timerData[Constants.itemList.keys
                  .toList()[Constants.appbarMenuPosation]][relayPos] = {};
              if (Constants
                  .timerData[Constants.itemList.keys
                      .toList()[Constants.appbarMenuPosation]][relayPos]
                  .isNotEmpty) {
                Constants.timerData[Constants.itemList.keys
                        .toList()[Constants.appbarMenuPosation]]
                    [relayPos][(Constants
                        .timerData[Constants.itemList.keys
                            .toList()[Constants.appbarMenuPosation]][relayPos]
                        .length)
                    .toString()] = dataJson;
              } else {
                Constants.timerData[Constants.itemList.keys
                        .toList()[Constants.appbarMenuPosation]]
                    [relayPos] = {"0": {}};
                Constants.timerData[Constants.itemList.keys
                        .toList()[Constants.appbarMenuPosation]][relayPos]
                    ["0"] = dataJson;
              }
            }
          } else {
            Constants.timerData[Constants.itemList.keys
                .toList()[Constants.appbarMenuPosation]] = {};
            Constants.timerData[Constants.itemList.keys
                    .toList()[Constants.appbarMenuPosation]]
                [relayPos] = {"0": dataJson};
          }
          break;
        default:
      }
      emit(
        ButtonDataState(
            status: Constants.itemListCurrentPage,
            appbarItemLength: Constants.appBarCardListLength),
      );
      await Future.delayed(const Duration(milliseconds: 200));
      Constants.itemList[Constants.itemList.keys.toList()[devicePos]][
              Constants.isOnline == 'true'
                  ? "device_Relay_Status"
                  : "Device_Relay_Status"] =
          jsonEncode(Constants.itemListCurrentPage);
      emit(
        ButtonDataState(
            status: Constants.itemListCurrentPage,
            appbarItemLength: Constants.appBarCardListLength),
      );
    } catch (e) {
      emit(ButtonDataState(
          status: Constants.itemListCurrentPage,
          appbarItemLength: Constants.appBarCardListLength));
    }
  }

// in method baraye taghir dar json koli ke daryaft mikonim

  void streamStatusItemList(
      {String currentStatus = "",
      String pos = "",
      int itemCount = 0,
      String remote = "",
      bool isActived = false,
      String? nameTag,
      String sensorData = "{}"}) async {
    try {
      Constants.itemList[pos]["device_Relay_Status"] = currentStatus;
      Constants.itemList[pos]["remote"] = remote;
      Constants.itemList[pos]["chanel_Count"] = itemCount;
      Constants.itemList[pos]["sensor"] = sensorData;
      Constants.itemList[pos]["tag"] =
          nameTag ?? "دستگاه ${Constants.appbarMenuPosation + 1}";
      if (Constants.appBarCardListLength != Constants.itemList.keys.length) {
        Constants.appBarCardListLength = Constants.itemList.keys.length;
      }
      emit(ButtonDataState(
          logData: state.logData,
          status:
              jsonDecode(Constants.itemList[pos]["device_Relay_Status"]) ?? "",
          appbarItemLength: Constants.itemList.keys.length));
      Future.delayed(Constants.loadingDuration).whenComplete(
        () => emit(
          ButtonDataState(
              logData: state.logData,
              status:
                  jsonDecode(Constants.itemList[pos]["device_Relay_Status"]) ??
                      "",
              appbarItemLength: Constants.itemList.keys.length),
        ),
      );
    } catch (_) {
      printF(text: "error  stream changeStatusStream cubit");
      emit(ButtonDataState(
          logData: state.logData,
          status:
              jsonDecode(Constants.itemList[pos]["device_Relay_Status"]) ?? "",
          appbarItemLength: Constants.itemList.keys.length));
    }
  }

  //---

  void changeStatusConnectionStream(
      {String pos = "", bool isActived = false}) async {
    try {
      emit(
        ButtonDataState(
          actived: isActived,
          appbarItemLength: Constants.itemList.keys.length,
        ),
      );

      Constants.itemList[pos]["status_Conect"] = isActived;
      emit(
        ButtonDataState(
          actived: isActived,
          appbarItemLength: Constants.itemList.keys.length,
        ),
      );
    } catch (e) {
      emit(
        ButtonDataState(
          actived: isActived,
          appbarItemLength: Constants.itemList.keys.length,
        ),
      );
    }
  }

  void sensorRTCStreamStream(Map<String, dynamic> dataSensor) async {
    try {
      List<dynamic> temp = state.logData;
      Constants.sensorSocketData[dataSensor["Sender"].toString()] =
          jsonDecode(dataSensor["Message"]);
      emit(ButtonDataState(
          currentSensorData: jsonDecode(dataSensor["Message"]), logData: temp));
    } catch (e) {
      emit(ButtonDataState(
          currentSensorData: jsonDecode(dataSensor["Message"])));
    }
  }

  void changeStatusInEachPage({int posation = 0}) async {
    try {
      Constants.appbarMenuPosation = posation;
      Constants.itemListCurrentPage = jsonDecode(
              Constants.itemList[Constants.itemList.keys.toList()[posation]][
                  Constants.isOnline == 'true'
                      ? "device_Relay_Status"
                      : "Device_Relay_Status"]) ??
          {};
      emit(ButtonDataState(currentPageStatus: Constants.itemListCurrentPage));
      state.currentPageStatus = Constants.itemListCurrentPage;
      Constants.appbarMenuPosation = posation;
      Future.delayed(Constants.loadingDuration).whenComplete(() => emit(
          ButtonDataState(currentPageStatus: Constants.itemListCurrentPage)));
    } catch (_) {
      printF(text: "error  stream changeStatusInEachPage cubit");
      emit(ButtonDataState(currentPageStatus: Constants.itemListCurrentPage));
    }
  }

  void loggerConfig(Jalali picked, Jalali startFilter, DateTime end, List logs,
      int type) async {
    try {
      emit(ButtonDataState(logData: []));
      if (type == 1) {
        if (picked.toDateTime().isBefore(end)) {
          Constants.filteredLogs.clear();
          logs.toList().forEach((element) {
            DateTime thisElement = DateTime.parse(element["time"]);

            if (thisElement.isBefore(end) &&
                thisElement.isAfter(startFilter.toDateTime())) {
              Constants.filteredLogs.add(element);
            }
          });
        }
      } else if (type == 2) {
        if (picked.toDateTime().isAfter(startFilter.toDateTime())) {
          Constants.filteredLogs.clear();
          logs.toList().forEach((element) {
            DateTime thisElement = DateTime.parse(element["time"]);

            if (thisElement.isBefore(end) &&
                thisElement.isAfter(startFilter.toDateTime())) {
              Constants.filteredLogs.add(element);
            }
          });
        }
      } else {
        Constants.filteredLogs.clear();
        logs.toList().forEach((element) {
          DateTime thisElement = DateTime.parse(element["time"]);
          if (thisElement.isAfter(startFilter.toDateTime())) {
            Constants.filteredLogs.add(element);
          }
        });
      }
      emit(ButtonDataState(logData: Constants.filteredLogs));
    } catch (_) {
      printF(text: "error  Logger cubit");
    }
  }

  //
  void activeAccount(bool actived) async {
    try {
      emit(ButtonDataState(actived: true));
    } catch (_) {
      printF(text: "error  stream changeStatusStream cubit");
      emit(ButtonDataState(actived: true));
    }
  }

  //
  void loadingSet({bool actived = false}) async {
    try {
      emit(ButtonDataState(isLoading: true));
      Future.delayed(const Duration(seconds: 5))
          .then((value) => emit(ButtonDataState(isLoading: false)));
    } catch (_) {
      printF(text: "set loading have err");
    }
  }

  //
  Future<void> deleteDevice(int pos) async {
    try {
      emit(
        ButtonDataState(
            appbarItemLength: Constants.appBarCardListLength,
            status: Constants.itemList),
      );
      await httpRequestDelete(
              body: {},
              deleteUrl:
                  "${Constants.hostUrl}api/Devices/${Constants.itemList.keys.toList()[pos]}")
          .then((value) {
        if (value.statusCode == 201) {
          Constants.appBarCardListLength = Constants.appBarCardListLength - 1;
          Constants.itemList.remove(Constants.itemList.keys.toList()[pos]);
          emit(
            ButtonDataState(
                appbarItemLength: Constants.appBarCardListLength,
                status: Constants.itemList),
          );
        }
      });
    } catch (_) {
      printF(text: "set loading have err");
    }
  }

  void connectingToOnline() async {
    try {
      Constants.isOnline = 'true';
      Constants.itemList.clear();
      Constants.itemListCurrentPage.clear();
      Constants.appBarCardListLength = 0;
      emit(ButtonDataState(
          currentPageStatus: Constants.itemListCurrentPage,
          appbarItemLength: Constants.appBarCardListLength,
          status: Constants.itemList));
    } catch (_) {
      printF(text: "set online have err");
    }
  }

  Future<void> userManagment(
      List<Map<String, dynamic>> users, int pos, bool creating,
      {Map<String, dynamic> user = const {}}) async {
    try {
      int mainPos = 0;
      if (creating) {
        Constants.userManageList.insert(0, user);
      }
      mainPos = Constants.userManageList.indexOf(user);
      if (!creating) {
        await httpRequestPut(
            body: Constants.userManageList[mainPos],
            putUrl: '${Constants.hostUrl}api/UManage');
      } else {
        await httpRequestPost(
            body: [Constants.userManageList[mainPos]],
            postUrl: '${Constants.hostUrl}api/UManage');
      }
      emit(ButtonDataState(
        userManageList: Constants.userManageList,
      ));
    } catch (_) {}
  }
}
