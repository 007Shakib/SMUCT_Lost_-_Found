class UserModel {
  final String userId;
  String name;
  final String email;
  final String role; // 'Student', 'Teacher & Staff', 'Admin'
  String? phoneNumber;
  String? profilePhotoUrl;
  final String? department;
  final String? studentId;
  bool isSuspended;

  String get uid => userId;
  String get phone => phoneNumber ?? '';
  set phone(String val) => phoneNumber = val;
  String? get avatarUrl => profilePhotoUrl;
  set avatarUrl(String? val) => profilePhotoUrl = val;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.profilePhotoUrl,
    this.department,
    this.studentId,
    this.isSuspended = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      userId: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'Student',
      phoneNumber: map['phoneNumber'],
      profilePhotoUrl: map['profilePhotoUrl'],
      department: map['department'],
      studentId: map['studentId'],
      isSuspended: map['isSuspended'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'profilePhotoUrl': profilePhotoUrl,
      'department': department,
      'studentId': studentId,
      'isSuspended': isSuspended,
    };
  }
}
