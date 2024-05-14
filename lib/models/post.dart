class Post {
  final String description;
  final String uid;
  final String username;
  final List likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      description: json['description'] ?? '',
      uid: json['uid'] ?? '',
      likes: json['likes'] ?? [],
      username: json['username'] ?? '',
      postId: json['postId'] ?? '',
      datePublished: json['datePublished'] != null
          ? DateTime.parse(json['datePublished'])
          : DateTime.now(),
      postUrl: json['postUrl'] ?? '',
      profImage: json['profImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished.toIso8601String(),
        'postUrl': postUrl,
        'profImage': profImage
      };
}
