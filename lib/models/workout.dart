class Workout {
  final String exerciseName;
  final String uid;
  final String exId;
  final String exWeight;
  final String exReps;
  final String exSets;
  final String exDate;

  const Workout({
    required this.exerciseName,
    required this.uid,
    required this.exId,
    required this.exWeight,
    required this.exReps,
    required this.exSets,
    required this.exDate,
  });

  static Workout fromJson(Map<String, dynamic> json) {
    return Workout(
      exerciseName: json['exerciseName'],
      uid: json['uid'],
      exId: json['exId'],
      exWeight: json['exWeight'],
      exReps: json['exReps'].toString(),
      exSets: json['exSets'].toString(),
      exDate: json['exDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "exId": exId,
        'exerciseName': exerciseName,
        'exWeight': exWeight,
        'exReps': exReps,
        'exSets': exSets,
        'exDate': exDate,
      };
}
