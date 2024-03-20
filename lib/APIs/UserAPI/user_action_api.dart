import 'dart:convert';
import 'dart:developer';
import 'package:e_commerce_ui_1/main_view/Providers/user_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiUser {
  final String? username;
  final String? password;
  final String? token;
  final String? email;
  final String? phoneNumber;
  final String? userType;
  final String? imageUrl;

  ApiUser(
      {required this.username,
      required this.password,
      required this.token,
      required this.email,
      required this.phoneNumber,
      required this.userType,
      required this.imageUrl});

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      username: json['username'],
      password: json['password'],
      token: json['token'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      userType: json['userType'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> regToJson() {
    return {
      "email": email,
      "username": username,
      "password": password,
      "phone_number": phoneNumber,
      "user_type": userType,
      "image_url": imageUrl,
    };
  }
}

class UserActionAPI {
  Uri baseUrl =
      Uri.parse('http://192.168.29.184/app_db/Rgistered_user_actions/');

  Future<void> userLogin(String username, String password,
      void Function(String) success, void Function(String) error) async {
    Uri finalUrl = baseUrl.resolve('login_user.php');
    try {
      final response = await http.post(
        finalUrl,
        body: jsonEncode(
          {
            "username": username,
            "password": password,
          },
        ),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        bool isSuccessful = jsonResponse['success'];
        if (isSuccessful) {
          String token = jsonResponse['token'];
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString('userToken', token);
          success('Success');
        } else {
          error("Error : ${jsonResponse['error']}");
          log(response.body);
        }
      } else {
        String jsonResponse = jsonDecode(response.body)['error'];
        error(jsonResponse);
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failure : $e');
    }
  }

  Future<void> registerUser(
      String? company,
      String? username,
      String? password,
      String? email,
      int? phoneNumber,
      String? userType,
      void Function(String?) success,
      void Function(String?) error,
      AuthProvider authProvider) async {
    Map<String, dynamic> toEncode = {
      "company": company,
      "username": username,
      "password": password,
      "email": email,
      "phone_number": phoneNumber,
      "user_type": userType,
    };
    String jsonBody = jsonEncode(toEncode);
    Uri finalUrl = baseUrl.resolve('register_user.php');
    final response = await http.post(
      finalUrl,
      body: jsonBody,
      headers: {
        "Content-Type": "application/json",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String token = jsonResponse['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userToken", token);
      authProvider.register(token);
      success(jsonResponse['message']);
    } else if (response.statusCode == 409) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else if (response.statusCode == 500) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else {
      log(response.statusCode.toString());
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    }
  }

  Future<List<String>> getCompanies() async {
    Uri finalUrl = Uri.parse(
        'http://192.168.29.184/app_db/Admin_actions/get_company_for_merchant.php');
    try {
      final response = await http.get(finalUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> companiesJson = data['companies'];
        final List<String> companies =
            companiesJson.map((companies) => companies.toString()).toList();
        return companies;
      } else {
        throw Exception('Failed to load companies ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load companies : $e');
    }
  }

  Future<void> deleteCurrentUser(
    String? username,
    String? password,
    void Function(String) success,
    void Function(String) error,
  ) async {
    Map<String, dynamic> toEncode = {
      "username": username,
      "password": password
    };
    String jsonBody = jsonEncode(toEncode);
    Uri finalUrl = baseUrl.resolve('');
    final response = await http.delete(
      finalUrl,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body)['message'];
      success(jsonResponse);
    } else if (response.statusCode == 400) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else if (response.statusCode == 404) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else if (response.statusCode == 405) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else if (response.statusCode == 500) {
      String jsonResponse = jsonDecode(response.body)['error'];
      error(jsonResponse);
    } else {
      error(response.statusCode.toString());
    }
  }
}

void saveData(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("username", username);
}

Future<String?> getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("username");
}

void logOutUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("username");
  await prefs.remove("userToken");
}

void areYouSure(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Are you sure ?'),
        content: const Text(
            'Do you really want to logout ? Some of the data might not be saved.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('cancel'),
          ),
          TextButton(
            onPressed: () {
              AuthProvider().logout();
            },
            child: const Text('yes'),
          ),
        ],
      );
    },
  );
}
