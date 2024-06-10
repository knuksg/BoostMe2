import 'package:boostme2/domain/repositories/weight_repository.dart';

class CreateWeight {
  final WeightRepository repository;

  CreateWeight(this.repository);

  Future<void> call(double weight) async {
    await repository.addWeight(weight);
  }
}
