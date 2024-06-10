class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      username: json["username"],
      uid: json["uid"].toString(),
      email: json["email"],
      photoUrl: json["photo_url"] ?? '',
      bio: json["bio"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photo_url": photoUrl,
        "bio": bio,
      };
}
