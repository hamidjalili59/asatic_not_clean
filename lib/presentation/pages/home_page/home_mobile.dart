import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:asatic/data/utils/api_services.dart';
import 'package:asatic/presentation/pages/home_page/widget/appbar_home_widget.dart';
import 'package:asatic/presentation/pages/home_page/widget/body_view_widget.dart';

import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../cubit/button_data_cubit.dart';

class HomeMobileWidget extends StatefulWidget {
  const HomeMobileWidget({Key? key}) : super(key: key);
  @override
  State<HomeMobileWidget> createState() => _HomeMobileWidgetState();
}

class _HomeMobileWidgetState extends State<HomeMobileWidget> {
  @override
  void initState() {
    super.initState();
    try {
      if (!(Constants.isOnline == 'true') && Constants.socketStarted == false) {
        Constants.socketStarted = true;
        Constants.socketStreamListener!.onData((event) async {
          ApiServices().socketFunc(context, event);
          var dRSTemp = Constants.itemList[Constants.itemList.keys.toList()[0]]
              ["Device_Relay_Status"];
          Constants.itemList[Constants.itemList.keys.toList()[0]]
              ["device_Relay_Status"] = dRSTemp;
          if (event.toString() == "ok") {
            // BlocProvider.of<ButtonDataCubit>(context).getStatusOffline(context, true);
          }
        });
        Constants.localchannel.onError((err) {
          Constants.socketStarted = false;
        });
      }

      if (Constants.itemList.keys.isNotEmpty) {
        checkTimersActivity(context);
      }
    } catch (_) {}
    permissionHandler();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getSize(context, isWidth: true),
      height: getSize(context, isWidth: false),
      child: BlocConsumer<ButtonDataCubit, ButtonDataState>(
        bloc: BlocProvider.of<ButtonDataCubit>(context),
        listener: (context, state) {
          setState(() {
            Constants.appBarCardListLength = Constants.itemList.keys.length;
            Constants.itemListCurrentPage = jsonDecode(Constants.itemList[
                    Constants.itemList.keys
                        .toList()[Constants.deviceSelectedIndex]][
                Constants.isOnline == 'true'
                    ? "device_Relay_Status"
                    : "Device_Relay_Status"]);
          });
        },
        builder: (context, state) {
          return Stack(
            children: [
              Constants.itemList.isNotEmpty
                  ? Stack(
                      children: const [
                        BodyViewWidget(),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            showDialogAddDevice(
                              context: context,
                              title: "آیا قصد اضافه کردن دستگاه دارید",
                              content:
                                  "با زدن بر روی کلید بله شما به صفحه اسکن بارکد منتقل میشوید",
                              route: "/add_device",
                            );
                          },
                          child: Align(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: SizedBox(
                                width: 1.sw,
                                height: 0.48.sh,
                                child: LottieBuilder.asset(
                                  'assets/lottie/add_device.json',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "لطفا با استفاده از دکمه + بالای صفحه \n دستگاه خود را اضافه کنید",
                          textAlign: TextAlign.center,
                          style: textStyler(
                              color: Constants.themeLight, fontsize: 16.r),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(height: 0.1.sh)
                      ],
                    ),
              Positioned(
                child: Constants.appBarCardListLength >= 1
                    ? const AppbarHomeWidget()
                    : const SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }
}
