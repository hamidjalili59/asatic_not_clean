import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ndialog/ndialog.dart';
import 'package:asatic/data/utils/app_constants.dart';
import 'package:asatic/data/utils/functions_helper.dart';
import 'package:asatic/presentation/cubit/button_data_cubit.dart';

class TileButtonWidget extends StatelessWidget {
  const TileButtonWidget({this.index = 0, this.isNotSensor = false, Key? key})
      : super(key: key);

  final int index;
  final bool isNotSensor;

  @override
  Widget build(BuildContext context) {
    void onLongPress(bool isNotSensor) {
      if (isNotSensor) {
        Constants.bodyItemPosation = index + 1;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/timer", ModalRoute.withName('/home'));
      } else {
        Constants.bodyItemPosation = index + 1;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/sensor", ModalRoute.withName('/home'));
      }
    }

    Future<void> onTap(bool isNotSensor, BuildContext context) async {
      if (Constants.itemListCurrentPage[(index + 1).toString()]['rMode'] ==
              'T' ||
          Constants.itemListCurrentPage[(index + 1).toString()]['rMode'] ==
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
                Constants.itemListCurrentPage[(index + 1).toString()]['rMode'] =
                    'M';
                if (Constants.isOnline == 'false') {
                  await isNotConnectedToWifi().then((value) async {
                    if (value) {
                      await BlocProvider.of<ButtonDataCubit>(context)
                          .changeStatusButton(
                              appbarPos: (Constants.appbarMenuPosation),
                              itemPos: (index));
                    }
                  });
                } else {
                  await BlocProvider.of<ButtonDataCubit>(context)
                      .changeStatusButton(
                          appbarPos: (Constants.appbarMenuPosation),
                          itemPos: (index))
                      .timeout(const Duration(seconds: 10));
                }

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
                      'خروجی توسط ${Constants.itemListCurrentPage[(index + 1).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} کنترل میشود آیا از تغییر اطمینان دارید؟',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14.r),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 0.55.sw,
                    child: Text(
                      'در صورت انتخاب گزینه بله ${Constants.itemListCurrentPage[(index + 1).toString()]['rMode'] == "T" ? 'تایمر' : 'سنسور'} های خروجی غیر فعال میشود',
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
        if (isNotSensor) {
          if (Constants.isOnline == 'false') {
            await isNotConnectedToWifi().then((value) async {
              if (value) {
                await BlocProvider.of<ButtonDataCubit>(context)
                    .changeStatusButton(
                        appbarPos: (Constants.appbarMenuPosation),
                        itemPos: (index));
              }
            });
          } else {
            await BlocProvider.of<ButtonDataCubit>(context)
                .changeStatusButton(
                    appbarPos: (Constants.appbarMenuPosation), itemPos: (index))
                .timeout(const Duration(seconds: 10));
          }
        } else {}
      }
    }

    // bool checkTimerActivity() {
    //   bool activity = false;
    //   if (Constants.timerData.containsKey(
    //           Constants.itemList.keys.toList()[Constants.appbarMenuPosation]) &&
    //       Constants.timerData[Constants.itemList.keys
    //               .toList()[Constants.appbarMenuPosation]]
    //           .containsKey("r${(index + 1)}")) {
    //     Constants.timerData[Constants.itemList.keys
    //             .toList()[Constants.appbarMenuPosation]]["r${(index + 1)}"]
    //         .forEach((key, value) {
    //       if (value["enable"] == true) {
    //         activity = true;
    //       }
    //     });
    //   }
    //   if (activity == false) {
    //     return false;
    //   } else {
    //     activity = true;
    //     return true;
    //   }
    // }

    return InkWell(
      onLongPress: () => onLongPress(isNotSensor),
      onTap: () async => await onTap(isNotSensor, context),
      child: Container(
        padding: EdgeInsets.only(right: 12.w, bottom: 4.h),
        decoration: BoxDecoration(
          color: Constants.secondryDarkCol,
          borderRadius: BorderRadius.circular(16),
        ),
        child: BlocBuilder<ButtonDataCubit, ButtonDataState>(
          builder: (context, state) {
            if (isNotSensor) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 0.183.sh,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 0.12.sw,
                              height: 0.12.sw,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14.r),
                                    bottomRight: Radius.circular(14.r)),
                                color: Constants.itemListCurrentPage[
                                            (index + 1).toString()]["status"] ??
                                        false
                                    ? Constants.greenCol
                                    : Constants.thirdryDarkCol,
                              ),
                              child: Icon(
                                Icons.power_settings_new_outlined,
                                color: Constants.themeLight,
                                size: 30,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 16.0),
                              child: SizedBox(
                                width: 60.w,
                                height: 0.1.sh,
                                child: Constants.timerData.containsKey(Constants.itemList.keys.toList()[Constants.appbarMenuPosation]) &&
                                        Constants.timerData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
                                            .containsKey("r${(index + 1)}") &&
                                        Constants
                                            .timerData[Constants.itemList.keys
                                                    .toList()[Constants.appbarMenuPosation]]
                                                ["r${(index + 1)}"]
                                            .isNotEmpty
                                    ? ListView.builder(
                                        itemCount: Constants
                                            .timerData[
                                                Constants.itemList.keys.toList()[
                                                    Constants.appbarMenuPosation]]
                                                ["r${(index + 1)}"]
                                            .length,
                                        itemBuilder: (ctx, listpos) {
                                          String mode = Constants.timerData[
                                              Constants.itemList.keys
                                                  .toList()[Constants.appbarMenuPosation]]["r${(index + 1)}"][Constants
                                              .timerData[Constants.itemList.keys
                                                      .toList()[Constants.appbarMenuPosation]]
                                                  ["r${(index + 1)}"]
                                              .keys
                                              .toList()[listpos]]["mode"];
                                          return SizedBox(
                                            width: 0.5.sw,
                                            child: Text(
                                              mode == "date"
                                                  ? "تاریخ"
                                                  : mode == "week"
                                                      ? "هفتگی"
                                                      : mode == "daily"
                                                          ? "روزانه"
                                                          : "یکبار",
                                              style: textStyler(
                                                  color: Constants.themeLight,
                                                  fontsize: 14.r),
                                              textAlign: TextAlign.right,
                                            ),
                                          );
                                        })
                                    : SizedBox(
                                        width: 0.5.sw,
                                        child: Text(
                                          "بدون تایمر",
                                          style: textStyler(
                                              fontsize: 12.r,
                                              color: Constants.themeLight),
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0.16.sh,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: 0.17.sw,
                              height: 25.h,
                              child: Text(
                                Constants.itemListCurrentPage[Constants
                                            .itemListCurrentPage.keys
                                            .toList()[index]]
                                        .containsKey("tag")
                                    ? Constants.itemListCurrentPage[Constants
                                            .itemListCurrentPage.keys
                                            .toList()[index]]["tag"] ??
                                        ""
                                    : "خروجی ${index + 1}",
                                textAlign: TextAlign.center,
                                style: textStyler(
                                    color: Constants.themeLight,
                                    fontsize: 15.r),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                                height: getSize(context, isWidth: false)! / 30),
                            Badge(
                              backgroundColor: Constants.greenCol,
                              isLabelVisible: Constants.itemListCurrentPage[
                                          (index + 1).toString()]['rMode'] ==
                                      'T' ||
                                  Constants.itemListCurrentPage[
                                          (index + 1).toString()]['rMode'] ==
                                      'S',
                              alignment: AlignmentDirectional.topEnd,
                              smallSize: 30,
                              largeSize: 30,
                              label: SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Constants.itemListCurrentPage[(index + 1)
                                              .toString()]['rMode'] ==
                                          "T"
                                      ? Icons.timer
                                      : Icons.water_drop,
                                  color: Constants.themeLight,
                                ),
                              ),
                              child: SvgPicture.asset(
                                "assets/svg/p_def.svg",
                                color: Constants.themeLight,
                                fit: BoxFit.cover,
                                width: 0.19.sw,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 12.w),
                    alignment: Alignment.center,
                    width: 0.18.sw,
                    height: 0.065.sh,
                    child: Text(
                      "سنسور",
                      textAlign: TextAlign.center,
                      style: textStyler(
                          color: Constants.themeLight,
                          fontsize: 18.r,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 0.12.sh,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: SizedBox(
                                  height: 0.1.sh,
                                  width: 0.19.sw,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                Constants.sensorSocketData
                                                        .containsKey(Constants
                                                                .itemList.keys
                                                                .toList()[
                                                            Constants
                                                                .appbarMenuPosation])
                                                    ? Constants
                                                            .sensorSocketData[
                                                                Constants
                                                                        .itemList
                                                                        .keys
                                                                        .toList()[
                                                                    Constants
                                                                        .appbarMenuPosation]]
                                                            .containsKey("temp")
                                                        ? "${Constants.sensorSocketData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]["temp"].toStringAsFixed(1)} \u00B0"
                                                        : "off"
                                                    : "off",
                                                style: textStyler(
                                                    fontsize: 12.r,
                                                    color:
                                                        Constants.themeLight),
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                Constants.sensorSocketData
                                                        .containsKey(Constants
                                                                .itemList.keys
                                                                .toList()[
                                                            Constants
                                                                .appbarMenuPosation])
                                                    ? Constants
                                                            .sensorSocketData[
                                                                Constants
                                                                        .itemList
                                                                        .keys
                                                                        .toList()[
                                                                    Constants
                                                                        .appbarMenuPosation]]
                                                            .containsKey(
                                                                "humidity")
                                                        ? "${Constants.sensorSocketData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]["humidity"].toStringAsFixed(1)} \u0025"
                                                        : "off"
                                                    : "off",
                                                style: textStyler(
                                                    fontsize: 12.r,
                                                    color:
                                                        Constants.themeLight),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(Icons.thermostat,
                                                  size: 24.r),
                                              SizedBox(height: 8.h),
                                              Icon(Icons.water_drop_rounded,
                                                  size: 24.r),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0.12.sh,
                        width: 0.145.sw,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/temp_h.svg",
                              color: Constants.themeLight,
                              fit: BoxFit.cover,
                              width: 0.14.sw,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
