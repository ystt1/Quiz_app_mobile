import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final TokenService _tokenService;
  final String baseUrl;

  ApiService(this._tokenService, {required this.baseUrl});

  Future<http.Response> get(String endpoint) async {
    final token = await _tokenService.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);

    if (response.statusCode == 401) {
      // Làm mới token nếu hết hạn
      final isRefreshed = await _refreshToken();
      if (isRefreshed) {
        return get(endpoint); // Gửi lại request với token mới
      } else {
        throw Exception('Refresh token failed');
      }
    }

    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final token = await _tokenService.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 401) {
      final isRefreshed = await _refreshToken();
      if (isRefreshed) {
        return post(endpoint, data); // Gửi lại request với token mới
      } else {
        throw Exception('Refresh token failed');
      }
    }

    return response;
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('http:/localhost:5000/api/user/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
          'token': 'Bearer $refreshToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['access_token'];
        final newRefreshToken = data['refresh_token'];

        await _tokenService.saveTokens(newAccessToken, newRefreshToken);
        return true;
      } else {
        await _tokenService.clearTokens();
        return false;
      }
    } catch (e) {

      await _tokenService.clearTokens();
      return false;
    }
  }
}




class TokenService {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(accessTokenKey, accessToken);
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
  }
}
