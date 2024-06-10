import 'package:boostme2/domain/repositories/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<void> call() async {
    await repository.deleteUser();
  }
}
