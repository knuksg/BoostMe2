import 'package:boostme2/domain/entities/user.dart';
import 'package:boostme2/domain/repositories/user_repository.dart';

class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  Future<User> call() async {
    return await repository.getUser();
  }
}
