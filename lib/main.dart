import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:asatic/data/hive/wifi_data/wifi_data.dart';
import 'data/hive/account_data/account_data.dart';
import 'data/utils/functions_helper.dart';
import 'presentation/cubit/button_data_cubit.dart';
import 'presentation/pages/app.dart';

void main() async {
  await initApp();
  // init Hive and set prototype
  Directory dir = await getApplicationDocumentsDirectory();
  Hive
    ..init(dir.path)
    ..initFlutter('hive_db')
    ..registerAdapter(AccountDataAdapter())
    ..registerAdapter(WifiDataAdapter());
    
  await initialLocalDatabase();
  // runApp
  runApp(BlocProvider<ButtonDataCubit>(
    create: (context) {
      return ButtonDataCubit();
    },
    child: const MyApp(),
  ));
}
