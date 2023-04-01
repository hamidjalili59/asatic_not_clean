import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ndialog/ndialog.dart';
import 'package:asatic/presentation/cubit/button_data_cubit.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../../data/utils/server_constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      backgroundColor: Constants.secondryDarkCol,
      child: Column(
        children: [
          SizedBox(height: getSize(context, isWidth: false)! / 5),
          SizedBox(
            height: getSize(context, isWidth: false)! / 35,
            child: Divider(
              height: 5,
              thickness: 4,
              color: Constants.thirdryDarkCol,
            ),
          ),
          InkWell(
            onTap: Constants.isOnline == 'true'
                ? () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/logger", ModalRoute.withName('/home'));
                  }
                : () {},
            child: Container(
                padding: const EdgeInsets.only(right: 14),
                alignment: Alignment.center,
                height: getSize(context, isWidth: false)! / 15,
                child: Text(
                  "دیدن گزارش ها",
                  style: textStyler(
                      color: Constants.isOnline == 'true'
                          ? Constants.themeLight
                          : Constants.themeLight.withOpacity(0.5),
                      fontsize: 18.r),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                )),
          ),
          SizedBox(
            height: getSize(context, isWidth: false)! / 35,
            child: Divider(
              height: 5,
              thickness: 4,
              color: Constants.thirdryDarkCol,
            ),
          ),
          InkWell(
            onTap: Constants.isOnline == 'true'
                ? () {
                    Constants.itemList.forEach((key, value) {
                      if (value["user"] == RestAPIConstants.phoneNumberID &&
                          !Constants.devicesListitems.contains(key)) {
                        Constants.devicesListitems.add(key);
                      }
                    });
                    setState(() {});
                    NAlertDialog(
                      dialogStyle: DialogStyle(titleDivider: true),
                      title: Text("مدیریت کاربران",
                          textDirection: TextDirection.rtl,
                          style: textStyler(
                              color: Constants.themeLight,
                              fontWeight: FontWeight.bold,
                              fontsize: 18.r)),
                      content: Column(
                        children: [
                          Text(
                              "لطفا دستگاه مورد نظر را برای مدیریت کاربران انتخاب کنید",
                              textDirection: TextDirection.rtl,
                              style: textStyler(
                                  color: Constants.themeLight, fontsize: 16.r)),
                          SizedBox(
                            width: 1.sw,
                            height: 0.7.sh,
                            child: ListView.builder(
                                itemCount: Constants.itemList.values
                                        .toList()
                                        .where((element) =>
                                            element["user"] ==
                                            RestAPIConstants.phoneNumberID)
                                        .isNotEmpty
                                    ? Constants.itemList.values
                                        .toList()
                                        .where((element) =>
                                            element["user"] ==
                                            RestAPIConstants.phoneNumberID)
                                        .length
                                    : 1,
                                itemBuilder: (ctx, pos) {
                                  if (Constants.devicesListitems.isNotEmpty) {
                                    return InkWell(
                                      onTap: () async {
                                        //
                                        Response tempUserManage =
                                            await httpRequestGet(
                                                getUrl:
                                                    "${Constants.hostUrl}api/UManage/${Constants.devicesListitems[pos]}");

                                        tempUserManage.data
                                            .forEach((preElement) {
                                          bool flag = false;
                                          if (preElement
                                              is Map<String, dynamic>) {
                                            Constants.userManageList
                                                .toList()
                                                .forEach((element) {
                                              if (element['id'] ==
                                                  preElement['id']) {
                                                flag = true;
                                                return;
                                              }
                                            });
                                            if (flag) return;
                                            Constants.userManageList
                                                .add(preElement);
                                          }
                                        });
                                        Constants.deviceSelected = pos;
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .pushNamed("/client_manage");
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              color: Colors.blueGrey,
                                              height: 79,
                                              width: 3,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  color: Colors.blueGrey,
                                                  height: 3,
                                                  width: 0.77.sw,
                                                ),
                                                Text(
                                                  Constants.itemList.isNotEmpty
                                                      ? Constants.itemList[Constants
                                                                          .devicesListitems[pos]]
                                                                      ["tag"] ==
                                                                  null ||
                                                              Constants
                                                                  .itemList[
                                                                      Constants
                                                                          .devicesListitems[pos]]
                                                                      ["tag"]
                                                                  .isEmpty
                                                          ? Constants.devicesListitems[
                                                              pos]
                                                          : Constants
                                                              .itemList[Constants
                                                                  .devicesListitems[
                                                              pos]]["tag"]
                                                      : '',
                                                  textAlign: TextAlign.center,
                                                  style: textStyler(
                                                      color:
                                                          Constants.themeLight,
                                                      fontsize: 21.r),
                                                ),
                                                Container(
                                                  color: Colors.blueGrey,
                                                  height: 3,
                                                  width: 0.77.sw,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              color: Colors.blueGrey,
                                              height: 79,
                                              width: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: Text(
                                      "دستگاهی موجود نیست",
                                      style: textStyler(
                                          color: Constants.themeLight),
                                    ));
                                  }
                                }),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 0.3.sw,
                              height: 0.065.sh,
                              decoration: BoxDecoration(
                                  color: Constants.greenCol,
                                  borderRadius: BorderRadius.circular(12.r)),
                              child: Text("بستن",
                                  textDirection: TextDirection.rtl,
                                  style: textStyler(
                                      color: Constants.themeLight,
                                      fontsize: 18.r)),
                            ),
                          )
                        ],
                      ),
                    ).show(context);
                  }
                : () {},
            child: Container(
                padding: const EdgeInsets.only(right: 14),
                alignment: Alignment.center,
                height: getSize(context, isWidth: false)! / 15,
                child: Text(
                  "مدیریت کاربران",
                  style: textStyler(
                      color: Constants.isOnline == 'true'
                          ? Constants.themeLight
                          : Constants.themeLight.withOpacity(0.5),
                      fontsize: 18.r),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                )),
          ),
          SizedBox(
            height: getSize(context, isWidth: false)! / 35,
            child: Divider(
              height: 5,
              thickness: 4,
              color: Constants.thirdryDarkCol,
            ),
          ),
          InkWell(
            onTap: Constants.isOnline == 'true'
                ? () {
                    Constants.itemList.isNotEmpty
                        ? Constants.itemList.forEach((key, value) {
                            if (value["user"] ==
                                    RestAPIConstants.phoneNumberID &&
                                !Constants.devicesListitems.contains(key)) {
                              Constants.devicesListitems.add(key);
                            }
                          })
                        : [];
                    setState(() {});
                    NAlertDialog(
                      dialogStyle: DialogStyle(titleDivider: true),
                      title: Text("حذف دستگاه",
                          textDirection: TextDirection.rtl,
                          style: textStyler(
                              color: Constants.themeLight,
                              fontWeight: FontWeight.bold,
                              fontsize: 18.r)),
                      content: Column(
                        children: [
                          Text("لطفا دستگاه مورد نظر را برای حذف انتخاب کنید",
                              textDirection: TextDirection.rtl,
                              style: textStyler(
                                  color: Constants.themeLight, fontsize: 16.r)),
                          SizedBox(
                            width: 1.sw,
                            height: 0.7.sh,
                            child: ListView.builder(
                                itemCount: Constants.itemList.values
                                        .toList()
                                        .where((element) =>
                                            element["user"] ==
                                            RestAPIConstants.phoneNumberID)
                                        .isNotEmpty
                                    ? Constants.itemList.values
                                        .toList()
                                        .where((element) =>
                                            element["user"] ==
                                            RestAPIConstants.phoneNumberID)
                                        .length
                                    : 1,
                                itemBuilder: (ctx, pos) {
                                  if (Constants.devicesListitems.isNotEmpty) {
                                    return InkWell(
                                      onTap: () async {
                                        //
                                        Navigator.of(context).pop();
                                        NAlertDialog(
                                          dialogStyle:
                                              DialogStyle(titleDivider: true),
                                          title: Text("حذف دستگاه",
                                              textDirection: TextDirection.rtl,
                                              style: textStyler(
                                                  color: Constants.themeLight,
                                                  fontWeight: FontWeight.bold,
                                                  fontsize: 18.r)),
                                          content: Text(
                                              "آیا از حذف این دستگاه اطمینان دارید؟",
                                              textDirection: TextDirection.rtl,
                                              style: textStyler(
                                                  color: Constants.themeLight,
                                                  fontsize: 16.r)),
                                          actions: <Widget>[
                                            MaterialButton(
                                              child: Text("تایید",
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  style: textStyler(
                                                      color: Constants
                                                          .themeLight)),
                                              onPressed: () async {
                                                await BlocProvider.of<
                                                            ButtonDataCubit>(
                                                        context)
                                                    .deleteDevice(pos)
                                                    .then((value) {
                                                  Constants.devicesListitems
                                                      .removeAt(pos);
                                                  Navigator.of(context).pop();
                                                });
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
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ).show(context);
                                        //
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              color: Colors.blueGrey,
                                              height: 79,
                                              width: 3,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  color: Colors.blueGrey,
                                                  height: 3,
                                                  width: 0.77.sw,
                                                ),
                                                Text(
                                                  Constants.itemList.isNotEmpty
                                                      ? Constants.itemList[Constants
                                                                          .devicesListitems[pos]]
                                                                      ["tag"] ==
                                                                  null ||
                                                              Constants
                                                                  .itemList[
                                                                      Constants
                                                                          .devicesListitems[pos]]
                                                                      ["tag"]
                                                                  .isEmpty
                                                          ? Constants
                                                              .itemList.keys
                                                              .toList()[pos]
                                                          : Constants.itemList[
                                                              Constants.devicesListitems[
                                                                  pos]]["tag"]
                                                      : '',
                                                  textAlign: TextAlign.center,
                                                  style: textStyler(
                                                      color:
                                                          Constants.themeLight,
                                                      fontsize: 21.r),
                                                ),
                                                Container(
                                                  color: Colors.blueGrey,
                                                  height: 3,
                                                  width: 0.77.sw,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              color: Colors.blueGrey,
                                              height: 79,
                                              width: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: Text(
                                      "دستگاهی موجود نیست",
                                      style: textStyler(
                                          color: Constants.themeLight),
                                    ));
                                  }
                                }),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 0.3.sw,
                              height: 0.065.sh,
                              decoration: BoxDecoration(
                                  color: Constants.greenCol,
                                  borderRadius: BorderRadius.circular(12.r)),
                              child: Text("بستن",
                                  textDirection: TextDirection.rtl,
                                  style: textStyler(
                                      color: Constants.themeLight,
                                      fontsize: 18.r)),
                            ),
                          )
                        ],
                      ),
                    ).show(context);
                  }
                : () {},
            child: Container(
                padding: const EdgeInsets.only(right: 14),
                alignment: Alignment.center,
                height: getSize(context, isWidth: false)! / 15,
                child: Text(
                  "حذف کردن دستگاه",
                  style: textStyler(
                      color: Constants.isOnline == 'true'
                          ? Constants.themeLight
                          : Constants.themeLight.withOpacity(0.5),
                      fontsize: 18.r),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                )),
          ),
          SizedBox(
            height: getSize(context, isWidth: false)! / 35,
            child: Divider(
              height: 5,
              thickness: 4,
              color: Constants.thirdryDarkCol,
            ),
          ),
          InkWell(
            onTap: () {
              if (Constants.flashDialogflag == false) {
                Constants.flashDialogflag = true;
                showBottomFlash(context,
                    title: "آیا اطمینان دارید", event: "logout");
              }
            },
            child: Container(
                padding: const EdgeInsets.only(right: 14),
                alignment: Alignment.center,
                height: getSize(context, isWidth: false)! / 15,
                child: Text(
                  "خروج از حساب کاربری",
                  style:
                      textStyler(color: Constants.themeLight, fontsize: 18.r),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                )),
          ),
          SizedBox(
            height: getSize(context, isWidth: false)! / 35,
            child: Divider(
              height: 5,
              thickness: 4,
              color: Constants.thirdryDarkCol,
            ),
          ),
          const Spacer(),
          Divider(
            height: 0,
            thickness: 3,
            color: Constants.thirdryDarkCol,
          )
        ],
      ),
    );
  }
}
