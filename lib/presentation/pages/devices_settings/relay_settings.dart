import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../../data/utils/server_constants.dart';
import '../../cubit/button_data_cubit.dart';

class RelaySettings extends StatefulWidget {
  const RelaySettings({Key? key}) : super(key: key);

  @override
  State<RelaySettings> createState() => _RelaySettingsState();
}

class _RelaySettingsState extends State<RelaySettings> {
  Map temp = {};
  @override
  void initState() {
    super.initState();
    var dataClone = jsonDecode(Constants.itemList[
            Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
        [Constants.isOnline == 'true' ? "device_Relay_Status" : "Device_Relay_Status"]);
    jsonDecode(Constants.itemList[
                Constants.itemList.keys.toList()[Constants.appbarMenuPosation]][
            Constants.isOnline == 'true' ? "device_Relay_Status" : "Device_Relay_Status"])
        .forEach((key, value) {
      if (value["tp"] == "r" && value.keys.contains("delay")) {
        temp[key] = {
          "type":
              double.parse(dataClone[key]["delay"]) > 0 ? "toggle" : "on/off",
          "delay": dataClone[key]["delay"],
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget changeRelayTypeMethod(int pos, BuildContext ctx) {
      return SizedBox(
        width: double.infinity,
        height: getSize(context, isWidth: false)! / 10,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(child: Text("رله ${pos + 1}")),
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
                flex: 3,
                // child: Container(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      icon: SizedBox(
                        child: Icon(Icons.arrow_drop_down,
                            size: 20, color: Constants.themeLight),
                      ),
                      isExpanded: false,
                      items: ["on/off", "toggle"]
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: temp[temp.keys.toList()[pos]]["type"],
                      onChanged: (value) {
                        if (temp[temp.keys.toList()[pos]]["delay"] == "0" &&
                            temp[temp.keys.toList()[pos]]["type"] == "on/off") {
                          temp[temp.keys.toList()[pos]]["delay"] = "1";
                        }
                        setState(() {
                          temp[temp.keys.toList()[pos]]["type"] =
                              value as String;
                        });
                      },
                    ),
                  ),
                )),
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      "s",
                      style: textStyler(
                          color:
                              (temp[temp.keys.toList()[pos]]["type"] ?? "") ==
                                      "toggle"
                                  ? Constants.themeLight
                                  : Constants.thirdryDarkCol),
                    ),
                    IgnorePointer(
                      ignoring: (temp[temp.keys.toList()[pos]]["type"] ?? "") ==
                          "on/off",
                      child: temp[temp.keys.toList()[pos]]["delay"] == "0" ||
                              temp[temp.keys.toList()[pos]]["type"] == "on/off"
                          ? Text(
                              "0",
                              style: textStyler(
                                  color: (temp[temp.keys.toList()[pos]]
                                                  ["type"] ??
                                              "") ==
                                          "toggle"
                                      ? Constants.themeLight
                                      : Constants.thirdryDarkCol),
                            )
                          : DropdownButtonHideUnderline(
                              child: DropdownButton(
                                icon: SizedBox(
                                  child: Icon(Icons.arrow_drop_down,
                                      size: 20,
                                      color: (temp[temp.keys.toList()[pos]]
                                                      ["type"] ??
                                                  "") ==
                                              "toggle"
                                          ? Constants.themeLight
                                          : Constants.thirdryDarkCol),
                                ),
                                isExpanded: false,
                                items: [
                                  '0.5',
                                  '1',
                                  '2',
                                  '3',
                                  '4',
                                  '5',
                                  '6',
                                  '7',
                                  '8',
                                  '9',
                                  '10'
                                ]
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.toString(),
                                          child: Text(
                                            item.toString(),
                                            style: textStyler(
                                                color: (temp[temp.keys.toList()[
                                                                pos]]["type"] ??
                                                            "") ==
                                                        "toggle"
                                                    ? Constants.themeLight
                                                    : Constants.thirdryDarkCol),
                                            textAlign: TextAlign.center,
                                          ),
                                        ))
                                    .toList(),
                                value: temp[temp.keys.toList()[pos]]["delay"]
                                    .toString(),
                                onChanged: (value) {
                                  setState(() {
                                    temp[temp.keys.toList()[pos]]["delay"] =
                                        value as String;
                                  });
                                },
                              ),
                            ),
                    ),
                  ],
                )),
          ],
        ),
      );
    }

    return BaseWidget(
        backgroundColor: Constants.primeryDarkCol,
        child: Center(
          child: SizedBox(
            width: getSize(context, isWidth: true)! / 1.1,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 8, bottom: 8, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
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
                        "تنظیم رله ها",
                        style: textStyler(
                          color: Constants.greenCol,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Map dataTemp = jsonDecode(Constants.itemList[Constants
                                  .itemList.keys
                                  .toList()[Constants.appbarMenuPosation]][
                              Constants.isOnline == 'true'
                                  ? "device_Relay_Status"
                                  : "Device_Relay_Status"]);
                          dataTemp.forEach((key, value) {
                            if (temp[key]["type"] == "toggle") {
                              dataTemp[key]["delay"] = temp[key]["delay"];
                            } else {
                              dataTemp[key]["delay"] = "0";
                            }
                          });
                          Constants.itemList[Constants.itemList.keys
                              .toList()[Constants.appbarMenuPosation]][Constants
                                  .isOnline == 'true'
                              ? "device_Relay_Status"
                              : "Device_Relay_Status"] = jsonEncode(dataTemp);
                          BlocProvider.of<ButtonDataCubit>(context).changeStatus(
                              appbarPos: Constants.appbarMenuPosation,
                              event: "UPDATE_REMOTE",
                              isEvent: true,
                              log:
                                  """{"e":"UPDATE_RELAY","r":${Constants.bodyItemPosation - 1},"t":${RestAPIConstants.phoneNumberID}}""");
                          Navigator.pop(context);
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
                  const SizedBox(height: 100),
                  SizedBox(
                    width: double.infinity,
                    height: getSize(context, isWidth: false)! / 2,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    "شماره رله",
                                    textAlign: TextAlign.center,
                                    style: textStyler(
                                        color: Constants.themeLight,
                                        fontsize: 16),
                                  )),
                              const Expanded(flex: 2, child: SizedBox()),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    "حالت",
                                    textAlign: TextAlign.center,
                                    style: textStyler(
                                        color: Constants.themeLight,
                                        fontsize: 16),
                                  )),
                              const Expanded(flex: 2, child: SizedBox()),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    "تاخیر",
                                    textAlign: TextAlign.center,
                                    style: textStyler(
                                        color: Constants.themeLight,
                                        fontsize: 16),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                changeRelayTypeMethod(0, context),
                                changeRelayTypeMethod(1, context),
                                changeRelayTypeMethod(2, context),
                                changeRelayTypeMethod(3, context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
