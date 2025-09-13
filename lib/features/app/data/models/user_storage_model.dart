import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class UserStorage {
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _fileName = 'user_data.json';

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // Save user data when login
  static Future<void> saveUser({required String username, required String userId}) async {
    final file = await _getFile();
    final data = {
      _userNameKey: username,
      _userIdKey: userId,
      _isLoggedInKey: true,
    };
    await file.writeAsString(jsonEncode(data));
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content);
        return data[_isLoggedInKey] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get username
  static Future<String?> getUsername() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content);
        return data[_userNameKey];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get user ID
  static Future<String?> getUserId() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = jsonDecode(content);
        return data[_userIdKey];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Logout (clear data)
  static Future<void> logout() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}