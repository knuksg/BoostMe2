import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boostme2/data/datasources/remote_datasource.dart';
import 'package:boostme2/data/repositories/user_repository_impl.dart';
import 'package:boostme2/data/repositories/weight_repository_impl.dart';
import 'package:boostme2/domain/repositories/user_repository.dart';
import 'package:boostme2/domain/repositories/weight_repository.dart';
import 'package:boostme2/domain/usecases/users/add_user.dart';
import 'package:boostme2/domain/usecases/users/delete_user.dart';
import 'package:boostme2/domain/usecases/users/get_user.dart';
import 'package:boostme2/domain/usecases/users/update_user.dart';
import 'package:boostme2/domain/usecases/weights/create_weight.dart';
import 'package:boostme2/domain/usecases/weights/get_weights.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return RemoteDataSource(client);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource);
});

final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  return WeightRepositoryImpl(remoteDataSource);
});

// User UseCases
final addUserProvider = Provider<AddUser>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return AddUser(repository);
});

final deleteUserProvider = Provider<DeleteUser>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return DeleteUser(repository);
});

final getUserInfoProvider = Provider<GetUser>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUser(repository);
});

final updateUserProvider = Provider<UpdateUser>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUser(repository);
});

// Weight UseCases
final createWeightProvider = Provider<CreateWeight>((ref) {
  final repository = ref.watch(weightRepositoryProvider);
  return CreateWeight(repository);
});

final getWeightsProvider = Provider<GetWeights>((ref) {
  final repository = ref.watch(weightRepositoryProvider);
  return GetWeights(repository);
});
