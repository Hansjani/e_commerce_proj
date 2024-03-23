import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderProduct {
  final int productId;
  final int quantity;

  OrderProduct({required this.productId, required this.quantity});

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      productId: json["productId"],
      quantity: json["quantity"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "quantity": quantity,
    };
  }
}

class Order {
  final int orderId;
  final String status;
  final double amount;

  Order({required this.orderId, required this.status, required this.amount});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json["orderId"],
      status: json["order_status"],
      amount: double.parse(json["totalAmount"]),
    );
  }
}

class OrderAPI {
  Uri baseUrl = Uri.parse(
      'http://192.168.29.184/app_db/Rgistered_user_actions/order_management/');

  Future<void> placeOrder(List<OrderProduct> products) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("userToken");
    List<Map<String, dynamic>> productsJson =
        products.map((product) => product.toJson()).toList();
    Map<String, dynamic> requestBody = {
      "token": token,
      "products": productsJson
    };
    String requestBodyJson = jsonEncode(requestBody);
    try {
      Uri finalUrl = baseUrl.resolve('add_new_order.php');
      final response = await http.post(
        finalUrl,
        body: requestBodyJson,
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        double amount = jsonResponse['amount'];
        print(amount);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Order>> getOrderHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("userToken");
    Uri finalUrl = baseUrl.resolve('order_history.php?token=$token');
    final response = await http.get(
      finalUrl,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Order> orders =
          jsonResponse.map((order) => Order.fromJson(order)).toList();
      print(orders);
      return orders;
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception();
    }
  }

  Future<List<OrderProduct>> getOrderItems(int orderId) async {
    Uri finalUrl = baseUrl.resolve('get_order_details.php?orderId=$orderId');
    final response = await http.get(
      finalUrl,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<OrderProduct> orderItems =
      jsonResponse.map((items) => OrderProduct.fromJson(items)).toList();
      print(orderItems);
      return orderItems;
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception();
    }
  }
}
