
// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  
  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _tokenTypeKey = 'token_type';
  static const String _expiresInKey = 'expires_in';
  
  // Token operations
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  static Future<void> saveTokenType(String tokenType) async {
    await _storage.write(key: _tokenTypeKey, value: tokenType);
  }
  
  static Future<String?> getTokenType() async {
    return await _storage.read(key: _tokenTypeKey);
  }
  
  static Future<void> saveExpiresIn(int expiresIn) async {
    await _storage.write(key: _expiresInKey, value: expiresIn.toString());
  }
  
  /*static Future<int?> getExpiresIn() async {
    final expiresIn = await _storage.read(key: _expiresInKey);
    return expiresIn != null ? int.tryParse(expiresIn) : null;
  }*/
  
  // User data operations
  static Future<void> saveUserData(String userData) async {
    await _storage.write(key: _userKey, value: userData);
  }
  
  static Future<String?> getUserData() async {
    return await _storage.read(key: _userKey);
  }
  
  // Clear all data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
  
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
