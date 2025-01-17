// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingAdapter extends TypeAdapter<Booking> {
  @override
  final int typeId = 0;

  @override
  Booking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Booking(
      id: fields[0] as int,
      clientName: fields[1] as String,
      clientEmail: fields[2] as String,
      clientContact: fields[3] as String,
      checkTypeId: fields[4] as int,
      addReInspection: fields[5] as dynamic,
      ptParentId: fields[6] as int,
      ptChildId: fields[7] as int,
      numberOfBedrooms: fields[8] as String,
      area: fields[9] as String,
      community: fields[10] as String,
      unit: fields[11] as String,
      visitDate: fields[12] as String,
      visitSlot: fields[13] as String,
      specialInstruction: fields[14] as String,
      inspectorId: fields[15] as int,
      clientPaid: fields[16] as dynamic,
      isDeleted: fields[17] as bool,
      createdAt: fields[18] as DateTime,
      updatedAt: fields[19] as DateTime,
      bookingStatus: fields[24] as String,
      bookingBookingRoomType: (fields[23] as List).cast<BookingRoomType>(),
      bookingChildPropertytype: fields[26] as String?,
      mainDoorImage: fields[25] as String?,
      doorImageTimestamp: fields[27] as String?,
      bookingChildPropertytypeName: fields[31] as String?,
      latitude: fields[28] as String?,
      longitude: fields[29] as String?,
      checkType: fields[30] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Booking obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clientName)
      ..writeByte(2)
      ..write(obj.clientEmail)
      ..writeByte(3)
      ..write(obj.clientContact)
      ..writeByte(4)
      ..write(obj.checkTypeId)
      ..writeByte(5)
      ..write(obj.addReInspection)
      ..writeByte(6)
      ..write(obj.ptParentId)
      ..writeByte(7)
      ..write(obj.ptChildId)
      ..writeByte(8)
      ..write(obj.numberOfBedrooms)
      ..writeByte(9)
      ..write(obj.area)
      ..writeByte(10)
      ..write(obj.community)
      ..writeByte(11)
      ..write(obj.unit)
      ..writeByte(12)
      ..write(obj.visitDate)
      ..writeByte(13)
      ..write(obj.visitSlot)
      ..writeByte(14)
      ..write(obj.specialInstruction)
      ..writeByte(15)
      ..write(obj.inspectorId)
      ..writeByte(16)
      ..write(obj.clientPaid)
      ..writeByte(17)
      ..write(obj.isDeleted)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt)
      ..writeByte(23)
      ..write(obj.bookingBookingRoomType)
      ..writeByte(24)
      ..write(obj.bookingStatus)
      ..writeByte(25)
      ..write(obj.mainDoorImage)
      ..writeByte(27)
      ..write(obj.doorImageTimestamp)
      ..writeByte(26)
      ..write(obj.bookingChildPropertytype)
      ..writeByte(28)
      ..write(obj.latitude)
      ..writeByte(29)
      ..write(obj.longitude)
      ..writeByte(30)
      ..write(obj.checkType)
      ..writeByte(31)
      ..write(obj.bookingChildPropertytypeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingUserAdapter extends TypeAdapter<BookingUser> {
  @override
  final int typeId = 1;

  @override
  BookingUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingUser(
      id: fields[0] as int,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      middleName: fields[3] as String,
      email: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingUser obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.middleName)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingCheckTypeAdapter extends TypeAdapter<BookingCheckType> {
  @override
  final int typeId = 2;

  @override
  BookingCheckType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingCheckType(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingCheckType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingCheckTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingPropertyTypeAdapter extends TypeAdapter<BookingPropertyType> {
  @override
  final int typeId = 3;

  @override
  BookingPropertyType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingPropertyType(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingPropertyType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingPropertyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingRoomTypeAdapter extends TypeAdapter<BookingRoomType> {
  @override
  final int typeId = 4;

  @override
  BookingRoomType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingRoomType(
      id: fields[0] as int,
      bookingId: fields[1] as int,
      brtParentId: fields[2] as int,
      brtChildId: fields[3] as int,
      bookingRoomType: fields[4] as RoomType,
      bookingChildRoomType: fields[5] as RoomType,
    );
  }

  @override
  void write(BinaryWriter writer, BookingRoomType obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookingId)
      ..writeByte(2)
      ..write(obj.brtParentId)
      ..writeByte(3)
      ..write(obj.brtChildId)
      ..writeByte(4)
      ..write(obj.bookingRoomType)
      ..writeByte(5)
      ..write(obj.bookingChildRoomType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingRoomTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoomTypeAdapter extends TypeAdapter<RoomType> {
  @override
  final int typeId = 5;

  @override
  RoomType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomType(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RoomType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingInspectorAdapter extends TypeAdapter<BookingInspector> {
  @override
  final int typeId = 6;

  @override
  BookingInspector read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingInspector(
      inspectorId: fields[0] as int,
      bookingId: fields[1] as int,
      bookingInspectorUser: fields[2] as BookingInspectorUser,
    );
  }

  @override
  void write(BinaryWriter writer, BookingInspector obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.inspectorId)
      ..writeByte(1)
      ..write(obj.bookingId)
      ..writeByte(2)
      ..write(obj.bookingInspectorUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingInspectorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingInspectorUserAdapter extends TypeAdapter<BookingInspectorUser> {
  @override
  final int typeId = 7;

  @override
  BookingInspectorUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingInspectorUser(
      email: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingInspectorUser obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingInspectorUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
