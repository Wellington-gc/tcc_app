// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fall_code.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FallCodeAdapter extends TypeAdapter<FallCode> {
  @override
  final int typeId = 1;

  @override
  FallCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FallCode(
      code: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FallCode obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FallCodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
