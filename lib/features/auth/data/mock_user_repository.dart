import '../models/user.dart';

class MockUserRepository {
  static const List<_MockAccount> _accounts = [
    _MockAccount(
      user: User(
        id: 'ARM-USER-001',
        name: 'Administrator',
        email: 'admin@armory.local',
        role: UserRole.administrator,
        profileImage: 'assets/images/profile/admin.jpg',
      ),
      password: 'armory123',
    ),
    _MockAccount(
      user: User(
        id: 'ARM-USER-002',
        name: 'Operator',
        email: 'operator@armory.local',
        role: UserRole.operator,
      ),
      password: 'operator123',
    ),
    _MockAccount(
      user: User(
        id: 'ARM-USER-003',
        name: 'Viewer',
        email: 'viewer@armory.local',
        role: UserRole.viewer,
      ),
      password: 'viewer123',
    ),
  ];

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 500),
    );

    for (final account in _accounts) {
      if (account.user.email == email.trim() &&
          account.password == password) {
        return account.user;
      }
    }

    return null;
  }
}

class _MockAccount {
  final User user;
  final String password;

  const _MockAccount({
    required this.user,
    required this.password,
  });
}