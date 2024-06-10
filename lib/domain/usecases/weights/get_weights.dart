import 'package:boostme2/domain/entities/weight.dart';
import 'package:boostme2/domain/repositories/weight_repository.dart';

class GetWeights {
  final WeightRepository repository;

  GetWeights(this.repository);

  Future<List<Weight>> call() async {
    return await repository.getWeights();
  }
}
