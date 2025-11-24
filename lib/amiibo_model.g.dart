// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amiibo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmiiboModelAdapter extends TypeAdapter<AmiiboModel> {
  @override
  final int typeId = 0;

  @override
  AmiiboModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AmiiboModel(
      amiiboSeries: fields[0] as String,
      character: fields[1] as String,
      gameSeries: fields[2] as String,
      head: fields[3] as String,
      tail: fields[4] as String,
      image: fields[5] as String,
      type: fields[6] as String,
      releaseAu: fields[7] as String,
      releaseEu: fields[8] as String,
      releaseJp: fields[9] as String,
      releaseNa: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AmiiboModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.amiiboSeries)
      ..writeByte(1)
      ..write(obj.character)
      ..writeByte(2)
      ..write(obj.gameSeries)
      ..writeByte(3)
      ..write(obj.head)
      ..writeByte(4)
      ..write(obj.tail)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.releaseAu)
      ..writeByte(8)
      ..write(obj.releaseEu)
      ..writeByte(9)
      ..write(obj.releaseJp)
      ..writeByte(10)
      ..write(obj.releaseNa);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmiiboModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
