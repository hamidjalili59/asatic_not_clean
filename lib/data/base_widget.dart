import 'package:flutter/material.dart';

import 'utils/app_constants.dart';

class BaseWidget extends StatelessWidget {
  final Widget? child;
  final PreferredSizeWidget? appbar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Key? scaffoldKey;
  final Color? backgroundColor;

  const BaseWidget({
    Key? key,
    @required this.child,
    this.appbar,
    this.bottomNavigationBar,
    this.drawer,
    this.scaffoldKey,
    this.backgroundColor,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor ?? Constants.themeLight,
        drawerEnableOpenDragGesture: false,
        appBar: appbar,
        drawer: drawer,
        body: child ?? Container(),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
