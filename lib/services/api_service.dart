import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://gray-dotterel-737970.hostingersite.com'; // Update with your API URL
  
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }
  
  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    final headers = await _getHeaders();
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }
  
  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    final headers = await _getHeaders();
    return await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }
  
  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    return await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
  }
  
  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await post('/api/login', body: {
      'email': email,
      'password': password,
    });
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token']) {
        await saveToken(data['token']);
      }
      return data;
    }
    throw Exception('Login failed: ${response.body}');
  }
  
  // Dashboard
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await get('/api/dashboard');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load dashboard');
  }
  
  // Events
  Future<List<dynamic>> getEvents() async {
    final response = await get('/api/events');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['events'] ?? [];
    }
    throw Exception('Failed to load events');
  }
  
  // Fees
  Future<List<dynamic>> getMyFees() async {
    final response = await get('/api/fees/my-fees');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['fees'] ?? [];
    }
    throw Exception('Failed to load fees');
  }
  
  // Clearance
  Future<List<dynamic>> getClearances() async {
    final response = await get('/api/clearance');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['clearances'] ?? [];
    }
    throw Exception('Failed to load clearances');
  }
  
  // Messages
  Future<List<dynamic>> getMessages() async {
    final response = await get('/api/messages');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['messages'] ?? [];
    }
    throw Exception('Failed to load messages');
  }
  
  // Elections
  Future<List<dynamic>> getElections() async {
    final response = await get('/api/vote/elections');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['elections'] ?? [];
    }
    throw Exception('Failed to load elections');
  }
  
  // Referendums
  Future<List<dynamic>> getReferendums() async {
    final response = await get('/api/vote/referendums');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['referendums'] ?? [];
    }
    throw Exception('Failed to load referendums');
  }
  
  // QR Code
  Future<Map<String, dynamic>> getQRCode() async {
    final response = await get('/api/qr-code');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load QR code');
  }
  
  // Library
  Future<List<dynamic>> getDocuments() async {
    final response = await get('/api/library');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['documents'] ?? [];
    }
    throw Exception('Failed to load documents');
  }
  
  // User Profile
  Future<Map<String, dynamic>> getUser() async {
    final response = await get('/api/user');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load user profile');
  }
}

