class BookingIssue {
  int id;
  int bookingId;
  int inspectorId;
  int issueTypeId;
  int rtParentId;
  int rtChildId;
  String issueDescription;
  String severity;
  String status;
  String remarks;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  Booking booking;
  User user;
  IssueType issueType;
  RoomType roomType;
  ChildRoomType childRoomType;

  BookingIssue({
    required this.id,
    required this.bookingId,
    required this.inspectorId,
    required this.issueTypeId,
    required this.rtParentId,
    required this.rtChildId,
    required this.issueDescription,
    required this.severity,
    required this.status,
    required this.remarks,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.booking,
    required this.user,
    required this.issueType,
    required this.roomType,
    required this.childRoomType,
  });

  factory BookingIssue.fromJson(Map<String, dynamic> json) {
    return BookingIssue(
      id: json['id'],
      bookingId: json['bookingId'],
      inspectorId: json['inspectorId'],
      issueTypeId: json['issueTypeId'],
      rtParentId: json['rtParentId'],
      rtChildId: json['rtChildId'],
      issueDescription: json['issueDescription'] ?? '',
      severity: json['severity'],
      status: json['status'] ?? '',
      remarks: json['remarks'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      booking: Booking.fromJson(json['bookingissueBooking']),
      user: User.fromJson(json['bookingissueUser']),
      issueType: IssueType.fromJson(json['bookingissueIssuetype']),
      roomType: RoomType.fromJson(json['bookingissueRoomtype']),
      childRoomType: ChildRoomType.fromJson(json['bookingissueChildRoomtype']),
    );
  }
}

class Booking {
  int id;
  String clientName;
  String clientEmail;
  String clientContact;
  int checkTypeId;
  bool addReInspection;
  int ptParentId;
  int ptChildId;
  String numberOfBedrooms;
  String area;
  String community;
  String unit;
  String visitSlot;
  String specialInstruction;
  String doorImage;
  String finalRemarks;
  String bookingStatus;
  bool clientPaid;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  Booking({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    required this.clientContact,
    required this.checkTypeId,
    required this.addReInspection,
    required this.ptParentId,
    required this.ptChildId,
    required this.numberOfBedrooms,
    required this.area,
    required this.community,
    required this.unit,
    required this.visitSlot,
    required this.specialInstruction,
    required this.doorImage,
    required this.finalRemarks,
    required this.bookingStatus,
    required this.clientPaid,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      clientName: json['clientName'],
      clientEmail: json['clientEmail'],
      clientContact: json['clientContact'],
      checkTypeId: json['checkTypeId'],
      addReInspection: json['addReInspection'],
      ptParentId: json['ptParentId'],
      ptChildId: json['ptChildId'],
      numberOfBedrooms: json['numberOfBedrooms'],
      area: json['area'],
      community: json['community'],
      unit: json['unit'],
      visitSlot: json['visitSlot'],
      specialInstruction: json['specialInstruction'],
      doorImage: json['doorImage'],
      finalRemarks: json['finalRemarks'],
      bookingStatus: json['bookingStatus'],
      clientPaid: json['clientPaid'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class User {
  int id;
  String firstName;
  String lastName;
  String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}

class IssueType {
  int id;
  String name;
  Subcategory subcategory;

  IssueType({
    required this.id,
    required this.name,
    required this.subcategory,
  });

  factory IssueType.fromJson(Map<String, dynamic> json) {
    return IssueType(
      id: json['id'],
      name: json['name'],
      subcategory: Subcategory.fromJson(json['issuetypeSubcategory']),
    );
  }
}

class Subcategory {
  int id;
  String name;
  Category category;

  Subcategory({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      name: json['name'],
      category: Category.fromJson(json['subcategoryCategory']),
    );
  }
}

class Category {
  int id;
  String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class RoomType {
  int id;
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
}

class ChildRoomType {
  int id;
  String name;

  ChildRoomType({
    required this.id,
    required this.name,
  });

  factory ChildRoomType.fromJson(Map<String, dynamic> json) {
    return ChildRoomType(
      id: json['id'],
      name: json['name'],
    );
  }
}
