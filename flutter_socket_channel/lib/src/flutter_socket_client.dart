import 'package:dartz/dartz.dart';
import 'package:flutter_socket_client/src/no_param.dart';
import 'package:flutter_socket_client/src/socket_errors.dart';

abstract class FlutterSocketClient {
  const FlutterSocketClient();

  Future<Stream> initializeConnecting();

  Future<Either<SocketError, NoParam>> closeSocket();

  Future<bool> testSocketConnection();
}
