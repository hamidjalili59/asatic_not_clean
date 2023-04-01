import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ndialog/ndialog.dart';
import 'package:asatic/data/base_widget.dart';
import 'package:asatic/data/hive/wifi_data/wifi_data.dart';
import 'package:asatic/data/utils/app_constants.dart';
import 'package:asatic/data/utils/functions_helper.dart';
import 'package:asatic/presentation/pages/offline_wifi_list/widget/wifi_tile_button.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiListOffline extends StatefulWidget {
  const WifiListOffline({Key? key}) : super(key: key);

  @override
  State<WifiListOffline> createState() => _WifiListOfflineState();
}

class _WifiListOfflineState extends State<WifiListOffline> {
  bool inLoading = false;
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  bool get isStreaming => Constants.wifiSubscription != null;

  void _handleScannedResults(BuildContext context,
      Result<List<WiFiAccessPoint>, GetScannedResultsErrors> result) {
    if (result.hasError) {
      setState(() => accessPoints = <WiFiAccessPoint>[]);
    } else {
      setState(() => accessPoints = result.value!);
    }
  }

  void showLoading() async {
    inLoading = true;
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text(
          "جستجوی وای فای های اطراف",
          textDirection: TextDirection.rtl,
        ),
        title: const Text(
          "چند لحظه منتظر بمانید ...",
          textDirection: TextDirection.rtl,
        ));
    progressDialog.show();
    await Future.delayed(const Duration(seconds: 3));
    progressDialog.dismiss();
    inLoading = false;
  }

  void _startListeningToScanResults(BuildContext context) {
    Constants.wifiSubscription = WiFiScan.instance.onScannedResultsAvailable
        .listen((result) => _handleScannedResults(context, result));
  }

  void findWifi() async {
    await WiFiScan.instance.startScan();
    setState(() => accessPoints = <WiFiAccessPoint>[]);
    _handleScannedResults(context, await WiFiScan.instance.getScannedResults());
    _startListeningToScanResults(context);
  }

  @override
  void initState() {
    super.initState();
    Constants.isOffline = 'true';
    findWifi();
  }

  @override
  Widget build(BuildContext context) {
    List<WifiData> wifiFilteredList = [];
    accessPoints
        .where((element) => element.ssid.endsWith("Asatic"))
        .toList()
        .forEach((element) async {
      if (!wifiFilteredList.toList().contains(
            WifiData(
                ssid: element.ssid,
                password: '',
                capabilities: element.capabilities),
          )) {
        wifiFilteredList.add(WifiData(
            capabilities: element.capabilities,
            ssid: element.ssid,
            password: Constants.deviceWifiList.containsKey(element.ssid)
                ? (await Constants.deviceWifiList.get(element.ssid)).password ??
                    ""
                : ""));
      }
    });
    return BaseWidget(
      child: Stack(
        children: [
          Container(
            height: 1.sh,
            color: Constants.primeryDarkCol,
            child: Padding(
              padding: EdgeInsets.only(top: 0.195.sh),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const DeviderWifiList(title: "دستگاه های ذخیره شده"),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: Constants.deviceWifiList.isNotEmpty
                            ? Constants.deviceWifiList.length
                            : 0,
                        itemExtent: 0.1.sh,
                        itemBuilder: (ctx, index) {
                          return WifiTileButton(
                            wifiFilteredList:
                                Constants.deviceWifiList.values.toList()[index],
                          );
                        }),
                    const DeviderWifiList(title: "دستگاه های اطراف"),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: wifiFilteredList.length,
                        itemExtent: 0.1.sh,
                        itemBuilder: (context, i) {
                          return WifiTileButton(
                            wifiFilteredList: wifiFilteredList[i],
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Constants.secondryDarkCol,
                boxShadow: const [BoxShadow(blurRadius: 5, spreadRadius: 5)],
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16))),
            height: 0.18.sh,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: 0.1.sw,
                    height: 35,
                    child: Padding(
                      padding: EdgeInsets.only(left: 24.r),
                      child: const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Icon(Icons.arrow_back_ios_rounded)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 0.7.sw,
                  child: Text(
                      "برای اتصال به شبکه مورد نظر\nبر روی شبکه مورد نظر کلیک کنید",
                      style: textStyler(color: Constants.themeLight),
                      textAlign: TextAlign.center),
                ),
                InkWell(
                  onTap: () async {
                    findWifi();
                    showLoading();
                  },
                  child: SizedBox(
                    width: 0.1.sw,
                    height: 40,
                    child: Padding(
                      padding: EdgeInsets.only(right: 24.r),
                      child: const FittedBox(
                          fit: BoxFit.fitHeight, child: Icon(Icons.refresh)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeviderWifiList extends StatelessWidget {
  final String title;
  const DeviderWifiList({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 0.33.sw, color: Colors.grey, height: 1),
          SizedBox(
              width: 0.3.sw,
              child: Text(
                title,
                textAlign: TextAlign.center,
              )),
          Container(width: 0.33.sw, color: Colors.grey, height: 1),
        ],
      ),
    );
  }
}
