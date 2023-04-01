// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountDataAdapter extends TypeAdapter<AccountData> {
  @override
  final int typeId = 0;

  @override
  AccountData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountData(
      cookie: fields[0] as String,
      phoneNum: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AccountData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.cookie)
      ..writeByte(1)
      ..write(obj.phoneNum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
