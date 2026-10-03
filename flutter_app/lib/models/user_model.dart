class UserModel {
  final String userId;
  final String name;
  final String email;
  final String role; // 'Student', 'Teacher', 'Staff', 'Admin'
  final String? phoneNumber;
  final String? profilePhotoUrl;
  final bool isSuspended;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.phoneNumber,
    this.profilePhotoUrl,
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
      'isSuspended': isSuspended,
    };
  }
}
