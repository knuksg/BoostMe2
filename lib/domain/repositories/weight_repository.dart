import 'package:boostme2/domain/entities/weight.dart';

abstract class WeightRepository {
  Future<void> addWeight(double weight);
  Future<List<Weight>> getWeights();
}
