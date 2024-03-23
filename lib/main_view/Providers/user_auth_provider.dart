import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String username;
  final String phoneNumber;
  final String? email;
  final String? userType;
  final String? profileImageUrl;

  User({
    required this.username,
    required this.phoneNumber,
    this.email,
    this.userType,
    this.profileImageUrl,
  });
}

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> register(
    String? token,
  ) async {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token!);
    String username = decodedToken['username'];
    String phoneNumber = decodedToken['phoneNumber'];
    String email = decodedToken['emai'];
    String userType = decodedToken['userType'];
    String? profileImageUrl = decodedToken['imageUrl'];


    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", username);
    await prefs.setString("phoneNumber", phoneNumber);
    await prefs.setString("email", email);
    await prefs.setString("userType", userType);
    await prefs.setString("profileImage", profileImageUrl ?? '');

    _currentUser = User(
      email: email,
      userType: userType,
      profileImageUrl: profileImageUrl,
      username: username,
      phoneNumber: phoneNumber,
    );
    notifyListeners();
  }

  Future<void> login(String? token) async {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token!);
    String username = decodedToken['username'];
    String phoneNumber = decodedToken['phoneNumber'];
    String email = decodedToken['emai'];
    String userType = decodedToken['userType'];
    String? profileImageUrl = decodedToken['imageUrl'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", username);
    await prefs.setString("phoneNumber", phoneNumber);
    await prefs.setString("email", email);
    await prefs.setString("userType", userType);
    await prefs.setString("profileImage", profileImageUrl ?? '');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> initUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString("username");
    final phoneNumber = prefs.getString("phoneNumber");
    final email = prefs.getString("email");
    final userType = prefs.getString("userType");
    final profileImage = prefs.getString("profileImage");

    if (username != null && phoneNumber != null) {
      _currentUser = User(
        username: username,
        phoneNumber: phoneNumber,
        email: email,
        profileImageUrl: profileImage,
        userType: userType,
      );
      notifyListeners();
    }
  }
}
