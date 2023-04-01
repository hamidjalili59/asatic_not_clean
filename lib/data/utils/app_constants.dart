import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_client/flutter_socket_client.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:asatic/data/utils/server_constants.dart';
import 'package:asatic/data/utils/socket_handler.dart';
import 'package:web_socket_channel/io.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../data/hive/account_data/account_data.dart';

class Constants {
// main Theme Colors
  static Color greenCol = const Color.fromARGB(255, 53, 210, 147);
  static Color primeryDarkCol = const Color.fromARGB(255, 40, 41, 43);
  static Color secondryDarkCol = const Color.fromARGB(255, 54, 55, 58);
  static Color fourDarkCol = const Color.fromARGB(255, 10, 10, 10);
  static Color appBarColor = const Color(0xff0e153a);
  static Color themeLight = const Color.fromARGB(255, 255, 255, 255);
  static Color thirdryDarkCol = const Color.fromARGB(255, 71, 71, 71);
  static Color transparentColor = const Color.fromARGB(0, 0, 0, 0);

  //Button_Colors

// sizes

  static SizedBox widthSpace = const SizedBox(width: 5);
  static Size hamidPhoneSize = const Size(393, 873);

  //
  // static Color drawerColor = const Color(0xFF302F2F);

  //paints
  static double radiusPaint = 3;

  //ints

  static int currentIndex = 0;
  static int appBarCardListLength = 0;
  static int relaySelected = 0;
  static int deviceSelected = 0;
  static int appbarMenuPosation = 0;
  static int bodyItemPosation = 0;
  static int deviceSelectedIndex = 0;

  //boolians
  static bool statusButton = false;
  static bool isAccepted = false;
  static bool remembered = false;
  static bool acceptedTerms = false;
  static bool isSignin = false;
  static bool flashDialogflag = false;
  static bool isTempConfigPage = false;
  static bool flagFolding = true;
  static String isOnline = '';
  static bool setOnline = false;
  static String isOffline = '';
  static bool setSocketStatus = false;
  static bool socketStarted = false;
  static bool buttonLoading = false;
  static bool streamStarted = false;

  // Database value constants

  static AccountData currentUserData = AccountData();

  // static var rememberedDatabase;
  static String verifyCode = "";
  static String regexValidator = r'^[a-zA-Z0-9$@$!%*?&#^-_. +]+$';
  static String currentSensorMode = "Cooler";
  static String jwtCode = "";
  static String sensorDefualtString = jsonEncode({
    "r1": {
      "type": "T",
      "mode": "Cooler",
      "tMax": 0.0,
      "tMin": 0.0,
      "hMax": 0.0,
      "hMin": 0.0,
      "s": false
    },
    "r2": {
      "type": "T",
      "mode": "Cooler",
      "tMax": 0.0,
      "tMin": 0.0,
      "hMax": 0.0,
      "hMin": 0.0,
      "s": false
    },
    "r3": {
      "type": "T",
      "mode": "Cooler",
      "tMax": 0.0,
      "tMin": 0.0,
      "hMax": 0.0,
      "hMin": 0.0,
      "s": false
    },
    "r4": {
      "type": "T",
      "mode": "Cooler",
      "tMax": 0.0,
      "tMin": 0.0,
      "hMax": 0.0,
      "hMin": 0.0,
      "s": false
    }
  });
  static String timerConfigPos = Constants
      .timerData[Constants.itemList.keys.toList()[Constants.appbarMenuPosation]]
          ["r$bodyItemPosation"]
      .keys
      .toList()
      .last;

  // Durations values

  static Duration timeOutDuration = const Duration(seconds: 10);
  static Duration loadingDuration = const Duration(milliseconds: 1500);

  // List

  static List appBarCardList = [];
  static List<Map<String, dynamic>> userManageList = [];
  static List<String> devicesListitems = [];
  // static List<String> devicesListitems = List.empty(growable: true);

  //Map
  static Map<dynamic, dynamic> itemList = {};
  static Map<dynamic, dynamic> remoteList = {};
  static Map<String, dynamic> dataBaseItems = {};
  static Map<String, dynamic> itemListCurrentPage = {};
  static Map<String, dynamic> bodyItemStatus = {};
  static Map<String, dynamic> espResponse = {};
  static Map<String, dynamic> timerData = {};
  static Map<String, dynamic> sensorData = {};
  static Map<String, dynamic> sensorSocketData = {};
  static Map<String, dynamic> nameAndDeviceID = {};

  static List<String> navbarPageRoutes = ["/home", "/profile", "/settings"];
  static StreamSubscription<
      Result<List<WiFiAccessPoint>, GetScannedResultsErrors>>? wifiSubscription;
  static List<dynamic> filteredLogs = [];
  // static List<dynamic> filteredLogs = List.empty(growable: true);
  static List<TextEditingController> editTextList = [];
  static List<String> remoteTypeList = ["toggle", "on/off"];
  static List<bool> foldOutList = [false, false, false, false];
  static List<String> monthNames = [
    "فروردین",
    "اردیبهشت",
    "خرداد",
    "تیر",
    "مرداد",
    "شهریور",
    "مهر",
    "آبان",
    "آذر",
    "دی",
    "بهمن",
    "اسفند"
  ];
  static List<String> weekDays = [
    "شنبه",
    "یکشنبه",
    "دوشنبه",
    "سه شنبه",
    "چهار شنبه",
    "پنج شنبه",
    "جمعه"
  ];

  // time of day

  static TimeOfDay? date;

  //Socket

  static Stream<bool>? streamPingPongInternal(context) =>
      Stream<bool>.periodic(const Duration(seconds: 5), (d) {
        return FlutterSocketClientImpl.socketStarted;
      }).takeWhile((element) => Constants.isOnline == 'false');

  static StreamSubscription<dynamic>? stream;
  static AsaticWebSocketHandler? streamOnline;

  //Esp data const

  static String usernameESP = "";
  static String pwdESP = "";
  static String usernameModem = "";
  static String pwdModem = "";
  static String currentVersion = "0.0.0.0";

  static String loginBody = """{
    "token":"mohsenandhamidandhadiandasakrobo",
    "PhoneNum":${RestAPIConstants.phoneNumberID}
}""";
  //urls
  static String hostUrl = isOnline == 'true' && !setOnline
      ? "http://asatic.ir/"
      : "http://192.168.1.210/";
  static String dataBaseSocket = "/ws?name=";
  static String reciveStatus =
      "http://asatic.ir/api/Devices/getdevice?deviceid=";
  static String updateDocLink = "http://asatic.ir/api/Devices";
  static String getLogLink = "http://asatic.ir/api/Devices/log/";

  // Socket
  static late IOWebSocketChannel channel;
  static late StreamSubscription<dynamic> localchannel;
  static StreamSubscription<dynamic>? socketStreamListener;
  static BuildContext? constContext;

// Keys

  // Hive Constants

  static late Box<dynamic> accountDataBox;
  static late Box<dynamic> deviceWifiList;
  static late Box<dynamic> optionsData;
  static Dio dio = Dio();

  static Logger logger = Logger();
}
