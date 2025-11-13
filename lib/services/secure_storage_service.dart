import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _keyUserRole = 'user_role';
  static const _keyUserData = 'user_data';

  static Future<void> saveUserData({
    required String role,
    required Map<String, dynamic> userData,
  }) async {
    await _storage.write(key: _keyUserRole, value: role);
    await _storage.write(key: _keyUserData, value: jsonEncode(userData));
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _keyUserRole);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: _keyUserData);
    if (data == null) return null;
    return jsonDecode(data);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
