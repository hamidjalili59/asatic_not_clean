import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../../data/utils/server_constants.dart';
import '../../cubit/button_data_cubit.dart';

class SensorConfigPage extends StatefulWidget {
  const SensorConfigPage({Key? key}) : super(key: key);

  @override
  State<SensorConfigPage> createState() => _SensorConfigPageState();
}

class _SensorConfigPageState extends State<SensorConfigPage> {
  String selectedValue = 'max';
  @override
  void initState() {
    super.initState();
    Constants.sensorData = (jsonDecode(Constants.itemList[Constants
                .itemList.keys
                .toList()[Constants.appbarMenuPosation]]["sensor"] ??
            "")) ??
        {};
    Constants.isTempConfigPage =
        Constants.sensorData["r${(Constants.relaySelected + 1)}"]["type"] == "T"
            ? true
            : false;
    if (Constants.sensorData["r${(Constants.relaySelected + 1)}"]["type"] ==
        "H") {
      if (Constants.currentSensorMode == "Cooler") {
        Constants.currentSensorMode = "کاهشی";
      } else {
        Constants.currentSensorMode = "افزایشی";
      }
    } else {
      if (Constants.currentSensorMode == "کاهشی") {
        Constants.currentSensorMode = "Cooler";
      } else {
        Constants.currentSensorMode = "Heater";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ////

    Widget circularRangeSliderTest(
        double min, double max, bool isTemp, bool draggable) {
      return Stack(
        children: [
          SfRadialGauge(axes: <RadialAxis>[
            RadialAxis(
              minimum: isTemp ? -20 : 0,
              maximum: isTemp ? 120 : 100,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: min,
                    endValue: max,
                    color: Constants.greenCol,
                    startWidth: 50.r,
                    endWidth: 50.r),
              ],
              pointers: [
                WidgetPointer(
                  value: max,
                  enableDragging: true,
                  onValueChanged: (val) {
                    setState(() {
                      selectedValue = 'max';
                      if (isTemp) {
                        Constants
                                .sensorData["r${(Constants.relaySelected + 1)}"]
                            ["tMax"] = double.parse((val).toStringAsFixed(1));
                      } else {
                        Constants
                                .sensorData["r${(Constants.relaySelected + 1)}"]
                            ["hMax"] = double.parse((val).toStringAsFixed(1));
                      }
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedValue = 'max';
                      });
                    },
                    child: SizedBox(
                      width: 70.r,
                      height: 70.r,
                      child: Center(
                        child: Container(
                          width: 50.r,
                          height: 50.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: selectedValue == 'max'
                                  ? Colors.green
                                  : Constants.greenCol,
                              borderRadius: BorderRadius.circular(36.r)),
                          child: Text(
                            max > min ? "Max" : "Min",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                WidgetPointer(
                  value: min,
                  enableDragging: true,
                  onValueChanged: (val) {
                    setState(() {
                      selectedValue = 'min';
                      if (isTemp) {
                        Constants
                                .sensorData["r${(Constants.relaySelected + 1)}"]
                            ["tMin"] = double.parse((val).toStringAsFixed(1));
                      } else {
                        Constants
                                .sensorData["r${(Constants.relaySelected + 1)}"]
                            ["hMin"] = double.parse((val).toStringAsFixed(1));
                      }
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedValue = 'min';
                      });
                    },
                    child: SizedBox(
                      width: 70.r,
                      height: 70.r,
                      child: Center(
                          child: Container(
                        width: 50.r,
                        height: 50.r,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: selectedValue == 'min'
                                ? Colors.green
                                : Constants.greenCol,
                            borderRadius: BorderRadius.circular(36.r)),
                        child: Text(
                          max < min ? "Max" : "Min",
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                    ),
                  ),
                ),
              ],
              canRotateLabels: false,
              showLastLabel: false,
              showAxisLine: true,
              showLabels: false,
              showTicks: false,
              axisLineStyle: AxisLineStyle(
                  thickness: 50.r, cornerStyle: CornerStyle.bothCurve),
            )
          ]),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedValue == "min") {
                        min = min - 0.1;
                      } else {
                        max = max - 0.1;
                      }
                      if (isTemp &&
                          (selectedValue == "min" ? min : max) >= -20) {
                        Constants.sensorData[
                                    "r${(Constants.relaySelected + 1)}"]
                                [(selectedValue == "min" ? "tMin" : "tMax")] =
                            double.parse((selectedValue == "min" ? min : max)
                                .toStringAsFixed(1));
                      } else if (!isTemp &&
                          (selectedValue == "min" ? min : max) >= 0) {
                        Constants.sensorData[
                                    "r${(Constants.relaySelected + 1)}"]
                                [(selectedValue == "min" ? "hMin" : "hMax")] =
                            double.parse((selectedValue == "min" ? min : max)
                                .toStringAsFixed(1));
                      }
                    });
                  },
                  child: SizedBox(
                    width: 0.14.sw,
                    height: 0.14.sw,
                    child: Icon(
                      Icons.remove,
                      size: 46.r,
                    ),
                  ),
                ),
                SizedBox(
                  width: 0.155.sw,
                  height: 0.14.sh,
                  child: Center(
                    child: Text(
                      isTemp
                          ? 'از\n${max > min ? min : max}\u2103\nتا\n${max > min ? max : min}\u2103'
                          : 'از\n${max > min ? min : max}%\nتا\n${max > min ? max : min}%',
                      style: TextStyle(
                          fontSize: 14.r, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedValue == "min") {
                        min = min + 0.1;
                      } else {
                        max = max + 0.1;
                      }
                      if (isTemp &&
                          (selectedValue == "min" ? min : max) <= 120) {
                        Constants.sensorData[
                                    "r${(Constants.relaySelected + 1)}"]
                                [selectedValue == "min" ? "tMin" : "tMax"] =
                            double.parse((selectedValue == "min" ? min : max)
                                .toStringAsFixed(1));
                      } else if (!isTemp &&
                          (selectedValue == "min" ? min : max) <= 100) {
                        Constants.sensorData[
                                    "r${(Constants.relaySelected + 1)}"]
                                [selectedValue == "min" ? "hMin" : "hMax"] =
                            double.parse((selectedValue == "min" ? min : max)
                                .toStringAsFixed(1));
                      }
                    });
                  },
                  child: SizedBox(
                    width: 0.14.sw,
                    height: 0.14.sw,
                    child: Icon(
                      Icons.add,
                      size: 46.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

////
    return BaseWidget(
      backgroundColor: Constants.primeryDarkCol,
      child: Center(
        child: SizedBox(
          width: getSize(context, isWidth: true)! / 1.1,
          height: getSize(context, isWidth: false)! / 1.1,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 55.w,
                        height: 60.h,
                        child: Icon(
                          Icons.close,
                          color: Constants.greenCol,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 18.0.r),
                      child: Text(
                        Constants.itemListCurrentPage[Constants
                                    .itemListCurrentPage.keys
                                    .toList()[Constants.relaySelected]]
                                .containsKey("tag")
                            ? "تنظیمات سنسور ${Constants.itemListCurrentPage[Constants.itemListCurrentPage.keys.toList()[Constants.relaySelected]]["tag"]}"
                            : "تنظیمات سنسور خروجی ${Constants.relaySelected + 1}",
                        style: textStyler(
                            color: Constants.greenCol,
                            fontWeight: FontWeight.bold,
                            fontsize: 18.r),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Constants
                                .sensorData["r${(Constants.relaySelected + 1)}"]
                            ["s"] = true;
                        if (Constants.currentSensorMode == "Cooler" ||
                            Constants.currentSensorMode == "کاهشی") {
                          Constants.sensorData[
                                  "r${(Constants.relaySelected + 1)}"]["mode"] =
                              "Cooler";
                        } else {
                          Constants.sensorData[
                                  "r${(Constants.relaySelected + 1)}"]["mode"] =
                              "Heater";
                        }
                        if (Constants.sensorData[
                                "r${(Constants.relaySelected + 1)}"]["tMax"] <
                            Constants.sensorData[
                                "r${(Constants.relaySelected + 1)}"]["tMin"]) {
                          double temp = Constants.sensorData[
                              "r${(Constants.relaySelected + 1)}"]["tMax"];
                          Constants.sensorData[
                                  "r${(Constants.relaySelected + 1)}"]["tMax"] =
                              Constants.sensorData[
                                  "r${(Constants.relaySelected + 1)}"]["tMin"];
                          Constants.sensorData[
                                  "r${(Constants.relaySelected + 1)}"]["tMin"] =
                              temp;
                        }
                        if (Constants.sensorData[
                                "r${(Constants.relaySelected + 1)}"]["hMax"] <
                            Constants.sensorData[
                                "r${(Constants.relaySelected + 1)}"]["hMin"]) {
                          double temp = Constants.sensorData[
                              "r${(Constants.relaySelected + 1)}"]["hMax"];
                          Constants.sensorData[
                                  "r${(Constants.relaySelected + 1)}"]["hMax"] =
                              Constants.sensorData[
                                  "r${(Constants.relaySelected + 1)}"]["hMin"];
                          Constants.sensorData[
                                  "r${(Constants.relaySelected + 1)}"]["hMin"] =
                              temp;
                        }

                        Constants.itemList[Constants.itemList.keys
                                .toList()[Constants.appbarMenuPosation]]
                            ["sensor"] = jsonEncode(Constants.sensorData);
                        BlocProvider.of<ButtonDataCubit>(context).changeStatus(
                            appbarPos: Constants.appbarMenuPosation,
                            event: "Sensor_Data",
                            log:
                                """{"e":"Sensor_Data","r":${Constants.appbarMenuPosation},"t":${RestAPIConstants.phoneNumberID},"m":${Constants.relaySelected + 1}}""",
                            isEvent: false);
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        width: 55.w,
                        height: 60.h,
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
                flex: 11,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            color: Constants.secondryDarkCol,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16.r),
                                topLeft: Radius.circular(16.r),
                                bottomLeft: Radius.circular(16.r),
                                bottomRight: Radius.circular(16.r))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 0.02.sh),
                            SizedBox(
                                width: 0.85.sw,
                                height: 0.38.sh,
                                child: circularRangeSliderTest(
                                    Constants.isTempConfigPage
                                        ? Constants.sensorData[
                                                "r${(Constants.relaySelected + 1)}"]
                                            ["tMin"]
                                        : Constants.sensorData[
                                                "r${(Constants.relaySelected + 1)}"]
                                            ["hMin"],
                                    Constants.isTempConfigPage
                                        ? Constants.sensorData[
                                                "r${(Constants.relaySelected + 1)}"]
                                            ["tMax"]
                                        : Constants.sensorData[
                                                "r${(Constants.relaySelected + 1)}"]
                                            ["hMax"],
                                    Constants.isTempConfigPage,
                                    true)),
                            Container(
                              width: 0.8.sw,
                              height: 0.1.sh,
                              decoration: BoxDecoration(
                                  color: Constants.primeryDarkCol,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (Constants.sensorData[
                                                    "r${(Constants.relaySelected + 1)}"]
                                                ["type"] ==
                                            "H") {
                                          if (Constants.currentSensorMode ==
                                              "کاهشی") {
                                            Constants.currentSensorMode =
                                                "Cooler";
                                          } else {
                                            Constants.currentSensorMode =
                                                "Heater";
                                          }
                                        }
                                        Constants.isTempConfigPage = true;
                                        Constants.sensorData[
                                                "r${(Constants.relaySelected + 1)}"]
                                            ["type"] = "T";
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constants.isTempConfigPage
                                              ? Constants.greenCol
                                              : Constants.primeryDarkCol,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8.r),
                                              bottomLeft:
                                                  Radius.circular(8.r))),
                                      width: 0.395.sw,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.device_thermostat_sharp,
                                              color: Constants.themeLight),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 0.15.sw,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.arrow_drop_up,
                                                        color: Constants
                                                            .themeLight),
                                                    Text(
                                                      Constants.sensorData[
                                                                      "r${(Constants.relaySelected + 1)}"]
                                                                  ["tMax"] >
                                                              Constants.sensorData[
                                                                      "r${(Constants.relaySelected + 1)}"]
                                                                  ["tMin"]
                                                          ? Constants
                                                              .sensorData[
                                                                  "r${(Constants.relaySelected + 1)}"]
                                                                  ["tMax"]
                                                              .toString()
                                                          : Constants
                                                              .sensorData[
                                                                  "r${(Constants.relaySelected + 1)}"]
                                                                  ["tMin"]
                                                              .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyler(
                                                          fontsize: 14.r,
                                                          color: Constants
                                                              .themeLight),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.15.sw,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.arrow_drop_down,
                                                        color: Constants
                                                            .themeLight),
                                                    Text(
                                                      Constants.sensorData[
                                                                      "r${(Constants.relaySelected + 1)}"]
                                                                  ["tMax"] >
                                                              Constants.sensorData[
                                                                      "r${(Constants.relaySelected + 1)}"]
                                                                  ["tMin"]
                                                          ? Constants
                                                              .sensorData[
                                                                  "r${(Constants.relaySelected + 1)}"]
                                                                  ["tMin"]
                                                              .toString()
                                                          : Constants
                                                              .sensorData[
                                                                  "r${(Constants.relaySelected + 1)}"]
                                                                  ["tMax"]
                                                              .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyler(
                                                          fontsize: 14.r,
                                                          color: Constants
                                                              .themeLight),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //
                                  Container(
                                    width: 2,
                                    height: 0.098.sh,
                                    color:
                                        Constants.themeLight.withOpacity(0.5),
                                  ),
                                  //
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (Constants.sensorData[
                                                    "r${(Constants.relaySelected + 1)}"]
                                                ["type"] ==
                                            "T") {
                                          if (Constants.currentSensorMode ==
                                              "Cooler") {
                                            Constants.currentSensorMode =
                                                "کاهشی";
                                          } else {
                                            Constants.currentSensorMode =
                                                "افزایشی";
                                          }
                                          Constants.isTempConfigPage = false;
                                          Constants.sensorData[
                                                  "r${(Constants.relaySelected + 1)}"]
                                              ["type"] = "H";
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constants.isTempConfigPage ==
                                                  false
                                              ? Constants.greenCol
                                              : Constants.primeryDarkCol,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(8.r),
                                              bottomRight:
                                                  Radius.circular(8.r))),
                                      width: 0.395.sw,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.water_drop_rounded,
                                              color: Constants.themeLight),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 0.15.sw,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.arrow_drop_up,
                                                        color: Constants
                                                            .themeLight),
                                                    Text(
                                                      Constants.sensorData[
                                                                      "r${(Constants.relaySelected + 1)}"]
                                                                  ["hMax"] >
                                                              Constants.sensorData[
                                                                      "r${(Constants.relaySelected + 1)}"]
                                                                  ["hMin"]
                                                          ? Constants
                                                              .sensorData[
                                                                  "r${(Constants.relaySelected + 1)}"]
                                                                  ["hMax"]
                                                              .toString()
                                                          : Constants
                                                              .sensorData[
                                                                  "r${(Constants.relaySelected + 1)}"]
                                                                  ["hMin"]
                                                              .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyler(
                                                          fontsize: 14.r,
                                                          color: Constants
                                                              .themeLight),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.15.sw,
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.arrow_drop_down,
                                                        color: Constants
                                                            .themeLight),
                                                    Text(
                                                      Constants.sensorData[
                                                                      "r${(Constants.relaySelected + 1)}"]
                                                                  ["hMax"] >
                                                              Constants.sensorData[
                                                                      "r${(Constants.relaySelected + 1)}"]
                                                                  ["hMin"]
                                                          ? Constants
                                                              .sensorData[
                                                                  "r${(Constants.relaySelected + 1)}"]
                                                                  ["hMin"]
                                                              .toString()
                                                          : Constants
                                                              .sensorData[
                                                                  "r${(Constants.relaySelected + 1)}"]
                                                                  ["hMax"]
                                                              .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: textStyler(
                                                          fontsize: 14.r,
                                                          color: Constants
                                                              .themeLight),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //
                            //!
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                    width: 0.2.sw,
                                    height: 0.15.sh,
                                    child: Icon(
                                      Icons.help,
                                      size: 26.r,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 0.4.sw,
                                  height: 0.15.sh,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      dropdownWidth: 0.5.sw,
                                      alignment: Alignment.center,
                                      style: textStyler(),
                                      isExpanded: true,
                                      items: (Constants.sensorData[
                                                          "r${(Constants.relaySelected + 1)}"]
                                                      ["type"] ==
                                                  "T"
                                              ? ["Heater", "Cooler"]
                                              : ["افزایشی", "کاهشی"])
                                          .toList()
                                          .map(
                                        (item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.w),
                                                  child: Text(
                                                    item,
                                                    style: TextStyle(
                                                        fontSize: 14.r,
                                                        color: Constants
                                                            .themeLight),
                                                  ),
                                                ),
                                                const Spacer(),
                                                SizedBox(
                                                  width: 35,
                                                  height: 35,
                                                  child: Constants.sensorData[
                                                                  "r${(Constants.relaySelected + 1)}"]
                                                              ["type"] ==
                                                          "T"
                                                      ? SvgPicture.asset(
                                                          item == "Cooler"
                                                              ? "assets/svg/cold.svg"
                                                              : "assets/svg/hot.svg",
                                                          color: Colors.white,
                                                        )
                                                      : Icon(item == "افزایشی"
                                                          ? Icons
                                                              .keyboard_double_arrow_up_rounded
                                                          : Icons
                                                              .keyboard_double_arrow_down),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      value: Constants.currentSensorMode,
                                      onChanged: (value) {
                                        setState(() {
                                          Constants.currentSensorMode =
                                              value.toString();
                                        });
                                      },
                                      buttonHeight: 80.h,
                                      buttonWidth: 50.w,
                                      itemHeight: 80.h,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 0.2.sw,
                                  height: 50,
                                ),
                              ],
                            ),
                          ],
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
  }
}
