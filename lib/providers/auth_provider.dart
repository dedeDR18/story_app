import 'package:flutter/material.dart';
import 'package:story_app/model/user.dart';
import 'package:story_app/services/api_service.dart';
import 'package:story_app/services/session_manager.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final SessionManager _sessionManager;

  AuthProvider(this._apiService, this._sessionManager);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  String errorMessage = '';

  Future<bool> login(String email, String password) async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);
      final user = User(
          name: result.loginResult!.name,
          userId: result.loginResult!.userId,
          token: result.loginResult!.token);
      isLoggedIn = await _sessionManager.saveUser(user);
    } catch (e) {
      errorMessage = e.toString().split(':').last.trim();
    }
    isLoadingLogin = false;
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> register(String name, String email, String password) async {
    isLoadingRegister = true;
    notifyListeners();
    try {
      await _apiService.registerUser(name, email, password);
    } catch (e) {
      errorMessage = e.toString().split(':').last.trim();
      isLoadingRegister = false;
      notifyListeners();
      return false;
    }

    isLoadingRegister = false;
    notifyListeners();
    return true;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();
    final logout = await _sessionManager.logout();
    if (logout) {
      await _sessionManager.clearUser();
    }
    isLoggedIn = await _sessionManager.isLoggedIn();
    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }
}
