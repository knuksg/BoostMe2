import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/weight_viewmodel.dart';
import '../../domain/entities/weight.dart';
import 'package:intl/intl.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key});

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  final TextEditingController _weightController = TextEditingController();
  int _currentPage = 0;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  List<Weight> _fillMissingWeights(List<Weight> weights) {
    final now = DateTime.now();
    final Map<String, double> weightMap = {
      for (var weight in weights)
        DateFormat('MM/dd').format(weight.date): weight.weight
    };

    List<Weight> filledWeights = [];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateString = DateFormat('MM/dd').format(date);
      filledWeights.add(
        Weight(date: date, weight: weightMap[dateString] ?? 0),
      );
    }
    return filledWeights;
  }

  @override
  Widget build(BuildContext context) {
    final weightState = ref.watch(weightViewModelProvider);
    final weightViewModel = ref.read(weightViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Graph section
            SizedBox(
              height: 300,
              child: weightState.when(
                data: (weights) {
                  if (weights.isEmpty) {
                    return const Center(
                        child: Text('No weight data available'));
                  }

                  final filledWeights = _fillMissingWeights(weights);

                  return Column(
                    children: [
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: filledWeights
                                    .map((e) => e.weight)
                                    .reduce((a, b) => a > b ? a : b) +
                                30,
                            barGroups: filledWeights
                                .asMap()
                                .entries
                                .map((e) => BarChartGroupData(
                                      x: e.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e.value.weight,
                                          color: Colors.blue,
                                          width: 20,
                                        ),
                                      ],
                                    ))
                                .toList(),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index < 0 || index > 6) {
                                      return Container();
                                    }
                                    final date = filledWeights[index].date;
                                    return Text(
                                        DateFormat('MM/dd').format(date));
                                  },
                                  reservedSize: 22,
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true, reservedSize: 40),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: _currentPage > 0
                                ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                  }
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {}, // 더 이상 미래로 이동하지 않도록 함
                          ),
                        ],
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
            const SizedBox(height: 20),
            // Weight input
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter your weight',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final weight = double.tryParse(_weightController.text);
                if (weight != null) {
                  weightViewModel.addWeight(weight);
                  _weightController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a valid number'),
                  ));
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
