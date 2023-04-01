import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:ndialog/ndialog.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../../data/utils/server_constants.dart';
import '../../cubit/button_data_cubit.dart';

class DevicesSettings extends StatefulWidget {
  final int devicePos;
  const DevicesSettings({
    Key? key,
    required this.devicePos,
  }) : super(key: key);

  @override
  State<DevicesSettings> createState() => _DevicesSettingsState();
}

class _DevicesSettingsState extends State<DevicesSettings> {
  @override
  void dispose() {
    Constants.editTextList.toList().forEach((element) {
      Constants.editTextList.remove(element);
      element.dispose();
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Constants.remoteList = Constants
            .itemList[Constants.itemList.keys.toList()[widget.devicePos]]
                ["remote"]
            .isNotEmpty
        ? jsonDecode(Constants
                .itemList[Constants.itemList.keys.toList()[widget.devicePos]]
            ["remote"])
        : {};
    if (Constants.remoteList.containsKey("count")) {
      Constants.remoteList.remove("count");
      Constants.remoteList.remove("name");
    }
    Constants.remoteList.forEach((key, value) {
      Constants.remoteList[key]["isEditing"] = false;

      if (Constants.editTextList.length <= Constants.remoteList.length) {
        TextEditingController newTEC = TextEditingController();
        newTEC.text = value["label"];
        Constants.editTextList.add(newTEC);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController deviceTagController = TextEditingController(text: "");
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
                    BlocBuilder<ButtonDataCubit, ButtonDataState>(
                      bloc: BlocProvider.of<ButtonDataCubit>(context),
                      builder: (context, state) {
                        void setItemList(String log) {
                          Constants.remoteList.forEach((key, value) {
                            Constants.remoteList[key].remove("isEditing");
                          });
                          Constants.remoteList["count"] =
                              Constants.remoteList.length;
                          Constants.remoteList["name"] = jsonDecode(
                              Constants.itemList[Constants.itemList.keys
                                      .toList()[widget.devicePos]]
                                  ["remote"])["name"];
                          Constants.itemList[Constants.itemList.keys
                                  .toList()[widget.devicePos]]["remote"] =
                              jsonEncode(Constants.remoteList);
                          BlocProvider.of<ButtonDataCubit>(context)
                              .changeStatus(
                                  appbarPos: widget.devicePos,
                                  log: log,
                                  event: "UPDATE_REMOTE",
                                  isEvent: false);
                          Constants.remoteList.remove("count");
                          Constants.remoteList.remove("name");
                          Constants.remoteList.forEach((key, value) {
                            Constants.remoteList[key]["isEditing"] = false;
                          });
                        }

                        FlutterSwitch flutterSwitchMethod(
                            BuildContext context, int pos, bool value) {
                          return FlutterSwitch(
                            activeColor: Constants.thirdryDarkCol,
                            activeToggleColor: Constants.greenCol,
                            inactiveToggleColor: Constants.thirdryDarkCol,
                            width: getSize(context, isWidth: true)! / 7.8,
                            height: getSize(context, isWidth: false)! / 30,
                            toggleSize: 25.0,
                            inactiveColor: Constants.primeryDarkCol,
                            toggleColor: Constants.greenCol,
                            value: value,
                            borderRadius: 50.0,
                            padding: 0,
                            showOnOff: false,
                            onToggle: (val) {
                              setState(() {
                                Constants.remoteList[Constants.remoteList.keys
                                    .toList()[pos]]["enable"] = val;
                              });
                              // setItemList("ریموت را ${val == true ? "فعال" : "غیر فعال"} کرد");
                              setItemList(jsonEncode({
                                "e": "REMOTE",
                                "r": widget.devicePos,
                                "t": RestAPIConstants.phoneNumberID.toString(),
                                "s": val,
                              }));
                            },
                          );
                        }

                        Widget timerTypeDateMethod(BuildContext context,
                            {int pos = 0}) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.065.sh),
                            child: Container(
                              height: getSize(context, isWidth: false)! < 850
                                  ? getSize(context, isWidth: false)! / 10
                                  : getSize(context, isWidth: false)! / 10,
                              width: getSize(context, isWidth: true)! / 1.3,
                              decoration: BoxDecoration(
                                  color: Constants.secondryDarkCol,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(25))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Constants.remoteList[Constants
                                                  .remoteList.keys
                                                  .toList()[pos]]["isEditing"]
                                              ? Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        Constants.remoteList[Constants
                                                                .remoteList.keys
                                                                .toList()[pos]][
                                                            "isEditing"] = false;
                                                        Constants
                                                                .remoteList[Constants
                                                                    .remoteList.keys
                                                                    .toList()[
                                                                pos]]["label"] =
                                                            Constants
                                                                .editTextList[
                                                                    pos]
                                                                .text;
                                                      });
                                                      setItemList(jsonEncode({
                                                        "e": "REMOTE_NAME",
                                                        "r": widget.devicePos,
                                                        "t": RestAPIConstants
                                                            .phoneNumberID
                                                            .toString(),
                                                      }));
                                                    },
                                                    child: SizedBox(
                                                      width: 100,
                                                      height: getSize(context,
                                                                  isWidth:
                                                                      false)! <
                                                              850
                                                          ? getSize(context,
                                                                  isWidth:
                                                                      false)! /
                                                              20
                                                          : getSize(context,
                                                                  isWidth:
                                                                      false)! /
                                                              15,
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Constants
                                                            .themeLight,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      Constants.remoteList[
                                                              Constants
                                                                  .remoteList.keys
                                                                  .toList()[pos]]
                                                          ["isEditing"] = true;
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    width: 100,
                                                    height: getSize(context,
                                                                isWidth:
                                                                    false)! <
                                                            850
                                                        ? getSize(context,
                                                                isWidth:
                                                                    false)! /
                                                            20
                                                        : getSize(context,
                                                                isWidth:
                                                                    false)! /
                                                            15,
                                                    child: Icon(
                                                      Icons.edit,
                                                      color:
                                                          Constants.themeLight,
                                                    ),
                                                  ),
                                                ),
                                          flutterSwitchMethod(
                                              context,
                                              pos,
                                              Constants.remoteList[Constants
                                                  .remoteList.keys
                                                  .toList()[pos]]["enable"]),
                                          Constants.remoteList[Constants
                                                  .remoteList.keys
                                                  .toList()[pos]]["isEditing"]
                                              ? SizedBox(
                                                  width: 150,
                                                  height: 50,
                                                  child: TextField(
                                                      controller: Constants
                                                          .editTextList[pos]))
                                              : SizedBox(
                                                  width: 150,
                                                  height: 50,
                                                  child: Center(
                                                    child: Text(
                                                        Constants.remoteList[Constants.remoteList.keys.toList()[pos]]
                                                                .containsKey(
                                                                    "label")
                                                            ? Constants.remoteList[Constants.remoteList.keys.toList()[pos]]
                                                                        [
                                                                        "label"] ==
                                                                    ""
                                                                ? "no name"
                                                                : Constants.remoteList[Constants
                                                                        .remoteList
                                                                        .keys
                                                                        .toList()[pos]]
                                                                    ["label"]
                                                            : "no name",
                                                        style: textStyler(
                                                            color: Constants
                                                                .themeLight)),
                                                  ),
                                                ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                Constants.remoteList.remove(
                                                    Constants.remoteList.keys
                                                        .toList()[pos]);

                                                Constants.editTextList.remove(
                                                    Constants
                                                        .editTextList[pos]);
                                              });
                                              setItemList(jsonEncode({
                                                "e": "REMOTE_CHANGE",
                                                "r": widget.devicePos,
                                                "t": RestAPIConstants
                                                    .phoneNumberID
                                                    .toString(),
                                                "s": false,
                                              }));
                                            },
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  color: Constants.greenCol,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50))),
                                              child: Icon(
                                                Icons.close,
                                                color:
                                                    Constants.secondryDarkCol,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return Container(
                          alignment: Alignment.center,
                          width: getSize(context, isWidth: true),
                          height: getSize(context, isWidth: false),
                          child: ListView.builder(
                              itemCount: Constants.remoteList.keys.isNotEmpty
                                  ? Constants.remoteList.keys.length
                                  : 0,
                              padding: const EdgeInsets.only(
                                  top: 150, left: 15, right: 15, bottom: 30),
                              itemBuilder: (context, pos) {
                                return timerTypeDateMethod(context, pos: pos);
                              }),
                        );
                      },
                    ),
                    Container(
                      height: 0.24.sh,
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
                        padding: const EdgeInsets.only(left: 26.0, right: 26.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: getSize(context, isWidth: false)! /
                                          20),
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
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: getSize(context, isWidth: false)! /
                                          40),
                                  child: SizedBox(
                                    width: 0.4.sw,
                                    height: 120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          // "assets/svg/wifi_router.svg",
                                          "assets/svg/ssd.svg",
                                          color: Constants.themeLight,
                                          fit: BoxFit.fill,
                                          // width: getSize(context, isWidth: true)! / 8,
                                          width: 50.w,
                                        ),
                                        SizedBox(height: 0.015.sh),
                                        InkWell(
                                          onTap: () {
                                            NAlertDialog(
                                              title: Text("تغییر اسم دستگاه",
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  style: textStyler(
                                                      color: Constants
                                                          .themeLight)),
                                              content: SizedBox(
                                                  width: 150,
                                                  height: 50,
                                                  child: TextField(
                                                      controller:
                                                          deviceTagController)),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  child: Text("تایید",
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: textStyler(
                                                          color: Constants
                                                              .themeLight)),
                                                  onPressed: () {
                                                    setState(() {
                                                      Constants.itemList[Constants
                                                                      .itemList.keys
                                                                      .toList()[
                                                                  Constants
                                                                      .appbarMenuPosation]]
                                                              ["tag"] =
                                                          deviceTagController
                                                              .text;
                                                    });
                                                    BlocProvider.of<
                                                                ButtonDataCubit>(
                                                            context)
                                                        .changeStatus(
                                                            appbarPos: Constants
                                                                .appbarMenuPosation,
                                                            event:
                                                                "rename_device",
                                                            log:
                                                                """{"e":"RENAME_DEVICE","r":${Constants.appbarMenuPosation + 1},"t":${RestAPIConstants.phoneNumberID},"m":"${deviceTagController.text}"}""",
                                                            isEvent: false);
                                                    // BlocProvider.of<ButtonDataCubit>(context).getAllDevicesData(context, false);
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
                                                    deviceTagController.clear();
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
                                                padding: EdgeInsets.only(
                                                    right: 18.w),
                                                child: Text(
                                                  // "Relay ${Constants.bodyItemPosation}",
                                                  Constants.itemList[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
                                                                  ["tag"] !=
                                                              null &&
                                                          Constants
                                                              .itemList[
                                                                  Constants
                                                                      .itemList
                                                                      .keys
                                                                      .toList()[Constants.appbarMenuPosation]]
                                                                  ["tag"]
                                                              .isNotEmpty
                                                      ? Constants.itemList[Constants
                                                                  .itemList.keys
                                                                  .toList()[Constants.appbarMenuPosation]]
                                                              ["tag"] ??
                                                          ""
                                                      : "دستگاه ${Constants.appbarMenuPosation + 1}",
                                                  style: textStyler(
                                                      color:
                                                          Constants.themeLight,
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
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: getSize(context, isWidth: false)! /
                                          20),
                                  child: SizedBox(
                                    width: 50,
                                    child: InkWell(
                                      onTap: () {
                                        Map temp1;
                                        temp1 = jsonDecode(Constants.itemList[
                                                Constants.itemList.keys
                                                        .toList()[
                                                    Constants
                                                        .appbarMenuPosation]][
                                            Constants.isOnline == 'true'
                                                ? "device_Relay_Status"
                                                : "Device_Relay_Status"]);
                                        if (!temp1["1"].containsKey("delay")) {
                                          temp1.forEach((key, value) {
                                            if (!temp1[key]
                                                    .containsKey("delay") &&
                                                temp1[key]["tp"] == "r") {
                                              temp1[key]["delay"] = "0";
                                              Constants.itemList[Constants
                                                              .itemList.keys
                                                              .toList()[
                                                          Constants
                                                              .appbarMenuPosation]]
                                                      [
                                                      Constants.isOnline ==
                                                              'true'
                                                          ? "device_Relay_Status"
                                                          : "Device_Relay_Status"] =
                                                  jsonEncode(temp1);
                                            }
                                          });
                                        }
                                        Navigator.of(context)
                                            .pushNamed("/relaySettings");
                                      },
                                      child: Icon(
                                        Icons.settings,
                                        color: Constants.themeLight,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                              child: Text(
                                'تنظیمات ریموت‌ها',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.r),
                              ),
                            ),
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
}
