class Issue {
  final String roomType;
  final String issueCategory;
  final String issueSubCategory;
  final String issue;

  Issue({
    required this.roomType,
    required this.issueCategory,
    required this.issueSubCategory,
    required this.issue,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      roomType: json['roomType'],
      issueCategory: json['issueCategory'],
      issueSubCategory: json['issueSubCategory'],
      issue: json['issue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomType': roomType,
      'issueCategory': issueCategory,
      'issueSubCategory': issueSubCategory,
      'issue': issue,
    };
  }

  static Issue fromDomain(dynamic domainIssue) {
    return Issue(
      roomType: domainIssue.roomType?.name ?? "Unknown Room Type",
      issueCategory: domainIssue.issueType?.subcategory.category.name ??
          "Unknown Category",
      issueSubCategory:
          domainIssue.issueType?.subcategory.name ?? "Unknown Subcategory",
      issue: domainIssue.issueType?.name ?? "Unknown Issue",
    );
  }
}
