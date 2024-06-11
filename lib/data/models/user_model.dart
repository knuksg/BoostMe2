import 'package:boostme2/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.uid,
    required super.photoUrl,
    required super.username,
    required super.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      uid: json['uid'],
      photoUrl: json['photoUrl'],
      username: json['username'],
      bio: json['bio'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'uid': uid,
      'photoUrl': photoUrl,
      'username': username,
      'bio': bio,
    };
  }
}
