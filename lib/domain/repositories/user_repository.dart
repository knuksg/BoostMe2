import 'package:boostme2/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getUser();

  Future<void> addUser({
    required String email,
    required String username,
    required String bio,
    required String photoUrl,
  });

  Future<void> updateUser({
    required String email,
    required String username,
    required String bio,
    required String photoUrl,
  });

  Future<void> deleteUser();
}
