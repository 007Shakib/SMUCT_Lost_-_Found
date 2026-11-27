import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool emailVerified;
  DateTime? createdAt;

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
    this.emailVerified = false,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime? parsedCreatedAt;
    if (map['createdAt'] != null) {
      if (map['createdAt'] is Timestamp) {
        parsedCreatedAt = (map['createdAt'] as Timestamp).toDate();
      } else if (map['createdAt'] is String) {
        parsedCreatedAt = DateTime.tryParse(map['createdAt']);
      }
    }

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
      emailVerified: map['emailVerified'] ?? false,
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'profilePhotoUrl': profilePhotoUrl,
      'department': department,
      'studentId': studentId,
      'isSuspended': isSuspended,
      'emailVerified': emailVerified,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? name,
    String? role,
    String? phoneNumber,
    String? profilePhotoUrl,
    String? department,
    String? studentId,
    bool? isSuspended,
    bool? emailVerified,
  }) {
    return UserModel(
      userId: userId,
      name: name ?? this.name,
      email: email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      department: department ?? this.department,
      studentId: studentId ?? this.studentId,
      isSuspended: isSuspended ?? this.isSuspended,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt,
    );
  }
}
