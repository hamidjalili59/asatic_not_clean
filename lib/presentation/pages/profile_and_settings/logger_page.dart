import 'dart:convert';
import 'dart:io';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../../data/utils/server_constants.dart';
import '../../cubit/button_data_cubit.dart';

class LoggerPage extends StatefulWidget {
  const LoggerPage({Key? key}) : super(key: key);

  @override
  State<LoggerPage> createState() => _LoggerPageState();
}

class _LoggerPageState extends State<LoggerPage> {
  int selectedMon = 0;
  // int itemsLength = 0;
  Jalali startFilter = Jalali.now();
  Jalali endFilter = Jalali.now();
  String currentDevice = "";
  String currentDeviceName = "";
  List<dynamic> logs = [];
  // List<dynamic> logs = List.empty(growable: true);

  Future getLogFromServer() async {
    Response logResponse =
        await httpRequestGet(getUrl: Constants.getLogLink + currentDevice);
    if (logResponse.statusCode == 200) {
      setState(() {
        logs.clear();
        logs = logResponse.data;
        BlocProvider.of<ButtonDataCubit>(context).loggerConfig(
            Jalali.now(), startFilter, endFilter.toDateTime(), logs, 3);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Constants.itemList.isNotEmpty
        ? currentDevice = Constants.itemList.keys.toList()[0]
        : "";
    getLogFromServer().whenComplete(() {
      BlocProvider.of<ButtonDataCubit>(context).loggerConfig(
          Jalali.now(), startFilter, endFilter.toDateTime(), logs, 3);
    });
  }

  @override
  void dispose() {
    logs.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Constants.hamidPhoneSize);
    return BlocBuilder<ButtonDataCubit, ButtonDataState>(
      bloc: BlocProvider.of<ButtonDataCubit>(context),
      builder: (context, state) {
        return BlurryModalProgressHUD(
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
          child: BaseWidget(
            backgroundColor: Constants.primeryDarkCol,
            child: SizedBox(
              child: Stack(
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: 1.sw,
                      height: 1.sh,
                      child: ListView.builder(
                          itemCount: state.logData.length,
                          itemExtent: 0.12.sh,
                          padding: EdgeInsets.only(
                              top: 0.27.sh,
                              left: 15.w,
                              right: 15.w,
                              bottom: 30.h),
                          itemBuilder: (context, pos) {
                            String logText() {
                              try {
                                String currentD =
                                    state.logData[pos]["deviceID"].toString();
                                Map<String, dynamic> currentDe = jsonDecode(
                                    Constants.itemList[currentD]
                                        ['device_Relay_Status']);
                                if (jsonDecode(
                                        state.logData[pos]["logs"])["e"] ==
                                    "UPDATE") {
                                  if (state.logData[pos]["user"].toString() !=
                                      currentDevice) {
                                    return ("${currentDe[currentDe.keys.toList()[jsonDecode(state.logData[pos]["logs"])["r"] - 1]].containsKey("tag") ? currentDe[currentDe.keys.toList()[jsonDecode(state.logData[pos]["logs"])["r"] - 1]]["tag"] ?? "" : "خروجی ${jsonDecode(state.logData[pos]["logs"])["r"]}"} "
                                        "را ${jsonDecode(state.logData[pos]["logs"])["s"] == 1 ? "روشن کرد" : "خاموش کرد"}");
                                  } else {
                                    return ("${currentDe[currentDe.keys.toList()[int.parse(jsonDecode(state.logData[pos]["logs"])["r"]) - 1]].containsKey("tag") ? currentDe[currentDe.keys.toList()[int.parse(jsonDecode(state.logData[pos]["logs"])["r"]) - 1]]["tag"] ?? "" : "خروجی ${jsonDecode(state.logData[pos]["logs"])["r"]}"} "
                                        "را ${jsonDecode(state.logData[pos]["logs"])["s"] == true ? "روشن کرد" : "خاموش کرد"}");
                                  }
                                } else if (jsonDecode(
                                        state.logData[pos]["logs"])["e"] ==
                                    "RENAME_RELAY") {
                                  return ("اسم خروجی ${jsonDecode(state.logData[pos]["logs"])["r"]} را به ${jsonDecode(state.logData[pos]["logs"])["m"]} تغییر داد");
                                } else if (jsonDecode(
                                        state.logData[pos]["logs"])["e"] ==
                                    "REMOTE_CHANGE") {
                                  return ("ریموت دستگاه ${Constants.itemList[Constants.itemList.keys.toList()[jsonDecode(state.logData[pos]["logs"])["r"]]]["tag"]} را ${jsonDecode(state.logData[pos]["logs"])["s"] == true ? "اضافه کرد" : "حذف کرد"}");
                                } else if (jsonDecode(
                                        state.logData[pos]["logs"])["e"] ==
                                    "REMOTE_NAME") {
                                  return ("اسم ریموت دستگاه ${Constants.itemList[Constants.itemList.keys.toList()[jsonDecode(state.logData[pos]["logs"])["r"]]]["tag"]} را تغییر داد");
                                } else if (jsonDecode(
                                        state.logData[pos]["logs"])["e"] ==
                                    "REMOTE") {
                                  return ("ریموت دستگاه ${Constants.itemList[Constants.itemList.keys.toList()[jsonDecode(state.logData[pos]["logs"])["r"]]]["tag"]} را ${jsonDecode(state.logData[pos]["logs"])["s"] == true ? "فعال کرد" : "غیر فعال کرد"}");
                                } else if (jsonDecode(
                                        state.logData[pos]["logs"])["e"] ==
                                    "RENAME_DEVICE") {
                                  return ("اسم دستگاه ${jsonDecode(state.logData[pos]["logs"])["r"]} را به ${jsonDecode(state.logData[pos]["logs"])["m"]} تغییر داد");
                                } else if (jsonDecode(
                                        state.logData[pos]["logs"])["e"] ==
                                    "Sensor_Data") {
                                  return ("تنظیمات سنسور ${currentDe[currentDe.keys.toList()[jsonDecode(state.logData[pos]["logs"])["m"] - 1]].containsKey("tag") ? currentDe[currentDe.keys.toList()[jsonDecode(state.logData[pos]["logs"])["m"] - 1]]["tag"] ?? "" : "خروجی ${jsonDecode(state.logData[pos]["logs"])["m"]}"} در دستگاه ${Constants.itemList[Constants.itemList.keys.toList()[jsonDecode(state.logData[pos]["logs"])["r"]]]["tag"]} تغییر داد");
                                } else if (jsonDecode(
                                        state.logData[pos]["logs"])["e"] ==
                                    "sensor") {
                                  return ("سنسور به دستگاه ${Constants.itemList[Constants.itemList.keys.toList()[jsonDecode(state.logData[pos]["logs"])["r"]]]["tag"]} ${jsonDecode(state.logData[pos]["logs"])["r"]}");
                                } else {
                                  return " جیسون تایپ متفاوت ${state.logData[pos]["logs"]}";
                                }
                              } catch (e) {
                                return "فرمت جیسون اشتباه ${state.logData[pos]["logs"]}";
                              }
                            }

                            return Padding(
                              padding: EdgeInsets.all(6.0.r),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Constants.thirdryDarkCol,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0.h,
                                          left: 15.0.w,
                                          right: 15.0.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${DateTime.parse(state.logData[pos]["time"]).toString().substring(10, 19)} - ${DateTime.parse(state.logData[pos]["time"]).toJalali().formatFullDate()}",
                                            style: textStyler(
                                                color: Constants.themeLight,
                                                fontsize: 15.r,
                                                fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            state.logData[pos]["user"]
                                                        .toString() ==
                                                    currentDevice
                                                ? "دستگاه"
                                                : state.logData[pos]["user"] ==
                                                        RestAPIConstants
                                                            .phoneNumberID
                                                    ? "شما"
                                                    : "${state.logData[pos]["user"]}",
                                            style: textStyler(
                                                color: Constants.themeLight,
                                                fontsize: 14.r,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            (pos + 1).toString(),
                                            style: textStyler(
                                                color: Constants.themeLight,
                                                fontsize: 14.r,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                        color:
                                            Constants.themeLight.withAlpha(120),
                                        thickness: 1),
                                    FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        logText(),
                                        textAlign: TextAlign.center,
                                        textDirection: TextDirection.rtl,
                                        style: textStyler(
                                            color: Constants.themeLight,
                                            fontsize: 16.r,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                  Container(
                    height: 0.25.sh,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black87,
                              blurRadius: 10,
                              spreadRadius: 2)
                        ],
                        color: Constants.secondryDarkCol,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 26.0.w, right: 26.0.w, top: 30.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 16.0.h),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: SizedBox(
                                    width: 0.33.sw,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 36.0.w),
                                      child: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: Constants.themeLight,
                                        size: 30.r,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80.w,
                                height: 80.h,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.receipt_long,
                                      color: Constants.themeLight,
                                      size: 40.r,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      "گزارش ها",
                                      style: textStyler(
                                          color: Constants.themeLight,
                                          fontsize: 14.r),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 16.0.h),
                                child: SizedBox(
                                  width: 0.33.sw,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      dropdownWidth: 120.w,
                                      items: Constants.nameAndDeviceID.keys
                                          .toList()
                                          .map((item) {
                                        if (currentDeviceName.isEmpty) {
                                          currentDeviceName = item;
                                        }

                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 14.r,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      value: currentDeviceName,
                                      onChanged: (value) {
                                        setState(() {
                                          currentDeviceName = value as String;
                                          currentDevice =
                                              Constants.nameAndDeviceID[value];
                                          getLogFromServer();
                                        });
                                      },
                                      buttonHeight: 50.h,
                                      buttonWidth: 50.w,
                                      itemHeight: 50.h,
                                      customButton: SizedBox(
                                        // width: getSize(context, isWidth: true)! / 2.3,
                                        width: 0.6.sw,
                                        height: 50.h,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Constants.greenCol
                                                        .withAlpha(180),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                width: 0.2.sw,
                                                child: Text(currentDeviceName)),
                                            Icon(Icons.more_vert_rounded,
                                                size: 26.r),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            width: double.infinity,
                            height: 0.085.sh,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 0.33.sw,
                                    child: InkWell(
                                      onTap: () async {
                                        Jalali? picked =
                                            await showPersianDatePicker(
                                          context: context,
                                          initialDate: Jalali.now(),
                                          firstDate: Jalali(1385, 8),
                                          lastDate: Jalali(1450, 9),
                                        );
                                        DateTime end = DateTime.parse(
                                            "${endFilter.toDateTime().toString().substring(0, 10)} 23:59:59");
                                        if (picked!
                                            .toDateTime()
                                            .isBefore(end)) {
                                          startFilter = picked;
                                          BlocProvider.of<ButtonDataCubit>(
                                                  context)
                                              .loggerConfig(picked, startFilter,
                                                  end, logs, 1);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Constants.greenCol,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "از تاریخ",
                                              style: textStyler(
                                                  color: Constants.themeLight,
                                                  fontsize: 14),
                                            ),
                                            Text(
                                              startFilter.formatCompactDate(),
                                              style: textStyler(
                                                  color: Constants.themeLight,
                                                  fontsize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 0.1.sw),
                                  SizedBox(
                                    width: 0.33.sw,
                                    child: InkWell(
                                      onTap: () async {
                                        Jalali? picked =
                                            await showPersianDatePicker(
                                          context: context,
                                          initialDate: Jalali.now(),
                                          firstDate: Jalali(1385, 8),
                                          lastDate: Jalali(1450, 9),
                                        );
                                        DateTime end = DateTime.parse(
                                            "${picked!.toDateTime().toString().substring(0, 10)} 23:59:59");
                                        if (end.isAfter(
                                            startFilter.toDateTime())) {
                                          endFilter = picked;
                                          BlocProvider.of<ButtonDataCubit>(
                                                  context)
                                              .loggerConfig(picked, startFilter,
                                                  end, logs, 2);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Constants.greenCol,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "تا تاریخ",
                                              style: textStyler(
                                                  color: Constants.themeLight,
                                                  fontsize: 14),
                                            ),
                                            Text(
                                              endFilter.formatCompactDate(),
                                              style: textStyler(
                                                  color: Constants.themeLight,
                                                  fontsize: 16),
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
    );
  }
}
