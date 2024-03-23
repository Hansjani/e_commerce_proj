import 'package:e_commerce_ui_1/APIs/UserAPI/cart_api.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/OrderTab/order_item.dart';
import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  late Future<List<Order>> orders;

  @override
  void initState() {
    orders = OrderAPI().getOrderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: FutureBuilder(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<Order> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                if (orders.isNotEmpty) {
                  final order = orders[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderItem(order: order),
                        ),
                      );
                    },
                    leading: Text("${index + 1}"),
                    title: Text('Order : #${order.orderId}'),
                    subtitle: Text(order.status),
                  );
                } else {
                  return const Center(child: Text("No order found"));
                }
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
