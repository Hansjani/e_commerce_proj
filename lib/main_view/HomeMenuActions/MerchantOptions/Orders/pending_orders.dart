import 'package:e_commerce_ui_1/APIs/AdminActionAPI/admin_get_users_api.dart';
import 'package:e_commerce_ui_1/APIs/OrderAPI/see_orders.dart';
import 'package:e_commerce_ui_1/Constants/SharedPreferences/key_names.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingOrders extends StatefulWidget {
  final int orderId;

  const PendingOrders({super.key, this.orderId = 48});

  @override
  State<PendingOrders> createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  late String? userCompany;
  String? username;

  Future<List<OrderItemForOrder>?> getOrderItems() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString(PrefsKeys.userName);
    if (username != null) {
      Users? user = await UserCRUD().getByUsername(username!);
      userCompany = user?.userCompany;
      if (userCompany != null) {
        return OrderForMerchantAPI().getOrderItems(userCompany!);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder(
        future: getOrderItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            if (snapshot.data == null) {
              return const Center(
                child: Text('No order item for this order'),
              );
            } else {
              List<OrderItemForOrder> orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  OrderItemForOrder order = orders[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 65,
                      child: order.imageUrl == null
                          ? Image.network(
                              'http://192.168.29.184/app_db/server_file/category/1710239821_phone.png')
                          : Image.network(order.imageUrl!),
                    ),
                    title: Text(
                      'Order Item ID : ${order.orderItemId.toString()}',
                    ),
                    subtitle: Text(
                      'Order Item Status : ${order.status}',
                    ),
                    onTap: () {},
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
