// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wifi_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WifiDataAdapter extends TypeAdapter<WifiData> {
  @override
  final int typeId = 1;

  @override
  WifiData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WifiData(
      ssid: fields[0] as String,
      password: fields[1] as String,
      capabilities: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WifiData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.ssid)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.capabilities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WifiDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
