import 'package:boostme2/core/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boostme2/domain/entities/weight.dart';
import 'package:boostme2/domain/usecases/weights/create_weight.dart';
import 'package:boostme2/domain/usecases/weights/get_weights.dart';

final weightViewModelProvider =
    StateNotifierProvider<WeightViewModel, AsyncValue<List<Weight>>>((ref) {
  final getWeights = ref.watch(getWeightsProvider);
  final createWeight = ref.watch(createWeightProvider);
  return WeightViewModel(getWeights: getWeights, createWeight: createWeight);
});

class WeightViewModel extends StateNotifier<AsyncValue<List<Weight>>> {
  final GetWeights getWeights;
  final CreateWeight createWeight;

  WeightViewModel({required this.getWeights, required this.createWeight})
      : super(const AsyncValue.loading()) {
    loadWeights();
  }

  Future<void> loadWeights() async {
    try {
      final weights = await getWeights.call();
      state = AsyncValue.data(weights);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addWeight(double weight) async {
    try {
      await createWeight.call(weight);
      await loadWeights(); // 새로 저장한 후 체중 데이터를 다시 로드
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
