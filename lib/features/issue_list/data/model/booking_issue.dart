class BookingIssue {
  final int id;
  final int bookingId;
  final int inspectorId;
  final int issueTypeId;
  final int rtParentId;
  final int rtChildId;
  final String issueDescription;
  final String severity;
  final String status;
  final String remarks;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BookingIssueBooking booking;
  final List<IssueImage> bookingIssueImages;
  final User inspector;
  final IssueType issueType;
  final RoomType roomType;
  final RoomType childRoomType;

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
    required this.bookingIssueImages,
    required this.inspector,
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
      remarks: json['remarks'] ?? '',
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      booking: BookingIssueBooking.fromJson(json['bookingissueBooking']),
      bookingIssueImages: (json['bookingissueBookingissueimage'] as List)
          .map((e) => IssueImage.fromJson(e))
          .toList(),
      inspector: User.fromJson(json['bookingissueUser']),
      issueType: IssueType.fromJson(json['bookingissueIssuetype']),
      roomType: RoomType.fromJson(json['bookingissueRoomtype']),
      childRoomType: RoomType.fromJson(json['bookingissueChildRoomtype']),
    );
  }
}

class BookingIssueBooking {
  final int id;
  final String clientName;
  final String clientEmail;
  final String clientContact;
  final String area;
  final String community;
  final String unit;
  final String visitDate;
  final String visitSlot;
  final bool isDeleted;
  final PropertyType propertyType;
  final PropertyType childPropertyType;

  BookingIssueBooking({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    required this.clientContact,
    required this.area,
    required this.community,
    required this.unit,
    required this.visitDate,
    required this.visitSlot,
    required this.isDeleted,
    required this.propertyType,
    required this.childPropertyType,
  });

  factory BookingIssueBooking.fromJson(Map<String, dynamic> json) {
    return BookingIssueBooking(
      id: json['id'],
      clientName: json['clientName'],
      clientEmail: json['clientEmail'],
      clientContact: json['clientContact'],
      area: json['area'],
      community: json['community'],
      unit: json['unit'],
      visitDate: json['visitDate'],
      visitSlot: json['visitSlot'],
      isDeleted: json['isDeleted'],
      propertyType: PropertyType.fromJson(json['bookingPropertytype']),
      childPropertyType:
          PropertyType.fromJson(json['bookingChildPropertytype']),
    );
  }
}

class IssueImage {
  final int id;
  final int bookingIssueId;
  final String issueImageUrl;
  final String notes;

  IssueImage({
    required this.id,
    required this.bookingIssueId,
    required this.issueImageUrl,
    required this.notes,
  });

  factory IssueImage.fromJson(Map<String, dynamic> json) {
    return IssueImage(
      id: json['id'],
      bookingIssueId: json['bookingIssueId'],
      issueImageUrl: json['issueImageUrl'],
      notes: json['notes'],
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;

  User({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}

class IssueType {
  final int id;
  final String name;
  final Subcategory subcategory;

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
  final int id;
  final String name;
  final Category category;

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
  final int id;
  final String name;

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
  final int id;
  final String name;

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

class PropertyType {
  final int id;
  final String name;

  PropertyType({
    required this.id,
    required this.name,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) {
    return PropertyType(
      id: json['id'],
      name: json['name'],
    );
  }
}
