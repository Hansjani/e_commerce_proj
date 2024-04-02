import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderForUser {
  final int orderId;
  final String userId;
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
      orderDate: json['orderDate'],
      orderStatus: json['order_status'],
      orderItems: orderItems,
    );
  }

  OrderForUser({
    required this.orderId,
    required this.userId,
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

  OrderItemForOrder({
    required this.orderItemId,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.status
  });
}

class OrderForMerchantAPI {
  Uri baseUrl = Uri.parse(
      'http://192.168.29.184/app_db/Seller_actions/oreder_management/');

  Future<OrderForUser?> getOrderDetails(int orderId, String company) async {
    Uri fullUrl =
    baseUrl.resolve('send_order.php?orderId=$orderId&company=$company');
    final response = await http.get(
      fullUrl,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      OrderForUser order = OrderForUser.fromJson(jsonResponse['order']);
      return order;
    }
    return null;
  }

  Future<List<OrderItemForOrder>?> getOrderItems(int orderId,
      String company) async {
    Uri fullUrl =
    baseUrl.resolve('send_order.php?orderId=$orderId&company=$company');
    final response = await http.get(
      fullUrl,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['orderItems'] == 'No order items for this order') {
        return null;
      } else {
        List<dynamic> order = jsonResponse['orderItems'];
        List<OrderItemForOrder> orderItems =
        order.map((items) => OrderItemForOrder.fromJson(items)).toList();
        return orderItems;
      }
    }
    return null;
  }
}
