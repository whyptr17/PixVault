// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotoModelAdapter extends TypeAdapter<PhotoModel> {
  @override
  final int typeId = 0;

  @override
  PhotoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotoModel(
      id: fields[0] as String,
      title: fields[1] as String,
      filename: fields[2] as String,
      size: fields[3] as int,
      width: fields[4] as int,
      height: fields[5] as int,
      url: fields[6] as String,
      displayUrl: fields[7] as String,
      thumbUrl: fields[8] as String,
      deleteUrl: fields[9] as String,
      viewerUrl: fields[10] as String,
      htmlEmbed: fields[11] as String,
      bbCode: fields[12] as String,
      tags: (fields[13] as List).cast<String>(),
      albumId: fields[14] as String?,
      isFavorite: fields[15] as bool,
      isPrivate: fields[16] as bool,
      uploadedAt: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PhotoModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.filename)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.width)
      ..writeByte(5)
      ..write(obj.height)
      ..writeByte(6)
      ..write(obj.url)
      ..writeByte(7)
      ..write(obj.displayUrl)
      ..writeByte(8)
      ..write(obj.thumbUrl)
      ..writeByte(9)
      ..write(obj.deleteUrl)
      ..writeByte(10)
      ..write(obj.viewerUrl)
      ..writeByte(11)
      ..write(obj.htmlEmbed)
      ..writeByte(12)
      ..write(obj.bbCode)
      ..writeByte(13)
      ..write(obj.tags)
      ..writeByte(14)
      ..write(obj.albumId)
      ..writeByte(15)
      ..write(obj.isFavorite)
      ..writeByte(16)
      ..write(obj.isPrivate)
      ..writeByte(17)
      ..write(obj.uploadedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
