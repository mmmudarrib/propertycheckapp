import 'package:hive/hive.dart';

part 'booking.g.dart';

@HiveType(typeId: 0)
class Booking extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String clientName;
  @HiveField(2)
  String clientEmail;
  @HiveField(3)
  String clientContact;
  @HiveField(4)
  int checkTypeId;
  @HiveField(5)
  dynamic addReInspection;
  @HiveField(6)
  int ptParentId;
  @HiveField(7)
  int ptChildId;
  @HiveField(8)
  String numberOfBedrooms;
  @HiveField(9)
  String area;
  @HiveField(10)
  String community;
  @HiveField(11)
  String unit;
  @HiveField(12)
  String visitDate;
  @HiveField(13)
  String visitSlot;
  @HiveField(14)
  String specialInstruction;
  @HiveField(15)
  int inspectorId;
  @HiveField(16)
  dynamic clientPaid;
  @HiveField(17)
  bool isDeleted;
  @HiveField(18)
  DateTime createdAt;
  @HiveField(19)
  DateTime updatedAt;
  @HiveField(23)
  List<BookingRoomType> bookingBookingRoomType;
  @HiveField(24)
  String bookingStatus;
  @HiveField(25)
  String? mainDoorImage;
  @HiveField(27)
  String? doorImageTimestamp;
  @HiveField(26)
  String? bookingChildPropertytype;
  @HiveField(28)
  double? latitude;
  @HiveField(29)
  double? longitude;
  Booking(
      {required this.id,
      required this.clientName,
      required this.clientEmail,
      required this.clientContact,
      required this.checkTypeId,
      this.addReInspection,
      required this.ptParentId,
      required this.ptChildId,
      required this.numberOfBedrooms,
      required this.area,
      required this.community,
      required this.unit,
      required this.visitDate,
      required this.visitSlot,
      required this.specialInstruction,
      required this.inspectorId,
      this.clientPaid,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt,
      required this.bookingStatus,
      required this.bookingBookingRoomType,
      required this.bookingChildPropertytype,
      required this.mainDoorImage,
      required this.doorImageTimestamp,
      this.latitude,
      this.longitude});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      latitude: json['longitude'],
      longitude: json['latitude'],
      clientName: json['bookinginspectorBooking']['clientName'],
      clientEmail: json['bookinginspectorBooking']['clientEmail'],
      clientContact: json['bookinginspectorBooking']['clientContact'],
      checkTypeId: json['bookinginspectorBooking']['checkTypeId'],
      addReInspection: json['bookinginspectorBooking']['addReInspection'],
      ptParentId: json['bookinginspectorBooking']['ptParentId'],
      ptChildId: json['bookinginspectorBooking']['ptChildId'],
      numberOfBedrooms: json['bookinginspectorBooking']['numberOfBedrooms'],
      area: json['bookinginspectorBooking']['area'],
      community: json['bookinginspectorBooking']['community'],
      unit: json['bookinginspectorBooking']['unit'],
      visitDate: json['bookinginspectorBooking']['visitDate'],
      visitSlot: json['bookinginspectorBooking']['visitSlot'],
      specialInstruction: json['bookinginspectorBooking']['specialInstruction'],
      inspectorId: 4,
      bookingChildPropertytype: json['bookinginspectorBooking']
              ['bookingChildPropertytype']['id']
          .toString(),
      clientPaid: json['bookinginspectorBooking']['clientPaid'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['bookinginspectorBooking']['createdAt']),
      updatedAt: DateTime.parse(json['bookinginspectorBooking']['updatedAt']),
      bookingStatus:
          json['bookinginspectorBooking']["bookingStatus"] ?? "Planned",
      mainDoorImage: json['bookinginspectorBooking']["doorImage"],
      doorImageTimestamp:
          json['bookinginspectorBooking']["doorImageTimestamp"] ?? "",
      bookingBookingRoomType:
          (json['bookinginspectorBooking']['bookingBookingroomtype'] as List)
              .map((i) => BookingRoomType.fromJson(i))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientContact': clientContact,
      'checkTypeId': checkTypeId,
      'addReInspection': addReInspection,
      'ptParentId': ptParentId,
      'ptChildId': ptChildId,
      'numberOfBedrooms': numberOfBedrooms,
      'area': area,
      'community': community,
      'unit': unit,
      'visitDate': visitDate,
      'visitSlot': visitSlot,
      'specialInstruction': specialInstruction,
      'inspectorId': inspectorId,
      'clientPaid': clientPaid,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

@HiveType(typeId: 1)
class BookingUser extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String middleName;
  @HiveField(4)
  String email;

  BookingUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      middleName: json['middleName'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'email': email,
    };
  }
}

@HiveType(typeId: 2)
class BookingCheckType extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;

  BookingCheckType({
    required this.id,
    required this.name,
  });

  factory BookingCheckType.fromJson(Map<String, dynamic> json) {
    return BookingCheckType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

@HiveType(typeId: 3)
class BookingPropertyType extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;

  BookingPropertyType({
    required this.id,
    required this.name,
  });

  factory BookingPropertyType.fromJson(Map<String, dynamic> json) {
    return BookingPropertyType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

@HiveType(typeId: 4)
class BookingRoomType extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  int bookingId;
  @HiveField(2)
  int brtParentId;
  @HiveField(3)
  int brtChildId;
  @HiveField(4)
  RoomType bookingRoomType;
  @HiveField(5)
  RoomType bookingChildRoomType;

  BookingRoomType({
    required this.id,
    required this.bookingId,
    required this.brtParentId,
    required this.brtChildId,
    required this.bookingRoomType,
    required this.bookingChildRoomType,
  });

  factory BookingRoomType.fromJson(Map<String, dynamic> json) {
    return BookingRoomType(
      id: json['id'],
      bookingId: json['bookingId'],
      brtParentId: json['brtParentId'],
      brtChildId: json['brtChildId'],
      bookingRoomType: RoomType.fromJson(json['bookingroomtypeRoomtype']),
      bookingChildRoomType:
          RoomType.fromJson(json['bookingroomtypeChildRoomtype']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'brtParentId': brtParentId,
      'brtChildId': brtChildId,
      'bookingroomtypeRoomtype': bookingRoomType.toJson(),
      'bookingroomtypeChildRoomtype': bookingChildRoomType.toJson(),
    };
  }
}

@HiveType(typeId: 5)
class RoomType extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;

  RoomType({
    required this.id,
    required this.name,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

@HiveType(typeId: 6)
class BookingInspector extends HiveObject {
  @HiveField(0)
  int inspectorId;
  @HiveField(1)
  int bookingId;
  @HiveField(2)
  BookingInspectorUser bookingInspectorUser;

  BookingInspector({
    required this.inspectorId,
    required this.bookingId,
    required this.bookingInspectorUser,
  });

  factory BookingInspector.fromJson(Map<String, dynamic> json) {
    return BookingInspector(
      inspectorId: json['inspectorId'],
      bookingId: json['bookingId'],
      bookingInspectorUser:
          BookingInspectorUser.fromJson(json['bookinginspectorUser']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inspectorId': inspectorId,
      'bookingId': bookingId,
      'bookinginspectorUser': bookingInspectorUser.toJson(),
    };
  }
}

@HiveType(typeId: 7)
class BookingInspectorUser extends HiveObject {
  @HiveField(0)
  String email;

  BookingInspectorUser({
    required this.email,
  });

  factory BookingInspectorUser.fromJson(Map<String, dynamic> json) {
    return BookingInspectorUser(
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
