import 'package:boostme2/domain/repositories/user_repository.dart';

class AddUser {
  final UserRepository repository;

  AddUser(this.repository);

  Future<void> call({
    required String email,
    required String username,
    required String bio,
    required String photoUrl,
  }) async {
    await repository.addUser(
      email: email,
      username: username,
      bio: bio,
      photoUrl: photoUrl,
    );
  }
}
