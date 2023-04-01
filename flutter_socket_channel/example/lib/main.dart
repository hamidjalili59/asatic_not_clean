import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_socket_client/flutter_socket_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Socket Test',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // قسمتی که قراره متن دریافتی سوکت پرینت بشه      color : greenAccent
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    color: Constants.socketConnected
                        ? Colors.greenAccent
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: Text(text),
                ),
              ),
              const SizedBox(height: 30),
              // باتن که برای ارسال اطلاعات به سوکت استفاده میشه      color : blue
              MaterialButton(
                color: Constants.socketConnected ? Colors.blue : Colors.grey,
                minWidth: 120,
                height: 60,
                onPressed: send,
                child: const Text('send',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 30),
              // باتن که برای اتصال به سوکت استفاده میشه      color : redAccent
              MaterialButton(
                color:
                    !Constants.socketConnected ? Colors.redAccent : Colors.grey,
                minWidth: 120,
                height: 60,
                onPressed: () {
                  setState(() {
                    connect();
                  });
                },
                child: const Text('connect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 30),
              // باتن که برای اتصال مجدد به سوکت استفاده میشه      color : indigoAccent
              MaterialButton(
                color: Constants.socketConnected
                    ? Colors.indigoAccent
                    : Colors.grey,
                minWidth: 120,
                height: 60,
                onPressed: () {
                  setState(() {
                    reConnect();
                  });
                },
                child: const Text('reConnect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void send() {
    setState(() {});
  }

  void connect() async {
    await FlutterSocketClientImpl(9361360584).initializeConnecting();

    FlutterSocketClientImpl(9361360584).listenWithAutoReConnect(customFunction: (e) {
      setState(() {
        if (e.toString() == "pong") {
          text = e.toString();
        }
      });
    }).join();
    Constants.socketConnected = true;
  }

  void reConnect() async {
    await FlutterSocketClientImpl(9361360584).closeSocket();
    Constants.socketConnected = false;
  }
}

class Constants {
  static bool socketConnected = false;
  static Stream? socket;
  static StreamSubscription<dynamic>? socketListener;
}
