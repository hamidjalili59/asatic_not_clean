import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:asatic/presentation/cubit/button_data_cubit.dart';

import '../../../data/base_widget.dart';
import '../../../data/utils/api_services.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/error_handling.dart';
import '../../../data/utils/functions_helper.dart';
import '../../../data/utils/server_constants.dart';
import '../../../data/utils/text_field_component.dart';

class UserAuthenticationMobileWidget extends StatefulWidget {
  const UserAuthenticationMobileWidget({Key? key}) : super(key: key);

  @override
  State<UserAuthenticationMobileWidget> createState() =>
      _UserAuthenticationMobileWidgetState();
}

class _UserAuthenticationMobileWidgetState
    extends State<UserAuthenticationMobileWidget> {
  final TextEditingController _number = TextEditingController();

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants.isOffline = 'false';
    ScreenUtil.init(context, designSize: Constants.hamidPhoneSize);
    return BaseWidget(
      backgroundColor: Constants.themeLight,
      child: Stack(
        children: [
          Positioned.fill(
              child: SvgPicture.asset(
            "assets/svg/bg.svg",
            fit: BoxFit.fill,
          )),
          Positioned.fill(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                width: getSize(context, isWidth: true),
                height: getSize(context, isWidth: false),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getSize(context, isWidth: false)! / 7.5,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 35.0),
                            child: SizedBox(
                              width: 50,
                              child: Image.asset(
                                "assets/images/logo_asatic.png",
                                color: Constants.greenCol,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSize(context, isWidth: false)! / 18,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0.w,
                          ),
                          child: Text(
                            "شماره موبایل",
                            style: textStyler(
                                color: Constants.secondryDarkCol,
                                fontsize: 12.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSize(context, isWidth: false)! / 19,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 45.0),
                          child: Text(
                            "خود را وارد نمایید",
                            style: textStyler(
                                color: Constants.secondryDarkCol, fontsize: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: SizedBox(
                        height: getSize(context, isWidth: false)! / 38,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "ما برای شما به شماره وارد شده کد تایید را ارسال خواهیم کرد",
                            style: textStyler(
                                color: Constants.secondryDarkCol, fontsize: 18),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: SizedBox(
                          height: getSize(context, isWidth: false)! / 18,
                          width: getSize(context, isWidth: true)! / 2.2,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: SizedBox(
                                    width:
                                        getSize(context, isWidth: true)! / 1.8,
                                    height: 50,
                                    child: customTextField(
                                        textAlign: TextAlign.left,
                                        maxLength: 11,
                                        controller: _number,
                                        style: textStyler(
                                            fontsize: 32.r,
                                            color: Constants.secondryDarkCol),
                                        hintStyle: textStyler(
                                            color: Constants.secondryDarkCol),
                                        obscureText: false),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 50,
                                  child: Text(
                                    "98+",
                                    style: textStyler(
                                        fontsize: 33.r,
                                        color: Constants.secondryDarkCol),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: getSize(context, isWidth: true)! / 1.4,
                        height: getSize(context, isWidth: false)! / 9,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () async {
                              RestAPIConstants.phoneNumberID =
                                  int.parse(_number.text);
                              var result = await InternetConnectionChecker()
                                  .hasConnection;
                              if (_number.text.length == 10) {
                                if (result) {
                                  ApiServices()
                                      .accountSession(context)
                                      .catchError((err) {
                                    handlingErr(statusCode: err.toString());
                                  });
                                } else {
                                  displaySnackBar(context,
                                      message: 'دسترسی به اینترنت موجود نیست');
                                }
                              } else if (_number.text.length == 11 &&
                                  !_number.text.startsWith("0")) {
                                displaySnackBar(context,
                                    message: 'شماره اشتباه است.');
                              } else if (_number.text.length == 11) {
                                if (result && _number.text.startsWith("0")) {
                                  _number.text
                                      .substring(1, _number.text.length);
                                  ApiServices()
                                          .accountSession(context)
                                          .catchError((err) {
                                    handlingErr(statusCode: err.toString());
                                  })
                                      ;
                                } else {
                                  displaySnackBar(context,
                                      message: 'دسترسی به اینترنت موجود نیست');
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Constants.appBarColor.withBlue(120),
                                  borderRadius: BorderRadius.circular(18)),
                              child: Center(
                                  child: Text(
                                "بعدی",
                                style: textStyler(
                                    color: Constants.themeLight, fontsize: 16),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: OnScreenKeyboard(
                        isPinCode: false,
                        controller: _number,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnScreenKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final bool isPinCode;
  final double width;
  final double height;
  const OnScreenKeyboard({
    required this.controller,
    required this.isPinCode,
    this.width = 1.25,
    this.height = 2.15,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
            color: Constants.themeLight,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        // width: getSize(context, isWidth: true)! < 390 ? getSize(context, isWidth: true)! / 1.4 : getSize(context, isWidth: true)! / 1.25,
        width: 305.w,
        height: 420.h,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: NumericKeyboard(
            onKeyboardTap: (String value) async {
              if (isPinCode) {
                if (controller.text.length < 4) {
                  controller.text = controller.text + value;
                }
              } else {
                if (controller.text.length < 11) {
                  controller.text = controller.text + value;
                }
              }
              if (isPinCode == true) {
                if (controller.text == Constants.verifyCode &&
                    controller.text.length >= 3) {
                  Constants.accountDataBox
                      .put("AccountData", Constants.currentUserData);
                  if (Constants.isOnline == 'true') {
                    await BlocProvider.of<ButtonDataCubit>(context)
                        .getAllDevicesData(context, false, isHttpMode: true);
                  }
                  // await ApiServices().getAllDevicesDataMethod()
                  //     .then((value) async => await Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false));
                  if (Constants.isOnline == 'true') {
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                        "/home", (Route<dynamic> route) => false);
                  } else {
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                        "/wifiConnect", (Route<dynamic> route) => false);
                  }
                }
              }
            },
            rightButtonFn: () {
              if (controller.text.isNotEmpty) {
                controller.text =
                    controller.text.substring(0, controller.text.length - 1);
              }
            },
            rightIcon: const Icon(
              Icons.backspace_outlined,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
