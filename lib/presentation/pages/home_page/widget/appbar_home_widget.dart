import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:asatic/data/utils/app_constants.dart';
import 'package:asatic/data/utils/functions_helper.dart';
import 'package:asatic/presentation/cubit/button_data_cubit.dart';
import 'package:asatic/presentation/pages/home_page/widget/homepage_paints.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class AppbarHomeWidget extends StatelessWidget {
  const AppbarHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScrollSnapListState> appbarKey =
        GlobalKey<ScrollSnapListState>(debugLabel: "appbar");
    return PhysicalShape(
      clipper: AppBarClipper(),
      elevation: 8,
      color: Colors.transparent,
      shadowColor: Colors.black87,
      child: CustomPaint(
        painter: HeaderCurvedContainer(context: context),
        child: SizedBox(
          width: 1.sw,
          height: 0.25.sh,
          child: BlocBuilder<ButtonDataCubit, ButtonDataState>(
            builder: (context, state) {
              return ScrollSnapList(
                curve: Curves.linear,
                initialIndex: Constants.appbarMenuPosation.toDouble(),
                focusOnItemTap: true,
                onItemFocus: (posation) async {
                  if (Constants.itemList.keys.isNotEmpty) {
                    checkTimersActivity(context);
                  }
                  //todo: inja bayad dade haye safhe eavaz beshe
                  if (Constants.isOnline == 'true') {
                    Constants.deviceSelectedIndex = posation;
                    // Constants.appbarMenuPosation = posation;
                    BlocProvider.of<ButtonDataCubit>(context)
                        .changeStatusInEachPage(posation: posation);
                    Constants.itemListCurrentPage = jsonDecode(Constants
                                    .itemList[
                                Constants.itemList.keys.toList()[posation] ??
                                    0][Constants.isOnline == 'true'
                                ? "device_Relay_Status"
                                : "Device_Relay_Status"] ??
                            {}) ??
                        "";
                  }
                },
                itemCount: Constants.itemList.isNotEmpty &&
                        Constants.itemList.keys.toList().isNotEmpty
                    ? Constants.appBarCardListLength < 1
                        ? 0
                        : Constants.appBarCardListLength
                    : 0,
                selectedItemAnchor: SelectedItemAnchor.MIDDLE,
                dynamicItemSize: true,
                itemSize: 0.32.sw,
                key: appbarKey,
                itemBuilder: (context, posation) {
                  return SizedBox(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        height: 160.h,
                        width: 0.32.sw,
                        decoration: BoxDecoration(
                          color: Constants.themeLight,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 20,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    height: 30,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        width: 55.r,
                                        // height: getSize(context, isWidth: false)! / 10,
                                        child: InkWell(
                                          onTap: () {
                                            try {
                                              Constants.appbarMenuPosation =
                                                  posation;
                                              appbarKey.currentState!
                                                  .focusToItem(Constants
                                                      .appbarMenuPosation);
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      "/devicesSettings",
                                                      ModalRoute.withName(
                                                          '/home'));
                                            } catch (_) {}
                                          },
                                          child: Icon(
                                            Icons.settings,
                                            color: Constants.primeryDarkCol,
                                            size: 30.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    "assets/svg/ssd.svg",
                                    color: Constants.fourDarkCol,
                                    fit: BoxFit.fill,
                                    width: 50.w,
                                  ),
                                  SizedBox(height: 0.008.sh),
                                  Text(
                                    (Constants.itemList[Constants.itemList.keys
                                                .toList()[posation]]["tag"] ??
                                            "دستگاه ${posation + 1}")
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: textStyler(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, bottom: 3),
                                    child: SvgPicture.asset(
                                      Constants.itemList[Constants.itemList.keys
                                                      .toList()[posation]
                                                      .toString()]
                                                  ["status_Conect"] ==
                                              true
                                          ? "assets/svg/wifi_on.svg"
                                          : "assets/svg/wifi_off.svg",
                                      color: Constants.itemList[Constants
                                                      .itemList.keys
                                                      .toList()[posation]
                                                      .toString()]
                                                  ["status_Conect"] ==
                                              true
                                          ? Constants.greenCol
                                          : Constants.secondryDarkCol,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
