import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_order_action_api.dart';
import 'package:e_commerce_ui_1/main_view/HomeMenuActions/AdminPanel/OrderManagement/update_order.dart';
import 'package:flutter/material.dart';

class AllOrderList extends StatefulWidget {
  const AllOrderList({super.key});

  @override
  State<AllOrderList> createState() => _AllOrderListState();
}

class _AllOrderListState extends State<AllOrderList> {
  late Future<List<OrdersForAdmin>> ordersList;

  @override
  void initState() {
    ordersList = AdminOrderActionAPI().getAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
      ),
      body: FutureBuilder(
        future: ordersList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<OrdersForAdmin> orders = snapshot.data!;
                if (orders.isEmpty) {
                  return const Center(
                    child: Text('No orders found'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      OrdersForAdmin order = orders[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateOrderStatus(ordersForAdmin: order),
                              ),
                            );
                          },
                          title: Text('OrderID : #${order.orderId}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order by : ${order.username}'),
                              Text('Ordered at : ${order.orderDate}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: Text('No orders found'),
                );
              }
            default:
              throw Exception();
          }
        },
      ),
    );
  }
}
