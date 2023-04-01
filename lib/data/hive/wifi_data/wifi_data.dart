import 'package:hive/hive.dart';

part 'wifi_data.g.dart';

@HiveType(typeId: 1)
class WifiData extends HiveObject {
  @HiveField(0)
  String ssid;

  @HiveField(1)
  String password;

  @HiveField(2)
  String capabilities;
  WifiData(
      {this.ssid = "", required this.password, required this.capabilities});
}
