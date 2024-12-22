import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String _tokenKey , String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken(String _tokenKey) async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken(String _tokenKey) async {
    await _storage.delete(key: _tokenKey);
  }
}
