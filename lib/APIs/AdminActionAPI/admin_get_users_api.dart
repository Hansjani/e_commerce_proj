import 'dart:convert';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Users {
  final String id;
  final String email;
  final String password;
  final String username;
  final int phoneNumber;
  final String imageUrl;
  final String userType;
  final String? userCompany;

  Users(
      {required this.id,
      required this.email,
      required this.password,
      required this.username,
      required this.phoneNumber,
      required this.imageUrl,
      required this.userType,
      required this.userCompany});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
      phoneNumber: int.parse(json['phone_number']),
      imageUrl: json['imageUrl'] ??
          'http://192.168.29.184/app_db/server_file/users/user_profile.jpeg',
      userType: json['userType'],
      userCompany: json['userType'] == 'merchant' || json['userType'] == 'admin'
          ? json['company'] ?? 'No company'
          : 'N/A',
    );
  }
}

class UserCRUD {
  Uri baseUrl = Uri.parse(
      'http://192.168.29.184/app_db/Admin_actions/admin_panel/user_info/');

  Future<void> createUser(
    String email,
    String password,
    String username,
    int phoneNumber,
    String userType,
  ) async {
    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
      'username': username,
      'phone_number': phoneNumber,
      'userType': userType,
    };

    String jsonRequestBody = jsonEncode(requestBody);
    Uri fullUrl = baseUrl.resolve('user_create.php');
    final response = await http.post(
      fullUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonRequestBody,
    );
    if (response.statusCode == 200) {
    } else if (response.statusCode == 405) {
    } else if (response.statusCode == 409) {
    } else if (response.statusCode == 500) {
    } else {}
  }

  Future<Users?> getByUsername(String username) async {
    Uri fullUrl = baseUrl.resolve(
        'http://192.168.29.184/app_db/Rgistered_user_actions/get_by_username.php?username=$username');
    final response = await http.get(fullUrl, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      Users user = Users.fromJson(jsonResponse);
      return user;
    } else {
      print(response.body);
      throw Exception();
    }
  }

  Future<List<Users>?> readUser() async {
    Uri fullUrl = baseUrl
        .resolve('http://192.168.29.184/app_db/Admin_actions/user_read.php');
    final response = await http.get(
      fullUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((user) => Users.fromJson(user)).toList();
    } else if (response.statusCode == 404) {
    } else if (response.statusCode == 405) {
    } else if (response.statusCode == 409) {
    } else if (response.statusCode == 500) {
    } else {}
    return null;
  }

  Future<void> updateUser(
    String email,
    String password,
    String username,
    int phoneNumber,
  ) async {
    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
      'username': username,
      'phone_number': phoneNumber,
    };

    String jsonRequestBody = jsonEncode(requestBody);
    Uri fullUrl = baseUrl.resolve('user_create.php');
    final response = await http.post(
      fullUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonRequestBody,
    );
    if (response.statusCode == 200) {
    } else if (response.statusCode == 404) {
    } else if (response.statusCode == 405) {
    } else if (response.statusCode == 409) {
    } else if (response.statusCode == 500) {
    } else {}
  }

  Future<void> deleteUser(
    String password,
    String username,
  ) async {
    Map<String, dynamic> requestBody = {
      'password': password,
      'username': username,
    };

    String jsonRequestBody = jsonEncode(requestBody);
    Uri fullUrl = baseUrl.resolve('user_create.php');
    final response = await http.post(
      fullUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonRequestBody,
    );
    if (response.statusCode == 200) {
    } else if (response.statusCode == 404) {
    } else if (response.statusCode == 405) {
    } else if (response.statusCode == 409) {
    } else if (response.statusCode == 500) {
    } else {}
  }

  Future<bool> isApprovedMerchant() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(PrefsKeys.userName);
    if(username != null){
      Uri finalUrl = baseUrl.resolve('merchant_approval.php?username=$username');
      final response = await http.get(
        finalUrl,
        headers: {"Content-Type": "application/jsom"},
      );
      if (response.statusCode == 200) {
        Map<String,dynamic> jsonResponse = jsonDecode(response.body);
        int isApproved = jsonResponse['is_approved'] ?? 0;
        if(isApproved == 1){
          return true;
        }else{
          return false;
        }
      } else {
        throw Exception();
      }
    }else{
      return false;
    }
  }
}
