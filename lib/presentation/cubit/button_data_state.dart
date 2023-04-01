part of 'button_data_cubit.dart';

class ButtonDataState {
  bool isLoading;
  Map<dynamic, dynamic> status;
  Map<String, dynamic> currentPageStatus;
  Map<String, dynamic> currentSensorData;
  List<dynamic> userManageList;
  int appbarItemLength;
  bool actived;
  List logData;
  ButtonDataState({
    this.currentSensorData = const {},
    this.isLoading = false,
    this.status = const {},
    this.appbarItemLength = 0,
    this.currentPageStatus = const {},
    this.userManageList = const [],
    this.actived = false,
    this.logData = const [],
  });
}
