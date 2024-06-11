import 'package:aws_secretsmanager_api/secretsmanager-2017-10-17.dart';

Future<String> getSecret(String secretId) async {
  try {
    final service = SecretsManager(region: 'ap-northeast-2');
    final response = await service.getSecretValue(secretId: secretId);
    return response.secretString!;
  } catch (e) {
    print('Error fetching secret: $e');
    return '';
  }
}
