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
        return OrderForMerchantAPI()
            .getOrderItems(widget.orderId, userCompany!);
      }
    }
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  OrderItemForOrder order = orders[index];
                  if(order.status == 'pending_check'){
                    return ListTile(
                      title: Text(snapshot.data![index].status.toString()),
                    );
                  }
                  return null;
                },
              );
            }
          }
        },
      ),
    );
  }
}
