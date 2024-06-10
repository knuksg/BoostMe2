import 'package:boostme2/data/datasources/remote_datasource.dart';
import 'package:boostme2/domain/entities/weight.dart';
import 'package:boostme2/domain/repositories/weight_repository.dart';

class WeightRepositoryImpl implements WeightRepository {
  final RemoteDataSource remoteDataSource;

  WeightRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addWeight(double weight) async {
    await remoteDataSource.addWeight(weight);
  }

  @override
  Future<List<Weight>> getWeights() async {
    final weightsData = await remoteDataSource.getWeights();
    return weightsData.map((data) {
      return Weight(
        date: DateTime.parse(data['date']),
        weight: data['weight'],
      );
    }).toList();
  }
}
