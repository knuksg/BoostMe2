class Yoga {
  final String yogaDate;
  final String yogaType;
  final String yogaDuration;
  final String yogaInstructor;
  final String yogaNote;
  final String uid;
  final String yId;

  const Yoga({
    required this.yogaDate,
    required this.yogaType,
    required this.yogaDuration,
    required this.yogaInstructor,
    required this.yogaNote,
    required this.uid,
    required this.yId,
  });

  static Yoga fromJson(Map<String, dynamic> json) => Yoga(
        yogaDate: json['yogaDate'],
        yogaType: json['yogaType'],
        yogaDuration: json['yogaDuration'],
        yogaInstructor: json['yogaInstructor'],
        yogaNote: json['yogaNote'],
        uid: json['uid'],
        yId: json['yId'],
      );

  Map<String, dynamic> toJson() => {
        'yogaDate': yogaDate,
        'yogaType': yogaType,
        'yogaDuration': yogaDuration,
        'yogaInstructor': yogaInstructor,
        'yogaNote': yogaNote,
        'uid': uid,
        'yId': yId,
      };
}
