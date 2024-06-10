import 'package:boostme2/domain/repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<void> call({
    required String email,
    required String username,
    required String bio,
    required String photoUrl,
  }) async {
    await repository.updateUser(
      email: email,
      username: username,
      bio: bio,
      photoUrl: photoUrl,
    );
  }
}
