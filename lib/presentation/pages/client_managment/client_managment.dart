import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../cubit/button_data_cubit.dart';

class ClientManagment extends StatefulWidget {
  final int devicePos;
  const ClientManagment({
    Key? key,
    required this.devicePos,
  }) : super(key: key);

  @override
  State<ClientManagment> createState() => _ClientManagmentState();
}

class _ClientManagmentState extends State<ClientManagment> {
  TextEditingController deviceTagController = TextEditingController(text: "");
  TextEditingController deviceNumberController =
      TextEditingController(text: "");
  @override
  void dispose() {
    deviceTagController.dispose();
    deviceNumberController.dispose();
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
                    BlocBuilder<ButtonDataCubit, ButtonDataState>(
                      bloc: BlocProvider.of<ButtonDataCubit>(context),
                      builder: (context, state) {
                        FlutterSwitch flutterSwitchMethod(
                            BuildContext context, int pos) {
                          return FlutterSwitch(
                            activeColor: Constants.primeryDarkCol,
                            activeToggleColor: Constants.greenCol,
                            inactiveToggleColor: Constants.thirdryDarkCol,
                            width: getSize(context, isWidth: true)! / 7.8,
                            height: getSize(context, isWidth: false)! / 30,
                            toggleSize: 30.0.r,
                            inactiveColor: Constants.primeryDarkCol,
                            toggleColor: Constants.greenCol,
                            value: Constants.userManageList[pos]['isEnable'],
                            borderRadius: 50.0,
                            padding: 0,
                            showOnOff: false,
                            onToggle: (val) async {
                              Constants.userManageList[pos]['isEnable'] = val;
                              await BlocProvider.of<ButtonDataCubit>(context)
                                  .userManagment(
                                      Constants.userManageList, pos, false,
                                      user: Constants.userManageList[pos]);
                            },
                          );
                        }

                        return Container(
                          alignment: Alignment.center,
                          width: getSize(context, isWidth: true),
                          height: getSize(context, isWidth: false),
                          child: ListView.builder(
                              itemCount: Constants.userManageList.length + 1,
                              padding: EdgeInsets.only(
                                  top: 180.h,
                                  left: 15.w,
                                  right: 15.w,
                                  bottom: 30.h),
                              itemBuilder: (context, pos) {
                                if (pos == Constants.userManageList.length) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 50.0.h),
                                      child: InkWell(
                                          onTap: () async {
                                            //--

                                            await userManagmentDialog(
                                                context,
                                                deviceNumberController,
                                                deviceTagController,
                                                true);

                                            //--
                                          },
                                          child: Icon(Icons.add_box,
                                              size: 100.r,
                                              color: Constants.themeLight)),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.all(10.h),
                                  child: Container(
                                      height: 0.13.sh,
                                      decoration: BoxDecoration(
                                          color: Constants.thirdryDarkCol,
                                          borderRadius:
                                              BorderRadius.circular(16.r)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0.r),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Constants.userManageList[pos]
                                                        ["owner"] ==
                                                    false
                                                ? flutterSwitchMethod(
                                                    context, pos)
                                                : SizedBox(
                                                    width: getSize(context,
                                                            isWidth: true)! /
                                                        7.8,
                                                    height: getSize(context,
                                                            isWidth: false)! /
                                                        30,
                                                  ),
                                            InkWell(
                                              onTap: () async {
                                                deviceNumberController.text =
                                                    '0${Constants.userManageList[pos]['phonenumber'].toString()}';
                                                deviceTagController.text =
                                                    Constants
                                                        .userManageList[pos]
                                                            ['name_Tag']
                                                        .toString();
                                                await userManagmentDialog(
                                                    context,
                                                    deviceNumberController,
                                                    deviceTagController,
                                                    false,
                                                    user: Constants
                                                        .userManageList[pos],
                                                    pos: pos);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, size: 26.r),
                                                  SizedBox(width: 5.w),
                                                  Text(
                                                    Constants.userManageList[pos]
                                                                    [
                                                                    "name_Tag"] ==
                                                                null ||
                                                            Constants
                                                                .userManageList[pos]
                                                                    ["name_Tag"]
                                                                .isEmpty
                                                        ? Constants.userManageList[
                                                                        pos]
                                                                    ["owner"] ==
                                                                false
                                                            ? Constants
                                                                .userManageList[
                                                                    pos][
                                                                    "phonenumber"]
                                                                .toString()
                                                            : "صاحب دستگاه"
                                                        : Constants
                                                                .userManageList[
                                                            pos]["name_Tag"],
                                                    textAlign: TextAlign.center,
                                                    style: textStyler(
                                                        color: Constants
                                                            .themeLight,
                                                        fontsize: 18.r),
                                                  )
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (Constants
                                                            .userManageList[pos]
                                                        ["owner"] ==
                                                    false) {
                                                  Map temp = {};
                                                  temp = Constants
                                                      .userManageList[pos];
                                                  Response deleteUser =
                                                      await httpRequestDelete(
                                                          deleteUrl:
                                                              "${Constants.hostUrl}api/UManage",
                                                          body: [temp]);
                                                  if (deleteUser.statusCode ==
                                                      201) {
                                                    setState(() {
                                                      Constants.userManageList
                                                          .remove(Constants
                                                                  .userManageList[
                                                              pos]);
                                                    });
                                                  }
                                                  temp.clear();
                                                }
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: Constants.greenCol,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                                child: Icon(
                                                  Constants.userManageList[pos]
                                                              ["owner"] ==
                                                          false
                                                      ? Icons.close
                                                      : Icons.star_half_rounded,
                                                  color:
                                                      Constants.secondryDarkCol,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              }),
                        );
                      },
                    ),
                    Container(
                      height: 0.18.sh,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getSize(context, isWidth: false)! / 15),
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
                                  top: getSize(context, isWidth: false)! / 30),
                              child: SizedBox(
                                width: 0.4.sw,
                                height: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      onTap: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            Constants.itemList[Constants.itemList.keys.toList()[Constants.deviceSelected]]
                                                            ["tag"] !=
                                                        null &&
                                                    Constants
                                                        .itemList[Constants
                                                                .itemList.keys
                                                                .toList()[Constants.deviceSelected]]
                                                            ["tag"]
                                                        .isNotEmpty
                                                ? Constants.itemList[Constants
                                                            .itemList.keys
                                                            .toList()[
                                                        Constants.deviceSelected]]["tag"] ??
                                                    ""
                                                : "دستگاه ${Constants.deviceSelected + 1}",
                                            style: textStyler(
                                                color: Constants.themeLight,
                                                fontsize: 16.r,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
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
                                  top: getSize(context, isWidth: false)! / 15),
                              child: SizedBox(
                                width: 50,
                                child: InkWell(
                                  onTap: () async {
                                    await userManagmentDialog(
                                        context,
                                        deviceNumberController,
                                        deviceTagController,
                                        true);
                                  },
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Constants.themeLight,
                                    size: 35,
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
            );
          },
        ));
  }
}
