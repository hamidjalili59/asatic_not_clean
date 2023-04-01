import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_socket_client/src/constants.dart';
import 'package:flutter_socket_client/src/flutter_socket_client.dart';
import 'package:flutter_socket_client/src/socket_errors.dart';
import 'package:flutter_socket_client/src/no_param.dart';
import 'package:web_socket_channel/io.dart';

class FlutterSocketClientImpl implements FlutterSocketClient {
  final int phoneNumber;

  FlutterSocketClientImpl(this.phoneNumber);
  @override
  Future<Either<SocketError, NoParam>> closeSocket() async {
    try {
      Constants.streamSubscription!.cancel();
      Constants.streamSink!.close();
      return const Right(NoParam());
    } catch (e) {
      return Left(SocketError(errorMessage: e.toString()));
    }
  }

  @override
  Future<Stream> initializeConnecting() async {
    String uri = 'ws://asatic.ir/ws?name=$phoneNumber';
    Constants.socket = IOWebSocketChannel.connect(uri);
    Constants.streamSink = Constants.socket!.sink;
    Constants.streamSubscription = Constants.socket!.stream.listen((event) {})
      ..onDone(() {})
      ..onError((err) {
        Constants.socketStarted = false;
      });
    if (Constants.socketStarted == false) {
      connectionPing().join();
    }
    Constants.socketStarted = true;
    return Constants.socket!.stream;
  }

  @override
  Future<bool> testSocketConnection() async {
    try {
      Constants.streamSink!.add('ping');
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream connectionPing() async* {
    while (Constants.socketStarted) {
      try {
        Constants.streamSink!.add('ping');
        Constants.serverHandshake = false;
        await Future.delayed(const Duration(seconds: 5));
        if (Constants.serverHandshake == false) {
          Constants.socketStarted = false;
        }
      } catch (e) {
        Constants.socketStarted = false;
        await Future.delayed(const Duration(seconds: 5));
        throw const SocketException('socket Closed');
      }
    }
  }

  Stream listenWithAutoReConnect(
      {void Function(dynamic)? customFunction}) async* {
    Constants.clientFunction = customFunction;
    listenerOnData!((e) {
      customFunction!(e);
      if (e.toString().trim().contains("pong")) {
        Constants.serverHandshake = true;
      }
    });
  }

  static void Function(void Function(dynamic)?)? get listenerOnData =>
      Constants.streamSubscription?.onData;
  static bool get socketStarted => Constants.socketStarted;
}
