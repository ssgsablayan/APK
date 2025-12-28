import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isAuthenticated = false;
  bool _needsSetup = false;
  Map<String, dynamic>? _user;
  String? _errorMessage;
  
  bool get isAuthenticated => _isAuthenticated;
  bool get needsSetup => _needsSetup;
  Map<String, dynamic>? get user => _user;
  String? get errorMessage => _errorMessage;
  
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
          _errorMessage = null;
          notifyListeners();
        } else if (response.statusCode == 401) {
          // Token is invalid/expired
          await logout();
        } else {
          // Other error (network, server error, etc.)
          // Don't logout, just keep current state
          print('Auth check failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Network error or other exception
      // Don't logout on network errors - user might be offline
      print('Auth check error: $e');
      // Only logout if we had a token (means it's invalid)
      final token = await _apiService.getToken();
      if (token != null) {
        // Try to parse error - if it's 401, logout
        // Otherwise, keep current state
      }
    }
  }
  
  Future<bool> login(String email, String password) async {
    try {
      _errorMessage = null;
      final data = await _apiService.login(email, password);
      _isAuthenticated = true;
      _user = data['user'];
      _needsSetup = data['needs_setup'] ?? false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    await _apiService.clearToken();
    _isAuthenticated = false;
    _user = null;
    _needsSetup = false;
    _errorMessage = null;
    notifyListeners();
  }
  
  Future<void> completeSetup(Map<String, dynamic> setupData) async {
    try {
      _errorMessage = null;
      final response = await _apiService.post('/api/setup', body: setupData);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _needsSetup = data['needs_setup'] ?? false;
        // Refresh user data after setup
        final userResponse = await _apiService.get('/api/user');
        if (userResponse.statusCode == 200) {
          final userData = jsonDecode(userResponse.body);
          _user = userData['user'];
          _needsSetup = userData['needs_setup'] ?? false;
        }
        notifyListeners();
      } else {
        try {
          final errorData = jsonDecode(response.body);
          _errorMessage = errorData['error'] ?? 'Setup failed';
        } catch (e) {
          _errorMessage = 'Setup failed';
        }
        notifyListeners();
        throw Exception(_errorMessage);
      }
    } catch (e) {
      if (e is! Exception || !e.toString().contains(_errorMessage ?? '')) {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        notifyListeners();
      }
      rethrow;
    }
  }
}

