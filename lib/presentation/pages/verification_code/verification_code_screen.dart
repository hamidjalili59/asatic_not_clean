import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:asatic/data/base_widget.dart';
import 'package:asatic/data/utils/app_constants.dart';
import 'package:asatic/data/utils/functions_helper.dart';
import 'package:asatic/data/utils/printf.dart';
import 'package:asatic/presentation/pages/authentication/user_authentication_mobile.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController pin = TextEditingController();
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
                              width: getSize(context, isWidth: true)! / 5,
                              child: Image.asset(
                                "assets/images/logo_asatic.png",
                                color: Constants.greenCol,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: getSize(context, isWidth: false)! / 16,
                        child: const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "کد ارسال شده",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: "IRANSans",
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: getSize(context, isWidth: false)! / 17,
                        child: const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 0.0),
                            child: Text(
                              "به موبایل خود را وارد نمایید",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontFamily: "IRANSans",
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: SizedBox(
                        height: getSize(context, isWidth: false)! / 40,
                        child: const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "ما برای شما به شماره وارد شده کد تایید را ارسال کرده ایم",
                            style: TextStyle(
                                fontSize: 8,
                                color: Colors.black,
                                fontFamily: "IRANSans",
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                          width: getSize(context, isWidth: true)! / 1.8,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: PinCodeTextField(
                              appContext: context,
                              length: 4,
                              onChanged: (String value) {
                                printF(text: "$value 23136");
                              },
                              textStyle: const TextStyle(color: Colors.black87),
                              controller: pin,
                              enabled: false,
                            ),
                          )),
                    ),
                    const Spacer(),
                    Center(
                      child: OnScreenKeyboard(
                        height: 2.35,
                        isPinCode: true,
                        controller: pin,
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
