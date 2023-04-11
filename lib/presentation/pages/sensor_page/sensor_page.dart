import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ndialog/ndialog.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../../data/utils/server_constants.dart';
import '../../cubit/button_data_cubit.dart';

class SensorPage extends StatefulWidget {
  final int relayPos;
  final int devicePos;
  const SensorPage({Key? key, this.relayPos = 0, this.devicePos = 0})
      : super(key: key);

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  double hin = 0.15.sh;
  @override
  void initState() {
    super.initState();
    Constants.flagFolding = true;
    Constants.foldOutList.clear();
    Constants.itemListCurrentPage.forEach((key, value) {
      if (value["tp"] == "r") {
        Constants.foldOutList.add(false);
      }
    });
    if (Constants.itemList[Constants.itemList.keys
                .toList()[Constants.appbarMenuPosation]]["sensor"]
            .toString()
            .isNotEmpty &&
        Constants.itemList[Constants.itemList.keys
                    .toList()[Constants.appbarMenuPosation]]["sensor"]
                .toString()
                .length >
            10) {
      Constants.sensorData = jsonDecode(Constants.itemList[Constants
              .itemList.keys
              .toList()[Constants.appbarMenuPosation]]["sensor"] ??
          "");
    } else {
      Constants.itemList[Constants.itemList.keys
          .toList()[Constants.appbarMenuPosation]]["sensor"] = jsonEncode({
        "r1": {
          "type": "T",
          "mode": "Cooler",
          "tMax": 0.0,
          "tMin": 0.0,
          "hMax": 0.0,
          "hMin": 0.0,
          "s": false
        },
        "r2": {
          "type": "T",
          "mode": "Cooler",
          "tMax": 0.0,
          "tMin": 0.0,
          "hMax": 0.0,
          "hMin": 0.0,
          "s": false
        },
        "r3": {
          "type": "T",
          "mode": "Cooler",
          "tMax": 0.0,
          "tMin": 0.0,
          "hMax": 0.0,
          "hMin": 0.0,
          "s": false
        },
        "r4": {
          "type": "T",
          "mode": "Cooler",
          "tMax": 0.0,
          "tMin": 0.0,
          "hMax": 0.0,
          "hMin": 0.0,
          "s": false
        }
      });
      BlocProvider.of<ButtonDataCubit>(context).changeStatus(
          appbarPos: Constants.appbarMenuPosation,
          event: "UPDATE_SENSOR",
          log: "",
          isEvent: true);
      Constants.sensorData = jsonDecode(Constants.itemList[
              Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
          ["sensor"]);
    }
  }

  @override
  void dispose() {
    Constants.flagFolding = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            itemCount: Constants.foldOutList.length,
                            padding: EdgeInsets.only(
                                top: 0.2.sh,
                                left: 15.w,
                                right: 15.w,
                                bottom: 0.15.sh),
                            itemBuilder: (context, pos) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0.w, vertical: 12.0.h),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // hin == 0.15.sh ? hin = 0.6.sh : hin = 0.15.sh;
                                      Constants.foldOutList = [
                                        false,
                                        false,
                                        false,
                                        false
                                      ];
                                      Constants.foldOutList[pos] = true;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 350),
                                    decoration: BoxDecoration(
                                        color: Constants.secondryDarkCol,
                                        borderRadius:
                                            BorderRadius.circular(20.r)),
                                    width: double.infinity,
                                    height: Constants.foldOutList[pos]
                                        ? hin = 0.27.sh
                                        : hin = 0.14.sh,
                                    child: Constants.foldOutList[pos]
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    Constants.secondryDarkCol,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        18.r)),
                                            child:
                                                //--------------------------------
                                                SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: [
                                                  _sensorsHeadersMethod(
                                                      pos, context),
                                                  Container(
                                                    height: 0.08.sh,
                                                    padding: EdgeInsets.zero,
                                                    decoration: BoxDecoration(
                                                        color: Constants
                                                            .secondryDarkCol,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    18.r)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 35,
                                                              height: 35,
                                                              child: Constants.sensorData[
                                                                              "r${(pos + 1)}"]
                                                                          [
                                                                          "type"] ==
                                                                      "T"
                                                                  ? SvgPicture
                                                                      .asset(
                                                                      Constants.sensorData["r${(pos + 1)}"]["mode"] ==
                                                                              "Cooler"
                                                                          ? "assets/svg/cold.svg"
                                                                          : "assets/svg/hot.svg",
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Icon(Constants.sensorData["r${(pos + 1)}"]
                                                                              [
                                                                              "mode"] ==
                                                                          "Cooler"
                                                                      ? Icons
                                                                          .keyboard_double_arrow_down
                                                                      : Icons
                                                                          .keyboard_double_arrow_up_rounded),
                                                            ),
                                                            SizedBox(
                                                                width: 0.03.sw),
                                                            Text(
                                                              Constants.sensorData[
                                                                              "r${(pos + 1)}"]
                                                                          [
                                                                          "type"] ==
                                                                      "T"
                                                                  ? Constants.sensorData["r${(pos + 1)}"]
                                                                              [
                                                                              "mode"] ==
                                                                          "Cooler"
                                                                      ? "Cooler"
                                                                      : "Heater"
                                                                  : Constants.sensorData["r${(pos + 1)}"]
                                                                              [
                                                                              "mode"] ==
                                                                          "Cooler"
                                                                      ? "کاهشی"
                                                                      : "افزایشی",
                                                              style: textStyler(
                                                                  color: Constants
                                                                      .themeLight,
                                                                  fontsize:
                                                                      16.r),
                                                            ),
                                                            SizedBox(
                                                              width: 0.05.sw,
                                                            ),
                                                            Text(
                                                              ":  حالت سنسور",
                                                              style: textStyler(
                                                                  color: Constants
                                                                      .themeLight,
                                                                  fontsize:
                                                                      16.r),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Constants.relaySelected =
                                                          pos;
                                                      if (Constants
                                                              .itemListCurrentPage[(Constants
                                                                  .itemListCurrentPage
                                                                  .keys
                                                                  .toList()[pos])
                                                              .toString()]['rMode'] ==
                                                          'T') {
                                                        NDialog(
                                                          actions: [
                                                            MaterialButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                'خیر',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.r,
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            MaterialButton(
                                                              onPressed:
                                                                  () async {
                                                                var temp = Constants
                                                                    .itemListCurrentPage;
                                                                temp[(Constants
                                                                        .itemListCurrentPage
                                                                        .keys
                                                                        .toList()[pos])
                                                                    .toString()]['rMode'] = 'S';
                                                                Constants
                                                                    .itemList[Constants
                                                                        .itemList
                                                                        .keys
                                                                        .toList()[
                                                                    Constants
                                                                        .appbarMenuPosation]]['device_Relay_Status'] = jsonEncode(
                                                                    temp);
                                                                Constants.sensorData[
                                                                        "r${(pos + 1)}"]
                                                                    [
                                                                    "s"] = !Constants
                                                                        .sensorData[
                                                                    "r${(pos + 1)}"]["s"];
                                                                Constants
                                                                    .itemList[Constants
                                                                        .itemList
                                                                        .keys
                                                                        .toList()[
                                                                    Constants
                                                                        .appbarMenuPosation]]["sensor"] = jsonEncode(
                                                                    Constants
                                                                        .sensorData);
                                                                await BlocProvider.of<
                                                                            ButtonDataCubit>(
                                                                        context)
                                                                    .changeStatus(
                                                                        appbarPos:
                                                                            Constants
                                                                                .appbarMenuPosation,
                                                                        event:
                                                                            "Sensor_Data",
                                                                        log:
                                                                            """{"e":"Sensor_Data","r":${Constants.appbarMenuPosation},"t":${RestAPIConstants.phoneNumberID},"m":${Constants.relaySelected + 1}}""",
                                                                        isEvent:
                                                                            true);
                                                                //\\\\\\\\
                                                                if (Constants
                                                                        .itemList[
                                                                            Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
                                                                            [
                                                                            "sensor"]
                                                                        .toString()
                                                                        .isEmpty ||
                                                                    Constants
                                                                            .itemList[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]["sensor"]
                                                                            .toString() ==
                                                                        "{}") {
                                                                  Constants
                                                                      .itemList[Constants
                                                                          .itemList
                                                                          .keys
                                                                          .toList()[
                                                                      Constants
                                                                          .appbarMenuPosation]]["sensor"] = Constants
                                                                      .sensorDefualtString;
                                                                }

                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamedAndRemoveUntil(
                                                                        "/sensor_config",
                                                                        ModalRoute.withName(
                                                                            '/sensor'));
                                                              },
                                                              child: Text(
                                                                'بله',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.r,
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ],
                                                          title: Text(
                                                            "تداخل ویژگی ها",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18.r,
                                                                color: Colors
                                                                    .white),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          content: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12.0.r),
                                                            child: SizedBox(
                                                              height: 0.15.sh,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                        0.55.sw,
                                                                    child: Text(
                                                                      'خروجی توسط ${Constants.itemListCurrentPage[(Constants.itemListCurrentPage.keys.toList()[pos]).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} کنترل میشود آیا از تغییر اطمینان دارید؟',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              14.r),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        0.55.sw,
                                                                    child: Text(
                                                                      'در صورت انتخاب گزینه بله ${Constants.itemListCurrentPage[(Constants.itemListCurrentPage.keys.toList()[pos]).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} های خروجی غیر فعال میشود',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              14.r),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ).show(context);
                                                      } else {
                                                        //===============================================================
                                                        //===============================================================
                                                        if (Constants.itemList[
                                                                    Constants
                                                                            .itemList
                                                                            .keys
                                                                            .toList()[
                                                                        Constants
                                                                            .appbarMenuPosation]]
                                                                    ["sensor"]
                                                                .toString()
                                                                .isEmpty ||
                                                            Constants.itemList[
                                                                        Constants
                                                                            .itemList
                                                                            .keys
                                                                            .toList()[Constants.appbarMenuPosation]]
                                                                        [
                                                                        "sensor"]
                                                                    .toString() ==
                                                                "{}") {
                                                          Constants
                                                              .itemList[Constants
                                                                  .itemList.keys
                                                                  .toList()[
                                                              Constants
                                                                  .appbarMenuPosation]]["sensor"] = Constants
                                                              .sensorDefualtString;
                                                        }

                                                        Navigator.of(context)
                                                            .pushNamedAndRemoveUntil(
                                                                "/sensor_config",
                                                                ModalRoute.withName(
                                                                    '/sensor'));
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 0.3.sw,
                                                      height: 0.048.sh,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Constants
                                                              .greenCol,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          12.r),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          12.r))),
                                                      child: Text("تنظیم مجدد",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: textStyler(
                                                              color: Constants
                                                                  .themeLight,
                                                              fontsize: 16.r)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //--------------------------------
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Constants.secondryDarkCol,
                                              borderRadius:
                                                  BorderRadius.circular(18.r),
                                            ),
                                            child:
                                                //-----------------
                                                _sensorsHeadersMethod(
                                                    pos, context),
                                            //------------------
                                          ),
                                  ),
                                ),

                                //------------------------------------------------------
                              );
                            })),
                    Container(
                      height: 140,
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
                        child: Row(
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
                              width: 50,
                              height: 120,
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/temp_h.svg",
                                    color: Constants.themeLight,
                                    fit: BoxFit.cover,
                                    width: 0.1.sw,
                                  ),
                                  SizedBox(height: 0.01.sh),
                                  Text(
                                    Constants.itemListCurrentPage.keys.toList()[
                                                Constants.bodyItemPosation -
                                                    1] ==
                                            "sensor"
                                        ? "سنسور"
                                        : "Relay ${Constants.bodyItemPosation}",
                                    style:
                                        textStyler(color: Constants.themeLight),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 50),
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

  Row _sensorsHeadersMethod(int pos, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 0.2.sw,
          child: Constants.sensorData["r${(pos + 1)}"]["type"] == "T"
              ? Icon(Icons.device_thermostat_sharp,
                  size: 38.r, color: Constants.themeLight)
              : Icon(Icons.water_drop_rounded,
                  size: 38.r, color: Constants.themeLight),
        ),
        Column(
          children: [
            InkWell(
              onTap: () async {
                if (Constants.itemListCurrentPage[
                        (Constants.itemListCurrentPage.keys.toList()[pos])
                            .toString()]['rMode'] ==
                    'T') {
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
                          var temp = Constants.itemListCurrentPage;
                          temp[
                              (Constants.itemListCurrentPage.keys.toList()[pos])
                                  .toString()]['rMode'] = 'S';
                          Constants.itemList[Constants.itemList.keys
                                  .toList()[Constants.appbarMenuPosation]]
                              ['device_Relay_Status'] = jsonEncode(temp);
                          Constants.sensorData["r${(pos + 1)}"]["s"] =
                              !Constants.sensorData["r${(pos + 1)}"]["s"];
                          Constants.itemList[Constants.itemList.keys
                                  .toList()[Constants.appbarMenuPosation]]
                              ["sensor"] = jsonEncode(Constants.sensorData);
                          await BlocProvider.of<ButtonDataCubit>(context)
                              .changeStatus(
                                  appbarPos: Constants.appbarMenuPosation,
                                  event: "Sensor_Data",
                                  log:
                                      """{"e":"Sensor_Data","r":${Constants.appbarMenuPosation},"t":${RestAPIConstants.phoneNumberID},"m":${Constants.relaySelected + 1}}""",
                                  isEvent: true);
                          Navigator.pop(context);
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
                                'خروجی توسط ${Constants.itemListCurrentPage[(Constants.itemListCurrentPage.keys.toList()[pos]).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} کنترل میشود آیا از تغییر اطمینان دارید؟',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.r),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(
                              width: 0.55.sw,
                              child: Text(
                                'در صورت انتخاب گزینه بله ${Constants.itemListCurrentPage[(Constants.itemListCurrentPage.keys.toList()[pos]).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} های خروجی غیر فعال میشود',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.r),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).show(context);
                } else {
                  Constants.sensorData["r${(pos + 1)}"]["s"] =
                      !Constants.sensorData["r${(pos + 1)}"]["s"];
                  Constants.itemList[Constants.itemList.keys
                          .toList()[Constants.appbarMenuPosation]]["sensor"] =
                      jsonEncode(Constants.sensorData);
                  var temp = Constants.itemListCurrentPage;
                  temp[(Constants.itemListCurrentPage.keys.toList()[pos])
                      .toString()]['rMode'] = 'S';
                  Constants.itemList[Constants.itemList.keys
                          .toList()[Constants.appbarMenuPosation]]
                      ['device_Relay_Status'] = jsonEncode(temp);

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
                    await BlocProvider.of<ButtonDataCubit>(context).changeStatus(
                        appbarPos: Constants.appbarMenuPosation,
                        event: "Sensor_Data",
                        log:
                            """{"e":"Sensor_Data","r":${Constants.appbarMenuPosation},"t":${RestAPIConstants.phoneNumberID},"m":${Constants.relaySelected + 1}}""",
                        isEvent: true);
                    // await BlocProvider.of<ButtonDataCubit>(context)
                    //     .changeStatusButton(
                    //         appbarPos: (Constants.appbarMenuPosation),
                    //         itemPos: Constants.bodyItemPosation)
                    //     .timeout(const Duration(seconds: 10));
                  }
                }
              },
              child: Container(
                width: 0.15.sw,
                height: 0.04.sh,
                decoration: BoxDecoration(
                    color: Constants.sensorData["r${(pos + 1)}"]["s"]
                        ? Constants.greenCol
                        : Constants.primeryDarkCol,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8.r),
                        bottomLeft: Radius.circular(8.r))),
                child: Icon(
                  Icons.power_settings_new_rounded,
                  color: Constants.themeLight.withAlpha(180),
                ),
              ),
            ),
            Text(
              Constants.itemListCurrentPage[
                          Constants.itemListCurrentPage.keys.toList()[pos]]
                      .containsKey("tag")
                  ? Constants.itemListCurrentPage[
                              Constants.itemListCurrentPage.keys.toList()[pos]]
                          ["tag"] ??
                      ""
                  : "خروجی ${pos + 1}",
            ),
            Container(
                width: 1,
                height: 0.065.sh,
                color: Constants.themeLight.withAlpha(150)),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 0.2.sw,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_drop_up, color: Constants.themeLight),
                  Text(
                    Constants.sensorData["r${(pos + 1)}"]["type"] == "T"
                        ? '${Constants.sensorData["r${(pos + 1)}"]["tMax"]}'
                        : '${Constants.sensorData["r${(pos + 1)}"]["hMax"]}',
                    textAlign: TextAlign.center,
                    style:
                        textStyler(fontsize: 16.r, color: Constants.themeLight),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 0.2.sw,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_drop_down, color: Constants.themeLight),
                  Text(
                    Constants.sensorData["r${(pos + 1)}"]["type"] == "T"
                        ? '${Constants.sensorData["r${(pos + 1)}"]["tMin"]}'
                        : '${Constants.sensorData["r${(pos + 1)}"]["hMin"]}',
                    textAlign: TextAlign.center,
                    style:
                        textStyler(fontsize: 16.r, color: Constants.themeLight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
