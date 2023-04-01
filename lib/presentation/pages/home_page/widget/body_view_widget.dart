import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ndialog/ndialog.dart';
import 'package:asatic/data/utils/app_constants.dart';
import 'package:asatic/data/utils/functions_helper.dart';
import 'package:asatic/presentation/cubit/button_data_cubit.dart';
import 'package:asatic/presentation/pages/home_page/widget/tile_button_widget.dart';

class BodyViewWidget extends StatefulWidget {
  const BodyViewWidget({Key? key}) : super(key: key);

  @override
  State<BodyViewWidget> createState() => _BodyViewWidgetState();
}

class _BodyViewWidgetState extends State<BodyViewWidget> {
  @override
  void dispose() {
    if (!(Constants.isOnline == 'true')) {
      Constants.stream!.pause();
      Constants.stream!.cancel();
      Constants.stream = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(Constants.isOnline == 'true')) {
      Constants.stream ??= offlineListener().listen((event) async {
        setState(() {
          Constants.itemList = event;
          Constants.itemListCurrentPage = jsonDecode(
              Constants.itemList[Constants.itemList.keys.toList()[Constants.deviceSelectedIndex]]
                  ["Device_Relay_Status"]);
          if (Constants.itemList[Constants.itemList.keys.toList()[Constants.deviceSelectedIndex]]
                      ["sensor_data"] !=
                  "{}" &&
              Constants
                  .itemList[Constants.itemList.keys.toList()[Constants.deviceSelectedIndex]]["sensor_data"]
                  .isNotEmpty) {
            Constants.sensorSocketData["10001"] = {};
            Constants.sensorSocketData["10001"]["temp"] =
                jsonDecode(Constants.itemList["10001"]["sensor_data"])["temp"];
            Constants.sensorSocketData["10001"]["humidity"] = jsonDecode(
                Constants.itemList["10001"]["sensor_data"])["humidity"];
          }
        });
      });
    }
    return BlocBuilder<ButtonDataCubit, ButtonDataState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Constants.thirdryDarkCol,
            width: 1.sw,
            height: 600.h,
            child: InkWell(
              onTap: () {
                if (Constants.itemList[Constants.itemList.keys
                        .toList()[Constants.appbarMenuPosation]
                        .toString()]["status_Conect"] ==
                    false) {
                  NAlertDialog(
                    dialogStyle: DialogStyle(titleDivider: true),
                    title: Text("مشکل در اتصال",
                        textDirection: TextDirection.rtl,
                        style: textStyler(
                            color: Constants.themeLight,
                            fontWeight: FontWeight.bold,
                            fontsize: 18.r)),
                    content: Text(
                        "لطفا از اتصال دستگاه به برق و اینترنت اطمینان حاصل کنید",
                        textDirection: TextDirection.rtl,
                        style: textStyler(
                            color: Constants.themeLight, fontsize: 16.r)),
                    actions: <Widget>[
                      MaterialButton(
                        child: Text("تلاش مجدد",
                            textDirection: TextDirection.rtl,
                            style: textStyler(color: Constants.themeLight)),
                        onPressed: () async {
                          await BlocProvider.of<ButtonDataCubit>(context)
                              .getAllDevicesData(context, true);
                          Navigator.of(context).pop();
                        },
                      ),
                      MaterialButton(
                        child: Text("لغو",
                            textDirection: TextDirection.rtl,
                            style: textStyler(color: Constants.themeLight)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ).show(context);
                }
              },
              child: Constants.itemList[Constants.itemList.keys
                          .toList()[Constants.appbarMenuPosation]
                          .toString()]["status_Conect"] ==
                      false
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 0.7.sw,
                        height: 0.5.sh,
                        child: Icon(
                          Icons.wifi_off_sharp,
                          size: 260.r,
                        ),
                      ),
                    )
                  : IgnorePointer(
                      ignoring: Constants.itemList.isNotEmpty
                          ? Constants.itemList[Constants.itemList.keys
                                  .toList()[Constants.appbarMenuPosation]
                                  .toString()]["status_Conect"] ==
                              false
                          : false,
                      child: GridView.builder(
                          padding: EdgeInsets.only(
                            top: 0.22.sh,
                            right: 30.h,
                            left: 30.h,
                            bottom: 0.05.sh,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 15,
                            mainAxisExtent: 0.2.sh,
                          ),
                          itemCount: Constants.itemList.isNotEmpty ||
                                  Constants.itemList.keys.toList().isNotEmpty &&
                                      Constants.itemList.containsKey(Constants.itemList.keys.toList()[Constants.appbarMenuPosation])
                              ? Constants.itemList[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]["chanel_Count"] > 0
                                  ? (Constants.itemList[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]["chanel_Count"])
                                  : 0
                              : 0,
                          itemBuilder: (context, posation) {
                            return TileButtonWidget(
                              isNotSensor: Constants.itemListCurrentPage[
                                      Constants.itemListCurrentPage.keys
                                          .toList()[posation]]["tp"] ==
                                  "r",
                              index: posation,
                            );
                          })),
            ),
          ),
        );
      },
    );
  }
}
