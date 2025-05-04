// lib/services/auth_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AuthService {
  static const _fileName = 'users.json';

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<Map<String, String>> _readUsers() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        return Map<String, String>.from(json.decode(contents));
      }
    } catch (_) {}
    return {};
  }

  Future<void> _writeUsers(Map<String, String> users) async {
    final file = await _getLocalFile();
    await file.writeAsString(json.encode(users));
  }

  Future<bool> signup(String username, String password) async {
    var users = await _readUsers();
    if (users.containsKey(username)) return false;
    users[username] = password;
    await _writeUsers(users);
    return true;
  }

  Future<bool> login(String username, String password) async {
    var users = await _readUsers();
    return users[username] == password;
  }
}
