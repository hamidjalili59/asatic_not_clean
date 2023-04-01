import 'package:hive/hive.dart';

part 'account_data.g.dart';

@HiveType(typeId: 0)
class AccountData extends HiveObject {
  @HiveField(0)
  String cookie;

  @HiveField(1)
  int phoneNum;
  AccountData({this.cookie = "", this.phoneNum = 0});
}
