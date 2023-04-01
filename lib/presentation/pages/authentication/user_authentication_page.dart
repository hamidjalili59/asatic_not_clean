import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../data/base_widget.dart';
import '../../../data/utils/app_constants.dart';
import '../../../data/utils/functions_helper.dart';
import '../../cubit/button_data_cubit.dart';
import 'user_authentication_mobile.dart';
import 'dart:io';

class UserAuthenticationPage extends StatefulWidget {
  const UserAuthenticationPage({Key? key}) : super(key: key);

  @override
  State<UserAuthenticationPage> createState() => _UserAuthenticationPageState();
}

class _UserAuthenticationPageState extends State<UserAuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    if (Constants.accountDataBox.isNotEmpty) {
      initWithStoredJWT(context);
    }

    return BlocBuilder<ButtonDataCubit, ButtonDataState>(
      builder: (context, state) {
        return BlurryModalProgressHUD(
          progressIndicator: Column(
            children: [
              SizedBox(
                height: getSize(context, isWidth: false)! / 6.5,
              ),
              SizedBox(
                height: getSize(context, isWidth: false)! -
                    getSize(context, isWidth: false)! / 6.5,
                width: getSize(context, isWidth: true),
                child: Center(
                  child: SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(
                          strokeWidth: 10,
                          color: Constants.greenCol.withBlue(10),
                          backgroundColor: Constants.greenCol.withAlpha(120))),
                ),
              ),
            ],
          ),
          inAsyncCall: state.isLoading,
          child: BaseWidget(
            backgroundColor: Platform.isAndroid
                ? Constants.secondryDarkCol
                : Constants.greenCol,
            child: Platform.isAndroid
                ? const UserAuthenticationMobileWidget()
                : Container(),
          ),
        );
      },
    );
  }
}
