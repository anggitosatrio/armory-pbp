enum UserRole {
  administrator,
  operator,
  viewer,
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
  });
}