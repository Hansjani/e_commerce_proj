import 'dart:convert';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderForUser {
  final int orderId;
  final String userId;
  final String totalAmount;
  final String orderDate;
  final String orderStatus;
  final List<OrderItemForOrder> orderItems;

  factory OrderForUser.fromJson(Map<String, dynamic> json) {
    List<OrderItemForOrder> orderItems = [];
    if (json['orderItems'] != null) {
      json['orderItems'].forEach((itemJson) {
        orderItems.add(OrderItemForOrder.fromJson(itemJson));
      });
    }
    return OrderForUser(
      orderId: json['orderId'],
      userId: json['userId'],
      totalAmount: json['totalAmount'],
      orderDate: json['orderDate'],
      orderStatus: json['order_status'],
      orderItems: orderItems,
    );
  }

  OrderForUser({
    required this.orderId,
    required this.userId,
    required this.totalAmount,
    required this.orderDate,
    required this.orderStatus,
    required this.orderItems,
  });
}

class OrderItemForOrder {
  final int orderItemId;
  final int orderId;
  final int productId;
  final int quantity;
  final String price;
  final String? imageUrl;
  final String status;

  factory OrderItemForOrder.fromJson(Map<String, dynamic> json) {
    return OrderItemForOrder(
      orderItemId: json['orderItemId'],
      orderId: json['orderId'],
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      status: json['status'],
    );
  }

  OrderItemForOrder(
      {required this.orderItemId,
      required this.orderId,
      required this.productId,
      required this.quantity,
      required this.price,
      required this.imageUrl,
      required this.status});
}

class OrderForMerchantAPI {
  Uri baseUrl = Uri.parse(
      'http://192.168.29.184/app_db/Seller_actions/oreder_management/');

  Future<List<OrderForUser?>?> getOrderDetails(String company) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    Uri fullUrl = baseUrl.resolve('send_order.php?company=$company');
    final response = await http.get(
      fullUrl,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> order = jsonResponse['order'];
      List<OrderForUser> orders =
          order.map((order) => OrderForUser.fromJson(order)).toList();
      return orders;
    }
    return null;
  }

  Future<List<OrderItemForOrder>?> getOrderItems(String company) async {
    Uri fullUrl = baseUrl.resolve('send_order.php?company=$company');
    final response = await http.get(
      fullUrl,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['orderItems'] == 'No order items for this order') {
        return null;
      } else {
        List<dynamic> order = jsonResponse['orderItem'];
        List<OrderItemForOrder> orderItems =
            order.map((items) => OrderItemForOrder.fromJson(items)).toList();
        return orderItems;
      }
    }
    return null;
  }

  Future<void> updateOrderItemStatus(
      int orderId,
    int orderItemId,
    String status,
    void Function(String message) success,
    void Function(Exception) error,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(PrefsKeys.userToken);
    Uri fullUrl = baseUrl.resolve('send_order.php');
    Map<String, dynamic> requestBody = {
      "orderItemId": orderItemId,
      "status": status,
      "orderId":orderId,
    };
    String jsonRequestBody = jsonEncode(requestBody);
    final response = await http.post(
      fullUrl,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonRequestBody,
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String,dynamic> jsonResponse = jsonDecode(response.body);
      String successMessage = jsonResponse['message'];
      success(successMessage);
    } else {
      Map<String,dynamic> jsonResponse = jsonDecode(response.body);
      String errorMessage = jsonResponse['error'];
      error(Exception(errorMessage));
    }
  }
}
