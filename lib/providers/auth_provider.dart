import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isAuthenticated = false;
  bool _needsSetup = false;
  Map<String, dynamic>? _user;
  
  bool get isAuthenticated => _isAuthenticated;
  bool get needsSetup => _needsSetup;
  Map<String, dynamic>? get user => _user;
  
  Future<void> checkAuthStatus() async {
    try {
      final token = await _apiService.getToken();
      if (token != null) {
        // Verify token with backend
        final response = await _apiService.get('/api/user');
        if (response.statusCode == 200) {
          _isAuthenticated = true;
          final data = jsonDecode(response.body);
          _user = data['user'];
          _needsSetup = data['needs_setup'] ?? false;
          notifyListeners();
        } else {
          await logout();
        }
      }
    } catch (e) {
      await logout();
    }
  }
  
  Future<bool> login(String email, String password) async {
    try {
      final data = await _apiService.login(email, password);
      _isAuthenticated = true;
      _user = data['user'];
      _needsSetup = data['needs_setup'] ?? false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> logout() async {
    await _apiService.clearToken();
    _isAuthenticated = false;
    _user = null;
    _needsSetup = false;
    notifyListeners();
  }
  
  Future<void> completeSetup(Map<String, dynamic> setupData) async {
    try {
      final response = await _apiService.post('/api/setup', body: setupData);
      if (response.statusCode == 200) {
        _needsSetup = false;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}

