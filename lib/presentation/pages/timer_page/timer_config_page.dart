import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinner_picker/flutter_spinner_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:asatic/data/base_widget.dart';
import 'package:asatic/data/utils/app_constants.dart';
import 'package:asatic/data/utils/functions_helper.dart';
import 'package:asatic/data/utils/server_constants.dart';
import 'package:asatic/presentation/cubit/button_data_cubit.dart';

class TimerConfigPage extends StatefulWidget {
  const TimerConfigPage({Key? key}) : super(key: key);

  @override
  State<TimerConfigPage> createState() => _TimerConfigPageState();
}

class _TimerConfigPageState extends State<TimerConfigPage> {
  final TextEditingController descriptionController =
      TextEditingController(text: '');
  Map<String, dynamic> tempAlarm = const {};
  DateTime dateS = DateTime.now();
  DateTime dateE = DateTime.now();
  bool trueAlarmDate = false;
  String startDateLabel = "";
  String endDateLabel = "";
  @override
  void initState() {
    startDateLabel = "انتخاب کنید";
    endDateLabel = "انتخاب کنید";
    super.initState();
    if (Constants.timerConfigPos != "new") {
      tempAlarm = Constants.timerData[
              Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
          ["r${Constants.bodyItemPosation}"][Constants.timerConfigPos];
    } else {
      tempAlarm = {
        "mode": "date",
        "enable": true,
        "start": Jalali.now().toJalaliDateTime().substring(0, 10) +
            DateTime.now().toString().substring(10, 16),
        "end": Jalali.now().toJalaliDateTime().substring(0, 10) +
            DateTime.now().toString().substring(10, 16),
        "week": []
      };
    }
  }

  @override
  void dispose() {
    tempAlarm = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      backgroundColor: Constants.primeryDarkCol,
      child: Center(
        child: SizedBox(
          width: getSize(context, isWidth: true)! / 1.1,
          height: getSize(context, isWidth: false)! / 1.1,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.close,
                          color: Constants.greenCol,
                        ),
                      ),
                    ),
                    Text(
                      "تنظیم تایمر",
                      style: textStyler(
                        color: Constants.greenCol,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Constants.itemListCurrentPage[(Constants
                                .itemListCurrentPage.keys
                                .toList()[Constants.bodyItemPosation - 1])
                            .toString()]['rMode'] = 'T';
                        if (tempAlarm["mode"] != "week") {
                          tempAlarm.remove("week");
                        }
                        if (Constants.isOnline == 'false') {
                          await isNotConnectedToWifi().then((value) async {
                            if (value) {
                              await BlocProvider.of<ButtonDataCubit>(context)
                                  .changeStatusButton(
                                      appbarPos: (Constants.appbarMenuPosation),
                                      itemPos: (Constants.bodyItemPosation - 1));
                            }
                          });
                        } else {
                          await BlocProvider.of<ButtonDataCubit>(context)
                              .changeStatusButton(
                                  appbarPos: (Constants.appbarMenuPosation),
                                  itemPos: Constants.bodyItemPosation - 1)
                              .timeout(const Duration(seconds: 10));
                        }
                       
                        tempAlarm["start"] =
                            tempAlarm["start"].substring(0, 10) +
                                dateS.toString().substring(10, 16);
                        tempAlarm["end"] = tempAlarm["end"].substring(0, 10) +
                            dateE.toString().substring(10, 16);
                        //year condition
                        if (dateCompair(
                            startIndex: 0, endIndex: 4, tempAlarm: tempAlarm)) {
                          //mon condition
                          if (dateCompair(
                              startIndex: 5,
                              endIndex: 7,
                              tempAlarm: tempAlarm)) {
                            //day condition
                            if (dateCompair(
                                startIndex: 8,
                                endIndex: 10,
                                tempAlarm: tempAlarm)) {
                              //hour condition
                              if (dateCompair(
                                  startIndex: 11,
                                  endIndex: 13,
                                  tempAlarm: tempAlarm)) {
                                //min condition
                                if (dateCompair(
                                        startIndex: 14,
                                        endIndex: 16,
                                        isMin: true,
                                        tempAlarm: tempAlarm) ||
                                    dateCompair(
                                        startIndex: 0,
                                        endIndex: 4,
                                        isMin: true,
                                        tempAlarm: tempAlarm) ||
                                    dateCompair(
                                        startIndex: 5,
                                        endIndex: 7,
                                        isMin: true,
                                        tempAlarm: tempAlarm) ||
                                    dateCompair(
                                        startIndex: 8,
                                        endIndex: 10,
                                        isMin: true,
                                        tempAlarm: tempAlarm) ||
                                    dateCompair(
                                        startIndex: 11,
                                        endIndex: 13,
                                        isMin: true,
                                        tempAlarm: tempAlarm)) {
                                  BlocProvider.of<ButtonDataCubit>(context)
                                      .setTimerState(context, 7,
                                          picked: Jalali.now(),
                                          relayPos:
                                              "r${Constants.bodyItemPosation}",
                                          devicePos:
                                              Constants.appbarMenuPosation,
                                          time: TimeOfDay.now(),
                                          dataJson: tempAlarm,
                                          mode: "date");
                                  if (Constants.isOnline == 'true') {
                                    await BlocProvider.of<ButtonDataCubit>(context)
                                        .changeTimers(
                                            log:
                                                """{"e":"UPDATE_TIMER","r":${Constants.bodyItemPosation - 1},"t":${RestAPIConstants.phoneNumberID},"s":1}""",
                                            appbarPos:
                                                Constants.appbarMenuPosation,
                                            event: "UPDATE_TIMER",
                                            isEvent: false,
                                            timerData: Constants
                                                .timerData[Constants
                                                    .itemList.keys
                                                    .toList()[
                                                Constants.appbarMenuPosation]]);
                                  } else {
                                    await httpRequestPost(
                                        postUrl: Constants.hostUrl,
                                        body: {
                                          "Message": jsonEncode(Constants
                                              .timerData[Constants.itemList.keys
                                                  .toList()[
                                              Constants.appbarMenuPosation]]),
                                          "Event": "Updatetimer"
                                        });
                                  }

                                  Navigator.pop(context);
                                } else {
                                  displaySnackBar(context,
                                      message: 'در وارد کردن دقیقه دقت کنید');
                                }
                              } else {
                                displaySnackBar(context,
                                    message: 'در وارد کردن ساعت دقت کنید');
                              }
                            } else {
                              displaySnackBar(context,
                                  message: 'در وارد کردن روز دقت کنید');
                            }
                          } else {
                            displaySnackBar(context,
                                message: 'در وارد کردن ماه دقت کنید');
                          }
                        } else {
                          displaySnackBar(context,
                              message: 'در وارد کردن سال دقت کنید');
                        }
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.check,
                          color: Constants.greenCol,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "از ساعت",
                          style: textStyler(
                              color: Constants.themeLight, fontsize: 12),
                          textAlign: TextAlign.center,
                        ),
                        FlutterSpinner(
                          selectedDate: dateS,
                          is24Hour: true,
                          color: Colors.transparent,
                          height: 0.22.sh,
                          fontSize: 20,
                          selectedFontColor: Constants.greenCol,
                          unselectedFontColor:
                              Constants.themeLight.withOpacity(0.6),
                          width: 1.sw,
                          onTimeChange: (date) {
                            dateS = date;
                          },
                        ),
                        tempAlarm["mode"] == "date"
                            ? const SizedBox(
                                height: 15,
                              )
                            : Container(),
                        tempAlarm["mode"] == "date"
                            ? InkWell(
                                onTap: () async {
                                  Jalali? picked = await showPersianDatePicker(
                                    context: context,
                                    initialDate: Jalali.now(),
                                    firstDate: Jalali(1385, 8),
                                    lastDate: Jalali(1450, 9),
                                  );
                                  var label = picked!.formatFullDate();
                                  setState(() {
                                    startDateLabel = label;
                                    tempAlarm["start"] = picked
                                            .toJalaliDateTime()
                                            .substring(0, 10) +
                                        tempAlarm["start"]
                                            .toString()
                                            .substring(10, 16);
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      startDateLabel,
                                      style: textStyler(
                                          color: Constants.themeLight,
                                          fontsize: 16),
                                    ),
                                    const Icon(
                                        Icons.keyboard_arrow_left_rounded),
                                    Text(
                                      "در تاریخ",
                                      style: textStyler(
                                          color: Constants.themeLight,
                                          fontsize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        tempAlarm["mode"] == "date"
                            ? const SizedBox(height: 25)
                            : Container(),
                        Text(
                          "تا ساعت",
                          style: textStyler(
                              color: Constants.themeLight, fontsize: 12),
                          textAlign: TextAlign.center,
                        ),
                        FlutterSpinner(
                          selectedDate: dateE,
                          is24Hour: true,
                          color: Colors.transparent,
                          height: 0.22.sh,
                          fontSize: 20,
                          selectedFontColor: Constants.greenCol,
                          unselectedFontColor:
                              Constants.themeLight.withOpacity(0.6),
                          width: 1.sw,
                          onTimeChange: (date) {
                            dateE = date;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        tempAlarm["mode"] == "date"
                            ? InkWell(
                                onTap: () async {
                                  Jalali? picked = await showPersianDatePicker(
                                    context: context,
                                    initialDate: Jalali.now(),
                                    firstDate: Jalali(1385, 8),
                                    lastDate: Jalali(1450, 9),
                                  );
                                  var label = picked!.formatFullDate();
                                  setState(() {
                                    endDateLabel = label;
                                    tempAlarm["end"] = picked
                                            .toJalaliDateTime()
                                            .substring(0, 10) +
                                        tempAlarm["end"]
                                            .toString()
                                            .substring(10, 16);
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      endDateLabel,
                                      style: textStyler(
                                          color: Constants.themeLight,
                                          fontsize: 16),
                                    ),
                                    const Icon(
                                        Icons.keyboard_arrow_left_rounded),
                                    Text(
                                      "در تاریخ",
                                      style: textStyler(
                                          color: Constants.themeLight,
                                          fontsize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : tempAlarm["mode"] == "week"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _daysButtonMethod(context, 7, text: "ج"),
                                      Constants.widthSpace,
                                      _daysButtonMethod(context, 6,
                                          text: "پ ش"),
                                      Constants.widthSpace,
                                      _daysButtonMethod(context, 5,
                                          text: "چ ش"),
                                      Constants.widthSpace,
                                      _daysButtonMethod(context, 4,
                                          text: "س ش"),
                                      Constants.widthSpace,
                                      _daysButtonMethod(context, 3,
                                          text: "د ش"),
                                      Constants.widthSpace,
                                      _daysButtonMethod(context, 2,
                                          text: "ی ش"),
                                      Constants.widthSpace,
                                      _daysButtonMethod(context, 1, text: "ش"),
                                    ],
                                  )
                                : Container(),
                        const SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            String temp = tempAlarm["mode"];
                            context.showFlashDialog(
                                positiveActionBuilder:
                                    (context, controller, setStateIn) {
                                  return Center(
                                    child: SizedBox(
                                      width: getSize(context, isWidth: true)! /
                                          1.1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            right: 8,
                                            bottom: 8,
                                            top: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setStateIn(() {
                                                  temp = "none";
                                                });
                                              },
                                              child: SizedBox(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor: temp ==
                                                                  "none"
                                                              ? Constants
                                                                  .greenCol
                                                              : Constants
                                                                  .primeryDarkCol,
                                                        ),
                                                        const Text(
                                                          "یکبار",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setStateIn(() {
                                                  temp = "daily";
                                                });
                                              },
                                              child: SizedBox(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor: temp ==
                                                                  "daily"
                                                              ? Constants
                                                                  .greenCol
                                                              : Constants
                                                                  .primeryDarkCol,
                                                        ),
                                                        const Text(
                                                          "روزانه",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (!tempAlarm
                                                    .containsKey("week")) {
                                                  tempAlarm["week"] = [];
                                                }
                                                setStateIn(() {
                                                  temp = "week";
                                                });
                                              },
                                              child: SizedBox(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor: temp ==
                                                                  "week"
                                                              ? Constants
                                                                  .greenCol
                                                              : Constants
                                                                  .primeryDarkCol,
                                                        ),
                                                        const Text(
                                                          "هفتگی",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setStateIn(() {
                                                  temp = "date";
                                                });
                                              },
                                              child: SizedBox(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor: temp ==
                                                                  "date"
                                                              ? Constants
                                                                  .greenCol
                                                              : Constants
                                                                  .primeryDarkCol,
                                                        ),
                                                        const Text(
                                                          "تاریخ",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () => setState(() {
                                                  tempAlarm["mode"] = temp;
                                                  controller.dismiss();
                                                }),
                                                child: Container(
                                                  width: 80,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Constants.greenCol,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      "تایید",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                content: const SizedBox(
                                  width: 50,
                                  height: 0,
                                ));
                          },
                          child: SizedBox(
                            height: getSize(context, isWidth: false)! / 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                        Icons.keyboard_arrow_left_rounded),
                                    Text(
                                        tempAlarm["mode"] == "week"
                                            ? "هفتگی"
                                            : tempAlarm["mode"] == "daily"
                                                ? "روزانه"
                                                : tempAlarm["mode"] == "date"
                                                    ? "تاریخ"
                                                    : "یکبار",
                                        style: textStyler(
                                            color: Constants.themeLight,
                                            fontsize: 12))
                                  ],
                                ),
                                Text(
                                  "تکرار",
                                  style: textStyler(
                                      color: Constants.themeLight,
                                      fontsize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            NAlertDialog(
                              title: Text("تنظیم یادداشت برای این تایمر",
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style:
                                      textStyler(color: Constants.themeLight)),
                              content: Container(
                                  padding:
                                      EdgeInsets.only(top: 0.h, bottom: 20.w),
                                  alignment: Alignment.bottomCenter,
                                  width: 0.65.sw,
                                  height: 0.11.sh,
                                  child: TextField(
                                      controller: descriptionController)),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text("تایید",
                                      textDirection: TextDirection.rtl,
                                      style: textStyler(
                                          color: Constants.themeLight)),
                                  onPressed: () {
                                    setState(() {
                                      tempAlarm["label"] =
                                          descriptionController.text;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                MaterialButton(
                                  child: Text("لغو",
                                      textDirection: TextDirection.rtl,
                                      style: textStyler(
                                          color: Constants.themeLight)),
                                  onPressed: () {
                                    descriptionController.clear();
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ).show(context);
                          },
                          child: SizedBox(
                            height: getSize(context, isWidth: false)! / 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.keyboard_arrow_left_rounded),
                                Text(tempAlarm["label"] ?? ""),
                                Text(
                                  "یادداشت",
                                  style: textStyler(
                                      color: Constants.themeLight,
                                      fontsize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _daysButtonMethod(BuildContext context, int dayPos,
      {String text = ""}) {
    return InkWell(
      onTap: () {
        setState(() {
          if (!tempAlarm["week"].contains(dayPos)) {
            tempAlarm["week"].add(dayPos);
          } else {
            tempAlarm["week"].remove(dayPos);
          }
        });
      },
      child: CircleAvatar(
        minRadius: getSize(context, isWidth: true)! / 17,
        backgroundColor: tempAlarm["week"].contains(dayPos)
            ? Constants.greenCol
            : Constants.thirdryDarkCol,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tempAlarm["week"].contains(dayPos)
                ? Constants.thirdryDarkCol
                : Constants.themeLight,
          ),
        ),
      ),
    );
  }
}
