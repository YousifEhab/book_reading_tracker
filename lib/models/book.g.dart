// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 1;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      id: fields[0] as String,
      title: fields[1] as String,
      author: fields[2] as String,
      totalPages: fields[3] as int,
      currentPage: fields[4] as int,
      status: fields[5] as ReadingStatus,
      dateAdded: fields[6] as DateTime,
      dateStarted: fields[7] as DateTime?,
      dateCompleted: fields[8] as DateTime?,
      notes: fields[9] as String?,
      rating: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.totalPages)
      ..writeByte(4)
      ..write(obj.currentPage)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.dateAdded)
      ..writeByte(7)
      ..write(obj.dateStarted)
      ..writeByte(8)
      ..write(obj.dateCompleted)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReadingStatusAdapter extends TypeAdapter<ReadingStatus> {
  @override
  final int typeId = 0;

  @override
  ReadingStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReadingStatus.toRead;
      case 1:
        return ReadingStatus.reading;
      case 2:
        return ReadingStatus.completed;
      case 3:
        return ReadingStatus.abandoned;
      default:
        return ReadingStatus.toRead;
    }
  }

  @override
  void write(BinaryWriter writer, ReadingStatus obj) {
    switch (obj) {
      case ReadingStatus.toRead:
        writer.writeByte(0);
        break;
      case ReadingStatus.reading:
        writer.writeByte(1);
        break;
      case ReadingStatus.completed:
        writer.writeByte(2);
        break;
      case ReadingStatus.abandoned:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
