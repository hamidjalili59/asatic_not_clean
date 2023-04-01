import 'package:flutter/cupertino.dart';
import 'package:asatic/data/utils/api_services.dart';
import 'package:asatic/data/utils/app_constants.dart';
import 'package:asatic/data/utils/server_constants.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AsaticWebSocketHandler {
  final BuildContext ctx;
  AsaticWebSocketHandler(this.ctx) {
    socketChannelConnectingStatus().then((value) {
      if (value && !Constants.socketStarted) {
        var hamid = startPingPong();
        hamid.listen((event) {});
        _channel!.sink.add("ping");
        _channel!.stream.listen((event) {
          ApiServices().socketFunc(ctx, event);
        });
        Constants.setSocketStatus = true;
      } else {
        Constants.setSocketStatus = false;
      }
    });
  }

  IOWebSocketChannel? _channel;

  Stream startPingPong() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5)).whenComplete(
        () {
          try {
            _channel!.sink.add("ping");
          } on WebSocketChannelException {
            Constants.logger.e("___ Socket Exeption ____");
          } catch (e) {
            Constants.logger.e("___ Socket error $e ____");
          }
        },
      );
    }
  }

  bool get isConnected => Constants.socketStarted;

  Future<bool> socketChannelConnectingStatus() async {
    try {
      if (Constants.setSocketStatus == false) {
        _channel = IOWebSocketChannel.connect(
            'ws://asatic.ir/ws?name=${RestAPIConstants.phoneNumberID}');
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
