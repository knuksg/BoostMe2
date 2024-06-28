import 'package:boostme2/data/datasources/remote_datasource.dart';
import 'package:boostme2/domain/entities/user.dart';
import 'package:boostme2/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUser() async {
    final userInfo = await remoteDataSource.getUser();

    final user = User(
      email: userInfo['email'],
      uid: userInfo['uid'],
      photoUrl: userInfo['photo_url'],
      username: userInfo['username'],
      bio: userInfo['bio'],
    );

    return user;
  }

  @override
  Future<void> addUser({
    required String email,
    required String username,
    required String bio,
    required String photoUrl,
  }) async {
    await remoteDataSource.addUser(
      email: email,
      username: username,
      bio: bio,
      photoUrl: photoUrl,
    );
  }

  @override
  Future<void> updateUser({
    required String email,
    required String username,
    required String bio,
    required String photoUrl,
  }) async {
    await remoteDataSource.updateUser(
      email: email,
      username: username,
      bio: bio,
      photoUrl: photoUrl,
    );
  }

  @override
  Future<void> deleteUser() async {
    await remoteDataSource.deleteUser();
  }
}
