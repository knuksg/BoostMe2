class WeightModel {
  final String date; // DateTime -> String
  final double weight;

  WeightModel({
    required this.date,
    required this.weight,
  });

  factory WeightModel.fromJson(Map<String, dynamic> json) {
    return WeightModel(
      date: json['date'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'weight': weight,
    };
  }
}
