import 'dart:async';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Constants {
  static IOWebSocketChannel? socket;
  static StreamSubscription<dynamic>? streamSubscription;
  static WebSocketSink? streamSink;
  static void Function(dynamic)? onData;
  static bool socketStarted = false;
  static bool serverHandshake = false;
  static Map<String, dynamic> previousEvent = {};
  static Map<String, dynamic> currentEvent = {};
  static void Function(dynamic)? clientFunction;
}
