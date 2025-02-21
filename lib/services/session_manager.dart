import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/model/user.dart';

class SessionManager {
  final SharedPreferences preferences;

  SessionManager(this.preferences);

  final String stateKey = 'STATE';
  final String userKey = 'USER';

  Future<bool> isLoggedIn() async {
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    preferences.setString(userKey, userJson);
    preferences.setBool(stateKey, true);
    return true;
  }

  Future<bool> clearUser() async {
    return preferences.setString(userKey, '');
  }

  Future<bool> logout() async {
    await Future.delayed(Duration(seconds: 1));
    return preferences.setBool(stateKey, false);
  }

  Future<User?> getUser() async {
    final userJson = preferences.getString(userKey);
    if (userJson != null && userJson.isNotEmpty) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<String> getToken() async {
    final user = await getUser();
    return user?.token ?? '';
  }
}
