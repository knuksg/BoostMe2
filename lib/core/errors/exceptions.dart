class ServerException implements Exception {
  final String message;

  ServerException({this.message = "An error occurred"});

  @override
  String toString() => "ServerException: $message";
}
