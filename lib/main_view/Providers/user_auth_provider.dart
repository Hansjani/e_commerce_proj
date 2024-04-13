import 'dart:convert';

import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../APIs/AdminActionAPI/admin_notification_for_app.dart';

class User {
  String username;
  String phoneNumber;
  String? email;
  String? userType;
  String? profileImageUrl;

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
    await prefs.setString(PrefsKeys.userName, username);
    await prefs.setString(PrefsKeys.userPhone, phoneNumber);
    await prefs.setString(PrefsKeys.userEmail, email);
    await prefs.setString(PrefsKeys.userType, userType);
    await prefs.setString(PrefsKeys.userProfile, profileImageUrl ?? '');

    _currentUser = User(
      email: email,
      userType: userType,
      profileImageUrl: profileImageUrl,
      username: username,
      phoneNumber: phoneNumber,
    );
    AppNotifications.userInit();
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
    await prefs.setString(PrefsKeys.userName, username);
    await prefs.setString(PrefsKeys.userPhone, phoneNumber);
    await prefs.setString(PrefsKeys.userEmail, email);
    await prefs.setString(PrefsKeys.userType, userType);
    await prefs.setString(PrefsKeys.userProfile, profileImageUrl ?? 'null');
    AppNotifications.userInit();
  }

  Future<void> logout({
    void Function(String success)? success,
    void Function(String error)? error,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(PrefsKeys.userName);
    final response = await http.put(Uri.parse(
        'http://192.168.29.184/app_db/Rgistered_user_actions/logout.php?username=$username'));
    if (response.statusCode == 200) {
      String message = jsonDecode(response.body)['message'];
      success?.call(message);
      await prefs.clear();
    } else {
      String message = jsonDecode(response.body)['error'];
      error?.call(message);
    }
  }

  Future<void> initUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(PrefsKeys.userName);
    final phoneNumber = prefs.getString(PrefsKeys.userPhone);
    final email = prefs.getString(PrefsKeys.userEmail);
    final userType = prefs.getString(PrefsKeys.userType);
    final profileImage = prefs.getString(PrefsKeys.userProfile);
    if (await isExpired()) {
      logout();
    } else {
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

  Future<void> updateUser({
    String? username,
    String? phoneNumber,
    String? email,
    String? userType,
    String? profileImageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (username != null) {
      await prefs.setString(PrefsKeys.userName, username);
    }
    if (phoneNumber != null) {
      await prefs.setString(PrefsKeys.userPhone, phoneNumber);
    }
    if (email != null) {
      await prefs.setString(PrefsKeys.userEmail, email);
    }
    if (userType != null) {
      await prefs.setString(PrefsKeys.userType, userType);
    }
    if (profileImageUrl != null) {
      await prefs.setString(PrefsKeys.userProfile, profileImageUrl);
    }

    if (await isExpired()) {
      logout();
    } else {
      final updatedUsername = username ?? prefs.getString(PrefsKeys.userName);
      final updatedPhoneNumber =
          phoneNumber ?? prefs.getString(PrefsKeys.userPhone);
      final updatedEmail = email ?? prefs.getString(PrefsKeys.userEmail);
      final updatedUserType = userType ?? prefs.getString(PrefsKeys.userType);
      final updatedProfileImage =
          profileImageUrl ?? prefs.getString(PrefsKeys.userProfile);

      if (updatedUsername != null && updatedPhoneNumber != null) {
        _currentUser = User(
          username: updatedUsername,
          phoneNumber: updatedPhoneNumber,
          email: updatedEmail,
          profileImageUrl: updatedProfileImage,
          userType: updatedUserType,
        );
        notifyListeners();
      }
    }
  }

  Future<bool> isExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PrefsKeys.userToken);
    if (token == null) {
      return true;
    } else {
      try {
        Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
        int? expirationTime = decodedToken['exp'];
        if (expirationTime != null) {
          DateTime expirationDate =
              DateTime.fromMillisecondsSinceEpoch(expirationTime * 1000);
          return DateTime.now().isAfter(expirationDate);
        } else {
          return true;
        }
      } catch (e) {
        throw Exception();
      }
    }
  }
}
