import 'dart:convert';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Constants/placeholders.dart';

class OrdersForAdmin {
  final int orderId;
  final String userId;
  final String totalAmount;
  final String orderDate;
  String orderStatus;
  final String username;

  OrdersForAdmin({
    required this.orderId,
    required this.userId,
    required this.totalAmount,
    required this.orderDate,
    required this.orderStatus,
    required this.username,
  });

  factory OrdersForAdmin.fromJson(Map<String, dynamic> json) {
    return OrdersForAdmin(
      orderId: json['orderId'] as int,
      userId: json['userId'],
      totalAmount: json['totalAmount'],
      orderDate: json['orderDate'],
      orderStatus: json['order_status'],
      username: json['username'],
    );
  }
}

class AdminOrderActionAPI {
  Uri baseUrl = Uri.parse(
      'http://${PlaceHolderImages.ip}/app_db/Admin_actions/admin_panel/order_action/');

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    return token;
  }

  Future<OrdersForAdmin?> getOrderById(
    int orderId,
    void Function(String errorMessage) error,
  ) async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Invalid user');
    }
    Uri finalUrl = baseUrl.resolve('admin_action.php?getType=single&orderId=$orderId');
    final response = await http.get(
      finalUrl,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return OrdersForAdmin.fromJson(jsonResponse);
    } else {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String errorMessage = jsonResponse['error'];
      error(errorMessage);
      return null;
    }
  }

  Future<List<OrdersForAdmin>> getAllOrders() async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Invalid user');
    }
    Uri finalUrl = baseUrl.resolve('admin_action.php?getType=all');
    final response = await http.get(
      finalUrl,
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<OrdersForAdmin> ordersList =
          jsonResponse.map((order) => OrdersForAdmin.fromJson(order)).toList();
      return ordersList;
    } else {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String errorMessage = jsonResponse['error'];
      throw Exception(errorMessage);
    }
  }

  Future<void> updateOrderStatus(
    int orderId,
    String orderStatus,
    void Function(String successMessage) success,
    void Function(String errorMessage) error,
  ) async {
    String? token = await getToken();
    if (token == null) {
      throw Exception('Invalid user');
    }
    Uri finalUrl = baseUrl.resolve('admin_action.php');
    final response = await http.post(
      finalUrl,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "status": orderStatus,
        "orderId": orderId,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successMessage = jsonResponse['message'];
      success(successMessage);
    } else {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String errorMessage = jsonResponse['error'];
      error(errorMessage);
    }
  }
}
