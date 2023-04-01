import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:ndialog/ndialog.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../../data/utils/server_constants.dart';
import '../../cubit/button_data_cubit.dart';

class TimerPage extends StatefulWidget {
  final int relayPos;
  final int devicePos;
  const TimerPage({Key? key, this.relayPos = 0, this.devicePos = 0})
      : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController relayTagController = TextEditingController(text: "");
    return BaseWidget(
        backgroundColor: Constants.primeryDarkCol,
        child: BlocBuilder<ButtonDataCubit, ButtonDataState>(
          bloc: BlocProvider.of<ButtonDataCubit>(context),
          builder: (context, state) {
            return SizedBox(
              width: getSize(context, isWidth: true),
              height: getSize(context, isWidth: false),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: getSize(context, isWidth: true),
                        height: getSize(context, isWidth: false),
                        child: ListView.builder(
                            itemCount: Constants.timerData.containsKey(Constants
                                    .itemList.keys
                                    .toList()[Constants.appbarMenuPosation])
                                ? Constants.timerData[
                                            Constants.itemList.keys.toList()[
                                                Constants.appbarMenuPosation]]
                                        .containsKey("r${widget.relayPos}")
                                    ? Constants
                                        .timerData[Constants.itemList.keys
                                                .toList()[Constants.appbarMenuPosation]]
                                            ["r${widget.relayPos}"]
                                        .keys
                                        .length
                                    : 0
                                : 0,
                            padding: const EdgeInsets.only(top: 220, left: 15, right: 15, bottom: 30),
                            itemBuilder: (context, pos) {
                              return _timerTypeDateMethod(context,
                                  pos: Constants
                                      .timerData[
                                          Constants.itemList.keys.toList()[
                                              Constants.appbarMenuPosation]]
                                          ["r${widget.relayPos}"]
                                      .keys
                                      .toList()[pos]);
                            })),
                    Container(
                      height: 190,
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
                        padding: const EdgeInsets.only(
                            left: 26.0, right: 26.0, top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: SizedBox(
                                      width: 50,
                                      child: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: Constants.themeLight,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 0.4.sw,
                                  height: 100.h,
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.laptop_mac,
                                        color: Constants.themeLight,
                                        size: 50,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          NAlertDialog(
                                            title: Text("تغییر اسم خروجی",
                                                textDirection:
                                                    TextDirection.rtl,
                                                style: textStyler(
                                                    color:
                                                        Constants.themeLight)),
                                            content: SizedBox(
                                                width: 150,
                                                height: 50,
                                                child: TextField(
                                                    controller:
                                                        relayTagController)),
                                            actions: <Widget>[
                                              MaterialButton(
                                                child: Text("تایید",
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: textStyler(
                                                        color: Constants
                                                            .themeLight)),
                                                onPressed: () {
                                                  Constants.itemListCurrentPage[
                                                          Constants
                                                              .itemListCurrentPage
                                                              .keys
                                                              .toList()[Constants
                                                                  .bodyItemPosation -
                                                              1]]["tag"] =
                                                      relayTagController.text;
                                                  Constants.itemList[Constants
                                                                  .itemList.keys
                                                                  .toList()[
                                                              Constants
                                                                  .deviceSelectedIndex]]
                                                          [
                                                          "device_Relay_Status"] =
                                                      jsonEncode(Constants
                                                          .itemListCurrentPage);
                                                  BlocProvider.of<
                                                              ButtonDataCubit>(
                                                          context)
                                                      .changeStatus(
                                                          appbarPos: Constants
                                                              .deviceSelectedIndex,
                                                          event: "rename_relay",
                                                          log:
                                                              """{"e":"RENAME_RELAY","r":${Constants.bodyItemPosation - 1},"t":${RestAPIConstants.phoneNumberID},"m":"${relayTagController.text}"}""",
                                                          isEvent: false);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              MaterialButton(
                                                child: Text("لغو",
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    style: textStyler(
                                                        color: Constants
                                                            .themeLight)),
                                                onPressed: () {
                                                  relayTagController.clear();
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ).show(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 22.r,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 18.w),
                                              child: Text(
                                                Constants.itemListCurrentPage[Constants
                                                            .itemListCurrentPage
                                                            .keys
                                                            .toList()[Constants
                                                                .bodyItemPosation -
                                                            1]]
                                                        .containsKey("tag")
                                                    ? Constants.itemListCurrentPage[Constants
                                                            .itemListCurrentPage
                                                            .keys
                                                            .toList()[Constants
                                                                .bodyItemPosation -
                                                            1]]["tag"] ??
                                                        ""
                                                    : "خروجی",
                                                style: textStyler(
                                                    color: Constants.themeLight,
                                                    fontsize: 16.r,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: SizedBox(
                                    width: 50,
                                    child: InkWell(
                                      onTap: () async {
                                        if (Constants.itemListCurrentPage[
                                                (Constants.itemListCurrentPage
                                                        .keys
                                                        .toList()[Constants
                                                            .bodyItemPosation -
                                                        1])
                                                    .toString()]['rMode'] ==
                                            'S') {
                                          NDialog(
                                            actions: [
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'خیر',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.r,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () async {
                                                  Constants
                                                      .itemListCurrentPage[(Constants
                                                          .itemListCurrentPage
                                                          .keys
                                                          .toList()[Constants
                                                              .bodyItemPosation -
                                                          1])
                                                      .toString()]['rMode'] = 'T';
                                                  if (Constants.isOnline ==
                                                      'false') {
                                                    await isNotConnectedToWifi()
                                                        .then((value) async {
                                                      if (value) {
                                                        await BlocProvider.of<
                                                                    ButtonDataCubit>(
                                                                context)
                                                            .changeStatusButton(
                                                                doChange: false,
                                                                appbarPos:
                                                                    (Constants
                                                                        .appbarMenuPosation),
                                                                itemPos: (Constants
                                                                    .bodyItemPosation));
                                                      }
                                                    });
                                                  } else {
                                                    await BlocProvider.of<
                                                                ButtonDataCubit>(
                                                            context)
                                                        .changeStatusButton(
                                                            doChange: false,
                                                            appbarPos: (Constants
                                                                .appbarMenuPosation),
                                                            itemPos: Constants
                                                                .bodyItemPosation)
                                                        .timeout(const Duration(
                                                            seconds: 10));
                                                  }
                                                  Navigator.of(context).pop();
                                                  Constants.timerConfigPos =
                                                      "new";
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          "/timer_config");
                                                },
                                                child: Text(
                                                  'بله',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.r,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                            title: Text(
                                              "تداخل ویژگی ها",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.r,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: Padding(
                                              padding: EdgeInsets.all(12.0.r),
                                              child: SizedBox(
                                                height: 0.15.sh,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 0.55.sw,
                                                      child: Text(
                                                        'خروجی توسط ${Constants.itemListCurrentPage[(Constants.itemListCurrentPage.keys.toList()[Constants.bodyItemPosation - 1]).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} کنترل میشود آیا از تغییر اطمینان دارید؟',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14.r),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 0.55.sw,
                                                      child: Text(
                                                        'در صورت انتخاب گزینه بله ${Constants.itemListCurrentPage[(Constants.itemListCurrentPage.keys.toList()[Constants.bodyItemPosation - 1]).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} های خروجی غیر فعال میشود',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14.r),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ).show(context);
                                        } else {
                                          Navigator.of(context).pop();
                                          Constants.timerConfigPos = "new";
                                          Navigator.of(context)
                                              .pushNamed("/timer_config");
                                        }
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Constants.themeLight,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 0.6.sw,
                              height: 50.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r)),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: InkWell(
                                      onTap: () async {
                                        Constants.itemListCurrentPage[(Constants
                                                    .itemListCurrentPage.keys
                                                    .toList()[
                                                Constants.bodyItemPosation - 1])
                                            .toString()]['rMode'] = 'T';
                                        if (Constants.isOnline == 'false') {
                                          await isNotConnectedToWifi()
                                              .then((value) async {
                                            if (value) {
                                              await BlocProvider.of<
                                                      ButtonDataCubit>(context)
                                                  .changeStatusButton(
                                                      doChange: false,
                                                      appbarPos: (Constants
                                                          .appbarMenuPosation),
                                                      itemPos: (Constants
                                                              .bodyItemPosation -
                                                          1));
                                            }
                                          });
                                        } else {
                                          await BlocProvider.of<
                                                  ButtonDataCubit>(context)
                                              .changeStatusButton(
                                                  doChange: false,
                                                  appbarPos: (Constants
                                                      .appbarMenuPosation),
                                                  itemPos: Constants
                                                          .bodyItemPosation -
                                                      1)
                                              .timeout(
                                                  const Duration(seconds: 10));
                                        }
                                      },
                                      child: Container(
                                        height: double.infinity,alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color:  Constants.itemListCurrentPage[(Constants
                                                    .itemListCurrentPage.keys
                                                    .toList()[
                                                Constants.bodyItemPosation - 1])
                                            .toString()]['rMode'] == 'T' ?Constants.primeryDarkCol:Constants.secondryDarkCol,
                                          border: Border.all(
                                              color: Constants.primeryDarkCol,
                                              width: 3),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.r),
                                            bottomLeft: Radius.circular(16.r),
                                          ),
                                        ),
                                        child: const Text('زمانبندی'),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: InkWell(
                                      onTap: () async {
                                        Constants.itemListCurrentPage[(Constants
                                                    .itemListCurrentPage.keys
                                                    .toList()[
                                                Constants.bodyItemPosation - 1])
                                            .toString()]['rMode'] = 'M';
                                        if (Constants.isOnline == 'false') {
                                          await isNotConnectedToWifi()
                                              .then((value) async {
                                            if (value) {
                                              await BlocProvider.of<
                                                      ButtonDataCubit>(context)
                                                  .changeStatusButton(
                                                      doChange: false,
                                                      appbarPos: (Constants
                                                          .appbarMenuPosation),
                                                      itemPos: (Constants
                                                              .bodyItemPosation -
                                                          1));
                                            }
                                          });
                                        } else {
                                          await BlocProvider.of<
                                                  ButtonDataCubit>(context)
                                              .changeStatusButton(
                                                  doChange: false,
                                                  appbarPos: (Constants
                                                      .appbarMenuPosation),
                                                  itemPos: Constants
                                                          .bodyItemPosation -
                                                      1)
                                              .timeout(
                                                  const Duration(seconds: 10));
                                        }
                                      },
                                      child: Container(
                                        height: double.infinity,alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Constants.itemListCurrentPage[(Constants
                                                    .itemListCurrentPage.keys
                                                    .toList()[
                                                Constants.bodyItemPosation - 1])
                                            .toString()]['rMode'] == 'M' ?Constants.primeryDarkCol:Constants.secondryDarkCol,
                                            border: Border.all(
                                                color: Constants.primeryDarkCol,
                                                width: 3)),
                                        child: const Text('دستی'),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 5,
                                    child: InkWell(
                                      onTap: () async {
                                        Constants.itemListCurrentPage[(Constants
                                                    .itemListCurrentPage.keys
                                                    .toList()[
                                                Constants.bodyItemPosation - 1])
                                            .toString()]['rMode'] = 'S';
                                        if (Constants.isOnline == 'false') {
                                          await isNotConnectedToWifi()
                                              .then((value) async {
                                            if (value) {
                                              await BlocProvider.of<
                                                      ButtonDataCubit>(context)
                                                  .changeStatusButton(
                                                      doChange: false,
                                                      appbarPos: (Constants
                                                          .appbarMenuPosation),
                                                      itemPos: (Constants
                                                              .bodyItemPosation -
                                                          1));
                                            }
                                          });
                                        } else {
                                          await BlocProvider.of<
                                                  ButtonDataCubit>(context)
                                              .changeStatusButton(
                                                  doChange: false,
                                                  appbarPos: (Constants
                                                      .appbarMenuPosation),
                                                  itemPos: Constants
                                                          .bodyItemPosation -
                                                      1)
                                              .timeout(
                                                  const Duration(seconds: 10));
                                        }
                                      },
                                      child: Container(
                                        height: double.infinity,alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color:  Constants.itemListCurrentPage[(Constants
                                                    .itemListCurrentPage.keys
                                                    .toList()[
                                                Constants.bodyItemPosation - 1])
                                            .toString()]['rMode'] == 'S' ?Constants.primeryDarkCol:Constants.secondryDarkCol,
                                          border: Border.all(
                                              color: Constants.primeryDarkCol,
                                              width: 3),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(16.r),
                                            bottomRight: Radius.circular(16.r),
                                          ),
                                        ),
                                        child: const Text('سنسور'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _timerTypeDateMethod(BuildContext context, {String pos = ""}) {
    return InkWell(
      onTap: () {
        Constants.timerConfigPos = pos;
        if (Constants.itemListCurrentPage[(Constants.itemListCurrentPage.keys
                    .toList()[Constants.bodyItemPosation - 1])
                .toString()]['rMode'] ==
            'S') {
          NDialog(
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'خیر',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.r,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  Constants.itemListCurrentPage[(Constants
                          .itemListCurrentPage.keys
                          .toList()[Constants.bodyItemPosation - 1])
                      .toString()]['rMode'] = 'T';
                  if (Constants.isOnline == 'false') {
                    await isNotConnectedToWifi().then((value) async {
                      if (value) {
                        await BlocProvider.of<ButtonDataCubit>(context)
                            .changeStatusButton(
                                doChange: false,
                                appbarPos: (Constants.appbarMenuPosation),
                                itemPos: (Constants.bodyItemPosation - 1));
                      }
                    });
                  } else {
                    await BlocProvider.of<ButtonDataCubit>(context)
                        .changeStatusButton(
                            doChange: false,
                            appbarPos: (Constants.appbarMenuPosation),
                            itemPos: Constants.bodyItemPosation - 1)
                        .timeout(const Duration(seconds: 10));
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("/timer_config");
                },
                child: Text(
                  'بله',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.r,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            title: Text(
              "تداخل ویژگی ها",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.r,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            content: Padding(
              padding: EdgeInsets.all(12.0.r),
              child: SizedBox(
                height: 0.15.sh,
                child: Column(
                  children: [
                    SizedBox(
                      width: 0.55.sw,
                      child: Text(
                        'خروجی توسط ${Constants.itemListCurrentPage[(Constants.itemListCurrentPage.keys.toList()[Constants.bodyItemPosation - 1]).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} کنترل میشود آیا از تغییر اطمینان دارید؟',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14.r),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      width: 0.55.sw,
                      child: Text(
                        'در صورت انتخاب گزینه بله ${Constants.itemListCurrentPage[(Constants.itemListCurrentPage.keys.toList()[Constants.bodyItemPosation - 1]).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} های خروجی غیر فعال میشود',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14.r),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).show(context);
        } else {
          Navigator.of(context).pushNamed("/timer_config");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          height: getSize(context, isWidth: false)! < 850
              ? Constants
                      .timerData[Constants.itemList.keys
                              .toList()[Constants.appbarMenuPosation]]
                          ["r${widget.relayPos}"][pos]
                      .keys
                      .toList()
                      .contains("week")
                  ? getSize(context, isWidth: false)! / 4
                  : getSize(context, isWidth: false)! / 6
              : Constants
                      .timerData[Constants.itemList.keys
                              .toList()[Constants.appbarMenuPosation]]
                          ["r${widget.relayPos}"][pos]
                      .keys
                      .toList()
                      .contains("week")
                  ? getSize(context, isWidth: false)! / 4.5
                  : getSize(context, isWidth: false)! / 7,
          width: getSize(context, isWidth: true)! / 1.3,
          decoration: BoxDecoration(
              color: Constants.secondryDarkCol,
              borderRadius: const BorderRadius.all(Radius.circular(25))),
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 80,
                        child: _flutterSwitchMethod(context, pos, "enable"),
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          Constants.timerData[Constants.itemList.keys
                                          .toList()[Constants.appbarMenuPosation]]
                                      ["r${widget.relayPos}"][pos]["mode"] ==
                                  "date"
                              ? "براساس تاریخ"
                              : Constants.timerData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
                                              ["r${widget.relayPos}"][pos]
                                          ["mode"] ==
                                      "daily"
                                  ? "روزانه"
                                  : Constants.timerData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
                                                  ["r${widget.relayPos}"][pos]
                                              ["mode"] ==
                                          "week"
                                      ? "هفتگی"
                                      : "یکبار",
                          textAlign: TextAlign.center,
                          style: textStyler(color: Constants.themeLight),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 5),
                        child: InkWell(
                          onTap: () {
                            showDialogFlash(context,
                                    persistent: true,
                                    title: "حذف آلارم",
                                    content: "آیا اطمینان دارید؟")
                                .then((value) {
                              if (value == true) {
                                BlocProvider.of<ButtonDataCubit>(context)
                                    .setTimerState(context, 6,
                                        picked: Jalali.now(),
                                        relayPos: "r${widget.relayPos}",
                                        devicePos: widget.devicePos,
                                        time: TimeOfDay.now(),
                                        timerPos: pos);
                                if (Constants.isOnline == 'true') {
                                  BlocProvider.of<ButtonDataCubit>(context)
                                      .changeTimers(
                                          log:
                                              """{"e":"UPDATE_TIMER","r":${Constants.bodyItemPosation - 1},"t":${RestAPIConstants.phoneNumberID},"s":0}""",
                                          appbarPos: widget.devicePos,
                                          event: "UPDATE_TIMER",
                                          isEvent: false,
                                          timerData: Constants.timerData[
                                              Constants.itemList.keys.toList()[
                                                  Constants
                                                      .appbarMenuPosation]]);
                                } else {
                                  httpRequestPost(
                                      postUrl: Constants.hostUrl,
                                      body: {
                                        "Message": jsonEncode(Constants
                                                .timerData[
                                            Constants.itemList.keys.toList()[
                                                Constants.appbarMenuPosation]]),
                                        "Event": "Updatetimer"
                                      });
                                }
                              }
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Constants.greenCol,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50))),
                            child: Icon(
                              Icons.close,
                              color: Constants.secondryDarkCol,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getSize(context, isWidth: false)! / 50),
                SizedBox(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 160,
                                height: 55,
                                decoration: BoxDecoration(
                                    color: Constants.thirdryDarkCol,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "تا",
                                      style: TextStyle(
                                          color: Constants.themeLight),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      Constants.timerData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
                                                      ["r${widget.relayPos}"]
                                                  [pos]["mode"] ==
                                              "date"
                                          ? Constants.timerData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
                                                  ["r${widget.relayPos}"][pos]
                                              ["end"]
                                          : Constants.timerData[Constants.itemList.keys
                                                      .toList()[Constants.appbarMenuPosation]]
                                                  ["r${widget.relayPos}"][pos]["end"]
                                              .toString()
                                              .substring(11, 16),
                                      style: TextStyle(
                                          color: Constants.themeLight),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                              Container(
                                width: 160,
                                height: 55,
                                decoration: BoxDecoration(
                                    color: Constants.thirdryDarkCol,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "از",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Constants.themeLight),
                                    ),
                                    Text(
                                      Constants.timerData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
                                                      ["r${widget.relayPos}"]
                                                  [pos]["mode"] ==
                                              "date"
                                          ? Constants.timerData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
                                                  ["r${widget.relayPos}"][pos]
                                              ["start"]
                                          : Constants.timerData[Constants.itemList.keys
                                                      .toList()[Constants.appbarMenuPosation]]
                                                  ["r${widget.relayPos}"][pos]["start"]
                                              .toString()
                                              .substring(11, 16),
                                      style: TextStyle(
                                          color: Constants.themeLight),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Constants
                                  .timerData[Constants.itemList.keys.toList()[
                                          Constants.appbarMenuPosation]]
                                      ["r${widget.relayPos}"][pos]
                                  .keys
                                  .toList()
                                  .contains("week")
                              ? const SizedBox(height: 15)
                              : const SizedBox(),
                          Constants
                                  .timerData[Constants.itemList.keys.toList()[
                                          Constants.appbarMenuPosation]]
                                      ["r${widget.relayPos}"][pos]
                                  .keys
                                  .toList()
                                  .contains("week")
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _daysButtonMethod(context, pos, 7,
                                        text: "ج"),
                                    Constants.widthSpace,
                                    _daysButtonMethod(context, pos, 6,
                                        text: "پ ش"),
                                    Constants.widthSpace,
                                    _daysButtonMethod(context, pos, 5,
                                        text: "چ ش"),
                                    Constants.widthSpace,
                                    _daysButtonMethod(context, pos, 4,
                                        text: "س ش"),
                                    Constants.widthSpace,
                                    _daysButtonMethod(context, pos, 3,
                                        text: "د ش"),
                                    Constants.widthSpace,
                                    _daysButtonMethod(context, pos, 2,
                                        text: "ی ش"),
                                    Constants.widthSpace,
                                    _daysButtonMethod(context, pos, 1,
                                        text: "ش"),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  CircleAvatar _daysButtonMethod(BuildContext context, String pos, int dayPos,
      {String text = ""}) {
    return CircleAvatar(
      minRadius: getSize(context, isWidth: true)! / 17,
      backgroundColor: Constants.timerData[Constants.itemList.keys
                      .toList()[Constants.appbarMenuPosation]]
                  ["r${widget.relayPos}"][pos]["mode"] ==
              "week"
          ? Constants.timerData[Constants.itemList.keys
                          .toList()[Constants.appbarMenuPosation]]
                      ["r${widget.relayPos}"][pos]["week"]
                  .contains(dayPos)
              ? Constants.greenCol
              : Constants.thirdryDarkCol
          : Constants.greenCol,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Constants.timerData[Constants.itemList.keys
                          .toList()[Constants.appbarMenuPosation]]
                      ["r${widget.relayPos}"][pos]["mode"] ==
                  "week"
              ? Constants.timerData[Constants.itemList.keys
                              .toList()[Constants.appbarMenuPosation]]
                          ["r${widget.relayPos}"][pos]["week"]
                      .contains(dayPos)
                  ? Constants.thirdryDarkCol
                  : Constants.themeLight
              : Constants.thirdryDarkCol,
        ),
      ),
    );
  }

  FlutterSwitch _flutterSwitchMethod(
      BuildContext context, String pos, String value) {
    return FlutterSwitch(
      activeColor: Constants.thirdryDarkCol,
      activeToggleColor: Constants.greenCol,
      inactiveToggleColor: Constants.thirdryDarkCol,
      width: getSize(context, isWidth: true)! / 7.8,
      height: getSize(context, isWidth: false)! / 30,
      toggleSize: 25.0,
      inactiveColor: Constants.primeryDarkCol,
      toggleColor: Constants.greenCol,
      value: Constants.timerData[
              Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
          ["r${widget.relayPos}"][pos][value],
      borderRadius: 50.0,
      padding: 0,
      showOnOff: false,
      onToggle: (val) {
        setState(() {
          Constants.timerData[Constants.itemList.keys
                  .toList()[Constants.appbarMenuPosation]]
              ["r${widget.relayPos}"][pos][value] = val;
        });
        BlocProvider.of<ButtonDataCubit>(context).changeTimers(
            log:
                """{"e":"UPDATE_TIMER","r":${Constants.bodyItemPosation - 1},"t":${RestAPIConstants.phoneNumberID},"s":2}""",
            appbarPos: widget.devicePos,
            event: "UPDATE_TIMER",
            isEvent: false,
            timerData: Constants.timerData[Constants.itemList.keys
                .toList()[Constants.appbarMenuPosation]]);
      },
    );
  }
}
